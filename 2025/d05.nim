# Advent of Code 2025 - Day 5

import std/[strscans,strutils,sequtils,algorithm]
import ../utils/common

type
  Range = Slice[int]
  Data = (seq[Range], seq[int])


proc `<`(x, y: Range): bool =
  if x.a == y.a:
    x.b < y.b
  else:
    x.a < y.a


func parseRange(line: string): Range =
  assert line.scanf("$i-$i", result.a, result.b)


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  let ranges = parts[0].split("\n").map(parseRange)
  let list = parts[1].split("\n").map(parseInt)
  result = (ranges, list)


func fresh(n: int, ranges: seq[Range]): bool =
  ranges.anyIt(n in it)


# Range consolidation, from Rosetta code
proc consolidate(ranges: seq[Range]): seq[Range] =
  var list = ranges
  list.sort

  result.add list[0]
  for i in 1..list.high:
    let rmin = result[^1]
    let rmax = list[i]
    if rmax.a <= rmin.b:
      result[^1] = rmin.a .. max(rmin.b, rmax.b)
    else:
      result.add rmax


let (ranges, ids) = parseData()

benchmark:
  echo ids.countIt(it.fresh(ranges))
  echo ranges.consolidate.mapIt(it.len).sum
