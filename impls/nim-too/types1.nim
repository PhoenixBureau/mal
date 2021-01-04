import tables

type
    MalTypeType* = enum
        mttAtom,
        mttFalse,
        mttInt,
        mttKeyword,
        mttHashmap,
        mttList,
        mttNil,
        mttParseError,
        mttStr,
        mttTrue,
        mttVector


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
        of mttVector:
            vectorVal*: seq[MalType]
        of mttHashmap:
            hashmapVal*: Table[string, MalType]
        of mttParseError:
            errorMessage*: string
        of mttStr:
            strVal*: string
        of mttNil, mttTrue, mttFalse:
            nil


proc hashmap_items*(hashmap: Table[string, MalType]): seq[MalType] =
    result = @[]
    for k, v in hashmap.pairs:
        result.add MalType(kind: mttKeyword, keyVal: k)
        result.add v

# Singleton values for these types.

let mal_nil* = MalType(kind: mttNil)
let mal_true* = MalType(kind: mttTrue)
let mal_false* = MalType(kind: mttFalse)
