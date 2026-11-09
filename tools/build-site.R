#!/usr/bin/env Rscript
stopifnot(file.exists("DESCRIPTION"))
if (!nzchar(Sys.getenv("R_USER_CACHE_DIR"))) {
  cache <- file.path(getwd(), ".cache", "r-user")
  dir.create(cache, recursive = TRUE, showWarnings = FALSE)
  Sys.setenv(R_USER_CACHE_DIR = cache)
}
if (!requireNamespace("pkgdown", quietly = TRUE))
  stop("Install pkgdown before building: install.packages('pkgdown')")
if (!rmarkdown::pandoc_available()) {
  candidates <- c(
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64",
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/x86_64")
  for (p in candidates) if (file.exists(file.path(p, "pandoc"))) {
    Sys.setenv(RSTUDIO_PANDOC = p)
    break
  }
}
if (!rmarkdown::pandoc_available()) stop("Pandoc is required to build the articles.")
# Use the destination repository's account when GitHub Actions rebuilds the site.
repository <- Sys.getenv("GITHUB_REPOSITORY")
if (nzchar(repository)) {
  parts <- strsplit(repository, "/", fixed = TRUE)[[1]]
  base <- paste0("https://", parts[1], ".github.io/")
  if (tolower(parts[2]) != paste0(tolower(parts[1]), ".github.io"))
    base <- paste0(base, parts[2], "/")
  config <- yaml::read_yaml("_pkgdown.yml")
  config$url <- base
  yaml::write_yaml(config, "_pkgdown.yml")
}
pkgdown::init_site()
pkgdown::build_home()
pkgdown::build_reference(examples = FALSE)
for (article in pkgdown::as_pkgdown()$vignettes$name) {
  pkgdown::build_article(article, new_process = FALSE)
}
pkgdown::build_site(new_process = FALSE, install = FALSE,
                    lazy = TRUE, examples = FALSE, preview = FALSE)
file.create("docs/.nojekyll")
