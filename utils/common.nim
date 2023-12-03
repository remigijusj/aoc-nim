import std/[times,monotimes,strutils]

template benchmark*(code: untyped) =
  block:
    when defined(timing):
      let start = getMonoTime()
    code
    when defined(timing):
      let elapsed = getMonoTime() - start
      let ms = elapsed.inMilliseconds
      echo "Time: ", ms, "ms"


# missing DMNQTVWX
const BlockFont6Size = 18
const BlockFont6List = "ABCEFGHIJKLOPRSUYZ"
const BlockFont6Data = [
".##..###...##..####.####..##..#..#..###...##.#..#.#.....##..###..###...###.#..#.#....####.",
"#..#.#..#.#..#.#....#....#..#.#..#...#.....#.#.#..#....#..#.#..#.#..#.#....#..#.#.......#.",
"#..#.###..#....###..###..#....####...#.....#.##...#....#..#.#..#.#..#.#....#..#..#.#...#..",
"####.#..#.#....#....#....#.##.#..#...#.....#.#.#..#....#..#.###..###...##..#..#...#...#...",
"#..#.#..#.#..#.#....#....#..#.#..#...#..#..#.#.#..#....#..#.#....#.#.....#.#..#...#..#....",
"#..#.###...##..####.#.....###.#..#..###..##..#..#.####..##..#....#..#.###...##....#..####."]

func decodeBF6*(code: string, shift = 0, width = 0): string =
  let lines = code.replace(' ','.').splitLines
  let width = if width > 0: width else: lines[0].len - shift

  assert lines.len >= 6, "Code height must be at least 6 lines, is " & $(lines.len)
  assert width mod 5 == 0, "Code width must be multiple of 5, is " & $width
  for y in 1..<6:
    let lwidth = lines[y].len-shift
    assert lwidth >= width-1, "Code width must be uniform, is " & $(y, lwidth)

  for x in countup(shift, shift+width-1, 5):
    for n in 0..<BlockFont6Size:
      var match = true
      for y in 0..<6:
        if lines[y][x ..< x+4] != BlockFont6Data[y][n*5 ..< n*5+4]:
          match = false
      if match:
        result &= BlockFont6List[n]


# often needed
func sum*[T](x: openArray[T]): T =
  for i in items(x): result = result + i
