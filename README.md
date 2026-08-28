# SQL_data_warehouse

Reprise personnelle du projet **[SQL Data Warehouse from Scratch](https://www.youtube.com/watch?v=9GVqKuTVANE&list=PLNcg_FV9n7qaUWeyUkPfiVtMbKlrfMqA8)**
(Data with Baraa) : construction d'un data warehouse SQL Server de bout
en bout, de l'ingestion de fichiers CSV bruts jusqu'à un modèle en
étoile prêt pour le reporting.

## Objectif

Suivre puis reproduire à ma façon l'architecture **médaillon**
(Bronze / Silver / Gold), en insistant sur les pratiques réelles
d'un projet d'ingénierie de données : pipelines ETL, nettoyage et
normalisation, modélisation dimensionnelle.

## Architecture

```
Sources CSV (CRM, ERP)
        │
        ▼
  ┌───────────┐   ingestion brute, sans transformation
  │  Bronze   │   (fichiers CSV → tables SQL Server, tel quel)
  └───────────┘
        │
        ▼
  ┌───────────┐   nettoyage, standardisation, normalisation
  │  Silver   │   (dédoublonnage, typage, règles métier)
  └───────────┘
        │
        ▼
  ┌───────────┐   modèle en étoile (faits / dimensions)
  │   Gold    │   prêt pour le reporting et l'analyse
  └───────────┘
```

## Flux de données détaillé

```mermaid
flowchart LR
    subgraph Sources["Sources"]
        direction TB
        CRM[("CRM")]
        ERP[("ERP")]
    end

    subgraph Bronze["Bronze Layer"]
        direction TB
        b_cust["crm_cust_info"]
        b_prd["crm_prd_info"]
        b_sales["crm_sales_details"]
        b_ecust["erp_cust_az12"]
        b_eloc["erp_loc_a101"]
        b_ecat["erp_px_cat_g1v2"]
    end

    subgraph Silver["Silver Layer"]
        direction TB
        s_cust["crm_cust_info"]
        s_prd["crm_prd_info"]
        s_sales["crm_sales_details"]
        s_ecust["erp_cust_az12"]
        s_eloc["erp_loc_a101"]
        s_ecat["erp_px_cat_g1v2"]
    end

    subgraph Gold["Gold Layer"]
        direction TB
        g_fact["fact_sales"]
        g_dimcust["dim_customer"]
        g_dimprod["dim_product"]
    end

    CRM --> b_cust
    CRM --> b_prd
    CRM --> b_sales
    ERP --> b_ecust
    ERP --> b_eloc
    ERP --> b_ecat

    b_cust --> s_cust
    b_prd --> s_prd
    b_sales --> s_sales
    b_ecust --> s_ecust
    b_eloc --> s_eloc
    b_ecat --> s_ecat

    s_sales --> g_fact
    s_cust --> g_dimcust
    s_ecust --> g_dimcust
    s_eloc --> g_dimcust
    s_prd --> g_dimprod
    s_ecat --> g_dimprod
    g_dimcust --> g_fact
    g_dimprod --> g_fact
```

Détail des colonnes de la couche Gold : [dictionnaire de données](docs/dictionnaire_donnees.md).

## Stack technique

| Usage | Technologie |
|---|---|
| Base de données | SQL Server |
| Client SQL | SQL Server Management Studio (SSMS) / DBeaver |
| Modélisation | Schéma en étoile (faits / dimensions) |
| Contrôle de version | Git |

## Structure du projet

```
SQL_data_warehouse/
├── datasets/             fichiers sources CSV (CRM, ERP)
├── docs/                 diagrammes d'architecture et de flux de données
├── scripts/
│   ├── bronze/           scripts de création et chargement (couche Bronze)
│   ├── silver/           scripts de nettoyage et transformation (couche Silver)
│   └── gold/             vues du modèle en étoile (couche Gold)
├── tests/                tests de qualité des données et du pipeline
├── LICENSE
└── README.md
```

## Suivi d'avancement

- [ ] Couche Bronze — ingestion des CSV source
- [ ] Couche Silver — nettoyage et normalisation
- [ ] Couche Gold — modèle en étoile (faits / dimensions)
- [ ] Documentation et diagrammes

## Source

Tutoriel original : [Data with Baraa — SQL Data Warehouse from Scratch](https://www.youtube.com/watch?v=9GVqKuTVANE&list=PLNcg_FV9n7qaUWeyUkPfiVtMbKlrfMqA8)
