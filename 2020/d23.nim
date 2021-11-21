# Advent of code 2020 - Day 23

import sequtils

type Game = object
  head: int
  list: seq[int]


proc readData(filename: string): seq[int] =
  result = readFile(filename).toSeq.mapIt(it.ord - '0'.ord)


proc nextValue(size: int, values: varargs[int]): int {.inline.} =
  result = values[0]
  while result in values:
    result.dec
    if result <= 0: result += size


proc playRound(game: var Game) {.inline.} =
  let n0 = game.head
  let n1 = game.list[n0]
  let n2 = game.list[n1]
  let n3 = game.list[n2]
  let n4 = game.list[n3]
  let nn = nextValue(game.list.len-1, n0, n1, n2, n3)
  # move 3 nodes after next val
  game.list[n0] = n4
  game.list[n3] = game.list[nn]
  game.list[nn] = n1
  # advance current node
  game.head = n4


proc play(game: Game, count: int): Game =
  result = game
  for _ in 1..count:
    result.playRound


proc populate(game: var Game, list: seq[int], prev: int): int =
  var prev = prev
  for n in list:
    game.list[prev] = n
    prev = n
  return prev


proc initGame(list: seq[int], limit: int = list.len): Game =
  result.head = list[0]
  result.list = newSeq[int](limit+1)
  var prev = result.populate(list[1..^1], list[0])
  prev = result.populate(toSeq((list.len+1)..limit), prev)
  result.list[prev] = list[0]


proc serializeFrom(game: Game, head: int): string =
  var n = head
  while true:
    n = game.list[n]
    if n == head: break
    result &= $n


proc nextPairProd(game: Game, head: int): int =
  let v1 = game.list[head]
  let v2 = game.list[v1]
  result = v1 * v2


proc partOne(list: seq[int]): string = list.initGame.play(100).serializeFrom(1)
proc partTwo(list: seq[int]): int = list.initGame(1_000_000).play(10_000_000).nextPairProd(1)


let list = readData("inputs/23.txt")
echo partOne(list)
echo partTwo(list)
