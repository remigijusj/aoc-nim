# Advent of Code 2019 - Day 14

import std/[strutils, tables, sets]
from algorithm import reversed
from math import ceilDiv, `^`
import npeg

type Item = tuple[units: int, name: string]

type Rule = object
  units: int
  needs: Table[string, int]

type Data = object
  rules: Table[string, Rule]
  order: seq[string]


var i: Item
var r: Rule
const dataParser = peg("data", data: Data):
  sep <- ?',' * *' '
  item <- >+Digit * sep * >+Alpha * sep:
    i = (parseInt($1), $2)
  needs <- item:
    r.needs[i.name] = i.units
  makes <- item:
    r.units = i.units
  rule <- +needs * "=> " * makes * '\n':
    data.rules[i.name] = r
    r.needs.clear
  data <- +rule


# DFS recursive topological sort
proc topoSort(data: Data, name: string): seq[string] =
  var seen: HashSet[string]
  var order: seq[string]

  proc sortHelper(name: string) =
    for dep in data.rules[name].needs.keys:
      if dep notin seen and dep in data.rules: # without ORE
        seen.incl(dep)
        sortHelper(dep)
    order.add(name)

  sortHelper(name)
  result = order.reversed


proc parseData(filename: string): Data =
  let text = readFile(filename)
  assert dataParser.match(text, result).ok
  result.order = result.topoSort("FUEL")


proc minOreForFuel(data: Data, units: int): int =
  var needs: CountTable[string]
  needs["FUEL"] = units

  for i, name in data.order:
    let batches = ceilDiv(needs[name], data.rules[name].units)
    for ingr, cnt in data.rules[name].needs:
      needs.inc(ingr, cnt * batches)

  result = needs["ORE"]


# Binary search
proc maxFuelFromOre(data: Data, limit: int): int =
  result = 3_600_000 # heuristic
  var step = 2 ^ 19
  while step > 0:
    if data.minOreForFuel(result) <= limit:
      result.inc(step)
    else:
      result.dec(step)
    step = step div 2
  if data.minOreForFuel(result) > limit:
    result.dec


proc partOne(data: Data): int = data.minOreForFuel(1)
proc partTwo(data: Data): int = data.maxFuelFromOre(1_000_000_000_000.int)

let data = parseData("inputs/14.txt")
echo partOne(data)
echo partTwo(data)
