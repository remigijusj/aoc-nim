# Advent of Code 2016 - Day 24

import std/[strutils,sequtils,deques,sets,algorithm]
import ../utils/common

const
  hx = 184
  hy = 38

type
  XY = tuple[x, y: int]

  Data = seq[string]

  Nums = array[8, XY]

  Dist = array[8, array[8, int]]

  Perm = seq[int]


proc parseData: Data =
  readAll(stdin).strip.splitLines


func findNumbers(data: Data): Nums =
  for y, row in data:
    for x, c in row:
      let i = "01234567".find(c)
      if i >= 0:
        result[i] = (x, y)


iterator neighbors(data: Data, this: XY): XY =
  for dx in [-1,1]:
    let next: XY = (this.x + dx, this.y)
    if next.x in 0..hx and next.y in 0..hy and data[next.y][next.x] != '#':
      yield next
  for dy in [-1,1]:
    let next: XY = (this.x, this.y + dy)
    if next.x in 0..hx and next.y in 0..hy and data[next.y][next.x] != '#':
      yield next


func calcDistances(data: Data, nums: Nums): Dist =
  for num, start in nums:
    var queue = [(start, 0)].toDeque
    var seen: HashSet[XY]
    while queue.len > 0:
      let (this, step) = queue.popFirst

      if data[this.y][this.x] notin ".#":
        let etc = nums.find(this)
        result[num][etc] = step

      for next in data.neighbors(this):
        if next notin seen:
          queue.addLast (next, step+1)
          seen.incl next


func pathLength(perm: Perm, dist: Dist, back: bool): int =
  for i in 1..<perm.len:
    result += dist[perm[i-1]][perm[i]]
  if back:
    result += dist[perm[^1]][0]


func shortestPath(data: Data, dist: Dist, back = false): int =
  result = int.high
  var perm: Perm = toSeq(0..7)
  while perm[0] == 0:
    let path = perm.pathLength(dist, back)
    if path < result: result = path
    discard perm.nextPermutation


let data = parseData()
let nums = data.findNumbers
let dist = data.calcDistances(nums)

benchmark:
  echo data.shortestPath(dist)
  echo data.shortestPath(dist, true)
