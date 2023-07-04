# Advent of Code 2017 - Day 7

import std/[strscans,strutils,sequtils,tables]

type
  Node = object
    name: string
    weight: int
    above: seq[string]

  Data = Table[string, Node]


func parseNode(line: string): Node =
  var above: string
  assert line.scanf("$+ ($i)$*", result.name, result.weight, above)
  if above.len > 0:
    result.above = above[4..^1].split(", ")


proc parseData: Data =
  for node in readAll(stdin).strip.splitLines.map(parseNode):
    result[node.name] = node


func rootName(data: Data): string =
  var seen: Table[string, bool]
  for node in data.values:
    for it in node.above:
      seen[it] = true
  for name in data.keys:
    if name notin seen:
      return name


func findOffender(weights: seq[int]): (int, int) =
  var tally: CountTable[int]
  for weight in weights:
    tally.inc(weight)

  if tally.len > 1:
    let idx = weights.find(tally.smallest.key)
    let delta = tally.smallest.key - tally.largest.key
    result = (idx, delta)


func traverseTree(data: Data, root: string): tuple[weight, unbalanced: int] =
  let node = data[root]
  var weights: seq[int]

  result.weight = node.weight
  for up in node.above:
    let (weight, unbalanced) = data.traverseTree(up)
    weights.add(weight)
    result.weight += weight
    if unbalanced != 0 and result.unbalanced == 0: # pass along if already found
      result.unbalanced = unbalanced

  if result.unbalanced == 0 and node.above.len > 2:
    let (idx, delta) = weights.findOffender
    if delta != 0:
      result.unbalanced = data[node.above[idx]].weight - delta


let data = parseData()
let root = data.rootName

echo root
echo data.traverseTree(root).unbalanced
