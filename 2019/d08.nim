# Advent of Code 2019 - Day 8

import std/[strutils, sequtils]
import ../utils/common

const
  width = 25
  height = 6
  layer = height * width

type Data = seq[seq[int]]


proc parseData: Data =
  let data = readInput().strip.mapIt(it.ord - '0'.ord)
  let num = data.len div layer
  result = data.distribute(num)


proc partOne(data: Data): int =
  let mi = data.mapIt(it.count(0)).minIndex
  result = data[mi].count(1) * data[mi].count(2)


proc compose(data: Data): seq[int] =
  for pi in 0..<layer:
    for li in 0..<data.len:
      if data[li][pi] < 2:
        result.add(data[li][pi])
        break


proc partTwo(data: Data): string =
  let single = data.compose
  assert single.len == layer

  for row in single.distribute(height):
    let line = row.mapIt(if it == 1: '#' else: ' ').join
    result &= (line & "\n")


let data = parseData()

benchmark:
  echo data.partOne
  echo data.partTwo.decodeBF6
