# Dataset Information

## Olist Brazilian E-Commerce Dataset

This project uses the **Olist Brazilian E-Commerce Dataset**, downloaded from **Kaggle**.

The dataset contains anonymized information about orders placed through the Olist marketplace and includes multiple relational datasets representing customers, orders, products, sellers, payments, reviews, and product categories.

## 📊 Dataset Source

**Source:** Kaggle

**Dataset:** Olist Brazilian E-Commerce Public Dataset

**Dataset Provider:** Olist

The dataset was downloaded from Kaggle and used for educational and portfolio-based data analysis.

---

## 📁 Files Used

The project uses 8 CSV files:

| File                                    | Description                                        |
| --------------------------------------- | -------------------------------------------------- |
| `olist_customers_dataset.csv`           | Customer information and location                  |
| `olist_orders_dataset.csv`              | Order details, status, purchase and delivery dates |
| `olist_order_items_dataset.csv`         | Products purchased, prices, freight and sellers    |
| `olist_order_payments_dataset.csv`      | Payment methods, installments and payment values   |
| `olist_order_reviews_dataset.csv`       | Customer review scores and review information      |
| `olist_products_dataset.csv`            | Product information and categories                 |
| `olist_sellers_dataset.csv`             | Seller information and location                    |
| `product_category_name_translation.csv` | Portuguese-to-English product category translation |

---

## 🔗 Data Relationships

The datasets are connected through common keys, including:

* `order_id`
* `customer_id`
* `customer_unique_id`
* `product_id`
* `seller_id`

These relationships were first utilized in PostgreSQL for SQL-based business analysis and later recreated in Excel Power Pivot for dashboard development.

---

## 🔄 How the Dataset Was Used

The dataset was processed through the following workflow:

**Kaggle Dataset → PostgreSQL → SQL Analysis → Power Query → Power Pivot → Excel Dashboard**

### PostgreSQL

The 8 CSV files were imported into PostgreSQL and analyzed using SQL to answer 25 business questions.

### Power Query

The CSV files were connected to Excel using Power Query for data preparation and transformation.

### Power Pivot

The tables were loaded into Power Pivot and relationships were established between the relevant tables to create a relational data model.

### Excel Dashboard

The data model was used to create Pivot Tables, Pivot Charts, filters, and an interactive e-commerce dashboard.

---

## ⚠️ Dataset Availability

The original CSV files are not included in this repository.

Users who want to reproduce the project should download the Olist dataset from Kaggle and place the CSV files in their local project directory.

The SQL queries, data-modeling approach, and dashboard are provided as part of this portfolio project.

---

## 📌 Disclaimer

This project is intended for **educational, learning, and portfolio purposes**. The analysis demonstrates practical applications of SQL, Excel, Power Query, Power Pivot, data modeling, and business analytics.
