# Advent of Code 2018 - Day 12

import std/[strscans,strutils,sequtils,tables]
import ../utils/common

type
  Rules = Table[string, char]

  Data = object
    state: string
    rules: Rules

  Pots = object
    state: string
    shift: int


proc parseData: Data =
  let parts = readInput().strip.split("\n\n")
  assert parts[0].scanf("initial state: $+", result.state)
  for line in parts[1].splitLines:
    result.rules[line[0..4]] = line[9]


proc generation(pots: var Pots, rules: Rules) =
  let state = "..." & pots.state & "..."
  pots.state = ""
  pots.shift.inc

  for i in 2..<state.len-2:
    let frag = state[i-2..i+2]
    pots.state.add(rules[frag])


func simulateSpread(data: Data, gens: int): Pots =
  result.state = data.state
  for _ in 1..gens:
    result.generation(data.rules)


func sumNumbers(pots: Pots): int =
  for i, pot in pots.state:
    if pot == '#':
      result += (i - pots.shift)


func calculateSpread(data: Data, gens: int64): int64 =
  var pots = Pots(state: data.state)
  var prev, this: int
  var delta: seq[int]
  this = pots.sumNumbers

  for gen in 1..int.high:
    pots.generation(data.rules)
    prev = this
    this = pots.sumNumbers
    delta.add(this - prev)
    if delta.len >= 5 and delta[^5..^1].deduplicate.len == 1:
      return (gens - gen) * (this - prev) + this


let data = parseData()

benchmark:
  echo data.simulateSpread(20).sumNumbers
  echo data.calculateSpread(50000000000)
