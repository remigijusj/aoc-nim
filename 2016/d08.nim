# Advent of Code 2016 - Day 8

import std/[strscans,strutils,sequtils,algorithm]
import ../utils/common

type
  Kind = enum
    rect, roth, rotv

  Instruction = tuple
    kind: Kind
    a, b: int

  Data = seq[Instruction]

  Screen = seq[string]


func parseInstruction(line: string): Instruction =
  if line.scanf("rect $ix$i", result.a, result.b):
    result.kind = rect
  elif line.scanf("rotate row y=$i by $i", result.a, result.b):
    result.kind = roth
  elif line.scanf("rotate column x=$i by $i", result.a, result.b):
    result.kind = rotv
  else:
    assert false


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseInstruction)


func `$`(s: Screen): string = s.join("\n")

func count(s: Screen): int = s.mapIt(it.count('#')).foldl(a + b)


func runInstructions(data: Data, dim = (50, 6)): Screen =
  result = newSeqWith(dim[1], repeat(' ', dim[0]))
  for op in data:
    case op.kind

      of rect:
        for y in 0..<op.b:
          for x in 0..<op.a:
            result[y][x] = '#'

      of roth:
        var list = result[op.a].toSeq
        list.rotateLeft(-op.b)
        result[op.a] = list.join

      of rotv:
        var list = result.mapIt(it[op.a])
        list.rotateLeft(-op.b)
        for y in 0..<result.len:
          result[y][op.a] = list[y]


let data = parseData()
let output = data.runInstructions

benchmark:
  echo output.count
  echo $output
