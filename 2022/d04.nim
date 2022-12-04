# Advent of Code 2022 - Day 4

import std/[strutils,strscans,sequtils]

type
  Pair = tuple[a, b, c, d: int]

  Data = seq[Pair]


proc parsePair(line: string): Pair =
  let (_, a, b, c, d) = scanTuple(line, "$i-$i,$i-$i")
  (a, b, c, d)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parsePair)


func contains(pair: Pair): bool = 
  (pair.a <= pair.c and pair.d <= pair.b) or (pair.c <= pair.a and pair.b <= pair.d)

func overlaps(pair: Pair): bool =
  not (pair.d < pair.a or pair.b < pair.c)


let data = parseData()

let part1 = data.countIt(it.contains)
let part2 = data.countIt(it.overlaps)

echo part1
echo part2
