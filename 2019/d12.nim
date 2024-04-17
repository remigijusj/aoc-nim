# Advent of Code 2019 - Day 12

import std/[sequtils, strutils, strscans]
from math import sgn, lcm
import ../utils/common

type
  Vec = array[3, int]

  Moon = object
    position: Vec
    velocity: Vec

  Data = array[4, Moon]


func parseMoon(line: string): Moon =
  discard scanf(line, "<x=$i, y=$i, z=$i>", result.position[0], result.position[1], result.position[2])


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for i, line in lines:
    result[i] = line.parseMoon


proc runStep(moons: var Data, k: int) =
  for moon in moons.mitems:
    for other in moons:
      if other.position[k] > moon.position[k]: moon.velocity[k].inc
      if other.position[k] < moon.position[k]: moon.velocity[k].dec

  for moon in moons.mitems:
    moon.position[k] = moon.position[k] + moon.velocity[k]


func l1(v: Vec): int {.inline.} = v[0].abs + v[1].abs + v[2].abs

func energy(moon: Moon): int = moon.position.l1 * moon.velocity.l1


proc totalEnergy(data: Data): int =
  var moons = data
  for step in 1..1000:
    for k in 0..2:
      moons.runStep(k)

  result = moons.map(energy).sum


# Assume moons will eventually return to original state
proc detectCycle(data: Data, k: int): int =
  var moons = data
  while true:
    result.inc
    moons.runStep(k)
    if moons == data: return


proc detectRepeat(data: Data): int =
  let cycle = (0..2).mapIt(data.detectCycle(it))
  result = lcm(cycle)


let data = parseData()

benchmark:
  echo data.totalEnergy
  echo data.detectRepeat
