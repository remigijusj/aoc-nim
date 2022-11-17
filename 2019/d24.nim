# Advent of Code 2019 - Day 24

import std/[sets,sequtils]

type Pos = tuple[x, y, z: int]

type Data = HashSet[Pos]

func `+`(a, b: Pos): Pos = (a.x + b.x, a.y + b.y, a.z + b.z)


proc parseData(filename: string): Data =
  for row, line in lines(filename).toSeq:
    for col, ch in line:
      if ch == '#':
        result.incl (col, row, 0)


iterator neighbors(pos: Pos, recursive: bool): Pos =
  for vec in [(-1,0,0).Pos, (1,0,0), (0,-1,0), (0,1,0)]:
    var adj: Pos = pos + vec

    if recursive:
      if pos.x == 2 and pos.y == 2:
        continue # no neighbors
      elif adj.x == 2 and adj.y == 2:
        for j in -2..2:
          if vec[0] == 0:
            yield pos + (j,-vec[1],-1)
          else:
            yield pos + (-vec[0],j,-1)
        continue
      elif adj.x notin 0..4 or adj.y notin 0..4:
        adj = (2,2,pos.z+1) + vec

    yield adj


proc countNeighbors(data: Data, pos: Pos, recursive: bool): int =
  for adj in pos.neighbors(recursive):
    if adj in data: result.inc


proc levels(data: Data, recursive: bool): Slice[int] =
  if not recursive: return 0..0

  var minz, maxz: int
  for pos in data:
    if pos.z < minz: minz = pos.z
    if pos.z > maxz: maxz = pos.z
  minz-1..maxz+1


proc step(data: Data, recursive = false): Data =
  for x in 0..4:
    for y in 0..4:
      for z in data.levels(recursive):
        let pos = (x, y, z)
        let cnt = data.countNeighbors(pos, recursive)
        if pos in data:
          if cnt in [1]: result.incl(pos)
        else:
          if cnt in [1,2]: result.incl(pos)


proc runUntilRepeat(data: Data): Data =
  var origin: Data
  var seen: HashSet[Data]

  result = data
  while result notin seen:
    seen.incl(result)
    swap(origin, result)
    result = origin.step


proc runRecursive(data: Data, steps: int): Data =
  result = data
  for s in 1..steps:
    result = result.step(true)


proc biodiversity(data: Data): int =
  for idx in 0..24:
    let (x, y) = (idx div 5, idx mod 5)
    if (x, y, 0) in data:
      result = result or (1 shl idx)


proc partOne(data: Data): int = data.runUntilRepeat.biodiversity
proc partTwo(data: Data): int = data.runRecursive(200).card

let data = parseData("inputs/24.txt")
echo partOne(data)
echo partTwo(data)
