import sequtils, strutils, types


proc pr_str*(thing: MalType): string =
    case thing.kind
    of mttAtom:
        result = thing.atomVal
    of mttInt:
        result = $ thing.intVal
    of mttList:
        result = "(" & join(map(thing.listVal, pr_str), " ") & ")"
