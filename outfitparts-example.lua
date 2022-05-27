-- outfitparts v2 example usage by shardion
-- you should play crosscode btw

-- if this exists and is set to true, then all outfitparts and their blockbench
-- groups will be disabled upon creation
-- if this does not exist or is set to false, then all outfitparts and their
-- blockbench groups will be enabled, even parts that otherwise conflict(!)
settingsDisableByDefault = true

-- load the outfitparts library (sold separately :P) from outfitparts.lua
--
-- ensure your avatar.json's `autoScripts` is set to only include your script
-- (and not outfitparts), otherwise weird stuff MIGHT happen
-- if you can't add any parts, that's the cause
outfitparts = require('outfitparts')

-- disables the vanilla model
-- not really outfitparts code but useful to keep here
-- comment this out if you use the vanilla model as a base and don't want
-- to disable it
vanilla_model.PLAYER:setVisible(false)

-- create an outfitpart
--
-- name can be any string
--
-- bbgroup must be a blockbench model part (groups work too!)
--
-- conflicts can be any string (but for it to do anything, there must be
-- another part with the exact same conflicts string)
--
-- if default is true, then when all parts which have this same
-- conflicts string are disabled, then this part will be enabled
partExampleShirt = outfitparts.createPart({ name = 'Example Shirt', bbgroup = models.your_model.example_shirt, conflicts = 'Body', default = false })

-- notice how bbgroup is just the path to a blockbench group. this means you
-- can turn anything you can make in blockbench into an outfit part(!)
--
-- if you just want to add clothes to a vanilla-style avatar, you can make a
-- "base model" without the clothes, add the clothes in separate groups,
-- give them an extremely tiny inflate value (0.001 for legs, 0.002 for body,
-- etc, changing that to 0.251/252 for layers) to prevent z-fighting,
-- and add them here as outfit parts
partExampleSweater = outfitparts.createPart({ name = 'Example Sweater', bbgroup = models.your_model.example_sweater, conflicts = 'Body', default = false })
partExampleJacket = outfitparts.createPart({ name = 'Example Jacket', bbgroup = models.your_model.example_jacket, conflicts = 'Body', default = false })

partExamplePants = outfitparts.createPart({ name = 'Example Pants', bbgroup = models.your_model.example_pants, conflicts = 'Legs', default = false })
partExampleShorts = outfitparts.createPart({ name = 'Example Shorts', bbgroup = models.your_model.example_pants, conflicts = 'Legs', default = false })

partExampleShoes = outfitparts.createPart({ name = 'Example Shoes', bbgroup = models.your_model.example_shoes, conflicts = 'Feet', default = false })

-- you can set conflicts to nil if you don't want the cosmetic to conflict with anything
-- good for small cosmetics like sunglasses or shoulder birds
partExampleShoulderBird = outfitparts.createPart({ name = 'Example Shoulder Bird', bbgroup = models.your_model.example_shoulder_bird, conflicts = nil, default = false })

-- create an outfit
-- name can be any string
-- parts must be a table containing all the parts in the outfit
outfitCool = outfitparts.createOutfit({ name = 'Cool', parts = { partExampleSweater, partPants, partShoes }})
outfitCooler = outfitparts.createOutfit({ name = 'Cooler', parts = { partExampleJacket, partPants, partShoes }})

-- sets your current outfit to Cool
-- as this is in init, in effect this creates a default outfit
outfitparts.setOutfit(outfitCool)

-- enables example shorts, disabling any parts that conflict with it automatically
outfitparts.setPart(partExampleShorts, true)

-- you can drop the true/false, in which case it will toggle the part instead
-- enables example shirt, because it's disabled at the time we call this
outfitparts.setPart(patExampleShirt)

-- create an outfit cycle keybind
-- lets you cycle between the specified outfits by pressing the keybind
mainOutfitCycle = createOutfitCycleKeybind({ outfitCool, outfitCooler })
-- you can make multiple
altOutfitCycle = createOutfitCycleKeybind({ outfitCooler, outfitCooler, outfitCool, outfitCool })

-- then you can apply them to keybinds like this
--
-- keybind name can be any string
--
-- key must be a valid key (key.keyoard.l, key.keyboard.r, ...)
--
-- change false to true if you want the keybind to work while in a GUI, like your inventory
-- note: this will not work in rewrite pre-2.1 or below
keybind:create('your keybind name here (shown in keybinds ui)', 'key.keyboard.g', false).onPress = mainOutfitCycle
keybind:create('your keybind name here: the sequel', 'key.keyboard.h', false).onPress = altOutfitCycle

-- you can also use /figura run to enable/disable parts, and set outfits
-- /figura run outfitparts.setOutfit(outfitVariable)
-- /figura run outfitparts.setPart(outfitPartVariable, true/false)
--
-- unfortunately, there's no better way of enabling/disabling outfitparts,
-- due to no action wheel in the figura rewrite
-- if you have very few outfitparts, you could try using a keybind for each:
-- keybind:create('your keybind name here: revengeance', 'key.keyboard.k', false).onPress = outfitparts.setPart(partExampleShirt)
