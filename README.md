# aoc-nim

Advent of Code in Nim

## Running scripts

Code compiles with the current (v1.6.0) Nim compiler, for example: `nim c -r d01`.

### Structure

`bin/aoc` is a helper tool to download puzzles & inputs, prepare template.
AoC session cookie is expected to be saved in the file `session.txt` (just the value).
Puzzle parsing depends on the [html2md](https://github.com/suntong/html2md) tool.

Sub-folders for each year contain:
- `puzzles` - description of AoC puzzles
- `inputs` - (my personal) input data
- `answers` - (my personal) solution answers
- solutions code
