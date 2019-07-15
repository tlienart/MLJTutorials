# # Self-tuning models

using MLJ
using PyPlot

#-

# Load the task corresponding to boston (data, interpretation & objective), a supervised task.

task = load_boston()

# Check what models are available to deal with the task

models(task)

# One of them is the decision tree regressor

@load DecisionTreeRegressor

# ## Using a single DTR

tree = DecisionTreeRegressor()
mach = machine(tree, task)

# We evaluate it using a Holdout resampling (training on 0.8 and testing on the remaining 0.2); we also use two metrics: the `rms` (usual root mean square) and the `rmslp1`

res = evaluate!(mach, resampling=Holdout(fraction_train=0.8), measure=[rms, rmslp1])
res.rms

# the `rmslp1` is given by the `rms` of $log((y+1)/(ŷ+1))$

res.rmslp1

# ## Ensemble of DTR (random forest)

forest = EnsembleModel(atom=tree)

#-

# In a random forest, the number of features used by every node is sampled, usually about the square root of the total number of features is used per tree

tree.n_subfeatures = 3

# To get an idea of how many trees we need, we wrap the forest model in the task, pick a range for the ensemble size, `n`, and generate learning curves

mach   = machine(forest, task)
curves = learning_curve!(mach,
                resampling   = Holdout(fraction_train=0.8),
                nested_range = (n=range(forest, :n, lower=10, upper=1000),),
                n            = 4,
                verbosity    = 0
                )

#-

figure()
plot(curves.parameter_values, curves.measurements, linestyle="none", marker="o")

xlabel("Number of trees")
ylabel("RMS")

gcf()

#-

forest.n = 300

# ## Tuning
# As `forest` is a composite model, it has nested hyperparameters; all hyperparameters can be recovered through `params` which gives back a named tuple

p = params(forest)

# We can recover the specifications of the atomic element (NOTE: here we have a homogenous ensemble where all the models in the ensemble follow the same blueprint)

p.atom

# We can also have access to general parameters of the ensemble such as the bagging fraction or how many trees are used

p.bagging_fraction

#-

p.n

# Let's define ranges for two hyperparameters we want to tune: first the number of subfeatures we want to use per tree (currently set to 3) and second the bagging fraction.

r1 = range(tree, :n_subfeatures, lower=1, upper=12)
r2 = range(forest, :bagging_fraction, lower=0.4, upper=1.0)

# The ranges can then be put in a common named tuple with names matching the pattern of `params(...)`

nested_ranges = (atom             = (n_subfeatures=r1, ),
                 bagging_fraction = r2  )

# Now we can wrap the forest in a tuing strategy to obtain a "self-tuning" model:

tuned_forest = TunedModel(model         = forest,
                          tuning        = Grid(resolution=12),
                          resampling    = CV(nfolds=6),
                          nested_ranges = nested_ranges,
                          measure       = rms)

# Again we can explore the parameters:

params(tuned_forest)

# ## Evaluation of the self-tuning random forest
# (This takes a while)

mach = machine(tuned_forest, task)
evaluate!(mach, resampling=Holdout(fraction_train=0.8), measure=[rms, rmslp1])

# Implicit in this evaluation is nested resampling: evaluate! fits the tuned forest on the training data and evaluates its performance on the houldout test set. We can explore the optimal parameters with `fitted_params`

fitted_params(mach)

# We can extract the best model as well

best = fitted_params(mach).best_model

#-

best.bagging_fraction

#-

best.atom.n_subfeatures

# we can also recover how the search went to (e.g.) build a heatmap. (12x12 grid)

mach.report.parameter_values

# and (144 measurements)

mach.report.measurements
