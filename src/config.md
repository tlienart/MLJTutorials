<!-----------------------------------------------------
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
------------------------------------------------------->
@def prepath = "MLJTutorials"

@def website_title = "MLJ Tutorials"
@def website_descr = "Tutorials for the MLJ universe"
@def website_url   = "https://tlienart.github.io/MLJTutorials/"

@def author = "Thibaut Lienart"

@def hasmath = false

\newcommand{\cout}[1]{@@code-output @@title output: @@ \output{!#1} @@}

<!-----------------------------------------------------
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
------------------------------------------------------->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}

\newcommand{\tutorial}[1]{*Download the* ~~~<a href="https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml" target="_blank"><em>Project.toml</em></a>~~~, *the* ~~~<a href="https://raw.githubusercontent.com/tlienart/MLJTutorials/gh-pages/notebooks/!#1.ipynb" target="_blank"><em>notebook</em></a>~~~ *or the* ~~~<a href="https://raw.githubusercontent.com/tlienart/MLJTutorials/gh-pages/scripts/!#1.jl" target="_blank"><em>script</em></a>~~~ *for this tutorial (right-click on the link and save).* <!--_-->

\toc

\literate{/scripts/!#1.jl}}
