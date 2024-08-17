local ColumKey = "raid"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

local DIFFICULTY_NAMES = {
	[DifficultyUtil.ID.Raid10Normal] = "NHC",
	[DifficultyUtil.ID.Raid25Normal] = "NHC",
	[DifficultyUtil.ID.Raid10Heroic] = "HC",
	[DifficultyUtil.ID.Raid25Heroic] = "HC",
	[DifficultyUtil.ID.RaidLFR] = "LFR",
	[DifficultyUtil.ID.PrimaryRaidNormal] = "NHC",
	[DifficultyUtil.ID.PrimaryRaidHeroic] = "HC",
	[DifficultyUtil.ID.PrimaryRaidMythic] = "MTH",
	[DifficultyUtil.ID.PrimaryRaidLFR] = "LFR",
}


Column.key = ColumKey
Column.config = {
    ["index"] = 4,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 40, canSort = false, dataType = "string", order = "DESC", offset = 20, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = "averageItemLevel",
    },
    ['emptyStr'] = {
        "0/2",
        "0/4",
        "0/6"
    },
    event = {
        {"WEEKLY_REWARDS_UPDATE", "WEEKLY_REWARDS_ITEM_CHANGED"},
        function(self)
            self.config.store(GreatVaultAddon.data:get())
            if GreatVaultInfoFrame:IsShown() then  -- refresh view if window is open
                GreatVaultAddon.ScrollFrame.ScollFrame:Refresh()
            end
        end
    },
    ["store"] = function(characterInfo)
        characterInfo.raid = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Raid)
        return characterInfo
    end,
    ["refresh"] = function(line, data, idx)
       local activity = _.get(data, {ColumKey, idx})

        if activity.progress >= activity.threshold then
            if activity.type == Enum.WeeklyRewardChestThresholdType.Raid then
                line[ColumKey .. idx].text  = GREEN_FONT_COLOR_CODE .. DIFFICULTY_NAMES[activity.level] .. FONT_COLOR_CODE_CLOSE
                return line
            end
        end

        if activity.progress > 0 then
            if activity.type == Enum.WeeklyRewardChestThresholdType.Raid then
                line[ColumKey .. idx].text  = activity.progress .. "/" .. activity.threshold
                return line
            end
        end

        line[ColumKey .. idx].text  = nil
        return line
    end
}