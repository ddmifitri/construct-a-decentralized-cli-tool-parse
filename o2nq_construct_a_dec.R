# o2nq_construct_a_dec.R

# Load required libraries
library(optparse)
library(RCurl)
library(jsonlite)

# Define the CLI tool parser function
construct_a_dec <- function() {
  # Define the CLI options
  option_list <- list(
    make_option(c("-h", "--help"), action="store_true", default=FALSE,
                help="Show this help message and exit"),
    make_option(c("-c", "--config"), type="character", default=NULL,
                help="Path to the configuration file"),
    make_option(c("-n", "--network"), type="character", default="mainnet",
                help="Network to connect to (mainnet/testnet/devnet)"),
    make_option(c("-p", "--port"), type="integer", default=8080,
                help="Port number to listen on")
  )
  
  # Parse the CLI options
  opt_parser <- OptionParser(option_list=option_list)
  args <- parse_args(opt_parser)
  
  # Load the configuration file
  if (!is.null(argsgetOption("config"))) {
    config <- fromJSON(file=argsgetOption("config"))
  } else {
    config <- list()
  }
  
  # Set up the network connection
  network <- argsgetOption("network")
  port <- argsgetOption("port")
  
  # Define a function to send requests to the network
  send_request <- function(method, endpoint, data=NULL) {
    url <- paste0("http://", network, ":", port, "/", endpoint)
    resp <- postForm(url, .params=data)
    return(fromJSON(resp))
  }
  
  # Define a function to handle user input
  handle_input <- function() {
    while (TRUE) {
      command <- readline(prompt="o2nq> ")
      if (command == "exit") {
        break
      } else if (command == "help") {
        cat("Available commands:\n")
        cat("  exit: Exit the CLI tool\n")
        cat("  help: Show this help message\n")
        cat("  <method> <endpoint> [data]: Send a request to the network\n")
      } else {
        args <- strsplit(command, "\\s+")[[1]]
        method <- args[1]
        endpoint <- args[2]
        data <- args[-c(1, 2)]
        resp <- send_request(method, endpoint, data)
        print(resp)
      }
    }
  }
  
  # Start the CLI tool
  handle_input()
}

# Run the CLI tool parser
construct_a_dec()