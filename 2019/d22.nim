# Advent of Code 2019 - Day 22

import std/[strscans,strutils,sequtils,algorithm,options]
import bigints
from math import euclMod
import ../utils/common

type
  Kind = enum
    kCut, kNew, kInc

  Shuffle = tuple
    kind: Kind
    value: int

  Data = seq[Shuffle]

  Map = (int, int)


proc parseData: Data =
  var val: int
  for line in readInput().strip.splitLines:
    if scanf(line, "cut $i", val):
      result.add (kCut, val)
    elif scanf(line, "deal with increment $i", val):
      result.add (kInc, val)
    elif scanf(line, "deal into new stack"):
      result.add (kNew, 0)


proc dealIncrement(cards: seq[int], step: int): seq[int] =
  result.setLen(cards.len)
  for i, card in cards:
    result[(i * step) mod cards.len] = card


proc runShuffles(data: Data, num: int): seq[int] =
  result = toSeq(0..<num)
  for it in data:
    case it.kind
      of kNew:
        result.reverse
      of kCut:
        result.rotateLeft(it.value)
      of kInc:
        result = result.dealIncrement(it.value)


proc toMap(it: Shuffle): Map =
  case it.kind
    of kNew: (-1, -1)
    of kCut: (1, -it.value)
    of kInc: (it.value, 0)


proc compose(maps: openarray[Map], m: int): Map =
  result = (1, 0)
  for (a, b) in maps:
    result[0] = euclMod(result[0] * a, m)
    result[1] = euclMod(result[1] * a + b, m)


proc apply(it: Map, x, m: int): int = euclMod(it[0] * x + it[1], m)


# y = a^e * x + b (a^e - 1) / (a - 1)
# x = (y - b (a^e - 1) / (a - 1)) / a^e
proc simulate(data: Data, num, exp: int, pos: int): int =
  let (a, b) = data.map(toMap).compose(num)
  let m = num.initBigInt
  let ae = powmod(a.initBigInt, exp.initBigInt, m)
  let a1 = invmod((a-1).initBigInt, m)
  let aei = invmod(ae, m)
  let x = ((pos.initBigInt - b.initBigInt * (ae - 1.initBigInt) * a1) * aei) mod m
  result = toInt[int](x).get


proc positionOfCard(data: Data, num, deck: int): int =
  result = data.runShuffles(deck).find(num)
  assert result == data.map(toMap).compose(deck).apply(num, deck)


proc numberOnCard(data: Data, pos, deck, times: int): int =
  result = data.simulate(deck, times, pos)


let data = parseData()

benchmark:
  echo data.positionOfCard(2019, 10007)
  echo data.numberOnCard(2020, 119315717514047.int, 101741582076661.int)
