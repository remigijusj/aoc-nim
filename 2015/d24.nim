# Advent of Code 2015 - Day 24

import std/[strutils,sequtils]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.splitLines.map(parseInt)


func idealSplit(data: Data, target, size: int): int =
  var indices: seq[int] = (0..<size).toSeq
  var weight: int = data[0..<size].sum

  while true:
    if weight == target:
      return indices.mapIt(data[it]).prod # QE

    var depth = size - 1
    while indices[depth] == data.len - size + depth:
      if depth == 0:
        return -1 # not found
      depth -= 1

    let this = indices[depth]
    let next = indices[depth] + 1
    indices[depth] = next
    weight = weight - data[this] + data[next]
    depth += 1

    while depth < size:
      let this = indices[depth]
      let next = indices[depth - 1] + 1
      indices[depth] = next
      weight = weight - data[this] + data[next]
      depth += 1


func idealSplit(data: Data, parts: int): int =
  let weight = data.sum div parts
  for size in 1..<data.len:
    result = data.idealSplit(weight, size)
    if result >= 0:
      return


let data = parseData()

benchmark:
  echo data.idealSplit(3)
  echo data.idealSplit(4)
