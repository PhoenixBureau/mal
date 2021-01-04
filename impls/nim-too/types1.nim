import tables, hashes

type

    MalHashmap = Table[MalHashKey, MalType]

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
            hashmapVal*: MalHashmap
        of mttParseError:
            errorMessage*: string
        of mttStr:
            strVal*: string
        of mttNil, mttTrue, mttFalse:
            nil

    MalHashKeyType* = enum
        mhkKeyword,
        mhkString

    MalHashKey* = ref object
        kind*: MalHashKeyType
        key*: string

proc hash*(k: MalHashKey): Hash =
    case k.kind
        of mhkKeyword:
            result = k.key.hash !& "k".hash
        of mhkString:
            result = k.key.hash !& "s".hash


proc hashmap_items*(hashmap: MalHashmap): seq[MalType] =
    result = @[]
    for k, v in hashmap.pairs:
        case k.kind
        of mhkKeyword:
            result.add MalType(kind: mttKeyword, keyVal: k.key)
        of mhkString:
            result.add MalType(kind: mttStr, strVal: k.key)
        result.add v

# Singleton values for these types.

let mal_nil* = MalType(kind: mttNil)
let mal_true* = MalType(kind: mttTrue)
let mal_false* = MalType(kind: mttFalse)
