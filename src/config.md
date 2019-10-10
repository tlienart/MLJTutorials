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
