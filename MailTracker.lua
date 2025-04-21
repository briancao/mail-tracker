print("Hello World!123")

local addonName, addonTable = ...

-- Initialize the saved variables table
MailTrackerData = MailTrackerData or {}

-- Event handler frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("MAIL_INBOX_UPDATE")
frame:RegisterEvent("PLAYER_LOGOUT")

a = {}

local function HasValue(array, value)
    for index, value in array do
        if value == val then
            return true
        end
    end

    return false
end

-- Function to process mail
local function ProcessMail()
    print("process mail start: ", GetServerTime())w
    -- Check all mail in the inbox
    for i = 1, GetInboxNumItems() do
        local sender, subject, money, codAmount, daysLeft, hasItem, wasRead = select(3, GetInboxHeaderInfo(i))
        print("2: GetInboxHeaderInfo", GetInboxHeaderInfo(i))
        print("sender", sender, "daysLeft", daysLeft, "subject", subject, "money", money, "hasItem", hasItem, "wasRead", wasRead)
        
        if wasRead then 
            MailTrackerData[sender] = MailTrackerData[sender] or {}
            print("test2")
            for j = 1, 12 do
                local itemLink = GetInboxItemLink(i, j)

                if itemLink then
                    print("3 :itemLink: ", itemLink)
                    print("3.1: GetInboxItem:", GetInboxItem(i, j))
                    local itemName, _, itemQuality, itemLevel, _, itemType, itemSubType, _, _, itemIcon = GetItemInfo(itemLink)

                    print("4: GetItemInfo(itemLink): ", GetItemInfo(itemLink))

                    table.insert(MailTrackerData[sender], {
                        subject = subject,
                        itemLink = itemLink,
                        itemName = itemName,
                        itemQuality = itemQuality,
                        itemLevel = itemLevel,
                        itemType = itemType,
                        itemSubType = itemSubType,
                        itemIcon = itemIcon,
                    })
                end
            end
        end

    end
end

-- Function to save the data as JSON
local function SaveDataAsJSON()
    print("Saving")
    if not MailTrackerData or next(MailTrackerData) == nil then return end

    local jsonData = "{\n"
    for sender, items in pairs(MailTrackerData) do
        jsonData = jsonData .. string.format('    "%s": [\n', sender)
        for _, item in ipairs(items) do
            local formaattedMailData = string.format('        {"subject": %q, "itemLink": %q, "itemName": %q, "itemQuality": %d, "itemLevel": %d, "itemType": %q, "itemSubType": %q, "itemIcon": %q},\n',
            item.subject, item.itemLink, item.itemName, item.itemQuality, item.itemLevel, item.itemType, item.itemSubType, item.itemIcon)
            print("formaattedMailData")

            jsonData = jsonData .. string.format('        {"subject": %q, "itemLink": %q, "itemName": %q, "itemQuality": %d, "itemLevel": %d, "itemType": %q, "itemSubType": %q, "itemIcon": %q},\n',
            item.subject, item.itemLink, item.itemName, item.itemQuality, item.itemLevel, item.itemType, item.itemSubType, item.itemIcon)
        end
        jsonData = jsonData .. "    ],\n"
    end
    jsonData = jsonData .. "}\n"

    -- Write the JSON data to the SavedVariables file (WoW handles this automatically)
    MailTrackerData.json = jsonData
end

-- Event handler
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "MAIL_INBOX_UPDATE" then
        ProcessMail()
    elseif event == "PLAYER_LOGOUT" then
        SaveDataAsJSON()
    end
end)
