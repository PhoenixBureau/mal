

type
    MalTypeType* = enum
        mttAtom,
        mttInt,
        mttList,
        mttParseError,
        mttStr

    MalType* = ref object
        case kind*: MalTypeType
        of mttAtom:
            atomVal*: string
        of mttInt:
            intVal*: int
        of mttList:
            listVal*: seq[MalType]
        of mttParseError:
            errorMessage*: string
        of mttStr:
            strVal*: string

