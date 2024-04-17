# Advent of Code 2015 - Day 8

import std/[strutils,sequtils]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func delta1(line: string): int =
  result = line.len - line.unescape.len


func delta2(line: string): int =
  result = line.escape.len - line.len


let data = parseData()

benchmark:
  echo data.map(delta1).sum
  echo data.map(delta2).sum
