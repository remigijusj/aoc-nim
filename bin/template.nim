# Advent of Code {year} - Day {day}

import std/[strutils,sequtils,sugar]

type Data = seq[string]


proc parseData: Data =
  readAll(stdin).strip(leading=false).splitLines


let data = parseData()

let part1 = 0
let part2 = 0

echo part1
echo part2
