local function setMultipliersIfPresent(runOverrides)
	if not runOverrides then return end
	if runOverrides.HarvestPointChanceMultiplier ~= nil then runOverrides.HarvestPointChanceMultiplier = 1 end
	if runOverrides.ShovelPointChanceMultiplier ~= nil then runOverrides.ShovelPointChanceMultiplier = 1 end
	if runOverrides.PickaxePointChanceMultiplier ~= nil then runOverrides.PickaxePointChanceMultiplier = 1 end
	if runOverrides.ExorcismPointChanceMultiplier ~= nil then runOverrides.ExorcismPointChanceMultiplier = 1 end
	if runOverrides.FishingPointChanceMultiplier ~= nil then runOverrides.FishingPointChanceMultiplier = 1 end
end

-- Set the multipliers for the base bounty types
setMultipliersIfPresent(game.BountyData.BasePackageBountyRandom.RunOverrides)
if config.resourcesInAllTrials then
	setMultipliersIfPresent(game.BountyData.DefaultPackagedBounty.RunOverrides)
end

-- The game will have already processed the data store at this point, and all base-game bounties inheriting from this won't automatically get the new values
for _, bountyData in pairs(game.BountyData) do
	if bountyData.InheritFrom and game.Contains(bountyData.InheritFrom, "BasePackageBountyRandom") and bountyData.RunOverrides then
		setMultipliersIfPresent(bountyData.RunOverrides)
	elseif config.resourcesInAllTrials and bountyData.InheritFrom and game.Contains(bountyData.InheritFrom, "DefaultPackagedBounty") and bountyData.RunOverrides then
		setMultipliersIfPresent(bountyData.RunOverrides)
	end
end
