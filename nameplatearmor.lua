local armors = {
  none = {"x", "#FFFFFF"},
  netherite = {"N", "#4C4143"},
  elytra = {"E", "#8F8FB3"},
  diamond = {"D", "#4AEDD9"},
  golden = {"G", "#FAD64A"},
  iron = {"I", "#A8A8A8"},
  chainmail = {"C", "#969696"},
  leather = {"L", "#D76B43"},
  turtle = {"T", "#47BF4a"}
}
local slotStr = [=[[{"text": "%s", "color": "%s", "bold": "%s"}]]=]
local formatStr = [=[["%s (",%s,%s,%s,%s,")"]]=]

local currentArmor = { nil, nil, {}, {}, {}, {} }

return function()
  if not player:exists() then return end
  currentArmor[1] = player:getName()
  local shouldUpdate = false
  for i=3,6 do
      local item = player:getItem(i)
      item = item and item.id or ":none"
      local slot = currentArmor[i]
      if item ~= slot[1] then
        shouldUpdate = true
        slot[1] = item
        local v = armors[item:match("[^:]*:?([^_]*)")]
        slot[2] = slotStr:format(v[1], v[2], false)
      end
  end
  if shouldUpdate then
    nameplate.ENTITY:setText(formatStr:format(
      currentArmor[1],
      currentArmor[6][2], currentArmor[5][2], currentArmor[4][2], currentArmor[3][2]
    ))
  end
end
