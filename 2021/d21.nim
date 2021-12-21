# Advent of Code 2021 - Day 21

import std/[strutils, tables]
import memo

type
  Data = array[2, int]

  Score = array[2, int]


proc parseData(filename: string): Data =
  let lines = readFile(filename).split("\n")
  result[0] = lines[0][28..28].parseInt
  result[1] = lines[1][28..28].parseInt


proc playSimple(data: Data, limit: int): int =
  var score: Score
  var pos = data
  var turn = 1
  var dice = 1

  for step in countup(1, int.high):
    turn = 1 - turn
    let sum = 3 * dice + 3
    pos[turn] = (pos[turn] + sum - 1) mod 10 + 1
    score[turn] += pos[turn]
    dice = (dice + 2) mod 100 + 1
    if score[turn] >= limit:
      return step * 3 * score.min


proc countGames(pos: Data, score: Score, limit: int): Score {.memoized.} =
  if score[1] >= limit:
    return [0, 1]

  for (sum, count) in [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)]:
    let pos0 = (pos[0] + sum - 1) mod 10 + 1
    let score0 = score[0] + pos0
    let total = countGames([pos[1], pos0], [score[1], score0], limit)
    result[0] += total[1] * count
    result[1] += total[0] * count


proc playDirac(data: Data, limit: int): int =
  let total = countGames(data, [0, 0], limit)
  return max(total[0], total[1])


proc partOne(data: Data): int = data.playSimple(1000)
proc partTwo(data: Data): int = data.playDirac(21)


let data = parseData("inputs/21.txt")
echo partOne(data)
echo partTwo(data)
