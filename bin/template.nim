# Advent of Code {year} - Day {day}

import std/[strutils,sequtils]

type Data = seq[string]


proc parseData: Data =
  readAll(stdin).strip.splitLines


let data = parseData()

echo 0
echo 0
