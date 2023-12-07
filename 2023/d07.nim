# Advent of Code 2023 - Day 7

import std/[strutils,sequtils,algorithm,tables]
import ../utils/common

const
  cards = "AKQJT98765432"
  stre1 = "mlkjihgfedcba"
  stre2 = "mlkajihgfedcb"

type
  Item = tuple
    hand: string
    bid: int
    key1, key2: (string, string)

  Data = seq[Item]


func parseItem(line: string): Item =
  result.hand = line[0..4]
  result.bid = line[6..^1].parseInt


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseItem)


func kind1(hand: string): string =
  hand.toCountTable.values.toSeq.sorted(SortOrder.Descending).join


func kind2(hand: string): string =
  var tally = hand.toCountTable
  var jokers = 0
  discard tally.pop('J', jokers)
  var list = tally.values.toSeq.sorted(SortOrder.Descending)
  if list.len > 0:
    list[0] += jokers
  else:
    list.add(jokers)
  result = list.join


func strength1(hand: string): string =
  hand.mapIt(stre1[cards.find(it)]).join


func strength2(hand: string): string =
  hand.mapIt(stre2[cards.find(it)]).join


func totalWinnings(data: Data): int =
  for i, item in data:
    result += (i+1) * item.bid


var data = parseData()
for it in data.mitems:
  it.key1 = (it.hand.kind1, it.hand.strength1)
  it.key2 = (it.hand.kind2, it.hand.strength2)

benchmark:
  echo data.sortedByIt(it.key1).totalWinnings
  echo data.sortedByIt(it.key2).totalWinnings
