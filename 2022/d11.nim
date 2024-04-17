# Advent of Code 2022 - Day 11

import std/[strutils,strscans,sequtils,algorithm]
import ../utils/common

type
  Op = enum
    oAdd, oMul, oSqr

  Monkey = object
    hold: seq[int]
    op: Op
    val: int
    test, pos, neg: int

  Data = seq[Monkey]


func parseMonkey(chunk: string): Monkey =
  for line in chunk.splitLines:
    if line.startsWith("  Starting items: "):
      result.hold = line[18..^1].split(", ").map(parseInt)
    elif line.scanf("  Operation: new = old + $i", result.val):
      result.op = oAdd
    elif line.scanf("  Operation: new = old * $i", result.val):
      result.op = oMul
    elif line.scanf("  Operation: new = old * old"):
      result.op = oSqr
    elif line.scanf("  Test: divisible by $i", result.test):
      discard
    elif line.scanf("    If true: throw to monkey $i", result.pos):
      discard
    elif line.scanf("    If false: throw to monkey $i", result.neg):
      discard


proc parseData: Data =
  for chunk in readInput().strip.split("\n\n"):
    result.add chunk.parseMonkey


proc monkeyBusiness(data: Data, rounds: int, reduce = false): int =
  var data = data
  var activity = newSeq[int](data.len)
  let factor = data.mapIt(it.test).prod

  for round in 1..rounds:
    for turn, monkey in data.mpairs:
      for item in monkey.hold.mitems:
        case monkey.op
          of oAdd: item += monkey.val
          of oMul: item *= monkey.val
          of oSqr: item *= item

        item = item mod factor
        if reduce:
          item = item div 3

        if item mod monkey.test == 0:
          data[monkey.pos].hold.add(item)
        else:
          data[monkey.neg].hold.add(item)

      activity[turn].inc(monkey.hold.len)
      monkey.hold.setLen(0)

  activity.sort
  result = activity[^1] * activity[^2]


let data = parseData()

benchmark:
  echo data.monkeyBusiness(20, true)
  echo data.monkeyBusiness(10000)
