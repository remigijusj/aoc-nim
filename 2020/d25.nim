# Advent of code 2020 - Day 25

import std/[strutils]
import ../utils/common

const MODULUS = 20_201_227

type Data = tuple[a, b: int]


proc parseData: Data =
  let lines = readInput().strip.splitLines
  result = (lines[0].parseInt, lines[1].parseInt)


proc encryptionKey(data: Data): int =
  var a = 1
  var b = 1
  while true:
    a = (a * 7) mod MODULUS
    b = (b * data.b) mod MODULUS
    if a == data.a: return b


let data = parseData()

benchmark:
  echo data.encryptionKey
