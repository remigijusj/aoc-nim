# Advent of Code 2015 - Day 14

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  Reindeer = tuple
    name: string
    speed, work, rest: int

  Data = seq[Reindeer]


func parseReindeer(line: string): Reindeer =
  assert line.scanf("$+ can fly $i km/s for $i seconds, but then must rest for $i seconds.",
    result.name, result.speed, result.work, result.rest)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseReindeer)


func distance(r: Reindeer, time: int): int =
  let cycles = time div (r.work + r.rest)
  let tail = time mod (r.work + r.rest)
  result = r.speed * (cycles * r.work + min(tail, r.work))


func maxScorePoints(data: Data, time: int): int =
  var distance = newSeq[int](data.len)
  var score = newSeq[int](data.len)
  for sec in 1..time:
    for i, r in data:
      distance[i] = r.distance(sec)

    let maxdist = distance.max
    for i, dist in distance:
      if dist == maxdist:
        score[i].inc

  result = score.max


let data = parseData()

benchmark:
  echo data.mapIt(it.distance(2503)).max
  echo data.maxScorePoints(2503)
