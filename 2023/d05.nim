# Advent of Code 2023 - Day 5

import std/[strutils,sequtils,algorithm]
import ../utils/common

type
  Interval = Slice[int]

  MapRange = tuple
    a, b, delta: int

  Map = seq[MapRange]

  Data = object
    seeds: seq[int]
    maps: seq[Map]


func parseMap(blob: string): Map =
  let lines = blob.splitLines
  for line in lines[1..^1]:
    let ints = line.split(" ").map(parseInt)
    result.add (ints[1], ints[1] + ints[2] - 1, ints[0] - ints[1])
  sort(result) do (x, y: MapRange) -> int:
    return cmp(x.a, y.a)


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  result.seeds = parts[0][7..^1].split(" ").map(parseInt)
  result.maps = parts[1..^1].map(parseMap)


func location(seed: int, data: Data): int =
  result = seed
  for map in data.maps:
    for r in map:
      if result in r.a .. r.b:
        result += r.delta
        break


func translate(list: seq[Interval], map: Map): seq[Interval] =
  for s in list:
    var sa = s.a
    for r in map:
      if sa < r.a: # before
        result.add(sa .. min(s.b, r.a-1))
        sa = r.a
      let rb = min(s.b, r.b)
      if sa <= rb: # intersection
        result.add(sa + r.delta .. rb + r.delta)
        sa = rb + 1
      if sa > s.b:
        break
    if sa <= s.b: # leftover
      result.add(sa .. s.b)


func locations(data: Data): seq[Interval] =
  for i in countup(0, data.seeds.len-1, 2):
    result.add(data.seeds[i] ..< data.seeds[i] + data.seeds[i+1])

  for map in data.maps:
    result = result.translate(map)
    sort(result) do (x, y: Interval) -> int:
      return cmp(x.a, y.a)


let data = parseData()

benchmark:
  echo data.seeds.mapIt(location(it, data)).min
  echo data.locations[0].a
