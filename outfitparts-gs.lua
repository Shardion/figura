---@class OutfitPart
---@field conflicts? string #A string that describes how this part should conflict with others.
---@field bbgroup userdata #The group this outfit part represents.

---@alias Outfit OutfitPart[]

---A fake bb group.  
---This *only* contains the function(s) used by the OutfitParts script.
local FakeBBGroup = {setVisible = function() end}

-- outfit parts v2, for the figs rerat, by shardion (Modified by Grandpa Scout)  
-- did i mention you should play crosscode
--
-- outfitparts, implemented in fp, without:  
-- action wheel code (no action wheel)  
-- syncing code (no backend)
local outfitparts = {
  ---@type {[table]: boolean}
  parts = {},
  outfits = {}
}

---Actually sets the state of a part. ~GS
---@param partToSet table
---@param setTo? boolean
function outfitparts.forceSetPart(partToSet, setTo)
  outfitparts.parts[partToSet] = setTo
  partToSet.bbgroup:setVisible(setTo)
end

---Sets the state of a part and also checks for conflicts/defaults. ~GS
---@param partToSet table
---@param setTo? boolean
function outfitparts.setPart(partToSet, setTo)
  local PARTS = outfitparts.parts
  --Make `setTo` a toggle of the current state if `nil` is passed.
  if setTo == nil then setTo = not PARTS[partToSet] end

  --If the part does not conflict, then there is no reason to check for any other parts.
  if not partToSet.conflicts then
    outfitparts.forceSetPart(partToSet, setTo)
    return --RETURN EARLY
  end

  --If the part is being enabled, we should probably check for parts to be disabled.
  --Otherwise, it cannot possibly conflict, we should check for the default instead.
  if setTo then
    --Loop through all parts to find and disable conflicting parts.
    for part, partState in pairs(PARTS) do
      if (part.conflicts == partToSet.conflicts) and partState then
        outfitparts.forceSetPart(part, false)
      end
    end
    outfitparts.forceSetPart(partToSet, true) --Enable main part.
  else
    local areAllPartsDisabled = true
    local defaultPart = nil
    --Loop through all parts to determine the default part and the state of all conflicting parts.
    for part, partState in pairs(PARTS) do
      if (part.conflicts == partToSet.conflicts) and partState then
        areAllPartsDisabled = false
        if part.default then defaultPart = part end
      end
    end

    --If all conflicting parts are disabled and a defaut part was found, enable it.
    if areAllPartsDisabled and defaultPart then
      outfitparts.forceSetPart(partToSet, true)
    end
  end
end

---Creates a new part. ~GS
---@generic table : OutfitPart
---@param part? table
---@param state? boolean
---@return table|OutfitPart
function outfitparts.createPart(part, state)
  part = part or {
    conflicts = nil,
    bbgroup = FakeBBGroup
  }
  if state == nil then state = not settingsDisableByDefault end

  --Call setPart to run through the usual logic when created.
  outfitparts.setPart(part, state)
  return part
end

---Sets an outfit by disabling all other parts and only enabling the parts in the outfit. ~GS
---@param outfit OutfitPart[]
function outfitparts.setOutfit(outfit)
  for part, state in pairs(outfitparts.parts) do
    if state then outfitparts.forceSetPart(part, false) end
  end
  for _, part in pairs(outfit.parts) do
    outfitparts.forceSetPart(part, true)
  end
end

---Creates an outfit for use later. ~GS
---@generic tableArray : OutfitPart[]
---@param partTable tableArray
---@return tableArray
function outfitparts.createOutfit(partTable)
  table.insert(outfitparts.outfits, partTable)
  return partTable
end

---Creates a function that cycles through the list of outfits given. ~GS
---@param outfits Outfit[]
---@return function
function outfitparts.createOutfitCycleKeybind(outfits)
  local outfitsWithIndex = { nextOutfit = 1, outfits = outfits }
  return function()
    outfitparts.setOutfit(outfitsWithIndex.outfits[outfitsWithIndex.nextOutfit])
    outfitsWithIndex.nextOutfit = outfitsWithIndex.nextOutfit + 1
    if outfitsWithIndex.nextOutfit > #outfitsWithIndex.outfits then
      outfitsWithIndex.nextOutfit = 1
    end
  end
end

return outfitparts
