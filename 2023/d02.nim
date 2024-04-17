# Advent of Code 2023 - Day 2

import std/[strscans,strutils,sequtils]
import ../utils/common

const colors = ["red","green","blue"]

type
  Set = array[3, int]

  Game = tuple
    id: int
    sets: seq[Set]

  Data = seq[Game]


func parseSet(line: string): Set =
  var count: int
  var color: string
  for sub in line.split(", "):
    assert sub.scanf("$i $+", count, color)
    result[colors.find(color)] = count


func parseGame(line: string): Game =
  var sets: string
  assert line.scanf("Game $i: $+", result.id, sets)
  result.sets = sets.split("; ").map(parseSet)


proc parseData: Data =
  readInput().strip.splitLines.map(parseGame)


func `<`(a, b: Set): bool =
  a[0] <= b[0] and a[1] <= b[1] and a[2] <= b[2]


func possible(game: Game, bag: Set): bool =
  game.sets.allIt(it < bag)


func minimal(game: Game): Set =
  for s in game.sets:
    for i in 0..2:
      if s[i] > result[i]: result[i] = s[i]


func power(bag: Set): int=
  bag[0] * bag[1] * bag[2]


let data = parseData()

benchmark:
  echo data.filterIt(it.possible([12, 13, 14])).mapIt(it.id).sum
  echo data.mapIt(it.minimal.power).sum
