# aoc-nim

Advent of Code in Nim

My goal is to build self-contained solutions (no external libs) using clean and concise code.

## Running scripts

All code compiles with the current (>= v1.6) Nim compiler, for example: `nim c -r d01`.

To run the solutions:
- feed the input to stdin: `dXX < input/dXX.txt`, or use the helper script `aoc`.
- to use data from clipboard: `pbpaste --lf | dXX`

Helper script to download puzzles/input data and run/test solutions:
```
bin/aoc command [day] [year]
```
Available commands (for the given day/year):
- p, puzzle - download the puzzle description
- i, input - download the input data file
- t, template - copy the template as placeholder
- c, compile - compile the script
- e, example -  run the script with example input (from clipboard)
- r, run - run the script
- x, check - run the script, check is answers match saved data
- w, write - write answers to the file

Day and year are optional, default to current.
Download commands need the session.txt file to be present.

### Structure

`bin/aoc` is a helper tool to download puzzles & inputs, prepare template.
AoC session cookie is expected to be saved in the file `session.txt` (just the value).
Puzzle parsing depends on the [html2md](https://github.com/suntong/html2md) tool.

Sub-folders for each year contain:
- `puzzles` - description of AoC puzzles
- `inputs` - (my personal) input data
- `answers` - (my personal) solution answers
- solutions code
