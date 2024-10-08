Data Analysis and Visualization Projects

This repository contains SQL queries, Power BI visualizations, and Python-based data analyses on various datasets. The projects include both e-commerce order data analysis and music platform analysis (Spotify and YouTube).

Table of Contents

Overview
SQL Queries
Power BI Visualizations
Python Data Analysis and Visualization
Spotify and YouTube Data Analysis
Employee Performance and Product Analysis
Usage Instructions
Requirements
Overview

This repository covers SQL queries for data extraction and analysis, as well as data visualizations using Power BI and Python. SQL queries focus on order, customer, and logistics data, while Power BI and Python are used to visualize these data sets. Additionally, a detailed analysis of Spotify and YouTube data is performed in Python.

Project Structure
SQL Queries: Queries analyzing orders, customers, and products from an e-commerce database.
Power BI Files: Visualizations based on the data extracted from SQL queries.
Python Files: Python-based analysis and visualization of both SQL query results and Spotify/YouTube data.
SQL Queries

The SQL queries in this repository are used to analyze order and customer data. These queries extract data from tables such as orders, customers, products, and logistics to provide the following insights:

Order Analysis: Total number of orders and order density over time.
Customer Analysis: Customers' order counts and total spending.
Revenue Analysis: Category-wise revenue and total discounts.
Logistics Analysis: Delivery times and shipment performance.
Employee Performance: Performance analysis based on orders and sales completed by employees.
The SQL queries can be found in the sql_queries.sql file and are optimized for specific SQL dialects (e.g., PostgreSQL or MySQL). Make sure your database tables are properly structured to match the queries.

Power BI Visualizations

The data obtained from the SQL queries is visualized using Power BI. The Power BI dashboards include:

Order Counts and Density: Visualizations showing the distribution of orders over time.
Customer Spending: Visualizing the top spending customers and customer segmentation.
Revenue Analysis: Product and category-wise revenue graphs.
Logistics Performance: Visualizing average delivery times.
These visualizations help users quickly and effectively understand key metrics from the database.

The Power BI file is available as powerbi_visualization.pbix.

Python Data Analysis and Visualization

In this project, data analyses were conducted using Python, with some SQL query results being visualized through Python. The analysis uses libraries such as pandas, matplotlib, and seaborn.

Spotify and YouTube Data Analysis
Spotify and YouTube data were analyzed to explore music listener behavior. The analysis includes:

Song Popularity: Identifying the most popular songs on both Spotify and YouTube.
Listening Durations: Analyzing user listening times and the most preferred music genres.
Platform Comparison: A comparison of listening durations between Spotify and YouTube.
This analysis provides valuable insights into user preferences for music streaming platforms.

The analysis can be found in the spotify_youtube_analysis.py file.

Employee Performance and Product Analysis
The data extracted from SQL queries is visualized using Python to analyze employee performance and product sales. The key visualizations include:

Total Sales per Employee: Visualizing the sales performance of employees.
Top-Selling Products: Analyzing product sales volumes and revenue.
These analyses are located in the performance_analysis.py file.

Usage Instructions

SQL Queries: Execute the SQL queries in the sql_queries.sql file using a suitable SQL editor.
Power BI: Open the powerbi_visualization.pbix file with Power BI Desktop to view the dashboards.
Python Analysis: Install the required libraries mentioned in requirements.txt, and run the Python scripts (spotify_youtube_analysis.py and performance_analysis.py).
Requirements


You will also need Power BI Desktop to open and view the Power BI file.

This repository offers a comprehensive structure for analyzing data using SQL, Power BI, and Python. Each project is designed to extract key insights from data and present them through visualizations.

Feel free to adapt this README to your repository as needed!






