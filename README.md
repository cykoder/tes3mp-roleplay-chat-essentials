# Install Guide

**1.)** This script requires **msgScriptEssentials** install from https://github.com/David-AW/tes3mp-chat-script-essentials


**2.)** Go into **/mp-stuff/data/** and open **scripts.json**


**3.)** Put ```"rpChatEssentials":[true,true,true]``` as the *first* script at the top

**Example:**
```
{
  "rpChatEssentials":[true,true,true]
  "foo":[true,false,false]
  "bar":[false,true,false]
  "zulu":[true,true,false]
}
```


**4.)** While in **/mp-stuff/data/**, create a folder named **style**


**5.)** Inside the newly created folder "**/mp-stuff/data/style/**", create a folder named **players**


**6.)** Drop **rpChatEssentials.lua** into **/mp-stuff/scripts/**


**7.)** While in **/mp-stuff/scripts/** open **server.lua**


**8.)** CTRL+F and find **OnPlayerConnect** and put ```msgScript.GetScript("rpChatEssentials").OnPlayerConnect(pid)``` *underneath* ```myMod.OnPlayerConnect(pid, playerName)```

**9.)** CTRL+F and find **OnPlayerDisconnect** and put ```msgScript.GetScript("rpChatEssentials").OnPlayerDisconnect(pid)``` *underneath* ```myMod.OnPlayerDisconnect(pid)```
