---@enum CheckpointType
CheckpointType = {
    -- ground race checkpoints - icon positioned at base of cylinder
    GroundRaceChevron1AtBase = 0,
    GroundRaceChevron2AtBase = 1,
    GroundRaceChevron3AtBase = 2,
    GroundRaceLapAtBase = 3,
    GroundRaceFinishAtBase = 4,
    GroundRacePitLaneAtBase = 5,

    -- ground race checkpoints - icon positioned at centre
    GroundRaceChevron1 = 6,
    GroundRaceChevron2 = 7,
    GroundRaceChevron3 = 8,
    GroundRaceLap = 9,
    GroundRaceFinish = 10,
    GroundRacePitLane = 11,

    -- air race checkpoints
    AirRaceChevron1 = 12,
    AirRaceChevron2 = 13,
    AirRaceChevron3 = 14,
    AirRaceLap = 15,
    AirRaceFinish = 16,

    -- water race checkpoints
    WaterRaceChevron1 = 17,
    WaterRaceChevron2 = 18,
    WaterRaceChevron3 = 19,
    WaterRaceLap = 20,
    WaterRaceFinish = 21,

    -- Remark(DeadBringer): I think these are the checkpoints used in singleplayer triathalons, but I am not sure.
    Unknown1Chevron1 = 22,
    Unknown1Chevron2 = 23,
    Unknown1Chevron3 = 24,
    Unknown1Lap = 25,
    Unknown1Finish = 26,
    Unknown2Chevron1 = 27,
    Unknown2Chevron2 = 28,
    Unknown2Chevron3 = 29,
    Unknown2Lap = 30,
    Unknown2Finish = 31,
    Unknown3Chevron1 = 32,
    Unknown3Chevron2 = 33,
    Unknown3Chevron3 = 34,
    Unknown3Lap = 35,
    Unknown3Finish = 36,

    -- Plane checkpoints
    PlaneFlat = 37,
    PlaneSideLeft = 38,
    PlaneSideRight = 39,
    PlaneInverted = 40,

    -- Parachuting checkpoints
    ParachutingRing = 42,
    UnknownPossiblyParachutingFinish = 43, -- Guessing this is a parachuting finish checkpoint, but no futher information yet

    -- marker type checkpoints, uses the num parameter(last parameter) of CreateCheckpoint
    -- see https://docs.fivem.net/docs/game-references/checkpoints/#checkpoint-type-44-46 for examples
    MarkerCheckpointOne = 44,
    MarkerCheckpointTwo = 45,
    MarkerCheckpointThree = 46,

    -- All of these look like just empty checkpoints with no icon
    Unknown4 = 47,
    Unknown5 = 48,
    Unknown6 = 49,

    -- Money icon checkpoint
    Money = 54,

    -- Beast checkpoint
    Beast = 55,

    -- Transforms checkpoints
    Transform = 56,
    TransformPlane = 57,
    TransformHelicopter = 58,
    TransformBoat = 59,
    TransformCar = 60,
    TransformBike = 61,
    TransformBicycle = 62,
    TransformTruck = 63,
    TransformParachute = 64,
    TransformThruster = 65,

    -- Warp checkpoint(s)
    Warp = 66
}
