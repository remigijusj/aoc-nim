# Advent of Code 2023 - Day 1

import std/[strutils]
import ../utils/common

type Data = seq[string]

const numbers = ["zero","one","two","three","four","five","six","seven","eight","nine"]


proc parseData: Data =
  readAll(stdin).strip.splitLines


proc fetchDigits(line: string, words: bool): seq[int] =
  for i, c in line:
    if c.isDigit:
      result.add(c.ord - '0'.ord)
    elif words:
      for d, num in numbers:
        if line.continuesWith(num, i):
          result.add(d)


func checksum(data: Data, words = false): int =
  for line in data:
    let digits = line.fetchDigits(words)
    result += digits[0] * 10 + digits[^1]


let data = parseData()

benchmark:
  echo data.checksum
  echo data.checksum(true)
