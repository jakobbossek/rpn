# rpn: Reverse Polish Notation Interpreter

[![CRAN Status Badge](http://www.r-pkg.org/badges/version/rpn)](http://cran.r-project.org/web/packages/rpn)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/rpn)](http://cran.rstudio.com/web/packages/rpn/index.html)
[![Build Status](https://travis-ci.org/jakobbossek/rpn.svg?branch=master)](https://travis-ci.org/jakobbossek/rpn)
[![Build status](https://ci.appveyor.com/api/projects/status/eu0nns2dsgocwntw/branch/master?svg=true)](https://ci.appveyor.com/project/jakobbossek/rpn/branch/master)
[![Coverage Status](https://coveralls.io/repos/jakobbossek/rpn/badge.svg)](https://coveralls.io/r/jakobbossek/rpn)

## Description

This R package contains a method to transform [(reverse) polish notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation) to
[infix notation](https://en.wikipedia.org/wiki/Infix_notation).

```splus
# simple example
r = c("4", "6", "*", "6", "+")
rpn(r)
rpn(r, eval = FALSE)

# the same example but with a variable
r = c("x", "6", "*", "6", "+")
rpn(r, eval = TRUE, vars = list(x = 4))
rpn(r, eval = FALSE)

# now a more complex expression with variables and custom operators/functions
rpe = c("x", "5", "6.4", "mysum", "5", "mystuff")
mysum = function(x, y, z) x + y + z # arity 3 and no infix operation
mystuff = function(x, y) 2 * (x + y) # arity 2 and no infix operation
ops = list(mysum = list(3, FALSE, mysum), mystuff = list(2, FALSE, mystuff))
vars = list(x = 3.6)
rpn(rpe, ops = ops, vars = vars)
```

## Installation Instructions

The package will be available in a first version at [CRAN](http://cran.r-project.org) soon. If you are interested in trying out and playing around with the current github developer version use the [devtools](https://github.com/hadley/devtools) package and type the following command in R:

```splus
devtools::install_github("jakobbossek/rpn")
```

## Contact

Please address questions and missing features about the **rpn package** to the author Jakob Bossek <j.bossek@gmail.com>. Found some nasty bugs? Please use the [issue tracker](https://github.com/jakobbossek/rpn/issues) for this. Pay attention to explain the problem as good as possible. At its best you provide an example, so I can reproduce your problem.
