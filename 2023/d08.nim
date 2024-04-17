# Advent of Code 2023 - Day 8

import std/[strutils,sequtils,tables]
from math import lcm
import ../utils/common

type Data = tuple
  moves: seq[int]
  nodes: Table[string, array[2, string]]


proc parseData: Data =
  let lines = readInput().strip.splitLines
  result.moves = lines[0].mapIt("LR".find(it))
  for line in lines[2..^1]:
    result.nodes[line[0..2]] = [line[7..9], line[12..14]]


func followMap(data: Data, start = "AAA", stop = @["ZZZ"]): int =
  var this = start
  var step = 0
  while this notin stop:
    let move = data.moves[step]
    this = data.nodes[this][move]
    step.inc
    if step == data.moves.len: step = 0
    result.inc


func simultaneously(data: Data): int =
  var starts = data.nodes.keys.toSeq.filterIt(it[^1] == 'A')
  var finish = data.nodes.keys.toSeq.filterIt(it[^1] == 'Z')
  let counts = starts.mapIt(data.followMap(it, finish))
  result = lcm(counts)


let data = parseData()

benchmark:
  echo data.followMap
  echo data.simultaneously
