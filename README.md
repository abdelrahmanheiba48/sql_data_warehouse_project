# SQL Data Warehouse Project

A comprehensive, end-to-end SQL Data Warehouse solution designed to transform transactional operational data into structured, analytical data assets. This project implements standard data warehousing best practices, including ETL/ELT pipelines, relational staging, multi-dimensional modeling (Star Schema), and performance optimization using T-SQL and Microsoft SQL Server (SSMS).

## 🚀 Architecture Overview

The data pipeline follows a structured architecture to ensure data integrity, separation of concerns, and optimized query performance:

1. **Source Layer:** Raw transactional data extracts (OLTP).
2. **Staging Area (`Bronze/Staging`):** Temporary storage used to ingest data directly from source systems with minimal transformation to prevent operational overhead.
3. **Data Warehouse Layer (`Silver/Gold`):** The core analytical layer modeled using a **Star Schema** with fully optimized Dimension and Fact tables to facilitate rapid reporting and business intelligence applications.

---

## 🛠️ Tech Stack & Tools
* **Database Engine:** Microsoft SQL Server
* **IDE:** SQL Server Management Studio (SSMS)
* **Language:** T-SQL (Stored Procedures, Views, Indexing, Data Normalization)

---

## 📐 Data Modeling (Star Schema)

The analytical database is designed around a multi-dimensional star schema optimized for analytical query performance:
* **Fact Tables:** Centralized tables containing business metrics, foreign keys to dimensions, and numeric KPIs (e.g., Sales, Transactions, Inventory).
* **Dimension Tables:** Surrounding descriptive attributes utilizing appropriate Slowly Changing Dimension (SCD) strategies to keep historical track of entity modifications.

---

## ⚙️ ETL / ELT Pipeline

The workflow is built entirely using robust SQL scripts structured as follows:
* **DDL Scripts:** Database creation, schema separation, table definitions, and constraints (Primary Keys, Foreign Keys).
* **Extraction & Loading:** Migrating raw records into staging tables.
* **Transformation & Aggregation:** Business logic implementation, handling NULL values, data type casting, surrogate key generation, and populating the dimensional model.

---
## ⏳ Upcoming Milestones
This project is actively maintained. The following components are planned for future releases:

📝 Comprehensive Documentation: Full data dictionary, entity-relationship diagrams (ERD), detailed column-level metadata , and data catalo

🧪 Data Quality Testing Suite: Automated SQL assertion scripts to test for uniqueness, reference integrity, null handling, and volume anomalies.
