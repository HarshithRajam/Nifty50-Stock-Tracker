# ui.R
library(shiny)
library(plotly)
library(DT)

# Define UI
ui <- fluidPage(
  
  # App title
  titlePanel("Nifty 50 Stock Price Viewer"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      selectInput("stock", "Select a Nifty 50 Company:", 
                  choices = c("RELIANCE.NS", "TCS.NS", "HDFCBANK.NS", "INFY.NS", 
                              "ICICIBANK.NS", "HINDUNILVR.NS", "SBIN.NS", "BAJFINANCE.NS",
                              "HDFC.NS", "BHARTIARTL.NS", "ITC.NS", "KOTAKBANK.NS", "LT.NS",
                              "AXISBANK.NS", "WIPRO.NS", "ASIANPAINT.NS", "MARUTI.NS", 
                              "SUNPHARMA.NS", "TITAN.NS", "ULTRACEMCO.NS"), 
                  selected = "RELIANCE.NS"),
      
      dateRangeInput("date_range", "Select Date Range:", 
                     start = Sys.Date() - 30, end = Sys.Date()),
      actionButton("fetch", "Fetch Data", icon = icon("sync"))
    ),
    
    # Main panel with tabs
    mainPanel(
      tabsetPanel(
        tabPanel("Stock Prices", 
                 h3("Real-Time Stock Price"), verbatimTextOutput("real_time_price"),
                 h3("Stock Price Trend"), plotlyOutput("stock_plot"),
                 h3("Historical Stock Data"), DTOutput("stock_table")
        ),
        tabPanel("Stock vs Nifty",
                 h3("Stock vs. Nifty 50 Price Movements"),
                 plotlyOutput("stock_nifty_dual_plot"))
      )
    )
  )
)
