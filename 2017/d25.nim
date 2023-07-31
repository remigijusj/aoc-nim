# Advent of Code 2017 - Day 25

import std/[strscans,strutils,sequtils,tables]

const size = 20_000 # heuristics

type
  State = char

  Symbol = int

  Action = tuple
    write: Symbol
    move: int # delta
    next: State

  Data = object
    transitions: Table[State, array[2, Action]]
    begin: State
    steps: int


func parseAction(num: int, lines: seq[string]): Action =
  var dir: string
  var val: int
  assert lines[0].scanf("If the current value is $i:", val)
  assert val == num
  assert lines[1].scanf("- Write the value $i.", result.write)
  assert lines[2].scanf("- Move one slot to the $+.", dir)
  assert lines[3].scanf("- Continue with state $c.", result.next)
  result.move = if dir == "right": 1 else: -1


func parsePart(part: string): (State, Action, Action) =
  let lines = part.splitLines.mapIt(it.strip)
  assert lines[0].scanf("In state $c:", result[0])
  result[1] = parseAction(0, lines[1..4])
  result[2] = parseAction(1, lines[5..8])


proc parseData: Data =
  let parts = readAll(stdin).strip.split("\n\n")
  assert parts[0].scanf("Begin in state $c.\nPerform a diagnostic checksum after $i steps.", result.begin, result.steps)
  for part in parts[1..^1]:
    let (this, act0, act1) = part.parsePart
    result.transitions[this] = [act0, act1]


func runTuringMachine(data: Data): seq[int] =
  result = newSeq[int](size)
  var place = size div 2
  var state = data.begin

  for _ in 1..data.steps:
    let this = result[place]
    let action = data.transitions[state][this]
    result[place] = action.write
    place += action.move
    state = action.next


let data = parseData()

echo data.runTuringMachine.count(1)
