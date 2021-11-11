# Advent of code 2020 - Day 5

import strutils, sequtils, algorithm


proc decodeBinary(code, lo, hi: string): int =
  let code = code.multiReplace [(lo,"0"), (hi,"1")]
  code.parseBinInt


proc parseSeat(line: string): int =
  let row = line[0..6].decodeBinary("F","B")
  let col = line[7..9].decodeBinary("L","R")
  return row * 8 + col


proc seatList(filename: string): seq[int] =
  for line in lines(filename):
    result.add parseSeat(line)


proc findGap(list: seq[int]): int =
  let list = list.sorted
  let first = list[0]
  for i, seat in list:
    if seat != first + i:
      return first + i


proc partOne(list: seq[int]): int = list.max
proc partTwo(list: seq[int]): int = list.findGap


let list = seatList("inputs/05.txt")
echo partOne(list)
echo partTwo(list)
