# Advent of Code 2022 - Day 9

import std/[strutils,strscans,sequtils,math,sets]

type
  Pair = (char, int)
  Data = seq[Pair]
  Pos = tuple[x, y: int]


func parseLine(line: string): Pair =
  discard line.scanf("$c $i", result[0], result[1])


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseLine)


proc move(head: var Pos, dir: char) =
  case dir
    of 'U': head.y.dec
    of 'D': head.y.inc
    of 'L': head.x.dec
    of 'R': head.x.inc
    else: discard


proc follow(tail: var Pos, head: Pos) =
  if (tail.x - head.x).abs > 1 or (tail.y - head.y).abs > 1:
    tail.x += sgn(head.x - tail.x)
    tail.y += sgn(head.y - tail.y)


func simulate(data: Data, len: int): HashSet[Pos] =
  var rope = newSeq[Pos](len)

  for (dir, units) in data:
    for _ in 1..units:
      rope[0].move(dir)
      for i in 1..<len:
        rope[i].follow(rope[i-1])

      result.incl rope[^1]


let data = parseData()

let part1 = data.simulate(2).card
let part2 = data.simulate(10).card

echo part1
echo part2
