# Advent of Code 2017 - Day 17

import std/[strutils,lists]

type
  Data = int

  Ring = SinglyLinkedRing[int]


proc parseData: Data =
  readAll(stdin).strip.parseInt


proc move(ring: var Ring, step: int) =
  var (head, tail) = (ring.head, ring.tail)
  for _ in 0..step:
    (head, tail) = (head.next, head)
  ring.head = head
  ring.tail = tail


func spinBuffer(step: Data, last: int): Ring =
  result.prepend(0)
  for n in 1..last:
    result.move(step)
    result.prepend(n)


func simulateBuffer(step: int, last: int): int =
  var pos = 0
  var len = 1
  for n in 1..last:
    pos = (pos + step + 1) mod len
    len.inc
    if pos == 0:
      result = n


let data = parseData()

echo spinBuffer(data, 2017).head.next.value
echo simulateBuffer(data, 50_000_000)
