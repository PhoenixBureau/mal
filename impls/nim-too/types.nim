

type
    MalTypeType* = enum
        mttAtom,
        mttList

    MalType* = ref object
        case kind*: MalTypeType
        of mttAtom:
            atomVal*: string
        of mttList:
            listVal*: seq[MalType]

