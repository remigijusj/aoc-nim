import std/[deques,heapqueue,sets,strutils]

const S = 81

type Data = string # SxS grid

type Keys = set[range['a'..'z']]

type Item = tuple
  dist: int
  loca: seq[int]
  keys: Keys

proc `<`(a, b: Item): bool = a.dist < b.dist


iterator neighbors(pos: int): int =
  yield pos - S
  yield pos + 1
  yield pos + S
  yield pos - 1


proc parseData(filename: string): Data =
  for line in lines(filename):
    result &= line
  assert result.len == S*S


iterator reachableKeys(data: Data, pos: int, keys: Keys): tuple[dist: int, pos: int, key: char] =
  var queue = [(0, pos)].toDeque
  var seen: HashSet[int]

  while queue.len > 0:
    let (dist, pos) = queue.popFirst

    let c = data[pos]
    if c.isLowerAscii and c notin keys:
      yield (dist, pos, c)
      continue

    for npos in pos.neighbors:
      if npos in seen: continue
      seen.incl(npos)

      let nc = data[npos]
      if nc != '#' and (not nc.isUpperAscii or nc.toLowerAscii in keys):
        queue.addLast (dist + 1, npos)


proc findAllKeys(data: Data, start: seq[int]): int =
  var queue: HeapQueue[Item] = [(0, start, Keys({}))].toHeapQueue
  var seen: HashSet[(seq[int], Keys)]

  while queue.len > 0:
    let (dist, places, keys) = queue.pop
    # debugecho (queue.len, dist, keys)

    if keys.card == 26:
      result = dist
      break

    if (places, keys) in seen: continue
    seen.incl (places, keys)

    for i, pos in places:
      for (d, npos, nkey) in data.reachableKeys(pos, keys):
        var nplaces = places
        nplaces[i] = npos
        var nkeys = keys
        nkeys.incl(nkey)
        queue.push (dist + d, nplaces, nkeys)


proc partOne(data: Data): int =
  let start = data.find('@')
  data.findAllKeys(@[start])


proc partTwo(data: var Data): int =
  let start = data.find('@')
  data[start-1-S .. start+1-S] = "@#@"
  data[start-1   .. start+1  ] = "###"
  data[start-1+S .. start+1+S] = "@#@"
  data.findAllKeys(@[start-S-1, start-S+1, start+S-1, start+S+1])


var data = parseData("inputs/18.txt")
echo partOne(data)
echo partTwo(data)
