# Advent of Code 2019 - Day 17

import std/[strutils,sequtils,sets,nre]
import intcode
import ../utils/common

type
  Cell = tuple[x, y: int]

  Op = tuple[rot: char, units: int]

  Data = seq[int]

const dirs = "^>v<"


# data functions
func move(cell: Cell, dir: char, units = 1): Cell =
  case dir
    of '^': (cell.x, cell.y-units)
    of 'v': (cell.x, cell.y+units)
    of '<': (cell.x-units, cell.y)
    of '>': (cell.x+units, cell.y)
    else: cell

func turn(dir, rot: char): char =
  let shift = "NR".find(rot) # L -> -1
  result = dirs[(dirs.find(dir) + shift + 4) mod 4]

# globals
var ascii: string


proc parseData: Data =
  readInput().strip.split(",").map(parseInt)


proc sumAlignmentParams(ascii: string): int =
  let lines = ascii.strip.split("\n")
  for li, line in lines:
    if li == 0 or li == lines.len-1: continue
    for ci in 1 .. line.len-2:
      if lines[li][ci-1..ci+1] == "###" and lines[li-1][ci-1..ci+1] == ".#." and lines[li+1][ci-1..ci+1] == ".#.":
        result += li * ci


proc sumAlignments(data: Data): int =
  var ic = data.toIntcode
  let output = ic.run
  ascii = output.mapIt(it.chr).join
  result = ascii.sumAlignmentParams


proc analyze(ascii: string): tuple[set: HashSet[Cell], start: Cell, dir: char] =
  let lines = ascii.strip.split("\n")
  for ri, line in lines:
    for ci, c in line:
      case c
        of '#': result.set.incl (ci, ri)
        of '^', '>', 'v', '<':
          result.start = (ci, ri)
          result.dir = c
        else: continue


proc buildPath(ascii: string): seq[Op] =
  var (scaffold, robot, dir) = ascii.analyze
  var op: Op
  while true:
    op = ('N', 0)
    for rot in "LR":
      if robot.move(dir.turn(rot)) in scaffold:
        op.rot = rot
        dir = dir.turn(rot)
    if op.rot == 'N':
      break # finished
    while robot.move(dir, op.units+1) in scaffold:
      op.units.inc
    result.add op
    robot = robot.move(dir, op.units)


proc buildMain(text: string, subs: varargs[string]): seq[char] =
  var pos = 0
  while pos < text.len:
    block inner:
      for i, sub in subs:
        if text.continuesWith(sub, pos):
          result.add("ABC"[i])
          pos.inc(sub.len + 1)
          break inner
      assert false


proc buildProgram(ascii: string): string =
  let path = ascii.buildPath.mapIt(it.rot & "," & $it.units)
  let text = path.join(",") & ","
  let subs = text.match(re"(.{3,20}?),(?:\1,)*(.{3,20}?),(?:\1,|\2,)*(.{3,20}?),(?:\1,|\2,|\3,)*$").get.captures
  let main = buildMain(text, subs[0], subs[1], subs[2]).join(",")
  result = [main, subs[0], subs[1], subs[2]].join("\n") & "\nN\n"


proc collectedDust(data: Data): int =
  var ic = data.toIntcode
  ic.setVal(2, 0)
  let program = ascii.buildProgram.mapIt(it.int)
  result = ic.getOutput(program)
  while result < 256:
    result = ic.getOutput
    # write(stdout, result.chr)


let data = parseData()

benchmark:
  echo data.sumAlignments
  echo data.collectedDust
