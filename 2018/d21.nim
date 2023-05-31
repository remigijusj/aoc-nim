# Advent of Code 2018 - Day 21

import std/[sets]


proc mainLoop(input = 0): int =
  var r1 = input or 0x10000
  result = 9450265 # R3
  while r1 > 0:
    result += r1 and 0xff
    result = result and 0xffffff
    result *= 65899
    result = result and 0xffffff
    r1 = r1 div 256


proc runOptimized(): int =
  var values: HashSet[int]
  while true:
    let next = mainLoop(result)
    if values.containsOrIncl(next):
      return
    result = next


echo mainLoop()
echo runOptimized()
