# Advent of Code 2022 - Day 23

import std/[strutils,tables]

type
  XY = tuple[x, y: int]
  Data = Table[XY, int]


proc parseData: Data =
  let lines = readAll(stdin).strip.splitLines
  for y, line in lines:
    for x, c in line:
      if c == '#': result[(x, y)] = 0


func boundaries(grid: Data): tuple[minx, maxx, miny, maxy: int] =
  for cell, _ in grid:
    if cell.x < result.minx: result.minx = cell.x
    if cell.x > result.maxx: result.maxx = cell.x
    if cell.y < result.miny: result.miny = cell.y
    if cell.y > result.maxy: result.maxy = cell.y


func move(elf: XY, dir: int): XY =
  case dir
    of 0: result = (elf.x, elf.y - 1)
    of 1: result = (elf.x, elf.y + 1)
    of 2: result = (elf.x - 1, elf.y)
    of 3: result = (elf.x + 1, elf.y)
    else: result = elf


iterator vectors(dir: int): XY =
  case dir
    of 0:
      yield (-1,-1)
      yield (0,-1)
      yield (1,-1)
    of 1:
      yield (-1, 1)
      yield (0, 1)
      yield (1, 1)
    of 2:
      yield (-1,-1)
      yield (-1,0)
      yield (-1,1)
    of 3:
      yield (1,-1)
      yield (1,0)
      yield (1,1)
    else:
      for dx in [-1,0,1]:
        for dy in [-1,0,1]:
          if dx != 0 or dy != 0: yield (dx, dy)


func occupied(data: Data, elf: XY, dir: int): bool =
  for v in dir.vectors:
    if data.hasKey((elf.x + v.x, elf.y + v.y)):
      return true


proc diffuse(data: Data, num : int): tuple[grid: Data, step: int] =
  var this, next: Data
  var count: CountTable[XY]
  next = data

  for step in 0..<num:
    this = next
    next.clear
    count.clear

    for elf, edir in this.mpairs:
      if not this.occupied(elf, -1):
        edir = -1
        count.inc(elf)
      else:
        for i in 0..3:
          let dir = (step + i) mod 4
          let adj = elf.move(dir)
          if not this.occupied(elf, dir):
            edir = dir
            count.inc(adj)
            break

    for elf, dir in this.pairs:
      let adj = elf.move(dir)
      next[if count[adj] == 1: adj else: elf] = dir

    if next == this:
      return (next, step+1)

  return (next, num+1)


func countEmpty(grid: Data): int =
  let b = grid.boundaries
  let area = (b.maxx - b.minx + 1) * (b.maxy - b.miny + 1)
  result = area - grid.len


let data = parseData()

echo data.diffuse(10).grid.countEmpty
echo data.diffuse(int.high).step
