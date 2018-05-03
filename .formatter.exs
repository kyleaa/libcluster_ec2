[
  # files to format
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [config: 0],
  line_length: 120,
  rename_deprecated_at: "1.6.1"
]