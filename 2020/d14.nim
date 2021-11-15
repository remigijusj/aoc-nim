# Advent of code 2020 - Day 14

import strutils, strscans, tables, bitops

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


proc readInstructions(filename: string): seq[Instruction] =
  for line in lines(filename):
    result.add parseInstruction(line)


proc run(list: seq[Instruction], decoder: Decoder): Memory =
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


proc partOne(list: seq[Instruction]): int = list.run(decoder1).sum
proc partTwo(list: seq[Instruction]): int = list.run(decoder2).sum


let list = readInstructions("inputs/14.txt")
echo partOne(list)
echo partTwo(list)
