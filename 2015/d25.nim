# Advent of Code 2015 - Day 25

import std/[strscans,strutils]
import ../utils/common

type Data = tuple
  row, col: int

const
  start = 20151125
  factor = 252533
  modulus = 33554393


proc parseData: Data =
  let lines = readAll(stdin).strip.split(".  ")
  assert lines[^1].scanf("Enter the code at row $i, column $i.", result.row, result.col)


func cantorPairing(data: Data): int =
  let (m, n) = (data.row - 1, data.col - 1)
  result = ((m + n) * (m + n + 1)) div 2 + n + 1


func findCode(number: int): int =
  result = start
  for i in 1..<number:
    result = (result * factor) mod modulus


let data = parseData()

benchmark:
  echo data.cantorPairing.findCode
