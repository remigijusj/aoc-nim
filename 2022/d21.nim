# Advent of Code 2022 - Day 21

import std/[strscans,strutils,tables,sets,algorithm,rationals]

type
  Monkey = object
    name: string
    val: int
    op: char
    arg1, arg2: string

  Equation = tuple[a, b: Rational[int]] # ax + b

  Data = Table[string, Monkey]


func parseMonkey(line: string): Monkey =
  result.name = line[0..3]
  result.op = ' '
  if line[6..^1].scanf("$i", result.val):
    discard
  elif line[6..^1].scanf("$w $c $w", result.arg1, result.op, result.arg2):
    discard
  else:
    discard


proc parseData: Data =
  for line in readAll(stdin).strip.splitLines:
    let m = line.parseMonkey
    result[m.name] = m


# DFS recursive topological sorting
proc topoSort(graph: Data, root: string): seq[string] =
  var order: seq[string]
  var seen: HashSet[string]

  proc helper(node: string) =
    let mon = graph[node]
    if mon.op != ' ':
      for dep in [mon.arg1, mon.arg2]:
        if dep notin seen:
          seen.incl(dep)
          helper(dep)
    order.insert(node, 0)

  helper(root)
  result = order.reversed


proc evalSymbolic(data: Data, list: seq[string], unknown = ""): Table[string, Equation] =
  for name in list:
    if name == unknown:
      result[name] = (1 // 1, 0 // 1).Equation
      continue

    let mon = data[name]
    case mon.op
      of ' ': result[name] = (0 // 1, mon.val // 1).Equation
      of '+': result[name] = (result[mon.arg1].a + result[mon.arg2].a, result[mon.arg1].b + result[mon.arg2].b)
      of '-': result[name] = (result[mon.arg1].a - result[mon.arg2].a, result[mon.arg1].b - result[mon.arg2].b)
      of '*':
        assert result[mon.arg1].a == 0 // 1 or result[mon.arg2].a == 0 // 1 # no multiplication of X
        result[name] = (
          result[mon.arg1].a * result[mon.arg2].b + result[mon.arg2].a * result[mon.arg1].b,
          result[mon.arg1].b * result[mon.arg2].b
        )
      of '/':
        assert result[mon.arg2].a == 0 // 1 and result[mon.arg2].b != 0 // 1 # division only by number
        result[name] = (result[mon.arg1].a / result[mon.arg2].b, result[mon.arg1].b / result[mon.arg2].b)
      else: discard


func solveEquality(values: Table[string, Equation], name1, name2: string): int =
  let a = values[name1].a - values[name2].a
  let b = values[name2].b - values[name1].b
  result = (b / a).toInt


let data = parseData()
let list = data.topoSort("root")

let part1 = data.evalSymbolic(list)["root"].b.toInt
let part2 = data.evalSymbolic(list, "humn").solveEquality(data["root"].arg1, data["root"].arg2)

echo part1
echo part2
