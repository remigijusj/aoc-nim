# Advent of Code 2021 - Day 22

import std/[sequtils, strscans, sets]
import memo

type
  Range = tuple[min, max: int]

  Box = seq[Range]

  Boxes = HashSet[Box]

  Rule = tuple[on: bool, box: Box]

  Data = seq[Rule]


proc parseRange(line: string): Range =
  discard line.scanf("$i..$i", result.min, result.max)


proc parseRule(line: string): Rule =
  let (_, o, x, y, z) = line.scanTuple("$+ x=$+,y=$+,z=$+")
  result = (o == "on", @[x, y, z].map(parseRange))


proc parseData(filename: string): Data =
  lines(filename).toSeq.map(parseRule)


proc empty(b: Box): bool =
  b.anyIt(it.min > it.max)


proc `*`(b, c: Box): Box =
  result = newSeq[Range](b.len)
  for i in 0..<b.len:
    result[i] = (max(b[i].min, c[i].min), min(b[i].max, c[i].max))


proc `-`(b, c: Box): seq[Box] =
  var fix, part: Box

  for i in 0..<b.len:
    if b[i].min < c[i].min:
      part = b
      for j in 0..<i: part[j] = fix[j]
      part[i] = (b[i].min, c[i].min-1)
      result.add(part)

    if c[i].max < b[i].max:
      part = b
      for j in 0..<i: part[j] = fix[j]
      part[i] = (c[i].max+1, b[i].max)
      result.add(part)

    fix.add (max(b[i].min, c[i].min), min(b[i].max, c[i].max))


proc applyRules(data: Data): Boxes {.memoized.} =
  var diff: Boxes
  for (on, b) in data:
    diff.clear

    for c in result:
      if (b * c).empty: continue
      diff.incl(c)
      for sub in c - b:
        diff.incl(sub)

    result = result -+- diff
    if on:
      result.incl(b)


proc clamp(bs: Boxes, box: Box): Boxes =
  for b in bs:
    let b1 = b * box
    if not b1.empty:
      result.incl(b1)


proc volume(b: Box): int = b.mapIt(it.max - it.min + 1).foldl(a * b)
proc volume(bs: Boxes): int = bs.toSeq.map(volume).foldl(a + b)


proc partOne(data: Data): int = data.applyRules.clamp(newSeqWith(3, (-50, 50))).volume
proc partTwo(data: Data): int = data.applyRules.volume


let data = parseData("inputs/22.txt")
echo partOne(data)
echo partTwo(data)
