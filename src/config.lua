local config = {
  enabled = true;
  resourcesInAllTrials = false;
  dreamDives = true;
}

local configDesc = {
  enabled = "Whether the mod is enabled or not. Will allow resource spawns in randomized Chaos Trials.";
  resourcesInAllTrials = "If enabled, resources will spawn in all Chaos Trials, not just randomized ones.";
  dreamDives = "If enabled, resources will also spawn in Dream Dives.";
}

return config, configDesc
