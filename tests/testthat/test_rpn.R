context("RPM to infix works fine")

test_that("RPM to infix conversion works fine", {
  re = c("6", "4", "*", "6", "+")
  res = rpn(re, eval = TRUE)
  expect_equal(res$infix, "((6*4)+6)")
  expect_equal(res$value, 30)

  expect_true(is.na(rpn(re, eval = FALSE)$value))

  # now more complex example
  re = c("6", "5", "5", "*", "+", "5", "-")
  res = rpn(re)
  expect_equal(res$infix, "((6+(5*5))-5)")
  expect_equal(res$value, 26)
})
