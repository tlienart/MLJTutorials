using MLJ, RDatasets
using Random: seed!
seed!(1234)

#-

task = load_iris()
shuffle!(task)

#-

@load DecisionTreeClassifier

# ### Single decision tree

tree = DecisionTreeClassifier()
mach = machine(tree, task)

# We can then just train the machine with default resampling and default metric.
# The default resampling is 6 fold CV so we get 6 metrics for each of these fold.

evaluate!(mach)

# When predicting from that machine, the model gives normalized scores (probabilities) associated with each possible class.

yhat = predict(mach, rows=1:2)

# We can return the score obtained for a given class for each instance:

[pdf(d, "virginica") for d in yhat]

# We can also just return the class with the highest score using  `predict_mode`:

predict_mode(mach, rows=1:2)

# ## Using a bag of trees
#
# Here we use MLJ's ensembling machinery to train several individual decision trees.
# Note that we can just reuse the template for the tree created earlier.
# We use default parameters otherwise which trains 100 models in parallel.

bag = EnsembleModel(atom=tree)

# As usual, we wrap the model (bag of tree) with the task (data, interpretation, objective)

mach = machine(bag, task)

# we can explore how many trees work best

r = range(bag, :n, lower=10, upper=1000, scale=:log10)
iterator(r, 5)

#-

nruns  = 4
curves = learning_curve!(mach,
             resampling = Holdout(fraction_train=0.8),
             range      = r,
             measure    = cross_entropy,
             n          = nruns,
             verbosity  = 0)

#-

using PyPlot

figure()

for i ∈ 1:nruns
    plot(curves.parameter_values, curves.measurements[:, i],
         linestyle="none", marker="o")
end
plot(curves.parameter_values, sum(curves.measurements, dims=2)/nruns)

xlabel("Number of trees")
ylabel("Cross entropy")

gcf()

#-

savefig("fig_interm-ensemble_learning-curve.pdf")

# Let's set the number of atoms to 100 for now

bag.n = 100

# We can inspect the parameters of the ensemble like so:

params(bag)
