# Advent of Code 2018 - Day 23

import std/[sequtils,strutils,strscans,heapqueue]
from math import nextPowerOfTwo
import ../utils/common

type
  Pos = array[3, int]

  Bot = tuple[pos: Pos, r: int]

  Data = seq[Bot]

  Box = (Pos, Pos)

  Item = tuple[bots, size, dist: int, box: Box]


func parseBot(line: string): Bot =
  assert line.scanf("pos=<$i,$i,$i>, r=$i", result.pos[0], result.pos[1], result.pos[2], result.r)


proc parseData: Data =
  readInput().strip.splitLines.map(parseBot)


func dist(a, b: Pos): int =
  abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])


func inRangeOf(a, b: Bot): bool =
  dist(a.pos, b.pos) <= b.r


func strongestReach(data: Data): int =
  let i = data.mapIt(it.r).maxIndex
  result = data.countIt(it.inRangeOf(data[i]))


func intersects(box: Box, bot: Bot): bool =
  var d = 0
  for i in 0..2:
    let (lo, hi) = (box[0][i], box[1][i] - 1)
    d += abs(bot.pos[i] - lo) + abs(bot.pos[i] - hi) + lo - hi
  d = d div 2
  result = d <= bot.r


# Priority by bots-in-range (max), box size (max), distance to origin (min)
proc `<`(a, b: Item): bool =
  if a.bots > b.bots: return true
  if a.bots < b.bots: return false
  if a.size > b.size: return true
  if a.size < b.size: return false
  return a.dist < b.dist


func span(bot: Bot): int =
  bot.pos.mapIt(it.abs).max + bot.r


func enclosingBox(data: Data): (int, Box) =
  let size = data.mapIt(it.span).max.nextPowerOfTwo
  result = (size, ([-size, -size, -size], [size, size, size]))


proc condensationPoint(data: Data): int =
  let (size, initBox) = data.enclosingBox

  var queue = [(data.len, 2 * size, 3 * size, initBox)].toHeapQueue
  while queue.len > 0:
    let (_, size, dist, box) = queue.pop
    if size == 1:
      return dist

    var size1 = size div 2
    for octant in [[0, 0, 0], [0, 0, 1], [0, 1, 0], [0, 1, 1], [1, 0, 0], [1, 0, 1], [1, 1, 0], [1, 1, 1]]:
      var box1 = box
      for i in 0..2:
        box1[0][i] += size1 * octant[i]
        box1[1][i] = box1[0][i] + size1
      let dist1 = dist(box1[0], [0, 0, 0])
      let count1 = data.countIt(box1.intersects(it))
      queue.push((count1, size1, dist1, box1))


let data = parseData()

benchmark:
  echo data.strongestReach
  echo data.condensationPoint
