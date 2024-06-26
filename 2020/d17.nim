# Advent of code 2020 - Day 17

import std/[strutils, sequtils, tables]
from math import `^`
import ../utils/common

type
  Dim[N: static[int]] = array[N, int8]

  Pocket[N: static[int]] = Table[Dim[N], bool]

  Data = seq[(int8, int8)]


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for y, line in pairs(lines):
    for x, ch in pairs(line):
      if ch == '#': result.add (x.int8, y.int8)


iterator neighbors[N: static[int]](v: Dim[N]): Dim[N] =
  var vec: Dim[N]
  for num in 0 ..< 3^N:
    var n = num.int8
    for i in 0..<N:
      vec[i] = v[i] + n mod 3 - 1'i8
      n = n div 3

    yield vec


# counts includes the vertice itself
proc neighborCounts[N: static[int]](pocket: Pocket[N]): CountTable[Dim[N]] =
  for v in keys(pocket):
    for n in neighbors[N](v):
      result.inc(n)


proc cube[N: static[int]](x, y: int8): Dim[N] =
  when N >= 1: result[0] = x
  when N >= 2: result[1] = y


proc simulate[N: static[int]](data: Data, gens: int): Pocket[N] =
  for (x, y) in data:
    let v = cube[N](x, y)
    result[v] = true

  for g in 1..gens:
    for v, cnt in neighborCounts[N](result):
      if result.getOrDefault(v):
        # limits are +1, see neighborCounts
        if cnt < 3 or cnt > 4: result.del(v)
      else:
        if cnt == 3: result[v] = true


let data = parseData()

benchmark:
  echo simulate[3](data, 6).len
  echo simulate[4](data, 6).len
