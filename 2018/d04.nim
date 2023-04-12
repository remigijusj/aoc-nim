# Advent of Code 2018 - Day 4

import std/[strscans,strutils,sequtils,algorithm,tables]

type
  Schedule = tuple
    guard: int
    datex: int # month * 100 + day
    slices: seq[Slice[int]]

  Data = seq[Schedule]


proc parseData: Data =
  let lines = readAll(stdin).strip.splitLines.sorted

  var month, day, hour, min, start, guard, datex: int
  var slices:  seq[Slice[int]]
  var tail: string

  for line in lines:
    assert line.scanf("[1518-$i-$i $i:$i] $+", month, day, hour, min, tail)

    if tail.endsWith("begins shift"):
      if guard > 0 and datex > 0:
        result.add (guard, datex, slices)
      assert tail.scanf("Guard #$i", guard)
      slices.setLen(0)

    elif tail == "falls asleep":
      assert hour == 0
      datex = month * 100 + day
      start = min

    elif tail == "wakes up":
      assert hour == 0
      slices.add(start ..< min)

  result.add (guard, datex, slices)


func topGuardMinute1(data: Data): int =
  var asleep: CountTable[int]

  for schedule in data:
    let minutes = schedule.slices.mapIt(it.len).foldl(a + b, 0)
    asleep.inc(schedule.guard, minutes)
  result = asleep.largest.key

  asleep.clear
  for schedule in data:
    if schedule.guard == result:
      for slice in schedule.slices:
        for min in slice:
          asleep.inc(min)
  result *= asleep.largest.key


proc topGuardMinute2(data: Data): int =
  var asleep: CountTable[(int, int)]

  for schedule in data:
    for slice in schedule.slices:
      for min in slice:
        asleep.inc((schedule.guard, min))
  let (guard, minute) = asleep.largest.key
  result = guard * minute


let data = parseData()

echo data.topGuardMinute1
echo data.topGuardMinute2
