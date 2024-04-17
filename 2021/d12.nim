# Advent of Code 2021 - Day 12

import std/[strutils, strscans, sequtils, tables]
import ../utils/common

type Data = Table[string, seq[string]]

proc parseLine(line: string, data: var Data) =
  var a, b: string
  if line.scanf("$*-$*", a, b):
    discard data.hasKeyOrPut(a, @[])
    discard data.hasKeyOrPut(b, @[])
    data[a].add(b)
    data[b].add(a)


proc parseData: Data =
  for line in readInput().strip.splitLines:
    line.parseLine(result)


proc countPaths(data: Data, this: string, seen: seq[string], twice: bool): int =
  if this == "end":
    return 1

  for node in data[this]:
    if node[0].isLowerAscii:
      if node notin seen:
        result += data.countPaths(node, seen.concat(@[node]), twice)
      elif twice and node != "start":
        result += data.countPaths(node, seen, false)
    else:
      result += data.countPaths(node, seen, twice)


let data = parseData()

benchmark:
  echo data.countPaths("start", @["start"], false)
  echo data.countPaths("start", @["start"], true)
