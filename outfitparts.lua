-- outfit parts v2, for the figs rerat, by shardion
-- did i mention you should play crosscode
--
-- outfitparts, implemented in fp, without:
-- action wheel code (no action wheel)
-- syncing code (no backend)
local outfitparts = {
  parts = {{}, {}},
  outfits = {}
}

function outfitparts.forceSetPart(partToSet, setTo)
  for i, part in pairs(outfitparts.parts[1]) do
    if part == partToSet then
      outfitparts.parts[2][part] = setTo
      part.bbgroup:setVisible(setTo)
    end
  end
end

-- logic spaghetti
-- why can't lua just have half normal syntax
function outfitparts.setPart(partToSet, setTo)
  -- handles part toggling
  setTo = setTo or not outfitparts.parts[2][partToSet]
  if setTo == nil then setTo = true end

  for i, part in pairs(outfitparts.parts[1]) do
    if part.conflicts == partToSet.conflicts and outfitparts.parts[2][part] then
      if setTo then
        outfitparts.forceSetPart(part, false)
      end
    end
    if part == partToSet then
      outfitparts.forceSetPart(part, setTo)
    end
  end

  if setTo == false and partToSet.conflicts ~= nil then
    local areAllPartsDisabled = true
    for i, part in pairs(outfitparts.parts[1]) do
      if part.conflicts == partToSet.conflicts and outfitparts.parts[2][part] then
        areAllPartsDisabled = false
      end
    end

    if areAllPartsDisabled then
      for i, part in pairs(outfitparts.parts[1]) do
        if part.default and part.conflicts == partToSet.conflicts then
          outfitparts.setPart(part, true)
        end
      end
    end
  end
end

function outfitparts.createPart(part)
  table.insert(outfitparts.parts[1], part)
  outfitparts.parts[2][part] = not settingsDisableByDefault
  part.bbgroup:setVisible(not settingsDisableByDefault)
  return part
end


function outfitparts.setOutfit(outfit)
  for _, part in pairs(outfitparts.parts[1]) do
    outfitparts.forceSetPart(part, false)
  end
  for _, part in pairs(outfit.parts) do
    outfitparts.forceSetPart(part, true)
  end
end

function outfitparts.createOutfit(partTable)
  table.insert(outfitparts.outfits, partTable)
  return partTable
end

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
