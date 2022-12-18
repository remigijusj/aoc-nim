# Advent of Code 2022 - Day 17

import std/[strutils,sequtils,bitops]

type
  Data = string
  Rows = seq[uint8]

var rocks = [
  @[0b0011110'u8],
  @[
    0b0001000'u8,
    0b0011100'u8,
    0b0001000'u8,
  ],
  @[
    0b0011100'u8,
    0b0000100'u8,
    0b0000100'u8,
  ],
  @[
    0b0010000'u8,
    0b0010000'u8,
    0b0010000'u8,
    0b0010000'u8,
  ],
  @[
    0b0011000'u8,
    0b0011000'u8,
  ]
]

proc parseData: Data =
  readAll(stdin).strip


proc push(rock: var Rows, dir: char, height: int, tower: Rows) =
  let shifted = rock.mapIt(if dir == '<': it shl 1 else: it shr 1)
  var free = true
  for i, row in shifted:
    if rock[i].testBit(if dir == '<': 6 else: 0):
      free = false
    if height+i < 0:
      let ti = tower.len + height+i
      if (row and tower[ti]) > 0:
        free = false
  if free:
    rock = shifted



proc blocked(rock: Rows, height: int, tower: Rows): bool =
  for i, row in rock:
    let ti = tower.len-1 + height+i
    if ti < 0:
      return true
    if ti < tower.len and (row and tower[ti]) > 0:
      return true


proc attach(tower: var Rows, rock: Rows, height: int) =
  for i, row in rock:
    if height+i < 0:
      let ti = tower.len + height+i
      tower[ti] = tower[ti] or row
    else:
      tower.add row


proc playTetris(jets: Data, num: int): int =
  var tower: Rows
  var ridx, jidx, height: int
  var hmin, hmod, smod: int
  var repeat: bool

  for step in 1..num:
    var rock = rocks[ridx]
    ridx = (ridx + 1) mod rocks.len
    height = 3 # rock bottom
    while true:
      rock.push(jets[jidx], height, tower)
      jidx = (jidx + 1) mod jets.len
      if jidx == 0: repeat = true
      if rock.blocked(height, tower):
        tower.attach(rock, height)
        break
      height.dec

    if num > jets.len:
      if height < hmin:
        hmin = height

      # find tower period
      if hmod == 0 and hmin < 0:
        for j in countdown(tower.high-1, hmin.abs):
          if (1..hmin.abs).allIt(tower[^it] == tower[j-it]):
            hmod = tower.len-j

      # find steps period, after jets repeating
      if smod == 0 and (step mod rocks.len == num mod rocks.len) and repeat:
        smod = step

      # use both periods on right step
      if hmod > 0 and smod > 0 and (step mod smod == num mod smod):
        let rem = tower.len - hmod * (step div smod)
        return rem + hmod * (num div smod)

  result = tower.len


let data = parseData()

echo data.playTetris(2022)
echo data.playTetris(1_000_000_000_000.int)
