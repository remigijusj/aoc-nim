# Advent of Code 2023 - Day 4

import std/[strscans,strutils,sequtils]
from math import `^`
import ../utils/common

type
  Card = tuple
    number: int
    wins: seq[int]
    have: seq[int]

  Data = seq[Card]


func parseCard(line: string): Card =
  var wins, have: string
  assert line.scanf("Card$s$i:$+|$+$.", result.number, wins, have)
  result.wins = wins.splitWhitespace.toSeq.map(parseInt)
  result.have = have.splitWhitespace.toSeq.map(parseInt)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseCard)


func score(card: Card): int =
  for num in card.have:
    if num in card.wins:
      result.inc


func accumulated(wins: seq[int]): seq[int] =
  result = repeat(1, wins.len)
  for i, n in wins:
    for j in countup(i+1, i+n):
      result[j] += result[i]


let data = parseData()
let wins = data.map(score)

benchmark:
  echo wins.filterIt(it > 0).mapIt(2 ^ (it-1)).sum
  echo wins.accumulated.sum
