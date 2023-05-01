# Advent of Code 2018 - Day 18

import std/[strutils,tables]

type
  Data = seq[string]


func resourceValue(data: Data): int =
  let grid = data.join
  result = grid.count('|') * grid.count('#')


proc parseData: Data =
  readAll(stdin).strip.splitLines


func adjacent(data: Data, x, y: int): array[3, int] =
  for ny in y-1 .. y+1:
    for nx in x-1 .. x+1:
      if (nx, ny) == (x, y): continue
      if ny < 0 or ny >= data.len: continue
      let row = data[ny]
      if nx < 0 or nx >= row.len: continue
      let idx = ".|#".find(row[nx])
      result[idx].inc


# Rules:
#   . -> | if |>=3
#   | -> # if #>=3
#   # -> . if not (|>=1 and #>=1)
proc updateLumber(input: Data, output: var Data) =
  for y, row in input:
    for x, cell in row:
      let adj = input.adjacent(x, y)
      case cell
      of '.':
        if adj[1] >= 3: output[y][x] = '|'
      of '|':
        if adj[2] >= 3: output[y][x] = '#'
      of '#':
        if not (adj[1] >= 1 and adj[2] >= 1): output[y][x] = '.'
      else: assert false


func runLumber(data: Data, total: int): Data =
  var seen = @[data]
  var this: Data
  var next = data
  for step in 1..total:
    this = next
    updateLumber(this, next)
    let prev = seen.find(next)
    if prev >= 0:
      return seen[prev + (total - step) mod (step - prev)]
    else:
      seen.add(next)

  return next


let data = parseData()

echo data.runLumber(10).resourceValue
echo data.runLumber(1_000_000_000).resourceValue
