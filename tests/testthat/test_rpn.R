context("RPN to infix works fine")

test_that("RPN to infix conversion works fine", {
  rpe = c("6", "4", "*", "6", "+")
  res = rpn(rpe, eval = TRUE)
  expect_equal(res$infix, "((6*4)+6)")
  expect_equal(res$value, 30)

  expect_true(is.na(rpn(rpe, eval = FALSE)$value))

  # now more complex example
  rpe = c("6", "5", "5", "*", "+", "5", "-")
  res = rpn(rpe)
  expect_equal(res$infix, "((6+(5*5))-5)")
  expect_equal(res$value, 26)
})

test_that("RPN breaks on wrong operator arity", {
  rpe = c("6", "+") # invalid! Wrong number of arguments
  expect_error(rpn(rpe), regexp = "arity")
})

test_that("RPN breaks if the number of elements on stack is greater 1 after termination", {
  rpe = c("5", "5", "5", "+") # invalid!
  expect_error(rpn(rpe), regexp = "single result")
})

test_that("PN and RPN give the same results", {
  rpe = c("6", "5", "5", "*", "+", "5", "-")
  pe = rev(rpe) # polish expression, i.e., operators before operands

  res.rpe = rpn(rpe)
  res.pe  = rpn(pe, reverse = FALSE)

  expect_equal(res.rpe$infix, res.pe$infix)
  expect_equal(res.rpe$value, res.pe$value)
})

test_that("Variables work and are included in evaluatio", {
  rpe = c("x", "y", "+", 5, "/")
  expect_warning(rpn(rpe, eval = TRUE)) # since variables are not replaced

  vars = list(x = 10.5, y = 14.5)
  res = rpn(rpe, vars = vars)
  expect_equal(res$infix, "((x+y)/5)")
  expect_equal(res$value, 5)
})

test_that("Additional operators work nicely", {
  rpe = c("x", "5", "6.4", "mysum", "5", "mystuff")
  mysum = function(x, y, z) x + y + z # arity 3 and no infix operation
  mystuff = function(x, y) 2 * (x + y) # arity 2 and no infix operation
  ops = list(mysum = list(3, FALSE, mysum), mystuff = list(2, FALSE, mystuff))
  vars = list(x = 3.6)
  res = rpn(rpe, ops = ops, vars = vars)
  expect_equal(res$infix, "mystuff(mysum(x, 5, 6.4), 5)")
  expect_equal(res$value, 40)
})

test_that("Cleaning RPN formula works fine", {
  rpe = c("6", "4", "*", "6", "+")
  rpe2 = c("(", "(", "6", "4", "*", ")", "6", "+", ")")
  res.rpe = rpn(rpe)
  res.rpe2 = rpn(rpe2)
  expect_equal(res.rpe$infix, res.rpe2$infix)
  expect_equal(res.rpe$value, res.rpe2$value)
})
