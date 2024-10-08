local ColumKey = "pvp"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 10,
    ["template"] = "GreatVaultListTableCellTripleTextTemplate",
    ["width"] = 250,
    ["padding"] = 0, 
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 40, canSort = false},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ['emptyStr'] = {
        "   0/1250",
        "   0/2500",
        "   0/5000"
    },
    ["demo"] = function(idx)

        local obj = {}

        local progress = math.random(5000)
        local threshold = {1250, 2500, 5000}

        for i = 1, 3, 1 do
            
            table.insert(obj, {
                progress = progress,
                threshold = threshold[i],
                level = math.random(9)
            })
        end
        return obj
    end,
    event = {
        {"WEEKLY_REWARDS_UPDATE", "WEEKLY_REWARDS_ITEM_CHANGED"},
        function(self)
            GreatVaultList.Data:store(ColumKey, true)
            if GreatVaultListFrame:IsShown() then  -- refresh view if window is open
                GreatVaultListFrame:RefreshScrollFrame()
            end
        end
    },
    ["store"] = function(characterInfo)
        characterInfo.pvp = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.RankedPvP)
        _.map(characterInfo.pvp, function(entry)
            entry["raidString"] = nil
            return entry
        end)
        return characterInfo
    end,
    ["populate"] = function(self, data, idx)
        if type(data) ~= "table" then return nil end
        local activity = _.get(data, {idx}, {} )
        local text = nil -- set default
        
        if not activity.progress then return nil end
        if not activity.threshold then return nil end
        
        if activity.progress >= activity.threshold then
            text = PVPUtil.GetTierName(activity.level)
        elseif activity.progress > 0 then
            text = GRAY_FONT_COLOR:WrapTextInColorCode(activity.progress .. "/" .. activity.threshold)
        end

        return text
    end
}