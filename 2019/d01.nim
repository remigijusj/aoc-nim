# Advent of Code 2019 - Day 1

import std/[strutils, sequtils]
from math import floor
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  for line in readInput().strip.splitLines:
    result.add line.parseInt


proc fuel(mass: int): int =
  floor(mass.float / 3.0).int - 2


proc recursiveFuel(mass: int): int =
  let fuel = fuel(mass)
  if fuel > 0: result = fuel + recursiveFuel(fuel)


let data = parseData()

benchmark:
  echo data.map(fuel).sum
  echo data.map(recursiveFuel).sum
