# Advent of code 2020 - Day 20

import sequtils, strutils, tables, algorithm
from math import euclMod

const MONSTER = """
..................#.
#....##....##....###
.#..#..#..#..#..#...
""".splitWhitespace

type Tile = seq[string]

type GridItem = tuple[num: int, tile: Tile]

type Grid = array[12, array[12, GridItem]]

type Data = object
  tiles: Table[int, Tile]
  edges: Table[string, seq[int]]


proc norm(source: string): string =
  result = source.reversed.join
  if result > source: result = source


# left, top, right, bottom
proc edges(tile: Tile): array[4, string] =
  result[0] = tile.mapIt(it[0]).join.norm
  result[1] = tile[0].norm
  result[2] = tile.mapIt(it[^1]).join.norm
  result[3] = tile[^1].norm


proc buildEdges(data: var Data) =
  for num, tile in pairs(data.tiles):
    for edge in tile.edges:
      if not(edge in data.edges): data.edges[edge] = @[]
      data.edges[edge].add(num)


proc readData(filename: string): Data =
  for part in readFile(filename).split("\n\n"):
    let lines = part.splitLines
    if lines[0].startsWith("Tile"):
      let num = parseInt(lines[0][5..^2])
      result.tiles[num] = lines[1..^1]

  result.buildEdges


proc findCorners(data: Data): seq[int] =
  var tally: CountTable[int]
  for nums in values(data.edges):
    if nums.len == 1: tally.inc(nums[0])
  for num, cnt in pairs(tally):
    if cnt > 1: result.add(num)


proc transpose(map: var seq[string]) =
  for y in 0 .. map.len-2:
    for x in y+1 .. map.len-1:
      swap(map[y][x], map[x][y])


iterator transforms(map: seq[string]): seq[string] =
  var map = map
  for i in 0..7:
    map.transpose
    map.reverse
    yield map
    if i == 3: map.reverse


proc orient(tile: Tile, left, top: string): Tile =
  for tile in tile.transforms:
    let edges = tile.edges
    if edges[0] == left and edges[1] == top:
      return tile


proc adjacent(tile: Tile, edge: string): array[2, string] =
  let edges = tile.edges
  let i = edges.find(edge)
  [edges[euclMod(i-1, 4)], edges[euclMod(i+1, 4)]]


proc matchTile(data: Data, left, top: GridItem = (0, @[])): GridItem =
  if left.num > 0 and top.num > 0:
    result.num = data.edges[left.tile.edges[2]].filterIt(it != left.num)[0]
    let tile = data.tiles[result.num]
    result.tile = orient(tile, left.tile.edges[2], top.tile.edges[3])

  elif left.num > 0:
    result.num = data.edges[left.tile.edges[2]].filterIt(it != left.num)[0]
    let tile = data.tiles[result.num]
    let top = tile.adjacent(left.tile.edges[2]).filterIt(data.edges[it].len == 1)[0]
    result.tile = orient(tile, left.tile.edges[2], top)

  elif top.num > 0:
    result.num = data.edges[top.tile.edges[3]].filterIt(it != top.num)[0]
    let tile = data.tiles[result.num]
    let left = tile.adjacent(top.tile.edges[3]).filterIt(data.edges[it].len == 1)[0]
    result.tile = orient(tile, left, top.tile.edges[3])

  else:
    result.num = data.findCorners[0]
    let tile = data.tiles[result.num]
    let edges = tile.edges.filterIt(data.edges[it].len == 1)
    result.tile = orient(tile, edges[0], edges[1])


proc assembleGrid(data: Data): Grid =
  for y in 0 .. 11:
    for x in 0 .. 11:
      let left = if x == 0: (0, @[]) else: result[y][x-1]
      let top = if y == 0: (0, @[]) else: result[y-1][x]
      result[y][x] = matchTile(data, left = left, top = top)


proc stitchTiles(grid: Grid): seq[string] =
  for y, row in grid:
    for x in 1..8: result.add("")
    for item in row:
      for x, line in item.tile[1..^2]:
        result[y * 8 + x] &= line[1..^2]


proc matchMonster(map: seq[string], i, j: int): bool =
  result = true
  for i1, row in MONSTER:
    for j1, ch in row:
      if ch == '#' and map[i+i1][j+j1] != '#':
        return false


proc countMonsters(map: seq[string]): int =
  for trans in map.transforms:
    for i in 0 ..< trans.len-MONSTER.len:
      for j in 0 ..< trans[0].len-MONSTER[0].len:
        if matchMonster(trans, i, j):
          result.inc


proc waterRoughness(data: Data): int =
  let map = data.assembleGrid.stitchTiles
  map.join.count('#') - map.countMonsters * MONSTER.join.count('#')


proc partOne(data: Data): int = data.findCorners.foldl(a * b)
proc partTwo(data: Data): int = data.waterRoughness


var data = readData("inputs/20.txt")
echo partOne(data)
echo partTwo(data)
