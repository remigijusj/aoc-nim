# Advent of Code 2025 - Day 7

import std/[strutils,sequtils,tables]
import ../utils/common

type
  Layer = set[uint8]
  Data = seq[Layer]


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for s in countup(0, lines.len-1, 2):
    var layer: Layer
    for i, c in lines[s]:
      if c != '.': layer.incl(i.uint8)
    result.add(layer)


func valuesAt(count: CountTable[uint8], part: set[uint8]): CountTable[uint8] =
  for key in part:
    result[key] = count[key]


func shiftBy(count: CountTable[uint8], delta: int): CountTable[uint8] =
  for key, val in count:
    result[(key.int+delta).uint8] = val


func countSplits(data: Data): int =
  var beam = data[0]
  for layer in data[1..^1]:
    let carry = beam - layer
    let stops = beam * layer
    let split = stops.toSeq.mapIt({it-1, it+1}).foldl(a + b)
    beam = carry + split
    result.inc stops.card


func countTimelines(data: Data): int =
  let start = data[0].toSeq[0]
  var count = [start].toCountTable

  var beam = data[0]
  for layer in data[1..^1]:
    let carry = beam - layer
    let stops = beam * layer
    let split = stops.toSeq.mapIt({it-1, it+1}).foldl(a + b)
    beam = carry + split

    let left = count.valuesAt(stops).shiftBy(-1)
    let right = count.valuesAt(stops).shiftBy(1)
    count = count.valuesAt(carry)
    count.merge(left)
    count.merge(right)

  result = count.values.toSeq.sum


let data = parseData()

benchmark:
  echo data.countSplits
  echo data.countTimelines
