# Advent of Code 2016 - Day 4

import std/[strutils,sequtils,nre,tables,algorithm]
import ../utils/common

type
  Room = tuple
    name: string
    sectorID: int
    xsum: string

  Data = seq[Room]


func parseRoom(line: string): Room =
  let c = line.match(re"^([a-z-]+)-(\d+)\[([a-z]{5})\]$").get.captures
  result = (c[0], c[1].parseInt, c[2])


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseRoom)


func checksum(room: Room): string =
  let freq = sequtils.toSeq(room.name.replace("-", "").toCountTable.pairs)
  result = freq.sortedByIt((-it[1], it[0])).mapIt(it[0]).join.substr(0, 4)


func decryptedName(room: Room): string =
  for c in room.name:
    if c == '-':
      result &= ' '
    else:
      result &= ((c.ord - 'a'.ord + room.sectorID) mod 26 + 'a'.ord).chr


func findNorthPole(data: Data): Room =
  for room in data:
    let name = room.decryptedName
    if name.find("north") >= 0 and name.find("pole") >= 0:
      return room


var data = parseData()
data.keepItIf(it.checksum == it.xsum)

benchmark:
  echo data.mapIt(it.sectorID).foldl(a + b)
  echo data.findNorthPole.sectorID
