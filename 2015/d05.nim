# Advent of Code 2015 - Day 5

import std/[strutils,sequtils,nre]
import ../utils/common

type Data = seq[string]

const vowels = {'a','e','i','o','u'}


proc parseData: Data =
  readInput().strip.splitLines


func nice1(line: string): bool =
  line.count(vowels) >= 3 and line.contains(re"(.)\1") and not line.contains(re"ab|cd|pq|xy")


func nice2(line: string): bool =
  line.contains(re"(..).*\1") and line.contains(re"(.).\1")


let data = parseData()

benchmark:
  echo data.countIt(it.nice1)
  echo data.countIt(it.nice2)
