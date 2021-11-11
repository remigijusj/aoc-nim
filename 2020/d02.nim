# Advent of code 2020 - Day 2

import strscans, sequtils

type Item = object
  a, b: int
  c: char
  pass: string


proc parseItem(line: string): Item =
  discard scanf(line, "$i-$i $c: $+", result.a, result.b, result.c, result.pass)


proc itemList(filename: string): seq[Item] =
  for line in lines(filename):
    result.add parseItem(line)


proc validCount(it: Item): bool =
  it.pass.count(it.c).in (it.a .. it.b)


proc validPositions(it: Item): bool =
  it.pass[it.a - 1] == it.c xor it.pass[it.b - 1] == it.c


proc partOne(list: seq[Item]): int = list.countIt validCount(it)
proc partTwo(list: seq[Item]): int = list.countIt validPositions(it)


let list = itemList("inputs/02.txt")
echo partOne(list)
echo partTwo(list)
