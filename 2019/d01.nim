# Advent of Code 2019 - Day 1

import std/[strutils]
from math import floor

type Data = seq[int]


proc parseData(filename: string): Data =
  for line in lines(filename):
    result.add line.parseInt


proc fuel(mass: int): int =
  floor(mass.float / 3.0).int - 2


proc recursiveFuel(mass: int): int =
  let fuel = fuel(mass)
  if fuel > 0: result = fuel + recursiveFuel(fuel)


proc partOne(data: Data): int =
  for mass in data:
    result += fuel(mass)

proc partTwo(data: Data): int =
  for mass in data:
    result += recursiveFuel(mass)


let data = parseData("inputs/01.txt")
echo partOne(data)
echo partTwo(data)
