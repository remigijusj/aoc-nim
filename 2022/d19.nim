# Advent of Code 2022 - Day 19

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  Blueprint = tuple
    id, c00, c10, c20, c21, c30, c32: int

  Data = seq[Blueprint]

  Vec = array[4, int]

  State = tuple[robots, mined: Vec]

func `+`(a, b: Vec): Vec = [a[0]+b[0], a[1]+b[1], a[2]+b[2], a[3]+b[3]]
func `-`(a, b: Vec): Vec = [a[0]-b[0], a[1]-b[1], a[2]-b[2], a[3]-b[3]]


func parseBlueprint(line: string): Blueprint =
  discard line.scanf(
    "Blueprint $i: Each ore robot costs $i ore. Each clay robot costs $i ore. Each obsidian robot costs $i ore and $i clay. Each geode robot costs $i ore and $i obsidian.",
    result.id, result.c00, result.c10, result.c20, result.c21, result.c30, result.c32)


proc parseData: Data =
  readInput().strip.splitLines.map(parseBlueprint)


template buildRobot(delta, costs) =
  for next in 0..3:
    search maximum, blue, time-1, next, (this.robots + delta, this.mined + this.robots - costs)
  break


func prune(maximum: int, blue: Blueprint, time, next: int, this: State): bool {.inline.} =
  let limit = time * (time - 1) div 2 # of potential geodes
  if this.mined[3] + this.robots[3] * time + limit <= maximum:
    return true

  result = case next
    of 0: this.robots[0] >= [blue.c00, blue.c10, blue.c20, blue.c30].max
    of 1: this.robots[1] >= blue.c21
    of 2: this.robots[2] >= blue.c32 or this.robots[1] == 0
    of 3: this.robots[2] == 0
    else: false


func search(maximum: var int, blue: Blueprint, time, next: int, this: State) =
  if prune(maximum, blue, time, next, this):
    return

  var this = this
  for time in countdown(time, 1):
    case next
    of 0: 
      if this.mined[0] >= blue.c00:
        buildRobot [1, 0, 0, 0], [blue.c00, 0, 0, 0]
    of 1:
      if this.mined[0] >= blue.c10:
        buildRobot [0, 1, 0, 0], [blue.c10, 0, 0, 0]
    of 2:
      if this.mined[0] >= blue.c20 and this.mined[1] >= blue.c21:
        buildRobot [0, 0, 1, 0], [blue.c20, blue.c21, 0, 0]
    of 3:
      if this.mined[0] >= blue.c30 and this.mined[2] >= blue.c32:
        buildRobot [0, 0, 0, 1], [blue.c20, 0, blue.c32, 0]
    else:
      discard

    this.mined = this.mined + this.robots

  if this.mined[3] > maximum:
    maximum = this.mined[3]


func maxGeodes(blue: Blueprint, num: int): int =
  let init: State = ([1, 0, 0, 0], [0, 0, 0, 0])
  for next in 0..3:
    search result, blue, num, next, init


let data = parseData()

benchmark:
  echo data.mapIt(it.maxGeodes(24) * it.id).sum
  echo data[0..2].mapIt(it.maxGeodes(32)).prod
