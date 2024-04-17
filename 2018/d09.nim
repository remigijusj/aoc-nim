# Advent of Code 2018 - Day 9

import std/[strscans,strutils,lists]
import ../utils/common

type Data = tuple[players, marbles: int]


proc parseData: Data =
  let data = readInput().strip
  assert data.scanf("$i players; last marble is worth $i points", result.players, result.marbles)


func maximumScore(players, marbles: int): int =
  var scores = newSeq[int](players)
  var circle = initDoublyLinkedRing[int]()
  circle.add(0)

  for marble in 1..marbles:
    let player = marble mod players
    if marble mod 23 == 0:
      for _ in 1..6:
        circle.head = circle.head.prev
      let node = circle.head.prev
      scores[player].inc(marble + node.value)
      circle.remove(node)
    else:
      circle.head = circle.head.next.next
      circle.prepend(marble)

  result = scores.max


let data = parseData()

benchmark:
  echo maximumScore(data.players, data.marbles)
  echo maximumScore(data.players, data.marbles * 100)
