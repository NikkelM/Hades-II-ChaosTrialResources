local function areResourcesEnabledThroughModForCurrentRun(currentRun)
	if not currentRun then
		return false
	end

	if currentRun.IsDreamRun then
		return config.dreamDives == true
	end

	if not currentRun.ActiveBounty then
		-- Already handled by vanilla
		return false
	end

	if config.resourcesInAllTrials then
		-- No matter what kind of Bounty, ActiveBounty is true so we spawn resources
		return true
	end

	local bountyData = game.BountyData[currentRun.ActiveBounty]
	if not bountyData or not bountyData.InheritFrom then
		return false
	end

	if game.ContainsAny(bountyData.InheritFrom, { "BasePackageBountyRandom", "ModsNikkelMHadesBiomes_BasePackageBountyRandom" }) then
		-- By default, the mod only spawns resources for randomized trials
		return true
	end

	return false
end

modutil.mod.Path.Wrap("CreateRoom", function(base, roomData, args)
	local room = base(roomData, args)

	mod.ResourcesEnabledForCurrentRun = areResourcesEnabledThroughModForCurrentRun(game.CurrentRun)

	if not mod.ResourcesEnabledForCurrentRun then
		return room
	end

	-- We only want to check this if the base game would have skipped the generation to not double-generate
	if game.CurrentRun.ActiveBounty or game.CurrentRun.IsDreamRun then
		-- Logic from here is just base game logic duplicated
		if room.HasHarvestPoint then
			if room.HarvestPointForceRequirements ~= nil and game.IsGameStateEligible(room, room.HarvestPointForceRequirements) then
				room.HarvestPointsAllowed = 1
			elseif game.IsGameStateEligible(room, room.HarvestPointRequirements or game.HarvestData.DefaultGameStateRequirements) then
				local familiarSpawnChance = 0
				if game.HasFamiliarTool("ToolHarvest") then
					familiarSpawnChance = familiarSpawnChance + game.GetTotalHeroTraitValue("FamiliarResourceBonusChance")
				end
				for _, spawnChance in ipairs(room.HarvestPointChances or game.HarvestData.DefaultSpawnChances) do
					if game.RandomChance(spawnChance + familiarSpawnChance) then
						room.HarvestPointsAllowed = room.HarvestPointsAllowed + 1
					end
				end
			end
		end

		local forceShovelPoint = false
		if room.HasShovelPoint then
			if room.ShovelPointForceRequirements ~= nil and game.IsGameStateEligible(room, room.ShovelPointForceRequirements) then
				forceShovelPoint = true
				room.ShovelPointSuccess = true
			elseif game.IsGameStateEligible(room, room.ShovelPointRequirements or game.ShovelPointData.DefaultGameStateRequirements) then
				local shovelPointChance = game.GetHarvestPointSpawnChance(game.ShovelPointData, room)
				room.ShovelPointSuccess = game.RandomChance(shovelPointChance)
			end
		end

		local forcePickaxePoint = false
		if room.HasPickaxePoint then
			if room.PickaxePointForceRequirements ~= nil and game.IsGameStateEligible(room, room.PickaxePointForceRequirements) then
				forcePickaxePoint = true
				room.PickaxePointSuccess = true
			elseif game.IsGameStateEligible(room, room.PickaxePointRequirements or game.PickaxePointData.DefaultGameStateRequirements) then
				local pickaxePointChance = game.GetHarvestPointSpawnChance(game.PickaxePointData, room)
				room.PickaxePointSuccess = game.RandomChance(pickaxePointChance)
			end
		end

		if room.HasExorcismPoint and game.IsGameStateEligible(room, room.ExorcismPointRequirements or game.ExorcismData.DefaultGameStateRequirements) then
			local exorcismPointChance = game.GetHarvestPointSpawnChance(game.ExorcismData, room)
			room.ExorcismPointSuccess = game.RandomChance(exorcismPointChance)
		end

		if room.HasFishingPoint and game.IsGameStateEligible(room, room.FishingPointRequirements or game.FishingData.DefaultGameStateRequirements) then
			local fishingPointChance = game.GetHarvestPointSpawnChance(game.FishingData, room)
			room.FishingPointSuccess = game.RandomChance(fishingPointChance)
		end

		if room.AllowOnlyOneToolHarvestableResource then
			local toolSuccesses = game.FYShuffle({ "ShovelPointSuccess", "PickaxePointSuccess", "ExorcismPointSuccess",
				"FishingPointSuccess" })
			local choseHarvestPoint = false
			for _, toolSuccess in ipairs(toolSuccesses) do
				if room[toolSuccess] then
					if choseHarvestPoint then
						room[toolSuccess] = false
					end
					choseHarvestPoint = true
				end
			end
		else
			-- Allow one simple harvest, unless both are forced
			if room.ShovelPointSuccess and room.PickaxePointSuccess and not (forceShovelPoint and forcePickaxePoint) then
				-- forced points take priority
				if forceShovelPoint then
					room.PickaxePointSuccess = false
				elseif forcePickaxePoint then
					room.ShovelPointSuccess = false
				elseif game.CoinFlip() then
					room.ShovelPointSuccess = false
				else
					room.PickaxePointSuccess = false
				end
			end

			-- Allow one complex harvest
			if room.ExorcismPointSuccess and room.FishingPointSuccess then
				if game.CoinFlip() then
					room.ExorcismPointSuccess = false
				else
					room.FishingPointSuccess = false
				end
			end
		end
	end

	return room
end)
