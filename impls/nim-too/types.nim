

type
    MalTypeType* = enum
        mttInt,
        mttList

    MalType* = ref object
        case kind*: MalTypeType
        of mttInt:
            intVal*: int
        of mttList:
            listVal*: seq[MalType]

