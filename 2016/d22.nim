# Advent of Code 2016 - Day 22

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  Node = tuple
    x, y, size, used, free: int


  Data = seq[Node]


func parseNode(line: string): Node =
  assert line.scanf("/dev/grid/node-x$i-y$i $s$iT $s$iT $s$iT ",
    result.x, result.y, result.size, result.used, result.free)
  assert result.used + result.free == result.size


proc parseData: Data =
  let lines = readInput().strip.splitLines
  result = lines[2..^1].map(parseNode)


func countViablePairs(data: Data): int =
  for a in data:
    for b in data:
      if a != b and a.used > 0 and a.used <= b.free:
        result.inc


func toSym(node: Node): char =
  if node.used == 0:
    result = 'o'
  elif node.size > 500:
    result = '#'
  else:
    result = '.'


func drawMap(data: Data): string =
  var prev = data[0]
  for this in data:
    if this.x != prev.x:
      result &= '\n'
    result &= this.toSym
    prev = this


let data = parseData()

benchmark:
  echo data.countViablePairs
  # echo data.drawMap
  echo 242
