# E-commerce Dashboard – INF416 H2025 Project

[**View the live dashboard**](https://ecommerce-dashboard.shinyapps.io/projet_4inf416_h2025-main/)

## 🎯 Project Objective

This project aims to develop an interactive dashboard for analyzing sales data from an e-commerce platform. The objectives are to:

* Visualize sales trends over time.
* Identify top-selling products.
* Analyze sales performance by region and customer segment.
* Provide interactive tools for dynamic data exploration.

## 🛠️ Technologies Used

* **R**: Main programming language.
* **Shiny**: Framework for creating interactive web applications.
* **shinydashboard**: Dashboard-style user interface.
* **Plotly**: Library for interactive visualizations.
* **dplyr**: Package for data manipulation.

## 📂 Project Structure

```
/ (project root)
│
├── Project.Rproj          # R project file
├── ui.R                   # Shiny user interface
├── server.R               # Shiny server logic
├── README.md              # Project documentation
├── ecommerce_logs.csv     # Main dataset
└── .gitignore             # Git ignore file
```

## 🚀 Usage Instructions

1. Clone this repository to your local machine.
2. Install the required R packages:

   ```R
   install.packages(c("shiny", "shinydashboard", "plotly", "dplyr"))
   ```
3. Run the Shiny application:

   ```R
   shiny::runApp(".")
   ```
4. Open your browser and go to `http://localhost:3838` to view the dashboard.

