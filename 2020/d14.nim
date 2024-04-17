# Advent of code 2020 - Day 14

import std/[strutils, sequtils, strscans, tables, bitops]
import ../utils/common

type
  Memory = Table[int, int]

  Mask = object
    zeros, ones, ixes: int

  Decoder = proc(memory: var Memory, mask: Mask, address, value: int)

  Kind = enum kMask, kMemo

  Instruction = object
    case kind: Kind
    of kMask: mask: Mask
    of kMemo: address, value: int

  Data = seq[Instruction]


proc parseMask(mask: string): Mask =
  result.zeros = mask.multiReplace(("X","0"), ("0","1"), ("1","0")).parseBinInt
  result.ones = mask.multiReplace(("X","0")).parseBinInt
  result.ixes = mask.multiReplace(("X","1"), ("1","0")).parseBinInt


proc parseInstruction(line: string): Instruction =
  if line[0..3] == "mask":
    result = Instruction(kind: kMask, mask: parseMask(line[7..42]))
  else:
    result = Instruction(kind: kMemo)
    discard scanf(line, "mem[$i] = $i", result.address, result.value)


proc parseData: Data =
  readInput().strip.splitLines.map(parseInstruction)


proc run(list: Data, decoder: Decoder): Memory =
  var mask: Mask
  for item in list:
    case item.kind:
    of kMask: mask = item.mask
    of kMemo: decoder(result, mask, item.address, item.value)


proc decoder1(memory: var Memory, mask: Mask, address, value: int) =
  memory[address] = value.clearMasked(mask.zeros).setMasked(mask.ones)


proc combine(address, variant, ixes: int): int {.inline.} =
  result = address
  var b: int
  for i in 0..<36:
    if ixes.testBit(i):
      if variant.testBit(b) != address.testBit(i): result.flipBit(i)
      b.inc


iterator variants(address, ixes: int): int =
  let count = ixes.countSetBits
  for variant in 0 ..< 1 shl count:
    yield address.combine(variant, ixes)


proc decoder2(memory: var Memory, mask: Mask, address, value: int) =
  var address = address.setMasked(mask.ones)
  for address in variants(address, mask.ixes):
    memory[address] = value


proc sum(memory: Memory): int =
  for value in values(memory): result += value


let data = parseData()

benchmark:
  echo data.run(decoder1).sum
  echo data.run(decoder2).sum
