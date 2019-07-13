using MLJ, RDatasets
using Random:seed!
seed!(1234)

# ## MLJ Basics

boston = dataset("MASS", "Boston")
first(boston, 3)

# ### Machine types and Scitypes
#
# MLJ distinguishes between the machine type (how the data is originally encoded) and the scientific type (how the user believes the data should be interpreted).
# So for instance, it may be that an "Age" feature is encoded as some integer format but should be interpreted as a continuous feature.
#
# To one scitype can correspond only one (Abstract)type e.g. Continuous <> AbstractFloat.
# The opposite is not true as one machine type can correspond to several scientific types (e.g. in categorical cases).
#
# When looking at data with no information about the scientific types, MLJ will try to guess what they are, if that guess is incorrect, the user should specify the differences.
#
# **Current context**: most features are floating point number and so will be interpreted as continuous. However for instance "Rad" will be interpreted as a `Count` but we'd like to interpret is as `Continuous`.

scitypes(boston)

# ### Tasks
#
# Tasks wrap
#
# 1. the data
# 1. the interpretation of the data (see scitypes above)
# 1. the learning objectives (supervised/unsupervised etc)
#
# Here we want to specify the data, change the interpretation of `Rad` and `Tax` and specify that we want a supervised model with probabilistic output with the response being the `MedV` variable.

task = supervised(
        data   = boston,
        target = :MedV,
        ignore = :Chas,
        types  = Dict(:Rad=>Continuous, :Tax=>Continuous),
        is_probabilistic = true)

# In case the data is arranged in a specific order, we may want to shuffle it so that this doesn't impact the training.

shuffle!(task)

# ### Models
#
# What models are available to us for the given task?

models(task)

# If we just want a deterministic model, a few more models are available:
#

task.is_probabilistic = false
models(task)

# ### Binding a task to a model
#
# Let's say we want to use a simple ridge regression to start with.
# We first need to load it, specify the parameter and wrap the task and the model in a `machine`.

@load RidgeRegressor
ridge  = RidgeRegressor(lambda=0.1)

#-

mach = machine(ridge, task)

# ### Training and evaluation of performance
#
# The step by step approach involves:
#
# * creating a train/test split
# * fitting the machine
# * predicting on the test set
# * checking the performance

train, test = partition(1:nrows(task), 0.7)
fit!(mach, rows=train)
yhat = predict(mach, rows=test)

#-

rms(yhat, task.y[test])

# This can be done "all in one" using the `evaluate!` function (which returns the metric)

evaluate!(mach,
          resampling = Holdout(fraction_train = 0.7),
          measure    = rms)

# Either way, you can extract the parameters with `fitted_params` applied to the machine:

fp = fitted_params(mach);
fp.coefficients

#-

fp.bias
