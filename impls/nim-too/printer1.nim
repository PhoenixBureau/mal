import sequtils, strutils, types1


proc pr_str*(thing: MalType): string =
    case thing.kind
    of mttAtom:
        result = thing.atomVal
    of mttInt:
        result = $ thing.intVal
    of mttList:
        result = "(" & join(map(thing.listVal, pr_str), " ") & ")"
    of mttParseError:
        result = thing.errorMessage
    of mttStr:
        result = thing.strVal
