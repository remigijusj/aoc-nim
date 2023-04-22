# Advent of Code 2018 - Day 13

import std/[strutils,sequtils,algorithm]

type
  XY = tuple[x, y: int]

  Grid = seq[string]

  Cart = object
    num: int
    pos: XY
    dir: int # 0 up, 1 right, 2 down, 3 left
    next: int # 0 left, 1 straight, 2 right
    gone: bool

  Data = object
    grid: Grid
    carts: seq[Cart]


func `$`(p: XY): string = $p.x & "," & $p.y


proc parseData: Data =
  result.grid = readAll(stdin).strip(chars = {'\n'}).splitLines
  for y, line in result.grid.mpairs:
    for x, c in line.mpairs:
      let dir = "^>v<".find(c)
      if dir >= 0:
        let cart = Cart(num: result.carts.len, pos: (x,y), dir: dir, next: 0)
        result.carts.add(cart)
        c = if dir in [0, 2]: '|' else: '-'


proc sortByPos(carts: var seq[Cart]) =
  carts.sort do (a, b: Cart) -> int:
    result = cmp(a.pos.y, b.pos.y)
    if result == 0:
      result = cmp(a.pos.x, b.pos.x)


proc move(cart: var Cart) =
  case cart.dir
  of 0: cart.pos.y.dec
  of 1: cart.pos.x.inc
  of 2: cart.pos.y.inc
  of 3: cart.pos.x.dec
  else: assert false


proc turn(cart: var Cart, grid: Grid) =
  case grid[cart.pos.y][cart.pos.x]
  of '/':
    cart.dir = cart.dir xor 1
  of '\\':
    cart.dir = cart.dir xor 3
  of '+':
    cart.dir = (cart.dir + (cart.next - 1) + 4) mod 4
    cart.next = (cart.next + 1) mod 3
  else:
    return


func collision(this: Cart, carts: seq[Cart]): int =
  result = -1
  for i, that in carts:
    if that.gone or that.num == this.num: continue
    if that.pos == this.pos:
      return i


proc firstCollission(data: Data): XY =
  var carts = data.carts
  while true:
    carts.sortByPos

    for cart in carts.mitems:
      cart.move
      cart.turn(data.grid)
      if cart.collision(carts) >= 0:
        return cart.pos


proc lastRemaining(data: Data): XY =
  var carts = data.carts
  while true:
    carts.sortByPos

    for cart in carts.mitems:
      if cart.gone: continue
      cart.move
      cart.turn(data.grid)
      let i = cart.collision(carts)
      if i >= 0:
        cart.gone = true
        carts[i].gone = true

    carts.keepItIf(not it.gone)
    if carts.len == 1:
      return carts[0].pos


let data = parseData()

echo data.firstCollission
echo data.lastRemaining
