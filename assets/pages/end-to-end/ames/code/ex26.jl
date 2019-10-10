# This file was generated by JuDoc, do not modify it. # hide
tuning = Grid(resolution=3)
resampling = CV(nfolds=6)

tm = TunedModel(model=krb, tuning=tuning, resampling=resampling,
                ranges=ranges, measure=rmsl)