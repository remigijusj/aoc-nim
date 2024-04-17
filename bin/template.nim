# Advent of Code {year} - Day {day}

import std/[strutils,sequtils]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


let data = parseData()

benchmark:
  echo 0
