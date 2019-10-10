# this runs in your environment and assumes that all your scripts are up to date etc.
# do not run this if you have not previously run `serve()` and checked everything was fine.

Pkg.activate()

using JuDoc, Pkg, Logging, NodeJS, Literate

##################################################################
## PART 1: generate all scripts and notebooks and push everything
# on the gh-pages branch (yes we're abusing the system)
##################################################################

Logging.disable_logging(Logging.LogLevel(1500))

ifiles = joinpath.("scripts", readdir("scripts"))

nbpath = joinpath("generated", "notebooks")
scpath = joinpath("generated", "scripts")

isdir(nbpath) || mkpath(nbpath)
isdir(scpath) || mkpath(scpath)

Literate.notebook.(ifiles, nbpath, execute=false, documenter=false)
Literate.script.(ifiles, scpath, documenter=false)

JS_GHP = """
    var ghpages = require('gh-pages');
    ghpages.publish('generated/', function(err) {});
    """

run(`$(nodejs_cmd()) -e $JS_GHP`)

##################################################################
## PART 2
# optimize (compress and pre-render) the website and publish it
# to the master branch this time.
##################################################################

publish()
