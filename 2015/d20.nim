# Advent of Code 2015 - Day 20

import std/[strutils,math]
import ../utils/common


proc parseData: int =
  readAll(stdin).strip.parseInt


proc sumOfDivisors(house, limit: int): int =
  let ceiling = min(limit, sqrt(house.float64).ceil.int)
  for visit in 1..ceiling:
    if house mod visit != 0:
      continue
    let elf = house div visit
    result += elf
    if visit != elf:
      result += visit


# lower bound from Axler estimate: sigma(n) < 4.694 * n
func lowestHouseNumber(number, factor: int, limit = int.high): int =
  let start = 77_000
  for house in start..int.high:
    var sum = sumOfDivisors(house, limit)
    if sum * factor > number:
      return house


let data = parseData()

benchmark:
  echo data.lowestHouseNumber(10)
  echo data.lowestHouseNumber(11, 50)
