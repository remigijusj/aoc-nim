# Advent of Code 2016 - Day 7

import std/[strutils,sequtils,nre]
import ../utils/common

type Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func supportTLS(line: string): bool =
  line.contains(re"(\w)(?!\1)(\w)\2\1") and
    not line.contains(re"(\w)(?!\1)(\w)\2\1\w*\]")


func supportSSL(line: string): bool =
  line.contains(re"(?:^|\])\w*?(\w)(?!\1)(\w)\1.*?\[\w*?\2\1\2") or
    line.contains(re"\[\w*?(\w)(?!\1)(\w)\1.*?\]\w*\2\1\2")


let data = parseData()

benchmark:
  echo data.countIt(it.supportTLS)
  echo data.countIt(it.supportSSL)
