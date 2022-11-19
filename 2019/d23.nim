# Advent of Code 2019 - Day 23

import std/[strutils,sequtils,deques]
import intcode

type Data = seq[int]

type Network = seq[Intcode]

type Nat = tuple[x, y: int]


proc parseData(filename: string): Data =
  readFile(filename).strip.split(",").map(parseInt)


proc buildNetwork(data: Data, size: int): Network =
  result = newSeqOfCap[Intcode](size)
  for i in 0..<size:
    var cpu = data.toIntcode
    cpu.addInput(i, -1)
    result.add(cpu)


proc idle(network: Network): bool =
  for i, ic in network:
    if ic.input[].len > 0 or ic.output[].len > 0:
      return false
  return true


proc run(network: var Network, short = false): int =
  var nat, nat1: Nat

  for step in 1..int.high:
    for i, ic in mpairs(network):
      if ic.input[].len == 0:
        ic.addInput(-1)

      discard ic.run(keep=true)

      if ic.output[].len > 0:
        let (y, x, d) = (ic.popOutput, ic.popOutput, ic.popOutput)
        if d == 255:
          if short: return y
          nat = (x, y)
        else:
          var ic2 = network[d]
          ic2.addInput(x, y)

    if short: continue

    if network.idle:
      network[0].addInput(nat.x, nat.y)
      if nat.y == nat1.y:
        return nat.y
      nat1 = nat


proc partOne(data: Data): int =
  var network = data.buildNetwork(50)
  result = network.run(true)


proc partTwo(data: Data): int =
  var network = data.buildNetwork(50)
  result = network.run


let data = parseData("inputs/23.txt")
echo partOne(data)
echo partTwo(data)
