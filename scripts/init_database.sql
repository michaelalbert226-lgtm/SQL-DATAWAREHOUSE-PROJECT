-- =============================================================================
-- Script: Database Initialization and Schema Setup
-- Purpose: Drop and recreate the Datawarehouse database with layered schemas
-- Description: This script performs a complete reset of the Datawarehouse 
--              database and establishes three schema layers for a data 
--              warehouse architecture (bronze, silver, gold).
-- WARNING: DESTRUCTIVE OPERATION - All existing data will be permanently deleted
-- Author: Created by Mikkymayor in VSCode MSSQL - review carefully before executing
-- Created: [3/14/2026]
-- =============================================================================

use master;
GO

--This is a destructive operation. All data, schema, and objects in Datawarehouse will be permanently deleted. 
--Execute only when you have confirmed the database is no longer needed or has been backed up.

--Drop and recreate the database warehouse if it already exists
IF DB_ID('Datawarehouse') IS NOT NULL
BEGIN
    ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Datawarehouse;
END;
GO

CREATE DATABASE Datawarehouse;
GO
--Set the database to use the new Datawarehouse
USE Datawarehouse;  
GO

--create schema for staging tables
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO                  
