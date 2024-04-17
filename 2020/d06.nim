# Advent of code 2020 - Day 6

import std/[strutils, sequtils, setutils]
import ../utils/common

type
  Answers = seq[set[char]]

  Data = seq[Answers]


proc parseAnswers(record: string): Answers =
  record.splitWhitespace.mapIt(it.toSet)


proc parseData: Data =
  readInput().split("\n\n").map(parseAnswers)


proc union(aw: Answers): set[char] = aw.foldl(a + b)
proc intersection(aw: Answers): set[char] = aw.foldl(a * b)


let data = parseData()

benchmark:
  echo data.mapIt(it.union.card).sum
  echo data.mapIt(it.intersection.card).sum
