# Dictionnaire de données — Couche Gold

Ce dictionnaire décrit les objets de la **couche Gold**, seule couche exposée
pour le reporting et l'analyse. Elle expose un modèle en étoile composé de
deux dimensions et une table de faits, sous forme de vues SQL Server
(schéma `gold`).

## Vue d'ensemble du modèle

```
                    ┌───────────────────┐
                    │  gold.dim_customer│
                    │  customer_key (PK)│
                    └─────────┬─────────┘
                              │
                              │ customer_key
                              │
┌───────────────────┐  ┌─────▼─────────┐  ┌────────────────────┐
│  gold.dim_product  │  │ gold.fact_sales│  │                    │
│  product_key (PK)  ├──►  product_key   │  │  grain : une ligne │
└───────────────────┘  │  customer_key   │  │  de commande       │
                        └────────────────┘  └────────────────────┘
```

- **gold.dim_customer** et **gold.dim_product** sont des dimensions
  (une ligne par entité).
- **gold.fact_sales** est la table de faits : une ligne par ligne de
  commande de vente, reliée aux dimensions via des clés de substitution
  (`customer_key`, `product_key`).

---

## gold.dim_customer

Dimension client. Combine les données CRM (`silver.crm_cust_info`) avec les
données ERP (`silver.erp_cust_az12` pour la naissance/le genre,
`silver.erp_loc_a101` pour le pays).

| Colonne | Type | Description |
|---|---|---|
| `customer_key` | `BIGINT` | Clé de substitution (surrogate key) générée par `ROW_NUMBER()`. Clé primaire de la dimension, utilisée pour les jointures avec `gold.fact_sales`. |
| `customer_id` | `INT` | Identifiant client système CRM (`cst_id`). |
| `customer_number` | `NVARCHAR(50)` | Identifiant métier du client (`cst_key`), utilisé comme clé de rapprochement avec les autres sources (ERP, table de faits). |
| `first_name` | `NVARCHAR(50)` | Prénom du client. |
| `last_name` | `NVARCHAR(50)` | Nom de famille du client. |
| `gender` | `NVARCHAR(50)` | Genre du client. Valeurs : `Male`, `Female`, `N/A`. Priorité à la valeur CRM (`cst_gndr`) ; si absente (`N/A`), on utilise la valeur ERP (`erp_cust_az12.gen`). |
| `marital_status` | `NVARCHAR(50)` | Statut marital. Valeurs : `Married`, `Single`, `N/A`. |
| `birth_date` | `DATE` | Date de naissance (source ERP `erp_cust_az12.bdate`). `NULL` si la date était postérieure à la date de chargement (donnée invalide filtrée en Silver). |
| `country` | `NVARCHAR(50)` | Pays de résidence (source ERP `erp_loc_a101.cntry`). Valeurs normalisées : `Germany`, `United States`, ou nom de pays brut ; `N/A` si inconnu. |
| `create_date` | `DATE` | Date de création de la fiche client dans le système source CRM (`cst_create_date`). |

**Grain** : une ligne par client (dédoublonné sur `cst_id`, en conservant la
fiche la plus récente selon `cst_create_date`).

---

## gold.dim_product

Dimension produit. Combine les données CRM (`silver.crm_prd_info`) avec la
catégorie de produit ERP (`silver.erp_px_cat_g1v2`).

| Colonne | Type | Description |
|---|---|---|
| `product_key` | `BIGINT` | Clé de substitution (surrogate key) générée par `ROW_NUMBER()`, ordonnée par date de début puis identifiant produit. Clé primaire de la dimension. |
| `product_id` | `INT` | Identifiant produit système CRM (`prd_id`). |
| `product_number` | `NVARCHAR(50)` | Référence produit (`prd_key`), utilisée comme clé de rapprochement avec `gold.fact_sales`. |
| `product_name` | `NVARCHAR(100)` | Nom du produit. |
| `category_id` | `NVARCHAR(50)` | Identifiant de catégorie extrait du préfixe de `prd_key` (source CRM), sert de clé de rapprochement avec la catégorie ERP. |
| `category` | `NVARCHAR(50)` | Catégorie du produit (ex. `Accessories`, `Bikes`), source ERP. |
| `subcategory` | `NVARCHAR(50)` | Sous-catégorie du produit, source ERP. |
| `maintenance_flag` | `NVARCHAR(3)` | Indique si le produit nécessite de la maintenance. Valeurs : `Yes`, `No`. |
| `product_cost` | `DECIMAL(18,2)` | Coût du produit. `0` si absent en source. |
| `product_line` | `NVARCHAR(50)` | Ligne de produit. Valeurs : `Mountain`, `Road`, `Other Sales`, `Touring`, `N/A`. |
| `product_start_date` | `DATE` | Date de mise en vente du produit. |

**Grain** : une ligne par produit **actuellement actif** — la vue ne
retient que les versions dont `prd_end_dt IS NULL` (historisation de type 2
en Silver, snapshot du produit courant en Gold).

---

## gold.fact_sales

Table de faits des ventes. Source : `silver.crm_sales_details`, enrichie
par jointure avec `gold.dim_product` et `gold.dim_customer` pour résoudre
les clés de substitution.

| Colonne | Type | Description |
|---|---|---|
| `order_number` | `NVARCHAR(50)` | Numéro de commande (`sls_ord_num`). |
| `product_key` | `BIGINT` | Clé étrangère vers `gold.dim_product.product_key`. |
| `customer_key` | `BIGINT` | Clé étrangère vers `gold.dim_customer.customer_key`. |
| `order_date` | `DATE` | Date de commande. |
| `shipping_date` | `DATE` | Date d'expédition. |
| `due_date` | `DATE` | Date d'échéance de paiement/livraison. |
| `sales_amount` | `INT` | Montant total de la ligne de vente. |
| `quantity` | `INT` | Quantité vendue. |
| `price` | `INT` | Prix unitaire. |

**Grain** : une ligne par ligne de commande (`sls_ord_num` + produit).
Les jointures vers les dimensions sont des `LEFT JOIN` : une commande dont
le produit ou le client n'est pas retrouvé dans la dimension correspondante
est tout de même conservée, avec une clé étrangère à `NULL`.

---

## Conventions

- **Clé de substitution (`*_key`)** : entier généré en Gold via
  `ROW_NUMBER()`, stable pour la durée de vie de la vue, utilisé pour les
  jointures entre faits et dimensions.
- **Clé métier (`*_id`, `*_number`)** : identifiant tel qu'il existe dans
  le système source (CRM ou ERP).
- **`N/A`** : valeur par défaut appliquée en couche Silver lorsque la
  donnée source est manquante, vide ou non reconnue.
- Les objets Gold sont des **vues** (`CREATE OR ALTER VIEW`), recalculées
  à chaque exécution — elles ne stockent pas physiquement les données.
