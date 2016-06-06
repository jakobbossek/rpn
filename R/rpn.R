#' @title
#' Reverse Polish Notation converter/interpreter.
#'
#' @description
#' Expects an expression in (reverse) polish notation as a character vector and
#' returns the expression in infix notation and the evaluated expression.
#'
#' @details
#' This is a pure R implementation.
#'
#' @references
#' Lukasiewicz, Jan (1957). Aristotle's Syllogistic from the Standpoint of Modern
#' Formal Logic. Oxford University Press.
#'
#' @param rpn.expr [\code{character}]\cr
#'   Character vector representing the expression to convert in (reverse) polish notation.
#' @param reverse [\code{logical(1)}]\cr
#'   Is \code{rpn.expr} in reverse polish notation or polish notation?
#'   Default is \code{TRUE}, i.e., reverse polish notation.
#' @param eval [\code{logical(1)}]\cr
#'   Shall the expression be evaluated?
#'   Default is \code{TRUE}.
#' @param vars [\code{list}]\cr
#'   Named list of variables which are used in the \code{rpn.expr} beside constants.
#'   Default is the empty list.
#' @param clean [\code{logical(1)}]\cr
#'   Should braces be removed from \code{rpn.expr} before interpretation?
#'   Default is \code{TRUE}.
#' @param ops [\code{list}]\cr
#'   Optional named list of operators. If non-empty, the list must be of key-value
#'   type, i.e., the key is the name of the function and the value is a list with
#'   the 1) the length of the parameter vector the corresponding function expects,
#'   2) a logical value indicating whether the function is a binary infix operator
#'   and third the actual function to be called in case the expression is evaluated.
#' @return List with the components
#'   \describe{
#'     \item{infix}{Infix representation of \code{rpn.expr}.}
#'     \item{value}{Evaluated expression or \code{NA} if \code{eval} is set to \code{FALSE}.}
#'   }
#'
#' @examples
#' # simple example
#' r = c("4", "6", "*", "6", "+")
#' rpn(r)
#' rpn(r, eval = FALSE)
#'
#' # the same example but with a variable
#' r = c("x", "6", "*", "6", "+")
#' rpn(r, eval = TRUE, vars = list(x = 4))
#' rpn(r, eval = FALSE)
#'
#' # now a more complex expression with variables and custom operators/functions
#' rpe = c("x", "5", "6.4", "mysum", "5", "mystuff")
#' mysum = function(x, y, z) x + y + z # arity 3 and no infix operation
#' mystuff = function(x, y) 2 * (x + y) # arity 2 and no infix operation
#' ops = list(mysum = list(3, FALSE, mysum), mystuff = list(2, FALSE, mystuff))
#' vars = list(x = 3.6)
#' res = rpn(rpe, ops = ops, vars = vars)
#'
#' @export
rpn = function(rpn.expr, reverse = TRUE, eval = TRUE, clean = TRUE, vars = list(), ops = list()) {
  # sanity checking
  assertCharacter(rpn.expr, min.len = 1L, any.missing = FALSE, all.missing = FALSE)
  assertFlag(reverse)
  assertFlag(eval)
  assertFlag(clean)
  assertList(vars, any.missing = FALSE, all.missing = FALSE)
  assertList(ops, types = "list", any.missing = FALSE, all.missing = FALSE)

  default.ops = list(
    "+" = list(2, TRUE, "+"),
    "-" = list(2, TRUE, "-"),
    "*" = list(2, TRUE, "*"),
    "/" = list(2, TRUE, "/")
  )

  ops.meta = BBmisc::insert(default.ops, ops)
  ops.names = names(ops.meta)

  if (clean) {
    idx.to.clean = which(rpn.expr %in% c("(", ")"))
    if (length(idx.to.clean) > 0L)
      rpn.expr = rpn.expr[-idx.to.clean]
  }

  # just polish notation?
  if (!reverse) {
    rpn.expr = rev(rpn.expr)
  }

  n = length(rpn.expr)
  eval.stack = c()
  infix.stack = c()

  # first transform to infix notation
  i = 1L
  while (i <= n) {
    el = rpn.expr[i]
    # constant or variable
    if (el %nin% ops.names) {
      infix.stack = c(infix.stack, el)
      if (eval)
        eval.stack = c(eval.stack, el)
    }
    # operator? Check arity, pop elements and push result
    if (el %in% ops.names) {
      arity = ops.meta[[el]][[1L]]
      if (length(infix.stack) < arity) {
        stopf("ERROR: Function/operator '%s' has arity %i, but only %i elements on stack left.",
          el, arity, length(infix.stack))
      }
      # "pop" arity element from stack
      idxs = (length(infix.stack) - arity + 1L):length(infix.stack)
      infix.args = infix.stack[idxs]
      # remove args from stack
      infix.stack = infix.stack[-idxs]
      # build infix formula and push back on stack
      if (ops.meta[[el]][[2L]]) {
        # functions is binary operator, i.e., x y op -> x op y
        term = paste0("(", infix.args[1L], el, infix.args[2L], ")")
      } else {
        # function is not an operator, i.e,, x y ... z op -> op(x, y, z)
        term = paste0(el, "(", collapse(infix.args, sep = ", "), ")")
      }
      infix.stack = c(infix.stack, term)

      if (eval) {
        eval.args = eval.stack[idxs]
        eval.stack = eval.stack[-idxs]
        #FIXME: refactor the following lines
        #FIXME: add check for missing variable values
        for (var.name in names(vars)) {
          idx.var = which(eval.args == var.name)
          eval.args[idx.var] = vars[[var.name]]
        }
        eval.stack = c(eval.stack, do.call(ops.meta[[el]][[3L]], as.list(as.numeric(eval.args))))
      }
    }
    i = i + 1L
  }

  # if everything was fine and the expression was in valid (R)PN syntax/format
  # there should be a single element on the stack.
  if (length(infix.stack) != 1L) {
    stopf("Expression processed, but there are %i elements on the stack instead of a single result.",
      length(infix.stack))
  }

  return(
    list(
      infix = infix.stack,
      value = if (eval) as.numeric(eval.stack) else NA
    )
  )
}
