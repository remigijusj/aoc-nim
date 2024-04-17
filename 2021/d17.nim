# Advent of Code 2021 - Day 17

import std/[strscans, math, sets]
import ../utils/common

type Data = object
  xmin, xmax: int
  ymin, ymax: int


proc parseData: Data =
  let data = readInput()
  discard data.scanf("target area: x=$i..$i, y=$i..$i", result.xmin, result.xmax, result.ymin, result.ymax)


# Triangular number: 1 + 2 + ... + n
proc triangular(n: int): int = n * (n+1) div 2


# What gets into range minv..maxv after cnt steps
proc fitrange(minv, maxv, cnt: int): auto =
  let tri = triangular(cnt - 1)
  let mins = ((minv + tri) / cnt).ceil.int
  let maxs = ((maxv + tri) / cnt).floor.int
  result = mins .. maxs


# Union-set, because some shots hhit target on multiple steps
proc shots(data: Data): HashSet[(int,int)] =
  for steps in 1..(data.ymin.abs * 2):
    for x in fitrange(data.xmin, data.xmax, min(steps, 10)):
      for y in fitrange(data.ymin, data.ymax, steps):
        result.incl (x,y)


let data = parseData()

benchmark:
  echo triangular(data.ymin.abs - 1)
  echo data.shots.card
