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
    ---
    -- Called if the @{MINIGAME} activates
    -- @hook
    -- @realm shared
    function MINIGAME:OnActivation()
        -- Disable DTTT mute logic
        hook.Add("DTTTPreMuteLogic", "DTTTSilenceMG", function()
            return true
        end)

        print("[DTTT-Silence] Muting all players")

        -- Mute in Discord
        hook.Run("DTTTMuteAll", 0) -- duration: 0

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

            LANG.Msg(ply, "dttt_minigame_chat_jammed", nil, MSG_CHAT_WARN)

            return false
        end)

        -- Disable team chat
        hook.Add("TTT2AvoidTeamChat", "DTTSilenceMG", function(sender, team, msg)
            if not IsValid(sender) or team == TEAM_SPECTATOR then return end

            LANG.Msg(sender, "dttt_minigame_chat_jammed", nil, MSG_CHAT_WARN)

            return false
        end)

    end

    ---
    -- Called if the @{MINIGAME} deactivates
    -- @hook
    -- @realm shared
    function MINIGAME:OnDeactivation()
        print("[DTTT-Silence] Unmuting all players")
        hook.Run("DTTTUnmuteAll", 0) -- duration: forever

        hook.Remove("TTTPlayerRadioCommand", "DTTTSilenceMG")
        hook.Remove("TTT2CanUseVoiceChat", "DTTTSilenceMG")
        hook.Remove("TTT2AvoidGeneralChat", "DTTTSilenceMG")
        hook.Remove("TTT2AvoidTeamChat", "DTTSilenceMG")
        hook.Remove("DTTTPreMuteLogic", "DTTTSilenceMG")
    end
end