# Advent of code 2020 - Day 9

import strutils, algorithm

proc integerList(filename: string): seq[int] =
  for line in lines(filename):
    result.add parseInt(line)


proc pairAddsTo(list: seq[int], target: int): bool =
  for i, x in list:
    if x >= target: continue
    for y in list[i+1 .. ^1]:
      if x + y == target:
        return true


proc findInvalid(list: seq[int], window: int): int =
  for i, x in list:
    if i < window: continue
    if not pairAddsTo(list[i-window .. i-1], x):
      return x


# returns index of the last element
proc rangeAddsTo(list: seq[int], target: int): int =
  var sum = 0
  for i, x in list:
    sum += x
    if sum == target:
      return i
    if sum > target:
      return -1


proc findContRange(list: seq[int], target: int): seq[int] =
  for i, x in list:
    let j = list[i..^1].rangeAddsTo(target)
    if j >= 0:
      return list[i..i+j]


proc minMaxSum(list: seq[int]): int =
  var list = list
  list.sort
  result = list[0] + list[^1]


proc partOne(list: seq[int]): int = list.findInvalid(25)
proc partTwo(list: seq[int]): int = list.findContRange(list.partOne).minMaxSum


let list = integerList("inputs/09.txt")
echo partOne(list)
echo partTwo(list)
