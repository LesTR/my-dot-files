-----------------------------------------------
-- Showmousepointer.lua
-----------------------------------------------

Install:andUse("MouseCircle")

-- 'red' is the default color
spoon.MouseCircle.color = hs.drawing.color.hammerspoon.green

spoon.MouseCircle:bindHotkeys({
  show = { "ctrl" , "m" }
})
