# Advent of Code 2024 - Day 14

import std/[strscans,strutils,sequtils]
from math import euclMod
import bitty
import ../utils/common

type
  Robot = tuple
    px, py, vx, vy: int

  Data = seq[Robot]

const
  w = 101
  h = 103


func parseRobot(line: string): Robot =
  assert line.scanf("p=$i,$i v=$i,$i", result.px, result.py, result.vx, result.vy)

proc parseData: Data =
  readInput().strip.splitLines.map(parseRobot)


func simulate(data: Data, gens: int): Data =
  for r in data:
    let px = euclMod(r.px + gens * r.vx, w)
    let py = euclMod(r.py + gens * r.vy, h)
    result.add (px, py, r.vx, r.vy)


func safetyFactor(data: Data): int =
  var quads: array[4, int]
  for r in data:
    let x = cmp(r.px, (w-1) div 2)
    let y = cmp(r.py, (h-1) div 2)
    if x != 0 and y != 0:
      quads[((x+1) div 2) * 2 + ((y+1) div 2)].inc
  result = quads.prod


# Total neighbors for each position
proc clusterScore(data: Data): int =
  var grid = newBitArray2d(w, h)
  for r in data:
    grid[r.py, r.px] = true
  for r in data:
    if r.py > 0   and grid[r.py-1, r.px]: result.inc
    if r.py < h-1 and grid[r.py+1, r.px]: result.inc
    if r.px > 0   and grid[r.py, r.px-1]: result.inc
    if r.px < w-1 and grid[r.py, r.px+1]: result.inc


proc findXmasTree(data: Data): int =
  var data = data
  var scores: seq[int]
  for i in 1..10_000: # heuristics
    for r in data.mitems:
      r.px = euclMod(r.px + r.vx, w)
      r.py = euclMod(r.py + r.vy, h)
    scores.add(data.clusterScore)
  result = 1 + scores.find(scores.max)


let data = parseData()

benchmark:
  echo data.simulate(100).safetyFactor
  echo data.findXmasTree
