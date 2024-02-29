# Used by "mix format"
wildcard = fn glob -> Path.wildcard(glob, match_dot: true) end
matches = fn globs -> Enum.flat_map(globs, &wildcard.(&1)) end

except = []

inputs = [
  "*.{heex,ex,exs}",
  "priv/*/seeds.exs",
  "{config,lib,test}/**/*.{heex,ex,exs}"
]

[
  plugins: [TailwindFormatter, Phoenix.LiveView.HTMLFormatter],
  import_deps: [:ecto, :ecto_sql, :phoenix, :phx_formatter],
  inputs: matches.(inputs) -- matches.(except),
  subdirectories: ["priv/*/migrations"],
  heex_line_length: 74,
  line_length: 80
]
