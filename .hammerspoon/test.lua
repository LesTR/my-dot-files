
Install:andUse("ModalMgr")

----------------------------------------------------------------------------------------------------
-- Then we create/register all kinds of modal keybindings environments.
----------------------------------------------------------------------------------------------------
-- Register windowHints (Register a keybinding which is NOT modal environment with modal supervisor)
hswhints_keys = {"alt", "tab"}
debuglog("loaded")
if string.len(hswhints_keys[2]) > 0 then
	debuglog("loadedi 2")
    spoon.ModalMgr.supervisor:bind(hswhints_keys[1], hswhints_keys[2], 'Show Window Hints', function()
		debuglog("Show windowHints")
        spoon.ModalMgr:deactivateAll()
        hs.hints.windowHints()
    end)
end
