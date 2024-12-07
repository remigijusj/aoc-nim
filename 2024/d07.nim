# Advent of Code 2024 - Day 7

import std/[strutils,sequtils]
from math import divMod,log10,floor,`^`
import ../utils/common

type
  Equation = tuple
    test: int
    numbers: seq[int]

  Data = seq[Equation]


func parseEquation(line: string): Equation =
  let sep = line.find(':')
  result.test = line[0..<sep].parseInt
  result.numbers = line[(sep+1)..<line.len].splitWhitespace.map(parseInt)


proc parseData: Data =
  readInput().strip.splitLines.map(parseEquation)


func split(x, y: int): (int, int) =
  let size = floor(log10(y.float)).int + 1
  let z = 10 ^ size
  result = divMod(x, z)


proc satisfy(eq: Equation, concat = false): bool =
  proc helper(test: int, i: int): bool =
    let num = eq.numbers[i]
    if test < num:
      return false
    if i == 0:
      return test == num

    if concat:
      let (head, tail) = split(test, num)
      if tail == num and helper(head, i-1):
        return true

    let (quo, rem) = divMod(test, num)
    if rem == 0 and helper(quo, i-1):
      return true

    helper(test - num, i-1)

  helper(eq.test, eq.numbers.len-1)



let data = parseData()

benchmark:
  echo data.filterIt(it.satisfy).mapIt(it.test).sum
  echo data.filterIt(it.satisfy(concat=true)).mapIt(it.test).sum
