# Advent of Code 2019 - Day 20

import std/[strutils,tables,deques,sets]

const S = 129

type Portal = array[2, int] # external, internal

type Data = object
  grid: string
  portals: Table[string,Portal]
  reverse: Table[int,(string,int)]


proc getPortalData(data: Data, pos: int): tuple[key: string, idx: int, pos: int] =
  let c = data.grid[pos]
  if data.grid[pos+1].isUpperAscii: # horizontal
    result.key = c & data.grid[pos+1]
    result.pos = if data.grid[pos-1] == '.': pos-1 else: pos+2
    result.idx = if pos mod S < 20 or pos mod S > 110: 0 else: 1

  elif pos+S < data.grid.len and data.grid[pos+S].isUpperAscii: # vertical
    result.key = c & data.grid[pos+S]
    result.pos = if pos-S >= 0 and data.grid[pos-S] == '.': pos-S else: pos+S+S
    result.idx = if pos div S < 20 or pos div S > 100: 0 else: 1


proc parsePortals(data: var Data) =
  for pos, c in data.grid:
    if not c.isUpperAscii: continue
    let (key, idx, port) = data.getPortalData(pos)
    if key == "": continue
    discard data.portals.hasKeyOrPut(key, [0, 0])
    data.portals[key][idx] = port
    data.reverse[port] = (key,idx)


proc parseData(filename: string): Data =
  for line in lines(filename):
    assert line.len == S
    result.grid &= line
  result.parsePortals


iterator neighbors(pos: int): int =
  yield pos - S
  yield pos + 1
  yield pos + S
  yield pos - 1


# BFS
proc findMazeExit(data: Data, recursive: bool): int =
  let (aa, zz) = (data.portals["AA"][0], data.portals["ZZ"][0])

  var queue = [(0, aa, 0)].toDeque
  var seen: HashSet[(int,int)]

  while queue.len > 0:
    let (dist, pos, level) = queue.popFirst

    if pos == zz and level == 0: return dist

    for neig in pos.neighbors:
      let nc = data.grid[neig]
      if nc == '#': continue

      var npos = neig
      var nlevel = level
      if nc.isUpperAscii: # passing portal
        let (key, idx) = data.reverse[pos]
        npos = data.portals[key][1-idx]
        if recursive:
          if idx == 1: nlevel.inc else: nlevel.dec
      else:
        assert nc == '.'

      if npos == 0 or nlevel < 0 or (npos, nlevel) in seen: continue
      seen.incl((npos, nlevel))
      queue.addLast (dist+1, npos, nlevel)


proc partOne(data: Data): int = data.findMazeExit(false)
proc partTwo(data: Data): int = data.findMazeExit(true)


let data = parseData("inputs/20.txt")
echo partOne(data)
echo partTwo(data)
