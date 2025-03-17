# server.R
library(shiny)
library(quantmod)
library(DT)
library(plotly)

# Define Server
server <- function(input, output) {
  
  # Fetch real-time stock price
  output$real_time_price <- renderPrint({
    req(input$stock)
    stock_quote <- getQuote(input$stock)
    stock_quote[, c("Trade Time", "Last", "Open", "High", "Low", "Volume")]
  })
  
  # Reactive function to fetch historical stock and Nifty index data
  stock_data <- reactive({
    req(input$stock, input$date_range)
    isolate({
      stock <- getSymbols(input$stock, src = "yahoo", from = input$date_range[1], to = input$date_range[2], auto.assign = FALSE)
      nifty <- getSymbols("^NSEI", src = "yahoo", from = input$date_range[1], to = input$date_range[2], auto.assign = FALSE)
      list(stock = stock, nifty = nifty)
    })
  })
  
  # Plot stock price trend
  output$stock_plot <- renderPlotly({
    df <- stock_data()$stock
    df <- data.frame(Date = index(df), coredata(df))
    plot_ly(df, x = ~Date, y = ~df[,4], type = "scatter", mode = "lines", name = input$stock) %>%
      layout(title = paste("Stock Price of", input$stock), 
             xaxis = list(title = "Date"), 
             yaxis = list(title = "Closing Price"))
  })
  
  # Display historical data table
  output$stock_table <- renderDT({
    df <- stock_data()$stock
    df <- data.frame(Date = index(df), coredata(df))
    datatable(df, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  # Plot stock vs. Nifty with dual Y-axes
  output$stock_nifty_dual_plot <- renderPlotly({
    stock_df <- stock_data()$stock
    nifty_df <- stock_data()$nifty

    stock_df <- data.frame(Date = index(stock_df), Stock_Close = coredata(stock_df)[,4])
    nifty_df <- data.frame(Date = index(nifty_df), Nifty_Close = coredata(nifty_df)[,4])

    # Merge datasets
    merged_df <- merge(stock_df, nifty_df, by = "Date", all = TRUE)

    # Create a dual-axis plot
    plot_ly() %>%
      add_lines(data = merged_df, x = ~Date, y = ~Nifty_Close, name = "Nifty 50", yaxis = "y1", line = list(color = 'red')) %>%
      add_lines(data = merged_df, x = ~Date, y = ~Stock_Close, name = input$stock, yaxis = "y2", line = list(color = 'blue')) %>%
      layout(
        title = paste(input$stock, "vs. Nifty 50 Price Movements"),
        xaxis = list(title = "Date"),
        yaxis = list(title = "Nifty 50 Price", side = "left", showgrid = FALSE),
        yaxis2 = list(title = paste(input$stock, "Stock Price"), side = "right", overlaying = "y", showgrid = FALSE)
      )
  })
}
