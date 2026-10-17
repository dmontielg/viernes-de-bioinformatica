# Allow VS Code Session Watcher to initialize alongside renv
if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
  if (file.exists(file.path(Sys.getenv("HOME"), ".vscode-R", "init.R"))) {
    source(file.path(Sys.getenv("HOME"), ".vscode-R", "init.R"))
  }
}

#source("renv/activate.R")
