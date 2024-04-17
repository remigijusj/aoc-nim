# Advent of Code 2016 - Day 3

import std/[strscans,strutils,sequtils,algorithm]
import ../utils/common

type
  Triple = array[3, int]

  Data = seq[Triple]


func parseTriple(line: string): Triple =
  assert line.scanf("$s$i$s$i$s$i", result[0], result[1], result[2])


proc parseData: Data =
  readInput().strip.splitLines.map(parseTriple)


func transposed(data: Data): Data=
  result = data
  for i in countup(0, data.len-1, 3):
    swap result[i][1], result[i+1][0]
    swap result[i][2], result[i+2][0]
    swap result[i+1][2], result[i+2][1]


func possible(tri: Triple): bool=
  var tri = tri.sorted
  tri[0] + tri[1] > tri[2]


let data = parseData()

benchmark:
  echo data.countIt(it.possible)
  echo data.transposed.countIt(it.possible)
