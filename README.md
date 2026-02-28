# Adventureworks-analysis

## AdventureWorks SQL Analysis: Joins & Subqueries
This repository contains a series of complex SQL queries executed against the AdventureWorks database (MySQL version). The focus of this project was mastering data relationships through multi-table joins and optimizing performance using subqueries.


📊 Database Overview
The AdventureWorks database is a large-scale, relational database representing a global manufacturing company. It features schemas for Sales, Production, Human Resources, and Purchasing.



🚀 Key Challenges Solved
1. Hierarchical Data (Self-Joins)
Solved the "Employee-Manager" relationship problem using self-joins on the OrganizationNode and OrganizationLevel columns.

Skill: Recursive logic and path enumeration in MySQL.

2. High-Value Filtering (Correlated Subqueries)
Identified products with a unit price higher than the global average.

Optimization: Used variables and CTE-style logic to prevent "Lost Connection" errors (Error 2013) caused by repeated subquery execution.

3. Inventory Management (Left Joins)
Generated a complete inventory report that includes products with zero stock, ensuring no data was lost during the join.

4. Performance Tuning
Handled common MySQL strict mode issues (ONLY_FULL_GROUP_BY) and resolved subquery cardinality errors (Subquery returns more than 1 row).


🛠️ Technical Stack
Database: MySQL 8.0 (AdventureWorks Light/OLTP Import)

Tooling: MySQL Workbench

Key Syntax: INNER JOIN, LEFT JOIN, COALESCE, GROUP BY, HAVING, SUBQUERIES.


📂 How to Use
Clone the repository.

Import the AdventureWorks.sql file into your local MySQL instance - You can use this [OLTP-Adventureworks](https://github.com/vishal180618/OLTP-AdventureWorks2019-MySQL/tree/6cc8851a60d8880ea347921d4605e6372c3c0307)

Run the scripts in the /queries folder to see the results.
