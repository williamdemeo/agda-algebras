#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Lean Universal Algebra Library documentation build configuration file, created by
# sphinx-quickstart on Mon May 13 2019.
#
# This file is execfile()d with the current directory set to its
# containing dir.
#
# Note that not all possible configuration values are present in this
# autogenerated file.
#
# All configuration values have a default; values that are commented out
# serve to show the default.

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
sys.path.insert(0, os.path.abspath('.'))

# -- General configuration ------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#
# needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['sphinx.ext.mathjax', 'sphinx.ext.githubpages', 'lean_sphinx', 'sphinxcontrib.bibtex']

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
#
# source_suffix = ['.rst', '.md']
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'The Lean Universal Algebra Library'
copyright = u'2019, William DeMeo'
author = u'William DeMeo'

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = u'0'
# The full version, including alpha/beta/rc tags.
release = u'0.1'

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = None

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This patterns also effect to html_static_path and html_extra_path
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store', '.venv', 'exclude']

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = False

source_parsers = {
}

# use numbering for section references with :numref:, e.g. 'Section 3.2'.
numfig = True


# -- Options for HTML output ----------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#
html_theme_options = {
    'logo_name': True,
    'font_family': 'Times New Roman, Times, serif',
    'head_font_family': 'Times New Roman, Times, serif',
    'code_bg': 'white',
    'extra_nav_links': {'PDF version':'ualib.pdf',
                       'Logical Foundations Home':'https://logicalfoundations.gitlab.io/'},
    # 'sidebar_width' : '200px',
    # 'page_width' : '960px',
    # 'fixed_sidebar' : True
}

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_favicon = '_static/lambda.jpg'
html_logo = '_static/lambda.jpg'
html_show_sourcelink = False
#html_output_encoding = 'ascii'

# Custom sidebar templates, must be a dictionary that maps document names
# to template names.
#
# This is required for the alabaster theme
# refs: http://alabaster.readthedocs.io/en/latest/installation.html#sidebars
html_sidebars = {
    '**': [
        'about.html',
        'navigation_without_header.html',
        #'relations.html',  # needs 'show_related': True theme option to display
        'searchbox.html',
        #'donate.html',
    ]
}


# -- Options for HTMLHelp output ------------------------------------------

# Output file base name for HTML help builder.
htmlhelp_basename = 'ualib'


# -- Options for LaTeX output ---------------------------------------------

latex_engine = 'xelatex'

latex_additional_files = ['unixode.sty', 'bussproofs.sty', 'mylogic.sty']

latex_elements = {
    # The paper size ('letterpaper' or 'a4paper').
    #
    # 'papersize': 'letterpaper',

    # The font size ('10pt', '11pt' or '12pt').
    #
    # 'pointsize': '10pt',

    # Additional stuff for the LaTeX preamble.
    # load packages and make box around code lighter
    'preamble': r'''
\usepackage{unixode}
\usepackage{bussproofs}
\usepackage{mylogic}
\usepackage{amsmath}
\definecolor{VerbatimBorderColor}{rgb}{0.7,0.7,0.7}
''',

    # Latex figure (float) alignment
    #
    # 'figure_align': 'htbp',
}
# -- Options for LaTeX extension ----------------------------------------------

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (master_doc, 'ualib.tex', u'Lean Universal Algebra Library',
     u'William DeMeo', 'manual'),
]


# -- Options for manual page output ------------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, 'ualib', u'Lean Universal Algebra Library',
     [author], 1)
]

# -- Options for Texinfo output ----------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (master_doc, 'ualib', u'Lean Universal Algebra Library',
     author, 'ualib', 'One line description of project.',
     'Miscellaneous'),
]

# -- Options for Epub output -------------------------------------------------


