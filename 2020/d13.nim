# Advent of code 2020 - Day 13

from strutils import parseInt, split
from sequtils import mapIt, filterIt

type Data = object
  stamp: int
  buses: seq[int]

proc readData(filename: string): Data =
  let lines = readLines(filename, 2)
  result.stamp = parseInt(lines[0])
  result.buses = lines[1].split(',').mapIt(if it == "x": -1 else: it.parseInt)


proc busAt(data: Data, time: int): int =
  for bus in data.buses:
    if bus > 0 and time mod bus == 0:
      return bus


proc findEarliest(data: Data): int =
  for time in countUp(data.stamp, int.high):
    let bus = data.busAt(time)
    if bus > 0:
      return (time - data.stamp) * bus


# (result * a0) mod b0 ≡ 1
proc modInverse(a0, b0: int): int =
  var (a, b, x0) = (a0, b0, 0)
  result = 1
  if b == 1: return
  while a > 1:
    let q = a div b
    a = a mod b
    swap a, b
    result = result - q * x0
    swap x0, result
  if result < 0: result += b0


# result ≡ a[i] mod n[i]
proc chineseRemainder(n, a: openArray[int]): int =
  var prod = 1
  for x in n: prod *= x

  var sum = 0
  for i in 0..<n.len:
    let p = prod div n[i]
    sum += a[i] * modInverse(p, n[i]) * p

  sum mod prod


proc findSequence(data: Data): int =
  let moduli = data.buses.filterIt(it > 0)
  var remainders: seq[int]
  for idx, bus in data.buses:
    if bus > 0: remainders.add(bus - idx)

  chineseRemainder(moduli, remainders)


proc partOne(data: Data): int = data.findEarliest
proc partTwo(data: Data): int = data.findSequence


let data = readData("inputs/13.txt")
echo partOne(data)
echo partTwo(data)
