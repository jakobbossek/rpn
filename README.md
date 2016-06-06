# rpn: Reverse Polish Notation Interpreter

[![CRAN Status Badge](http://www.r-pkg.org/badges/version/rpn)](http://cran.r-project.org/web/packages/rpn)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/rpn)](http://cran.rstudio.com/web/packages/rpn/index.html)
[![Build Status](https://travis-ci.org/jakobbossek/rpn.svg?branch=master)](https://travis-ci.org/jakobbossek/rpn)
[![Build status](https://ci.appveyor.com/api/projects/status/eu0nns2dsgocwntw/branch/master?svg=true)](https://ci.appveyor.com/project/jakobbossek/rpn/branch/master)
[![Coverage Status](https://coveralls.io/repos/jakobbossek/rpn/badge.svg)](https://coveralls.io/r/jakobbossek/rpn)

## Description

This R package contains a method to transform (reverse) polish notation to
infix notation. It is a minimalistic, pure R implementation with no syntax checking. Passing syntatically correct RPN is thus neccessary. Otherwise the parsing process may fail with incomprehensible error messages.

## Installation Instructions

The package will be available in a first version at [CRAN](http://cran.r-project.org) soon. If you are interested in trying out and playing around with the current github developer version use the [devtools](https://github.com/hadley/devtools) package and type the following command in R:

```splus
devtools::install_github("jakobbossek/rpn")
```

## Example

Assume we want to minimize the 2D [Ackeley Function](http://www.sfu.ca/~ssurjano/ackley.html). To accomplish this task with *rpn* we need to define the objective function as a [smoof](https://github.com/jakobbossek/smoof) function. This function is then passed with some control arguments to the main function of the packge.

## Contact

Please address questions and missing features about the **rpn package** to the author Jakob Bossek <j.bossek@gmail.com>. Found some nasty bugs? Please use the [issue tracker](https://github.com/jakobbossek/rpn/issues) for this. Pay attention to explain the problem as good as possible. At its best you provide an example, so I can reproduce your problem.
