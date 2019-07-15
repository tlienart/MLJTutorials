using Literate

for f in readdir(".")
    endswith(f, ".jl") || continue
    Literate.notebook(f, "generated-notebooks")
end
