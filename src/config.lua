local config = {
  enabled = true;
  resourcesInAllTrials = false;
}

local configDesc = {
  enabled = "Whether the mod is enabled or not. Will allow resource spawns in randomized Chaos Trials.";
  resourcesInAllTrials = "If enabled, resources will spawn in all Chaos Trials, not just randomized ones.";
}

return config, configDesc
