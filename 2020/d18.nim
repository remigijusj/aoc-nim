# Advent of code 2020 - Day 18

import strutils, sequtils, nre

proc readLines(filename: string): seq[string] =
  for line in lines(filename):
    result.add line


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


proc partOne(list: seq[string]): int = list.mapIt(it.evalNested(evalOps)).foldl(a + b)
proc partTwo(list: seq[string]): int = list.mapIt(it.evalNested(evalInvert)).foldl(a + b)


let list = readLines("inputs/18.txt")
echo partOne(list)
echo partTwo(list)
