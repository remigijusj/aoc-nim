# Advent of Code 2018 - Day 17

import std/[strscans,strutils,sequtils,tables]

type
  XY = tuple[x, y: int]

  Kind = enum
    sand, clay, still, flows

  Data = Table[XY, Kind]


func up(t: XY): XY {.inline.} = (t.x, t.y-1)
func down(t: XY): XY {.inline.} = (t.x, t.y+1)
func left(t: XY): XY {.inline.} = (t.x-1, t.y)
func right(t: XY): XY {.inline.} = (t.x+1, t.y)

func `[]`(data: Data, tile: XY): Kind {.inline.} = data.getOrDefault(tile, sand)


proc parseData: Data =
  var a, b, c: int
  for line in readAll(stdin).strip.splitLines:
    if line.scanf("x=$i, y=$i..$i", a, b, c):
      for y in b..c:
        result[(a, y)] = clay
    elif line.scanf("y=$i, x=$i..$i", a, b, c):
      for x in b..c:
        result[(x, a)] = clay
    else: assert false


func verticalSpan(data: Data): Slice[int] =
  result.a = int.high
  for (x, y) in data.keys:
    if y < result.a: result.a = y
    if y > result.b: result.b = y


func convertLayer(data: var Data, tile: XY) =
  var (a, b) = (tile.x, tile.x)
  while data[(a, tile.y)] == flows: a.dec
  while data[(b, tile.y)] == flows: b.inc
  if data[(a, tile.y)] == clay and data[(b, tile.y)] == clay:
    for x in a+1 .. b-1:
      data[(x, tile.y)] = still


proc fill(data: var Data, span: Slice[int], tile: XY, down = true) =
  if not (tile.y in span): return

  if data[tile] != still:
    data[tile] = flows

  if data[tile.down] == sand:
    data.fill(span, tile.down)

  elif data[tile.down] in {clay, still}:
    if data[tile.left] == sand:
      data.fill(span, tile.left, false)
    if data[tile.right] == sand:
      data.fill(span, tile.right, false)

    data.convertLayer(tile)

    if data[tile] == still and down:
      data.fill(span, tile.up, down)


var data = parseData()
let span = data.verticalSpan
data.fill(span, (500, span.a))

echo data.values.countIt(it in {still, flows})
echo data.values.countIt(it in {still})
