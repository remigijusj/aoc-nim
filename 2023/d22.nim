# Advent of Code 2023 - Day 22

import std/[strscans,strutils,sequtils,algorithm,intsets]
import ../utils/common

type
  Point = tuple[x, y, z: int]

  Brick = tuple[a, b: Point; up, down: IntSet]

  Data = seq[Brick]


func parseBrick(line: string): Brick =
  var a, b: Point
  assert line.scanf("$i,$i,$i~$i,$i,$i", a.x, a.y, a.z, b.x, b.y, b.z)
  assert a.x in 0..9 and b.x in 0..9 and a.x <= b.x and
         a.y in 0..9 and b.y in 0..9 and a.y <= b.y and
         a.z > 0     and b.z > 0     and a.z <= b.z # TEMP
  result = (a, b, initIntSet(), initIntSet())


proc parseData: Data =
  result = readAll(stdin).strip.splitLines.map(parseBrick)
  result.sort do (x, y: Brick) -> int:
    result  = cmp(x.a.z, y.a.z)


iterator points(brick: Brick): (int, int) =
  let (a, b, _, _) = brick
  if a.x < b.x:
    for x in a.x..b.x:
      yield (x, a.y)
  elif a.y < b.y:
    for y in a.y..b.y:
      yield (a.x, y)
  else:
    yield (a.x, a.y)


proc dropDown(data: var Data) =
  var tops: array[10, array[10, tuple[z, idx: int]]]
  for idx, brick in data.mpairs:
    var z = 0
    for (x, y) in brick.points:
      if tops[y][x].z > z:
        z = tops[y][x].z
    let top = brick.b.z - brick.a.z + z+1
    for (x, y) in brick.points:
      if tops[y][x].z == z and z > 0:
        let down = tops[y][x].idx
        brick.down.incl(down)
        data[down].up.incl(idx)
      tops[y][x] = (top, idx)


func countSafe(data: Data): int =
  for idx, brick in data:
    if brick.up.toSeq.allIt(data[it].down.card > 1):
      result.inc


func totalFall(data: Data): int =
  for i in 0..<data.len:
    var fall = [i].toIntSet
    var next: IntSet
    while true:
      next.clear
      for j in fall:
        for k in data[j].up:
          if data[k].down <= fall and k notin fall:
            next.incl(k)
      if next.card == 0:
        break
      fall = fall + next
    result += fall.card - 1


var data = parseData()

benchmark:
  data.dropDown
  echo data.countSafe
  echo data.totalFall
