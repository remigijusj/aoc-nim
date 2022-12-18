# Advent of Code 2022 - Day 18

import std/[strscans,strutils,sequtils,sets,options]

type
  Cube = array[3, int]
  Data = HashSet[Cube]


func parseCube(line: string): Cube =
  discard line.scanf("$i,$i,$i", result[0], result[1], result[2])


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseCube).toHashSet


iterator adjacent(cube: Cube): Cube =
  yield [cube[0]+1, cube[1], cube[2]]
  yield [cube[0]-1, cube[1], cube[2]]
  yield [cube[0], cube[1]+1, cube[2]]
  yield [cube[0], cube[1]-1, cube[2]]
  yield [cube[0], cube[1], cube[2]+1]
  yield [cube[0], cube[1], cube[2]-1]


func bounds(data: Data): array[3, Slice[int]] =
  for cube in data:
    for i in 0..2:
      if cube[i] < result[i].a: result[i].a = cube[i]
      if cube[i] > result[i].b: result[i].b = cube[i]
  for i in 0..2:
    result[i].a.dec
    result[i].b.inc


func exterior(data: Data): Data =
  let bounds = data.bounds
  var front = @[[bounds[0].a, bounds[1].a, bounds[2].a]]

  while front.len > 0:
    let this = front.pop
    for next in this.adjacent:
      if (0..2).allIt(next[it] in bounds[it]):
        if next notin result and next notin data:
          result.incl next
          front.add(next)


func surfaceArea(data: Data, exterior = none(Data)): int =
  for cube in data:
    for next in cube.adjacent:
      if next notin data and (exterior.isNone or next in exterior.get):
        result.inc


let data = parseData()

let part1 = data.surfaceArea
let part2 = data.surfaceArea(data.exterior.some)

echo part1
echo part2
