# Advent of Code 2017 - Day 15

import std/strscans
import ../utils/common

type
  Data = tuple[A, B: int]

const
  Mult: Data = (16807, 48271)
  Period = 2147483647

proc parseData: Data =
  let text = readInput()
  assert text.scanf("Generator A starts with $i\nGenerator B starts with $i\n", result.A, result.B)


func initGen(start, mult: int, cond: int = 1): iterator(): int =
  result = iterator(): int =
    var value = start
    while true:
      value = (value * mult) mod Period
      if value mod cond == 0:
        yield(value)


proc countMatches(data, mult, cond: Data, rounds: int): int =
  let genA = initGen(data.A, mult.A, cond.A)
  let genB = initGen(data.B, mult.B, cond.B)
  for _ in 1..rounds:
    for a in genA():
      for b in genB():
        if (a and 0xFFFF) == (b and 0xFFFF):
          result.inc
        break
      break


let data = parseData()

benchmark:
  echo countMatches(data, Mult, (1, 1), 40_000_000)
  echo countMatches(data, Mult, (4, 8), 5_000_000)
