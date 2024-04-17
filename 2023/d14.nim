# Advent of Code 2023 - Day 14

import std/[strutils,tables]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func tiltNorth(data: var Data) =
  for ri in countup(1, data.len-1):
    for ci in 0..<data[ri].len:
      if data[ri][ci] != 'O':
        continue
      var fall = 0
      for rd in countup(1, ri):
        if data[ri-rd][ci] == '.':
          fall.inc
        else:
          break
      swap(data[ri-fall][ci], data[ri][ci])


func tiltSouth(data: var Data) =
  for ri in countdown(data.len-2, 0):
    for ci in 0..<data[ri].len:
      if data[ri][ci] != 'O':
        continue
      var fall = 0
      for rd in countup(1, data.len-1-ri):
        if data[ri+rd][ci] == '.':
          fall.inc
        else:
          break
      swap(data[ri+fall][ci], data[ri][ci])


func tiltWest(data: var Data) =
  for ci in countup(1, data[0].len-1):
    for ri in 0..<data.len:
      if data[ri][ci] != 'O':
        continue
      var fall = 0
      for cd in countup(1, ci):
        if data[ri][ci-cd] == '.':
          fall.inc
        else:
          break
      swap(data[ri][ci-fall], data[ri][ci])


func tiltEast(data: var Data) =
  for ci in countdown(data[0].len-2, 0):
    for ri in 0..<data.len:
      if data[ri][ci] != 'O':
        continue
      var fall = 0
      for cd in countup(1, data[ri].len-1-ci):
        if data[ri][ci+cd] == '.':
          fall.inc
        else:
          break
      swap(data[ri][ci+fall], data[ri][ci])


proc spinCycle(data: var Data, count: int) =
  var seen = {data: 0}.toTable
  var stop = 0
  for this in 1..count:
    data.tiltNorth
    data.tiltWest
    data.tiltSouth
    data.tiltEast
    if data in seen and stop == 0:
      let first = seen[data]
      let cycle = this - first
      stop = this + (count - first) mod cycle
    seen[data] = this
    if this == stop:
      break


func totalLoad(data: Data): int =
  for ri, row in data:
    result += row.count('O') * (data.len - ri)


var data1 = parseData()
var data2 = data1

benchmark:
  data1.tiltNorth
  echo data1.totalLoad
  data2.spinCycle(1000000000)
  echo data2.totalLoad
