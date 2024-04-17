# Advent of code 2020 - Day 18

import std/[strutils, sequtils, nre]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


proc evalNested(expr: string, eval: proc(expr: string): int): int =
  var expr = expr
  while expr.contains re"\(":
    expr = expr.replace(re"\([0-9 +*]+\)", proc(match: string): string = $eval(match[1..^2]))
  eval(expr)


proc evalOps(expr: string): int =
  for m in expr.findIter(re"(^|[+*] )(\d+)"):
    case m.captures[0]:
    of "": result = m.captures[1].parseInt
    of "+ ": result += m.captures[1].parseInt
    of "* ": result *= m.captures[1].parseInt


proc evalInvert(expr: string): int =
  var expr = expr
  while expr.contains re"\+":
    expr = expr.replace(re"\d+( \+ \d+)+", proc(match: string): string = $evalOps(match))
  evalOps(expr)


let data = parseData()

benchmark:
  echo data.mapIt(it.evalNested(evalOps)).sum
  echo data.mapIt(it.evalNested(evalInvert)).sum
