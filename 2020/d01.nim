# Advent of code 2020 - Day 1

import strutils, algorithm

proc sortedIntList(filename: string): seq[int] =
  for line in lines(filename):
    result.add parseInt(line)

  result.sort


proc splitProduct2(list: seq[int], target: int): int =
  for i, x in list:
    if x >= target: break
    for y in list[i+1 .. ^1]:
      if x + y == target:
        return x * y


proc splitProduct3(list: seq[int], target: int): int =
  for i, x in list:
    if x >= target: break
    let y = splitProduct2(list[i+1 .. ^1], target - x)
    if y > 0:
      return x * y


proc partOne(list: seq[int]): int = splitProduct2(list, 2020)
proc partTwo(list: seq[int]): int = splitProduct3(list, 2020)


let list = sortedIntList("inputs/01.txt")
echo partOne(list)
echo partTwo(list)
