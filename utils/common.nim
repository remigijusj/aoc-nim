import std/[times,monotimes]

template benchmark*(code: untyped) =
  block:
    when defined(timing):
      let start = getMonoTime()
    code
    when defined(timing):
      let elapsed = getMonoTime() - start
      let ms = elapsed.inMilliseconds
      echo "Time: ", ms, "ms"
