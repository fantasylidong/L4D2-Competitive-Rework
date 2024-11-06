
DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMinSize = 30
	MobMaxSize = 50
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 2
	RelaxMaxFlowTravel = 50
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 1000
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()