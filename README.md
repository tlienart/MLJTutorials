# MLJTutorials
Tutorials for MLJ.jl

## Generating notebooks

To generate notebooks from the scripts, use `Literate.jl` in the folder:

```julia
using Literate

for f in readdir(".")
    endswith(f, ".jl") || continue
    Literate.notebook(f, "generated-notebooks")
end
```

This will generate all corresponding notebooks after executing the scripts (which will work assuming you have the relevant dependencies). 
If you would like to execute the notebooks yourself step-by-step, add a keyword `execute=false` in the `Literate.notebook` call above.
