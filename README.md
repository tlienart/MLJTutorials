# MLJTutorials

This readme assumes that your current directory is `MLJTutorials`.

## For readers

You can read the tutorials [online](https://tlienart.github.io/MLJTutorials/).

If you want to experiment on the side, make sure to **activate a directory** with [this Project.toml](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml) file and update so that you get an environment which matches the one used to generate the tutorials:

```julia
using Pkg
Pkg.activate(".")
Pkg.update()
```

Each tutorial has a link at the top for a notebook or the raw script which you can download by right-clicking on the link and selecting "Save file as...".

## For developers

### Literate scripts

1. activate the environment (`] activate .`)
2. add packages if you need additional ones (`] add ...`)
3. add/modify tutorials in the `scripts/` folder
4. to help display things neatly (no horizontal overflow), prefer `pprint` from `PrettyPrinting.jl`

**Important**: use `MLJ.color_off` otherwise output is shown with ANSI colour codes (see other tutorials in the folder, add a `# hide` on that line so that it's not displayed on the web page).

### Adding a page

Say you've added a new script `A-my-tutorial.jl`, follow these steps to add a corresponding page on the website:

1. copy one of the markdown file available in `src/pages/getting-started` and paste it somewhere appropriate e.g.: `src/pages/getting-started/my-tutorial.md`
2. modify the title on that page, `# My tutorial`
3. modify the `\tutorial` command to `\tutorial{A-my-tutorial}` (no extensions)

By now you have at `src/pages/getting-started/my-tutorial.md`

```markdown
@def hascode = true
@def showall = true

# My tutorial

\tutorial{A-my-tutorial}
```

The last thing to do is to add a link to the page in `src/_html_parts/head.html`, copy paste the appropriate list item modifying the names so for instance:

```html
<li class="pure-menu-item {{ispage pub/getting-started/my-tutorial.html}}pure-menu-selected{{end}}"><a href="/pub/getting-started/my-tutorial.html" class="pure-menu-link">⊳ My tutorial</a></li>
```

### Visualise modifications locally

```julia
cd("path/to/MLJTutorials")
using JuDoc
serve()
```

If you have changed the *code* of some of the literate scripts, JuDoc will need to re-evaluate some of the code which may take some time, progress is indicated in the REPL.

If you decide to change some of the code while `serve()` is running, this is fine, JuDoc will detect it and trigger an update of the relevant web pages (after evaluating the new code).

**Note**: avoid modifying the literate file, killing the Julia session, then calling `serve()` that sequence can cause weird issues where Julia will complain about the age of the world...

### Merge conflicts

If when trying to run `serve` you get merge conflicts, do

```julia
cleanpull()
serve()
```

the first command will remove all stale generated HTML.

### Push updates

*Requirements*:

* admin access to the repo
* `] add Literate JuDoc NodeJS`
* install `highlight.js` and `gh-pages` from within Julia: ``run(`sudo $(npm_cmd()) i highlight.js gh-pages`)``

Assuming you have all that, just run

```julia
include("deploy.jl")
```

This should take ≤ 15 seconds to complete.

If you don't have some of the requirements, or if something failed, just open a PR.
