# Advent of Code 2015 - Day 19

import std/[strutils,sequtils,sets,algorithm]
import ../utils/common

type
  Repl = (string, string)

  Data = tuple
    replacements: seq[Repl]
    molecule: string


func parseRepl(line: string): Repl =
  let parts = line.split(" => ")
  result = (parts[0], parts[1])


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  result.replacements = parts[0].split("\n").map(parseRepl)
  result.molecule = parts[1]


proc replace(str: string, i: int, a, b: string): string {.inline.} =
  result = str[0..<i] & b & str[(i+a.len)..^1]


func substitutes(data: Data): HashSet[string] =
  let str = data.molecule
  for i in 0..<str.len:
    for (a, b) in data.replacements:
      if str.continuesWith(a, i):
        let str1 = str.replace(i, a, b)
        result.incl(str1)


func shortenTo(data: Data, seed: string): int =
  var str = data.molecule
  let replacements = data.replacements.sortedByIt(-it[1].len)
  while str != seed:
    block loop:
      result.inc
      for (a, b) in replacements:
        for i in 0..<str.len:
          if str.continuesWith(b, i):
            str = str.replace(i, b, a)
            break loop


let data = parseData()

benchmark:
  echo data.substitutes.card
  echo data.shortenTo("e")
