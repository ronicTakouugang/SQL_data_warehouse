/* ============================================================
   DATA WAREHOUSE - DATABASE INITIALIZATION
   ============================================================
   Description :
       - Vérifie l'existence de la base DataWarehouse
       - Supprime la base si elle existe
       - Recrée une base DataWarehouse propre
       - Crée les schémas Bronze, Silver et Gold

   WARNING :
       L'exécution de ce script supprime toutes les données
       existantes dans la base DataWarehouse.
   ============================================================ */


-- Vérifier si la base DataWarehouse existe
IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
    -- Forcer la déconnexion des utilisateurs
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    -- Supprimer la base
    DROP DATABASE DataWarehouse;
END;
GO

-- Créer une nouvelle base DataWarehouse
CREATE DATABASE DataWarehouse;
GO

-- Utiliser la base
USE DataWarehouse;
GO

-- Créer les schémas dans l'ordre
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO