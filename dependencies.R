# dependencies.R
required_packages <- c("shiny", "quantmod", "DT", "plotly")

# Install missing packages
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if (length(new_packages)) install.packages(new_packages)

# Load packages
lapply(required_packages, require, character.only = TRUE)
