if SERVER then
    AddCSLuaFile()
end

MINIGAME.author = "vertiKarl" -- author
MINIGAME.contact = "https://github.com/vertiKarl" -- contact to the author
if CLIENT then
    MINIGAME.lang = {
        name = {
            de = "Schweigsame Stille",
            en = "Silent Silence"
        },
        desc = {
            de = "Versuche ohne verbale Kommunikation zu gewinnen!",
            en = "Try to win without verbal communication!"
        }
    }



    function MINIGAME:OnActivation()
        -- disable radio commands
        hook.Add("TTT2ClientRadioCommand", "DTTTSilenceMG", function()
            return true
        end)

        -- disable voice chat ui
        hook.Add("TTT2CanUseVoiceChat", "DTTTSilenceMG", function(ply, isTeam)
            return false
        end)
    end

    function MINIGAME:OnDeactivation()
        hook.Remove("TTT2ClientRadioCommand", "DTTTSilenceMG")
        hook.Remove("TTT2CanUseVoiceChat", "DTTTSilenceMG")
    end
end

if SERVER then
    local muteLogic
    local moveLogic
    ---
    -- Called if the @{MINIGAME} activates
    -- @hook
    -- @realm shared
    function MINIGAME:OnActivation()
        -- TODO: add Hook to disable logic
        muteLogic = pcall(GetConVar("dttt_enable_internal_mute_logic"):GetBool())
        moveLogic = pcall(GetConVar("dttt_enable_internal_move_logic"):GetBool())
        if muteLogic then
            RunConsoleCommand("dttt_enable_internal_mute_logic 0")
        end
        if moveLogic then
            RunConsoleCommand("dttt_enable_internal_move_logic 0")
        end
        print("[DTTT-Silence] Muting all players")

        -- Mute in Discord
        hook.Run("DTTTMuteAllPlayers")

        -- Disable radio commands server side
        hook.Add("TTTPlayerRadioCommand", "DTTTSilenceMG", function()
            return true
        end)

        -- Disable ingame voice chat
        hook.Add("TTT2CanUseVoiceChat", "DTTTSilenceMG", function(ply, isTeam)
            return false
        end)

        -- Disable text chat
        hook.Add("TTT2AvoidGeneralChat", "DTTTSilenceMG", function(ply, text)
            if not IsValid(ply) then return end

            LANG.Msg(ply, "dttt_silence_minigame_chat_jammed", nil, MSG_CHAT_WARN)

            return false
        end)

    end

    ---
    -- Called if the @{MINIGAME} deactivates
    -- @hook
    -- @realm shared
    function MINIGAME:OnDeactivation()
        print("[DTTT-Silence] Muting all players")
        -- TODO: add Hook to reenable logic, is that even needed?
        hook.Run("DTTTUnmuteAllPlayers")
        if muteLogic then
            RunConsoleCommand("dttt_enable_internal_mute_logic 1")
        end
        if moveLogic then
            RunConsoleCommand("dttt_enable_internal_move_logic 1")
        end
        print("[DTTT-Silence] Muting all players")

        hook.Remove("TTTPlayerRadioCommand", "DTTTSilenceMG")
        hook.Remove("TTT2CanUseVoiceChat", "DTTTSilenceMG")
        hook.Remove("TTT2AvoidGeneralChat", "DTTTSilenceMG")
    end
end