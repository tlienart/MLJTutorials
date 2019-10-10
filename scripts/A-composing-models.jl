# Before running this, make sure to activate the environment corresponding to
# [this `Project.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml)
# and update it so that you get an environment which matches the one used to generate
# the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the Project.toml
# using Pkg
# Pkg.activate(".")
# Pkg.update()
# ```

using MLJ, PrettyPrinting
MLJ.color_off() # hide / @reader: feel free to comment this out
@load KNNRegressor
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
height = [178, 194, 165, 173, 168];

scitype_union(X.age)

pipe = @pipeline MyPipe(X -> coerce(X, :age=>Continuous),
                       hot = OneHotEncoder(),
                       knn = KNNRegressor(K=3),
                       target = UnivariateStandardizer());

pipe.knn.K = 2
pipe.hot.drop_last = true;

evaluate(pipe, X, height, resampling=Holdout(),
         measure=rms) |> pprint

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

