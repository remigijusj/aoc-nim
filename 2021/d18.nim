# Advent of Code 2021 - Day 18

import std/[strutils, sequtils]
# https://github.com/zevv/npeg
import npeg

type
  Tree = ref object
    left, right, up: Tree
    val: int


const treeParser = peg("tree", t: Tree):
  digit <- Digit:
    t.val = parseInt($0)
  left <- '[':
    t.left = Tree(up: t)
    t.right = Tree(up: t)
    t = t.left
  comma <- ',':
    t = t.up.right
  right <- ']':
    t = t.up
  tree <- digit | left * tree * comma * tree * right


proc parseTree(line: string): Tree =
  new(result)
  assert treeParser.match(line, result).ok


proc parseData(filename: string): seq[Tree] =
  for line in lines(filename):
    result.add line.parseTree


proc pair(tree: Tree): bool =
  tree.left != nil and tree.right != nil


proc magnitude(tree: Tree): int =
  if tree.pair:
    tree.left.magnitude * 3 + tree.right.magnitude * 2
  else:
    tree.val


template leftRight(tree: Tree, call, args: untyped): untyped =
  result = tree.left.call(args)
  if result == nil:
    result = tree.right.call(args)


proc nested(tree: Tree, level: int): Tree =
  if tree.pair:
    if level == 0:
      return tree
    tree.leftRight(nested, level-1)


proc over(tree: Tree, limit: int): Tree =
  if tree.pair:
    tree.leftRight(over, limit)
  else:
    if tree.val > limit:
      result = tree


template withNeighbour(tree: Tree, left, right, actions: untyped): untyped =
  block:
    var node {.inject.}: Tree = tree
    while node.up != nil and node == node.up.left:
      node = node.up
    node = node.up
    if node != nil:
      node = node.left
      while node.pair:
        node = node.right
      actions


proc explode(tree: var Tree) =
  withNeighbour(tree, left, right):
    node.val += tree.left.val
  withNeighbour(tree, right, left):
    node.val += tree.right.val

  tree.left = nil
  tree.right = nil
  tree.val = 0


proc split(node: var Tree) =
  let half = node.val div 2
  node.left = Tree(up: node, val: half)
  node.right = Tree(up: node, val: node.val - half)


proc reduce(tree: var Tree) =
  var node = tree
  while node != nil:
    node = tree.nested(4)
    if node != nil:
      node.explode
    else:
      node = tree.over(9)
      if node != nil:
        node.split


proc dup(tree: Tree): Tree =
  if tree.pair:
    result = Tree(left: tree.left.dup, right: tree.right.dup)
    result.left.up = result
    result.right.up = result
  else:
    result = Tree(val: tree.val)


proc `+`(left, right: Tree): Tree =
  result = Tree(left: left, right: right).dup
  result.reduce


proc pairSums(data: seq[Tree]): seq[Tree] =
  for i, one in data:
    for j, two in data:
      if i != j:
        result.add(one + two)


proc partOne(data: seq[Tree]): int = data.foldl(a + b).magnitude
proc partTwo(data: seq[Tree]): int = data.pairSums.map(magnitude).max


let data = parseData("inputs/18.txt")
echo partOne(data)
echo partTwo(data)
