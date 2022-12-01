# Advent of Code 2022 - Day 1

import std/[strutils,sequtils,algorithm,math]

type Data = seq[int]


proc parseData: Data =
  let chunks = readAll(stdin).strip.split("\n\n")
  for chunk in chunks:
    result.add chunk.split("\n").map(parseInt).sum


var data = parseData()
data.sort(SortOrder.Descending)

let part1 = data[0]
let part2 = data[0..2].sum

echo part1
echo part2
