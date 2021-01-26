# ualib.gitlab.io

This is the main repository for the Agda Universal Algebra Library (UALib), a library of Agda modules for universal algebra and related subjects, and the associated html and pdf documentation.

Below are instructions for getting the Agda UALib installed on your machine.  I hope that these steps work for you; they work on my Ubuntu 18.04 machine, but I haven't tested them on a fresh distro, or any other OS, so... 

...in any case, please [email me](mailto:williamdemeo@gmail.com) if you have trouble.

---------------------------

## Introduction

This repository contains the source code, as well as files that generate [documentation](https://ualib.gitlab.io/), for the [Agda Universal Algebra Library](https://gitlab.com/ualib/ualib.gitlab.io), aka [Agda UALib](https://gitlab.com/ualib/ualib.gitlab.io).

The docs are served at [ualib.org](https://ualib.gitlab.io/), and are automatically generated from the .lagda files using the script [generate-md](https://gitlab.com/ualib/ualib.gitlab.io/-/blob/master/generate-md). See the section on [Generating the documentation](#generating-the-documentation) below.

-----------------------------

## Install Agda

Agda [2.6.1](https://agda.readthedocs.io/en/v2.6.1/getting-started/installation.html) is required. 

If you don't have Agda and agda2-mode installed, follow the [official installation instructions](https://agda.readthedocs.io/en/v2.6.0/getting-started/installation.html) or [Martin Escardo's installation instructions](INSTALL_AGDA.md) to help you set up Agda and Emacs.

-----------------------------

## Download the UALib

[Clone](https://docs.gitlab.com/ee/gitlab-basics/command-line-commands.html) the repository to your local machine using **ONE** of the following alternative commands:

``` sh
git clone https://gitlab.com/ualib/ualib.gitlab.io.git
cd ualib.gitlab.io
```

**OR**, if you have a gitlab account and have configured [ssh keys](https://docs.gitlab.com/ee/ssh/),


``` sh
git clone git@gitlab.com:ualib/ualib.gitlab.io.git
cd ualib.gitlab.io
```

After installing Agda and cloning the ualib.gitlab.io repository, you should be able to work with the Agda UALib source code contained in the .lagda files like UALib.lagda or any of it submodules in the ualib.gitlab.io/UALib directory.  For example, you could start by having a look at [UALib/Prelude/Preliminaries.lagda](https://gitlab.com/ualib/ualib.gitlab.io/-/blob/master/UALib/Prelude/Preliminaries.lagda).

--------------------------------------------

## Generating the documentation

(**To do** update this section with better, more complete instructions)

The html documentation pages are generated from the [literate](https://agda.readthedocs.io/en/latest/tools/literate-programming.html) Agda (.lagda) files, written in markdown, with the formal, verified, mathematical development appearing within `\begin{code}...\end{code}` blocks, and some mathematical discussions outside those blocks.

The html pages are generated automatically by Agda with the command

```
agda --html --html-highlight=code UALib.lagda
```

This generates a set of markdown files that are then converted to html by jekyll with the command

```shell
bundle exec jekyll build
```

In practice, we use the script `generate-md`, to process the lagda files and put the resulting markdown output in the right place, and then using the script `jekyll-serve` to invoke the following commands

```
cp html/UALib.md index.md
cp html/*.html html/*.md .
bundle install --path vendor
bundle exec jekyll serve --watch --incremental
```

This causes jekyll to serve the web pages locally so we can inspect them by pointing a browser to [127.0.0.1:4000](http://127.0.0.1:4000).

--------------------------------


## Acknowledgements

A great source of information and inspiration for the Agda UALib is [Marin Escardo's lecture notes on HoTT/UF in Agda](https://www.cs.bham.ac.uk/~mhe/HoTT-UF-in-Agda-Lecture-Notes/index.html).

See also Martin's [HoTT/UF github repository](https://github.com/martinescardo/HoTT-UF-Agda-Lecture-Notes) and [Type Topology github repository](https://github.com/martinescardo/TypeTopology).

-------------------------------
