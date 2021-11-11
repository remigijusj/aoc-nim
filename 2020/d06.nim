# Advent of code 2020 - Day 6

import strutils, sequtils
from std/setutils import toSet
from math import sum

type Answers = seq[set[char]]

proc parseAnswers(record: string): Answers =
  record.splitWhitespace.mapIt(it.toSet)


proc answersList(filename: string): seq[Answers] =
  readFile(filename).split("\n\n").mapIt(it.parseAnswers)


proc union(aw: Answers): set[char] = aw.foldl(a + b)
proc intersection(aw: Answers): set[char] = aw.foldl(a * b)


proc partOne(list: seq[Answers]): int = list.mapIt(it.union.card).sum
proc partTwo(list: seq[Answers]): int = list.mapIt(it.intersection.card).sum


let list = answersList("inputs/06.txt")
echo partOne(list)
echo partTwo(list)
