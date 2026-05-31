-- #region Fix Plentiful Forage
-- Remove vanilla requirements that cause the boon to not show in Chaos Trials and Dream Dives
game.TraitData.PlantHealthBoon.GameStateRequirements[3] = nil
game.TraitData.PlantHealthBoon.GameStateRequirements[4] = nil

game.TraitData.PlantHealthBoon.GameStateRequirements.OrRequirements = {
	-- Vanilla: Always allow if this isn't a Chaos Trials or a Dream Dive
	{
		{
			PathFalse = { "CurrentRun", "ActiveBounty" },
		},
		{
			PathFalse = { "CurrentRun", "IsDreamRun" },
		},
	},
	-- Alternatively, also allow if mod config allows spawning resources in this run
	{
		{
			PathTrue = { _PLUGIN.guid, "ResourcesEnabledForCurrentRun" },
		},
	},
}
-- #endregion
