import std/os
import std/streams

template withStream*(f: untyped, filename: string, mode: FileMode, body: untyped) =
    let fn = filename
    if fileExists(fn):
        var f = newFileStream(fn, mode)
        try:
            body
        finally:
            f.close()
    else:
        var f = newStringStream(fn)
        try:
            body
        finally:
            f.close()
