# Advent of code 2020 - Day 24

import sequtils, sets, tables

const DIR = {
  "w": [-1,0,1], "e": [1,0,-1], "nw": [0,-1,1], "se": [0,1,-1], "ne": [1,-1,0], "sw": [-1,1,0]
}.toTable

type
  Hex = array[3, int]

  Path = seq[Hex]

  Map = HashSet[Hex]

proc `+`*(a, b: Hex): Hex = [a[0] + b[0], a[1] + b[1], a[2] + b[2]]


proc parsePath(line: string): Path =
  var this = ""
  for ch in line:
    this.add(ch)
    if DIR.hasKey(this):
      result.add(DIR[this])
      this = ""


proc readData(filename: string): seq[Path] =
  for line in lines(filename):
    result.add parsePath(line)


proc buildMap(list: seq[Path]): Map =
  for i, path in list:
    let hex = path.foldl(a + b, [0, 0, 0])
    if hex in result: result.excl(hex) else: result.incl(hex)


proc neighborCounts(map: Map): CountTable[Hex] =
  for hex in map:
    result.inc(hex) # includes self
    for dir in values(DIR):
      result.inc(hex + dir)


proc simulate(map: Map, days: int): Map =
  result = map
  for _ in 1..days:
    for hex, cnt in neighborCounts(result):
      if hex in result:
        # limits are +1, see neighborCounts
        if cnt < 2 or cnt > 3: result.excl(hex)
      else:
        if cnt == 2: result.incl(hex)


proc partOne(list: seq[Path]): int = list.buildMap.card
proc partTwo(list: seq[Path]): int = list.buildMap.simulate(100).card


let list = readData("inputs/24.txt")
echo partOne(list)
echo partTwo(list)
