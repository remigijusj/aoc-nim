# Advent of Code 2021 - Day 23

import astar

const
  chars = "ABCD."
  costs = [1, 10, 100, 1000]
  tops = [2, 4, 6, 8]
  hall = 11

type
  Game = tuple[]

  State = string


proc parseData(filename: string): State =
  for c in readFile(filename):
    if chars.find(c) >= 0: result &= c


proc room(c: char): int = chars.find(c) # 0..3

proc cost(c: char): int = costs[c.room] # 1,10,..


proc roomLevel(pos: int): tuple[room, level: int] =
  result.room = (pos - hall) mod 4
  result.level = (pos - hall) div 4


proc freePlace(state: State, c: char, room: int): int =
  if c.room != room: return -1
  for pos in countup(hall+room, state.len-1, 4):
    if state[pos] == '.':
      result = pos
    elif state[pos] != c:
      return -1


proc hallFree(state: State, a, b: int): bool =
  if a < b:
    for pos in countup(a+1, b):
      if state[pos] != '.': return false
  else:
    for pos in countup(b, a-1):
      if state[pos] != '.': return false
  return true


proc move(state: State, a, b: int): State =
  result = state
  swap(result[a], result[b])


iterator neighbors(game: Game, state: State): State =
  for pos, c in state:
    if c == '.': continue

    if pos < hall: # hallway to home room
      if state.hallFree(pos, tops[c.room]):
        let to = state.freePlace(c, c.room)
        if to >= 0:
          yield state.move(pos, to)

    else: # some room to hallway
      let (room, level) = roomLevel(pos)
      if (level == 0 or state[pos-4] == '.') and state.freePlace(c, room) < 0: # can move up
        for to in 0..<hall:
          if to notin tops and state.hallFree(tops[room], to):
            yield state.move(pos, to)


proc cost(game: Game, prev, this: State): int =
  var a, b: int
  for i in 0..<this.len:
    if prev[i] != '.' and this[i] == '.': a = i
    if prev[i] == '.' and this[i] != '.': b = i

  assert min(a,b) < hall and max(a,b) >= hall

  let (room, level) = roomLevel(max(a,b))
  let dist = (tops[room] - min(a,b)).abs + (level + 1)
  result = this[b].cost * dist


proc heuristic(game: Game, state, goal: State): int =
  for pos, c in state:
    if c == '.':
      if pos >= hall:
        result += 1
    else:
      if pos < hall:
        let top = tops[c.room]
        result += (pos - top).abs + 1


proc minCost(start: State, goal: string): int =
  let game = ()
  var prev = start
  for this in path[Game, State, int](game, start, goal):
    if this != start:
      result += cost(game, prev, this)
      prev = this


proc unfold(state: State): State =
  result = state
  result.insert("DCBADBAC", 15)


proc partOne(state: State): int = state.minCost("...........ABCDABCD")
proc partTwo(state: State): int = state.unfold.minCost("...........ABCDABCDABCDABCD")


let data = parseData("inputs/23.txt")
echo partOne(data)
echo partTwo(data)
