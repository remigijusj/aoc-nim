# Advent of Code 2024 - Day 5

import std/[strscans,strutils,sequtils,sets,algorithm]
import ../utils/common

type
  Rule = tuple[a, b: int]

  Pages = seq[int]

  Data = tuple
    rules: HashSet[Rule]
    updates: seq[Pages]


func parseRule(line: string): Rule =
  assert line.scanf("$i|$i", result.a, result.b)


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  result.rules = parts[0].split("\n").map(parseRule).toHashSet
  result.updates = parts[1].split("\n").mapIt(it.split(",").map(parseInt))


func calcMiddleSums(data: Data): (int, int) =
  for pages in data.updates:
    let correct = pages.sorted do (a, b: int) -> int:
      if (a, b) in data.rules: -1 else: 1

    let middle = correct[correct.len div 2]

    if pages == correct:
      result[0] += middle
    else:
      result[1] += middle


let data = parseData()

benchmark:
  let (correct, incorrect) = data.calcMiddleSums
  echo correct
  echo incorrect
