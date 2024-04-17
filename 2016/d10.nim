# Advent of Code 2016 - Day 10

import std/[strscans,strutils,tables]
import ../utils/common

type
  Value = Table[int, int] # value -> bot

  Rules = Table[int, array[2, int]] # bot -> lo, hi (+bot, -output)

  Data = tuple[r: Rules, v: Value]

  Hold = TableRef[int, seq[int]]


proc parseData: Data =
  var value, bot, t1, t2: int
  var k1, k2: string

  let lines = readInput().strip.splitLines
  for line in lines:
    if line.scanf("value $i goes to bot $i", value, bot):
      result.v[value] = bot
    elif line.scanf("bot $i gives low to $+ $i and high to $+ $i", bot, k1, t1, k2, t2):
      if k1 != "bot": t1 = -t1-1
      if k2 != "bot": t2 = -t2-1
      result.r[bot] = [t1, t2]


proc propagate(hold: var Hold, bot: int, data: Data) =
  var pair = hold[bot]
  if bot < 0 or pair.len < 2:
    return

  if pair[0] > pair[1]:
    swap(pair[0], pair[1])

  for i, next in data.r[bot]:
    discard hold.hasKeyOrPut(next, @[])
    hold[next].add(pair[i])
    hold.propagate(next, data)


func calculate(data: Data): Hold =
  result = newTable[int, seq[int]]()
  for val, bot in data.v:
    discard result.hasKeyOrPut(bot, @[])
    result[bot].add(val)
    result.propagate(bot, data)


func findIt(hold: Hold, a, b: int): int =
  for key, val in hold:
    if val == @[a, b] or val == @[b, a]:
      return key


let data = parseData()

benchmark:
  let hold = data.calculate
  echo hold.findIt(61, 17)
  echo hold[-1][0] * hold[-2][0] * hold[-3][0]
