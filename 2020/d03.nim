# Advent of code 2020 - Day 3

type Slope = tuple[x, y: int]

proc itemsList(filename: string): seq[string] =
  for line in lines(filename):
    result.add line


proc countSlope(list: seq[string], s: Slope): int =
  var pos = 0
  for i in countUp(0, list.len-1, s.y):
    if list[i][pos mod list[i].len] == '#':
      result.inc
    pos.inc(s.x)


proc multCounts(list: seq[string], slopes: seq[Slope]): int =
  result = 1
  for s in slopes:
    result *= list.countSlope(s)


proc partOne(list: seq[string]): int = list.countSlope((3, 1))
proc partTwo(list: seq[string]): int = list.multCounts(@[(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)])


let list = itemsList("inputs/03.txt")
echo partOne(list)
echo partTwo(list)
