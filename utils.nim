template withFile*(f: untyped, filename: string, mode: FileMode, body: untyped) =
    let fn = filename
    var f: File
    if open(f, fn, mode):
        try:
            body
        finally:
            f.close()
    else:
        raise newException(IOError, "Could not open file: " & fn)