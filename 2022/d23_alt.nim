# Advent of Code 2022 - Day 23

import std/[strutils]
import ../utils/common

type
  XY = tuple[x, y: int8]

  Cell = tuple
    elf: bool
    dir: int8 # 0..3 -> 1..4, -1=conflict

  Data = array[int8.low..int8.high, array[int8.low..int8.high, Cell]]


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for y, line in lines:
    for x, c in line:
      if c == '#': result[y.int8][x.int8].elf = true


func move(pos: XY, dir: int): XY =
  case dir
    of 0: result = (pos.x, pos.y - 1)
    of 1: result = (pos.x, pos.y + 1)
    of 2: result = (pos.x - 1, pos.y)
    of 3: result = (pos.x + 1, pos.y)
    else: result = pos


iterator vectors(dir: int8): XY {.inline.} =
  case dir
    of 0'i8:
      yield (-1'i8,-1'i8)
      yield ( 0'i8,-1'i8)
      yield ( 1'i8,-1'i8)
    of 1'i8:
      yield (-1'i8, 1'i8)
      yield ( 0'i8, 1'i8)
      yield ( 1'i8, 1'i8)
    of 2'i8:
      yield (-1'i8,-1'i8)
      yield (-1'i8, 0'i8)
      yield (-1'i8, 1'i8)
    of 3'i8:
      yield (1'i8,-1'i8)
      yield (1'i8, 0'i8)
      yield (1'i8, 1'i8)
    else: discard


func occupied(data: Data, pos: XY, dir: int8): bool =
  for v in dir.vectors:
    if data[pos.y + v.y][pos.x + v.x].elf:
      return true


func isolated(data: Data, pos: XY): bool =
  result = true
  for dx in [-1'i8, 0'i8, 1'i8]:
    for dy in [-1'i8, 0'i8, 1'i8]:
      if dx == 0 and dy == 0: continue
      if data[pos.y + dy][pos.x + dx].elf:
        return false


func boundaries(data: Data): tuple[minx, maxx, miny, maxy: int8] =
  for y in int8.low..int8.high:
    for x in int8.low..int8.high:
      if data[y][x].elf:
        if x < result.minx: result.minx = x
        if x > result.maxx: result.maxx = x
        if y < result.miny: result.miny = y
        if y > result.maxy: result.maxy = y


proc diffuse(data: Data, num : int): tuple[grid: Data, step: int] =
  var data = data
  var moved: int

  for step in 0..<num:
    for y in int8.low..int8.high:
      for x in int8.low..int8.high:
        if not data[y][x].elf: continue

        if data.isolated((x, y)):
          continue

        for i in 0..3:
          let dir = int8((step + i) mod 4)
          let adj = move((x, y), dir)
          if not data.occupied((x, y), dir):
            if data[adj.y][adj.x].dir == 0: # empty
              data[adj.y][adj.x].dir = (dir xor 1) + 1 # flip
            else:
              data[adj.y][adj.x].dir = -1 # conflict
            break

    moved = 0
    for y in int8.low..int8.high:
      for x in int8.low..int8.high:
        let cell = data[y][x]
        if not cell.elf and cell.dir in 1..4:
          let adj = move((x, y), cell.dir-1)
          data[adj.y][adj.x].elf = false
          data[y][x].elf = true
          moved.inc
        data[y][x].dir = 0

    if moved == 0:
      return (data, step+1)

  return (data, num+1)


func countEmpty(data: Data): int =
  let b = data.boundaries
  for y in b.miny..b.maxy:
    for x in b.minx..b.maxx:
      if not data[y][x].elf: result.inc


let data = parseData()

benchmark:
  echo data.diffuse(10).grid.countEmpty
  echo data.diffuse(int.high).step
