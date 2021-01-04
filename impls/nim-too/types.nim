

type
    MalTypeType* = enum
        mttAtom,
        mttInt,
        mttList

    MalType* = ref object
        case kind*: MalTypeType
        of mttAtom:
            atomVal*: string
        of mttInt:
            intVal*: int
        of mttList:
            listVal*: seq[MalType]

