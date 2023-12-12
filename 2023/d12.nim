# Advent of Code 2023 - Day 12

import std/[strutils,sequtils]
import ../utils/common
import memo

type
  Item = tuple
    springs: string
    groups: seq[int]

  Data = seq[Item]


func parseItem(line: string): Item =
  let parts = line.splitWhitespace
  result.springs = parts[0]
  result.groups = parts[1].split(',').map(parseInt)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseItem)


func unfold(item: Item, count: int): Item =
  result.springs = sequtils.repeat(item.springs, count).join("?")
  result.groups = item.groups.cycle(count)


proc countArrangements(item: Item): int =
  # spring index, group index, this group
  proc count(si, gi, this: int): int {.memoized.} =
    if si == item.springs.len:
      if gi == item.groups.len and this == 0:
        return 1
      elif gi == item.groups.len-1 and this == item.groups[gi]:
        return 1
      else:
        return 0

    let d = item.springs[si]
    for c in ".#":
      if d == '?' or d == c:
        if c == '#':
          result += count(si+1, gi, this+1)
        elif c == '.' and this == 0:
          result += count(si+1, gi, 0)
        elif c == '.' and this > 0 and gi < item.groups.len and this == item.groups[gi]:
          result += count(si+1, gi+1, 0)

  result = count(0, 0, 0)


let data = parseData()

benchmark:
  echo data.map(countArrangements).sum
  echo data.mapIt(it.unfold(5)).map(countArrangements).sum
