

type
    MalTypeType* = enum
        mttAtom,
        mttFalse,
        mttInt,
        mttKeyword,
        mttList,
        mttNil,
        mttParseError,
        mttStr,
        mttTrue


    MalType* = ref object
        case kind*: MalTypeType
        of mttAtom:
            atomVal*: string
        of mttInt:
            intVal*: int
        of mttKeyword:
            keyVal*: string
        of mttList:
            listVal*: seq[MalType]
        of mttParseError:
            errorMessage*: string
        of mttStr:
            strVal*: string
        of mttNil, mttTrue, mttFalse:
            nil


# Singleton values for these types.

let mal_nil* = MalType(kind: mttNil)
let mal_true* = MalType(kind: mttTrue)
let mal_false* = MalType(kind: mttFalse)
