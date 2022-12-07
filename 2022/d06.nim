# Advent of Code 2022 - Day 6

import std/[strutils,setutils]

proc findDistinct(data: string, n: int): int =
  for i, _ in data:
    if data[i..<(i+n)].toSet.card == n:
      return i+n


let data = readAll(stdin).strip

let part1 = data.findDistinct(4)
let part2 = data.findDistinct(14)

echo part1
echo part2
