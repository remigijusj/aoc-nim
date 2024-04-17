# Advent of Code 2022 - Day 8

import std/[strutils,sequtils]
import ../utils/common

type
  Dir = tuple[view: int, blocked: bool]

  Tree = array[4, Dir]

  Data = seq[seq[int]]


func parseLine(line: string): seq[int] =
  line.mapIt(it.ord - '0'.ord)


proc parseData: Data =
  readInput().strip.splitLines.map(parseLine)


template `<-`(dir, pval) =
  dir.view.inc
  if pval >= val:
    dir.blocked = true
    break


iterator trees(grid: Data): Tree =
  for ri, row in grid:
    for ci, val in row:
      var tree: Tree
 
      for cj in countdown(ci-1, 0):        tree[0] <- grid[ri][cj]
      for cj in countup(ci+1, row.len-1):  tree[1] <- grid[ri][cj]
      for rj in countdown(ri-1, 0):        tree[2] <- grid[rj][ci]
      for rj in countup(ri+1, grid.len-1): tree[3] <- grid[rj][ci]
 
      yield tree


func visible(tree: Tree): bool = tree.anyIt(not it.blocked)

func scenicScore(tree: Tree): int = tree.mapIt(it.view).prod


func countVisibleTrees(data: Data): int =
  for tree in data.trees:
    if tree.visible:
      result.inc


func maxScenicScore(data: Data): int =
  for tree in data.trees:
    let score = tree.scenicScore
    if score > result:
      result = score


let data = parseData()

benchmark:
  echo data.countVisibleTrees
  echo data.maxScenicScore
