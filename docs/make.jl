using Documenter, Enrich

makedocs(
    modules = [Enrich],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Fredrik Pettersson",
    sitename = "Enrich.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/Fredrikp-ume/Enrich.jl.git",
    push_preview = true
)
