# Advent of Code 2023 - Day 13

import std/[strutils,sequtils]
import ../utils/common

type
  Field = seq[string]

  Data = seq[Field]


proc parseData: Data =
  readAll(stdin).strip.split("\n\n").mapIt(it.splitLines)


func sumReflections(field: Field, expected: int): int =
  for x in 1..<field[0].len:
    var diff = 0
    for d in 0..min(x-1, field[0].len-1-x):
      for y in 0..<field.len:
        if field[y][x+d] != field[y][x-1-d]:
          diff.inc
    if diff == expected:
      result += x

  for y in 1..<field.len:
    var diff = 0
    for d in 0..min(y-1, field.len-1-y):
      for x in 0..<field[0].len:
        if field[y+d][x] != field[y-1-d][x]:
          diff.inc
    if diff == expected:
      result += 100 * y


let data = parseData()

benchmark:
  echo data.mapIt(it.sumReflections(0)).sum
  echo data.mapIt(it.sumReflections(1)).sum
