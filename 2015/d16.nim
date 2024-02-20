# Advent of Code 2015 - Day 16

import std/[strscans,strutils,sequtils,tables]
import ../utils/common

const
  facts = {
    "cats": 7, "samoyeds": 2, "pomeranians": 3, "akitas": 0, "vizslas": 0,
    "goldfish": 5, "trees": 3, "cars": 2, "perfumes": 1, "children": 3
  }.toTable

type
  Aunt = tuple
    number: int
    items: Table[string, int]

  Data = seq[Aunt]


func parseAunt(line: string): Aunt =
  var names: array[3, string]
  var quant: array[3, int]

  assert line.scanf("Sue $i: $+: $i, $+: $i, $+: $i",
    result.number, names[0], quant[0], names[1], quant[1], names[2], quant[2])
  result.items = names.zip(quant).toTable

  for key in result.items.keys:
    assert key in facts


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseAunt)


proc findNum(data: Data, match: proc(key: string, val: int): bool): int =
  for aunt in data:
    var fits = true
    for key, val in aunt.items:
      if not match(key, val):
        fits = false
    if fits:
      return aunt.number


proc match1(key: string, val: int): bool =
  return val == facts[key]


func match2(key: string, val: int): bool =
  if key in ["cats", "trees"]:
    return val > facts[key]
  elif key in ["pomeranians", "goldfish"]:
    return val < facts[key]
  else:
    return val == facts[key]


let data = parseData()

benchmark:
  echo data.findNum(match1)
  echo data.findNum(match2)
