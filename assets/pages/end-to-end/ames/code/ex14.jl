# This file was generated by JuDoc, do not modify it. # hide
fit!(ŷ, rows=train)
ypreds = ŷ(rows=test)
rmsl(y[test], ypreds)
