return {
  cmd = { "haskell-language-server-wrapper", "--lsp" },

  filetypes = { "haskell" },

  root_markers = {
    "hie.yaml",
    "stack.yaml",
    "cabal.project",
    "*.cabal",
    "package.yaml",
    ".git",
  },
}
