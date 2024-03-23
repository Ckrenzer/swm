install_if_not_found "r-base-core"
install_if_not_found "libxml2-dev"          # r-languageserver (neovim LSP package) dependency
install_if_not_found "libcurl4-openssl-dev" # R package dependency
install_if_not_found "libssl-dev"           # R package dependency
install_if_not_found "libudunits2-dev"      # R package dependency
install_if_not_found "libgdal-dev"          # R package dependency

# install R packages
sudo Rscript -e "pkgs <- commandArgs(trailingOnly = TRUE)
                 installed <- rownames(installed.packages())
                 pkgs <- pkgs[!pkgs %in% installed]
                 install.packages(pkgs)" \
                     data.table    \
                     foreach       \
                     iterators     \
                     parallel      \
                     doParallel    \
                     rlang         \
                     roxygen2      \
                     xml2          \
                     lintr         \
                     stringr       \
                     ggplot2       \
                     patchwork     \
                     cowplot       \
                     gridExtra     \
                     knitr         \
                     kableExtra    \
                     openxlsx      \
                     googlesheets4 \
                     clipr         \
                     arrow         \
                     DBI           \
                     RPostgres     \
                     duckdb        \
                     dbplyr        \
                     rsconnect
