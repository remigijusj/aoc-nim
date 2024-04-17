# Advent of code 2020 - Day 9

import std/[strutils, sequtils, algorithm]
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.splitLines.map(parseInt)


proc pairAddsTo(list: Data, target: int): bool =
  for i, x in list:
    if x >= target: continue
    for y in list[i+1 .. ^1]:
      if x + y == target:
        return true


proc findInvalid(list: Data, window: int): int =
  for i, x in list:
    if i < window: continue
    if not pairAddsTo(list[i-window .. i-1], x):
      return x


# returns index of the last element
proc rangeAddsTo(list: Data, target: int): int =
  var sum = 0
  for i, x in list:
    sum += x
    if sum == target:
      return i
    if sum > target:
      return -1


proc findContRange(list: Data, target: int): Data =
  for i, x in list:
    let j = list[i..^1].rangeAddsTo(target)
    if j >= 0:
      return list[i..i+j]


proc minMaxSum(list: Data): int =
  var list = list
  list.sort
  result = list[0] + list[^1]


let data = parseData()

benchmark:
  let invalid = data.findInvalid(25)
  echo invalid
  echo data.findContRange(invalid).minMaxSum
