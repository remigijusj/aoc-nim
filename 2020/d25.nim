# Advent of code 2020 - Day 25

import strutils

const MODULUS = 20_201_227

type Data = tuple[a, b: int]

proc readData(filename: string): Data =
  let lines = readFile(filename).splitLines
  result = (lines[0].parseInt, lines[1].parseInt)


proc partOne(data: Data): int =
  var a = 1
  var b = 1
  while true:
    a = (a * 7) mod MODULUS
    b = (b * data.b) mod MODULUS
    if a == data.a: return b


let data = readData("inputs/25.txt")
echo partOne(data)
