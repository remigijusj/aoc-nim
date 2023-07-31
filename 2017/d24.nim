# Advent of Code 2017 - Day 24

import std/[strutils,sequtils,bitops]

type
  Piece = array[2, int]

  Data = seq[Piece]

  Bridge = tuple[len, str: int]


func strength(p: Piece): int = p[0] + p[1]


func parsePiece(line: string): Piece =
  let parts = line.split("/").map(parseInt)
  result = [parts[0], parts[1]]


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parsePiece)


iterator bridges(data: Data, taken: int, start: int): Bridge {.closure.} =
  var found = false
  for i, piece in data:
    if taken.testBit(i): continue
    let e = piece.find(start)
    if e >= 0:
      found = true
      for bridge in data.bridges(taken.setMasked(i..i), piece[1-e]):
        yield (bridge.len + 1, bridge.str + piece.strength)
  if not found:
    yield (0, 0)


func strongestBridge(data: Data): Bridge =
  for bridge in data.bridges(0, 0):
    if bridge.str > result.str:
      result = bridge


func longestBridge(data: Data): Bridge =
  for bridge in data.bridges(0, 0):
    if bridge.len > result.len or (bridge.len == result.len and bridge.str > result.str):
      result = bridge


let data = parseData()

echo data.strongestBridge.str
echo data.longestBridge.str
