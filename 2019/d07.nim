# Advent of Code 2019 - Day 7

import std/[strutils, sequtils, algorithm, deques]
import intcode
import ../utils/common

type
  Data = seq[int]

  Phases = array[5, int]


proc parseData: Data =
  readInput().strip.split(',').mapIt(it.parseInt)


proc simulateSimple(data: Data, phases: Phases): int =
  for phase in phases:
    var ic = data.toIntcode
    let output = ic.run(phase, result, keep=true)
    assert output.len == 1
    result = output[0]


# Connect output->intput, feed phases and zero
proc setupChain(data: Data, phases: Phases): array[5, Intcode] =
  for i in 0..4:
    result[i] = data.toIntcode
    result[i].addInput(phases[i])
  result[0].addInput(0)

  for i in 0..4:
    result[i].output = result[(i + 1) %% 5].input


# Run until all halted, return signal from last
proc simulateFeedback(data: Data, phases: Phases): int =
  var chain = setupChain(data, phases)
  var i = 0
  while not chain[i].halted:
    if chain[i].step == oOutput:
      i = (i + 1) %% 5

  result = chain[^1].output[].popLast


proc maxSignal(data: Data, phases: Phases, simulate: proc(data: Data, phases: Phases): int): int =
  var phases = phases
  while true:
    let signal = data.simulate(phases)
    if signal > result:
      result = signal

    let cont = phases.nextPermutation
    if not cont: break


let data = parseData()

benchmark:
  echo data.maxSignal([0, 1, 2, 3, 4], simulateSimple)
  echo data.maxSignal([5, 6, 7, 8, 9], simulateFeedback)
