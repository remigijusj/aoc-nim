# Advent of Code 2018 - Day 7

import std/[strutils,sequtils,options,algorithm]
import ../utils/common

type
  Step = char

  Edge = (Step, Step)

  Data = seq[Edge]

  Task = tuple[step: Option[Step], left: int]


func weight(step: Step): int = step.ord - 'A'.ord


# "Step A must be finished before step B can begin."
proc parseData: Data =
  readInput().strip.splitLines.mapIt((it[5], it[36]))


func allSteps(data: Data): set[Step] =
  for (a, b) in data:
    result.incl(a)
    result.incl(b)


func nextStep(data: Data, done, todo: set[Step]): Option[Step] =
  var blocked: set[Step]
  for (a, b) in data:
    if a notin done:
      blocked.incl(b)

  let available = toSeq(todo - blocked).sorted
  if available.len > 0:
    some(available[0])
  else:
    none(Step)


func orderedSteps(data: Data): seq[Step] =
  var todo = data.allSteps
  var done: set[Step]
  let count = todo.card

  while done.card < count:
    let next = data.nextStep(done, todo).get
    todo.excl(next)
    done.incl(next)
    result.add(next)


proc teamWork(data: Data, count, duration: int): int =
  var todo = data.allSteps
  var done: set[Step]
  let count = todo.card
  var workers = newSeq[Task](count)

  while done.card < count:
    result.inc

    for worker in workers.mitems:
      if worker.step.isNone:
        let next = data.nextStep(done, todo)
        worker.step = next
        if next.isSome:
          todo.excl(next.get)
          worker.left = duration + next.get.weight

    for worker in workers.mitems:
      if worker.step.isSome:
        if worker.left > 0:
          worker.left.dec
        else:
          done.incl(worker.step.get)
          worker.step = none(Step)


let data = parseData()

benchmark:
  echo data.orderedSteps().join
  echo data.teamWork(5, 60)
