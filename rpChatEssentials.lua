Methods = {}

local enableLocalChat = true
local enableNickNames = true

local localChatCellRadius = 1 -- 0 means only the players in the same cell can hear eachother

local globalChatHeader = "[OOC] "
local globalChatHeaderColor = color.Gray

local localOOCChatHeader = "[LOOC] "
local localOOCChatHeaderColor = color.Gray

local actionMsgSymbol = "*"
local actionMsgColor = color.DarkGray

local nickNames = {}
local nickNameColor = color.Cyan
local nickNameMinCharLength = 3
local nickNameMaxCharLength = 15


--[[

In server.lua add [ chatEss = require("rpChatEssentials") ] to the top

In server.lua search for "return false -- commands should be hidden" and highlight the "else" all the way to the "return true"
replace it with

		elseif cmd[1] == "me" then
			chatEss.SendActionMsg(pid, message)
		elseif cmd[1] == "nick" then
			chatEss.SetNickName(pid, message)
		elseif cmd[1] == "/" then
			chatEss.SendGlobalMessage(pid, message)
		elseif cmd[1] == "//" then
			chatEss.SendLocalOOCMessage(pid, message)
        else
            local message = "Not a valid command. Type /help for more info.\n"
            tes3mp.SendMessage(pid, color.Error..message..color.Default, false)
        end

        return false -- commands should be hidden
    end
	
	chatEss.SendLocalMessage(pid, message, true)
	
    return false -- hide default chat and replace it with chat essentials.


--]]


Methods.SendLocalMessage = function(pid, message, useName)
	local playerName = Players[pid].name
	
	-- Get top left cell from our cell
	local myCellDescription = Players[pid].data.location.cell
	
	if tes3mp.IsInExterior(pid) == true then
		local cellX = tonumber(string.sub(myCellDescription, 1, string.find(myCellDescription, ",") - 1))
		local cellY = tonumber(string.sub(myCellDescription, string.find(myCellDescription, ",") + 2))
		
		local firstCellX = cellX - localChatCellRadius
		local firstCellY = cellY + localChatCellRadius
		
		local length = localChatCellRadius * 2
		
		for x = 0, length, 1 do
			for y = 0, length, 1 do
				-- loop through all y inside of x
				local tempCell = (x+firstCellX)..", "..(firstCellY-y)
				-- send message to each player in cell
				if LoadedCells[tempCell] ~= nil then
					if useName == true then
						if nickNames[playerName] ~= nil and enableNickNames == true then
							SendMessageToAllInCell(tempCell, nickNameColor..nickNames[playerName]..color.Default..": "..message.."\n")
						else
							SendMessageToAllInCell(tempCell, playerName..": "..message.."\n")
						end
					else
						SendMessageToAllInCell(tempCell, message.."\n")
					end
				end
			end
		end
	else
		if useName == true then
			if nickNames[playerName] ~= nil and enableNickNames == true then
				SendMessageToAllInCell(myCellDescription, nickNameColor..nickNames[playerName]..color.Default..": "..message.."\n")
			else
				SendMessageToAllInCell(myCellDescription, playerName..": "..message.."\n")
			end
		else
			SendMessageToAllInCell(myCellDescription, message.."\n")
		end
	end
end

Methods.SendLocalOOCMessage = function(pid, message)
	if enableLocalChat == true then
		message = string.sub(message, 4)
		local msg = localOOCChatHeaderColor..localOOCChatHeader..color.Default..Players[pid].name.." ("..pid.."):"..message
		Methods.SendLocalMessage(pid, msg, false)
	else
		tes3mp.SendMessage(pid, "You cannot send a local OOC with local chat disabled.\n")
	end
end

function SendMessageToAllInCell(cellDescription, message)
	for index,pid in pairs(LoadedCells[cellDescription].visitors) do
		if Players[pid].data.location.cell == cellDescription then
			tes3mp.SendMessage(pid, message, false)
		end
	end
end

Methods.SendGlobalMessage = function(pid, message)
	if message:len() > 3 then
		message = string.sub(message, 3)
		tes3mp.SendMessage(pid, globalChatHeaderColor..globalChatHeader..color.Default..Players[pid].name.." ("..pid.."):"..message.."\n", true)
	else
		tes3mp.SendMessage(pid, "Your message cannot be empty.\n", false)
	end
end

Methods.OnPlayerSendMessage = function(pid, message)
	if enableLocalChat == true then
		Methods.SendLocalMessage(pid, message, true)
	else
		if nickNames[playerName] ~= nil and enableNickNames == true then
			tes3mp.SendMessage(pid, nickNameColor..nickNames[playerName]..color.Default..": "..message.."\n", true)
		else
			tes3mp.SendMessage(pid, playerName..": "..message.."\n", true)
		end
	end
end

Methods.SendActionMsg = function(pid, message)
	local msg
	if message:len() > 4 then
		if nickNames[Players[pid].name] ~= nil and enableNickNames == true then
			msg = actionMsgColor..actionMsgSymbol..nickNames[Players[pid].name]..string.sub(message, 4)..actionMsgSymbol..color.Default
		else
			msg = actionMsgColor..actionMsgSymbol..Players[pid].name..string.sub(message, 4)..actionMsgSymbol..color.Default
		end
			
		if enableLocalChat == true then
			Methods.SendLocalMessage(pid, msg, false)
		else 
			tes3mp.SendMessage(pid, msg.."\n", true)
		end
	else
		tes3mp.SendMessage(pid, "Your message cannot be empty.\n", false)
	end
end

Methods.SetNickName = function(pid, name)
	if enableNickNames == true then
		if name ~= nil then
			name = string.sub(name, 7)
			if name:len() >= nickNameMinCharLength and name:len() <= nickNameMaxCharLength then
				nickNames[Players[pid].name] = name
				tes3mp.SendMessage(pid, "Your nickname has been set to: "..name.."\n", false)
			else
				nickNames[Players[pid].name] = nil
				tes3mp.SendMessage(pid, "Your nickname has been reset.\n(Nicknames must be "..nickNameMinCharLength.."-"..nickNameMaxCharLength.." characters long)\n", false)
			end
		end
	else
		tes3mp.SendMessage(pid, "Nicknames are not enabled on this server.\n", false)
	end
end

Methods.IsLocalChatEnabled = function()
	return enableLocalChat
end

return Methods