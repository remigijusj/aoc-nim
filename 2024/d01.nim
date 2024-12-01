# Advent of Code 2024 - Day 1

import std/[strscans,strutils,sequtils,algorithm,tables]
import ../utils/common

type
  List = seq[int]

  Data = (List, List)


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for line in lines:
    let (_, one, two) = line.scanTuple("$i   $i")
    result[0].add(one)
    result[1].add(two)


func distance(data: Data): int =
  let one = data[0].sorted
  let two = data[1].sorted
  for (l, r) in zip(one, two):
    result += abs(l - r)


func similarity(data: Data): int =
  let cnt = data[1].toCountTable
  for val in data[0]:
    result += val * cnt[val]


let data = parseData()

benchmark:
  echo data.distance
  echo data.similarity
