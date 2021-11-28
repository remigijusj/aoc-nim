# Advent of Code {year} - Day {day}

import std/[strutils]

type Data = seq[string]


proc parseData(filename: string): Data =
  for line in lines(filename):
    result.add line


proc partOne(data: Data): int = 0
proc partTwo(data: Data): int = 0

let data = parseData("inputs/{day:02}.txt")
echo partOne(data)
echo partTwo(data)
