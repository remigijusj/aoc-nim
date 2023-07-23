# Advent of Code 2017 - Day 20

import std/[strscans,strutils,sequtils,tables]

type
  XYZ = array[3, int]

  Particle = tuple
    p, v, a: XYZ
    dead: bool

  Data = seq[Particle]


func distToOrigin(a: XYZ): int = a[0].abs + a[1].abs + a[2].abs


func parseParticle(line: string): Particle =
  assert line.scanf("p=<$i,$i,$i>, v=<$i,$i,$i>, a=<$i,$i,$i>",
    result.p[0], result.p[1], result.p[2],
    result.v[0], result.v[1], result.v[2],
    result.a[0], result.a[1], result.a[2])


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseParticle)


func closestToOrigin(data: Data): int =
  data.mapIt(it.a.distToOrigin).minIndex


proc update(particle: var Particle) =
  for i in 0..2:
    particle.v[i] += particle.a[i]
    particle.p[i] += particle.v[i]


func countUncollided(data: Data): int =
  var collisions: Table[XYZ, seq[int]]
  var data = data
  var counts: seq[int]
  result = data.len

  for i in 0..100:
    counts.add(result)

    collisions.clear
    for n, particle in data.mpairs:
      if not particle.dead:
        particle.update
        collisions.mgetOrPut(particle.p, @[]).add(n)

    for list in collisions.values:
      if list.len == 1: continue
      for n in list:
        data[n].dead = true
        result.dec

  assert counts[^1] == counts[40] # verified heuristics


let data = parseData()

echo data.closestToOrigin
echo data.countUncollided
