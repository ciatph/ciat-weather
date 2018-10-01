## Loads an R package if its already installed
## Downloads, installs and loads an R package if its not yet installed
## @param x: package name
## Usage: use usepackage('package_name') instead of library(package_name)
## madbarua; 20180927
usepackage <- function(x) {
  if (!is.element(x, installed.packages()[,1]))
    install.packages(x, dep = TRUE)
  require(x, character.only = TRUE)
}