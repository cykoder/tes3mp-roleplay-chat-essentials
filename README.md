# Install Guide

**1.)** In **server.lua** add ```chatEss = require("rpChatEssentials")``` *near the top* **and** *under* ```myMod = require("myMod")```


**2.)** CTRL+F and find ```return false -- commands should be hidden``` then replace:

```
        else
            local message = "Not a valid command. Type /help for more info.\n"
            tes3mp.SendMessage(pid, color.Error..message..color.Default, false)
        end

        return false -- commands should be hidden
    end

    return true -- default behavior, chat messages should not
```

**with:**

```
		elseif cmd[1] == "me" then
			chatEss.SendActionMsg(pid, message)
		elseif cmd[1] == "nick" then
			chatEss.SetNickName(pid, message)
		elseif cmd[1] == "/" then
			message = string.sub(message, 3)
			chatEss.SendGlobalMessage(pid, message)
		elseif cmd[1] == "//" then
			message = string.sub(message, 4)
			chatEss.SendLocalOOCMessage(pid, message)
        else
            local message = "Not a valid command. Type /help for more info.\n"
            tes3mp.SendMessage(pid, color.Error..message..color.Default, false)
        end
        return false -- commands should be hidden
    end
	
	chatEss.SendLocalMessage(pid, message, true)
	
  return false -- hide default chat and replace it with chat essentials.
```
