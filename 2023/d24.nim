# Advent of Code 2023 - Day 24

import std/[strscans,strutils,sequtils,math]
import manu # https://github.com/planetis-m/manu
import ../utils/common

type
  XYZ = tuple[x,y,z: int]

  Stone = tuple
    pos, vel: XYZ

  Data = seq[Stone]

const
  test1 = 200000000000000'f64 .. 400000000000000'f64


func `-`(a, b: XYZ): XYZ = (a.x - b.x, a.y - b.y, a.z - b.z)

func rot(a, b: XYZ): XYZ = (a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)

func dot(a, b: XYZ): int = a.x * b.x + a.y * b.y + a.z * b.z

func sum(pos: XYZ): int = pos.x + pos.y + pos.z


func parseStone(line: string): Stone =
  var pos, vel: XYZ
  assert line.scanf("$i, $i, $i @ $i, $i, $i", pos.x, pos.y, pos.z, vel.x, vel.y, vel.z)
  result = (pos, vel)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseStone)


func pathsWillIntersect(a, b: Stone): bool =
  let d = a.vel.y * b.vel.x - a.vel.x * b.vel.y
  if d == 0:
    return false
  let bt = ((b.pos.y - a.pos.y) * a.vel.x - (b.pos.x - a.pos.x) * a.vel.y).float / d.float
  let at = ((b.pos.y - a.pos.y) * b.vel.x - (b.pos.x - a.pos.x) * b.vel.y).float / d.float
  if bt <= 0 or at <= 0:
    return false
  let ax = a.pos.x.float + at * a.vel.x.float
  let ay = a.pos.y.float + at * a.vel.y.float
  let bx = b.pos.x.float + bt * b.vel.x.float
  let by = b.pos.y.float + bt * b.vel.y.float
  result = ax in test1 and ay in test1 and bx in test1 and by in test1


func countIntersections(data: Data): int =
  for l in 1..<data.len:
    for k in 0..<l:
      if pathsWillIntersect(data[k], data[l]):
        result.inc


func restriction(a, b: Stone): (XYZ, int) =
  let da = a.pos - b.pos
  result[0] = rot(da, a.vel - b.vel)
  result[1] = dot(da, rot(a.vel, b.vel))


proc deltaV(data: Data): XYZ =
  let (c1, d1) = restriction(data[0], data[1])
  let (c2, d2) = restriction(data[0], data[2])
  let (c3, d3) = restriction(data[1], data[2])
  let a = matrix(3, @[c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, c3.x, c3.y, c3.z].mapIt(it.float))
  let b = matrix(1, @[d1, d2, d3].mapIt(it.float))
  let x = a.solve(b)
  let v = x.getColumnPacked.mapIt(it.round.int)
  result = (v[0], v[1], v[2])


proc collisionPlace(data: Data): XYZ =
  let v = data.deltaV
  let w = data[0].vel - v
  let z = v - data[1].vel
  let d = data[0].pos - data[1].pos
  let a = matrix(2, @[w.x, z.x, w.y, z.y].mapIt(it.float))
  let b = matrix(1, @[d.x, d.y].mapIt(it.float))
  let x = a.solve(b)
  let s = x[0, 0].round.int
  let u = data[0].pos
  result = (u.x - w.x * s, u.y - w.y * s, u.z - w.z * s)


let data = parseData()

benchmark:
  echo data.countIntersections
  echo data.collisionPlace.sum
