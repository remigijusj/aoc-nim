# Advent of Code 2021 - Day 16

import std/[strutils, sequtils, math]

type Packet = object
  version: int
  kind: int
  value: int
  subpackets: seq[Packet]


proc parseData(filename: string): string =
  readFile(filename).strip

proc toBinary(data: string): string =
  data.parseHexStr.mapIt(it.ord.toBin(8)).foldl(a & b)


proc parsePackets(data: string, maxp: int = -1): tuple[packets: seq[Packet], ends: int]


proc parseLiteral(data: string): tuple[value, ends: int] =
  var idx = 0
  while idx + 4 < data.len:
    let final = data[idx]
    result.value = result.value * 16 + data[idx+1 .. idx+4].parseBinInt
    idx += 5
    if final == '0': break
  result.ends = idx


proc parseOperator(data: string): tuple[packets: seq[Packet], ends: int] =
  let lenType = data[0]
  if lenType == '0':
    let bits = data[1..15].parseBinInt
    let (packets, ends) = parsePackets(data[16..15+bits])
    return (packets, 16 + ends)
  else:
    let subs = data[1..11].parseBinInt
    let (packets, ends) = parsePackets(data[12..^1], maxp = subs)
    return (packets, 12 + ends)


proc parsePacket(data: string): tuple[packet: Packet, ends: int] =
  result.packet.version = data[0..2].parseBinInt
  result.packet.kind = data[3..5].parseBinInt
  if result.packet.kind == 4:
    let (value, ends) = parseLiteral(data[6..^1])
    result.packet.value = value
    result.ends = 6 + ends
  else:
    let (packets, ends) = parseOperator(data[6..^1])
    result.packet.subpackets = packets
    result.ends = 6 + ends


proc parsePackets(data: string, maxp: int = -1): tuple[packets: seq[Packet], ends: int] =
  var idx = 0
  while idx + 6 < data.len:
    let (packet, ends) = parsePacket(data[idx..^1])
    result.packets.add(packet)
    idx += ends
    if result.packets.len == maxp:
      break
  result.ends = idx


proc sumVersions(packet: Packet): int =
  packet.version + packet.subpackets.map(sumVersions).sum


proc calcValue(packet: Packet): int =
  let subvalues = packet.subpackets.map(calcValue)
  case packet.kind
  of 0: subvalues.sum
  of 1: subvalues.prod
  of 2: subvalues.min
  of 3: subvalues.max
  of 4: packet.value
  of 5: (if subvalues[0] > subvalues[1]: 1 else: 0)
  of 6: (if subvalues[0] < subvalues[1]: 1 else: 0)
  of 7: (if subvalues[0] == subvalues[1]: 1 else: 0)
  else: 0


proc partOne(data: string): int = data.toBinary.parsePacket.packet.sumVersions
proc partTwo(data: string): int = data.toBinary.parsePacket.packet.calcValue


let data = parseData("inputs/16.txt")
echo partOne(data)
echo partTwo(data)
