--------------------Key binding--------------------------------------------------------
BINDING_HEADER_LSAMM = "LightSpell's Advanced Marker: Marks Over Mouse"
BINDING_HEADER_LSAMF = "LightSpell's Advanced Marker: Flares"
BINDING_NAME_LSAMSTAR = "Yellow Star Mark"
BINDING_NAME_LSAMCOOKIE = "Orange Cookie Mark"
BINDING_NAME_LSAMRHOMB = "Purple Rhomb Mark"
BINDING_NAME_LSAMSTRING = "Green String Mark"
BINDING_NAME_LSAMMOON = "Silver Moon Mark"
BINDING_NAME_LSAMSQUARE = "Blue Square Mark"
BINDING_NAME_LSAMCROSS = "Red Cross Mark"
BINDING_NAME_LSAMSKULL = "White Skull Mark"
BINDING_NAME_LSAMCLEAR = "Clear Mark"

_G["BINDING_NAME_CLICK LSAM_FlareButtons1:LeftButton"] = "Blue Square Flare"
_G["BINDING_NAME_CLICK LSAM_FlareButtons2:LeftButton"] = "Green String Flare"
_G["BINDING_NAME_CLICK LSAM_FlareButtons3:LeftButton"] = "Purple Rhomb Flare"
_G["BINDING_NAME_CLICK LSAM_FlareButtons4:LeftButton"] = "Red Cross Flare"
_G["BINDING_NAME_CLICK LSAM_FlareButtons5:LeftButton"] = "Yellow Star Flare"
_G["BINDING_NAME_CLICK LSAM_FlareButtons6:LeftButton"] = "Orange Cookie Flare"
_G["BINDING_NAME_CLICK LSAM_FlareButtons7:LeftButton"] = "Silver Moon Flare"
_G["BINDING_NAME_CLICK LSAM_FlareButtons8:LeftButton"] = "White Skull Flare"
_G["BINDING_NAME_CLICK LSAM_ClearAllButton:LeftButton"] = "Clear All Flares"

--------------------Initialization (1 stage)-------------------------------------------
local LSAM_MainFrame = CreateFrame("Frame", "LSAM_MainFrame", UIParent)
local LSAM_MainFrameTexture = nil
local LSAM_Anchor = nil
local LSAM_Options = {}
LSAM_MainFrame:Hide()
LSAM_MainFrame:RegisterEvent("ADDON_LOADED")

--------------------Utility functions--------------------------------------------------

function LSAM_MainFrame:CopyOptions()
	if not LSAM_CharacterOptions then
		LSAM_CharacterOptions = {}
		for k, v in pairs(LSAM_GlobalOptions) do
			LSAM_CharacterOptions[k] = v
		end
	end
end

function LSAM_MainFrame:ShowBack()
	if LSAM_MainFrameTexture == nil then
		LSAM_MainFrameTexture = LSAM_MainFrame:CreateTexture()
		LSAM_MainFrameTexture:SetAllPoints(LSAM_MainFrame)
		LSAM_MainFrameTexture:SetColorTexture(0, 0, 0, LSAM_Options["BackAlpha"])
		LSAM_MainFrameTexture:Show()
	else
		LSAM_MainFrameTexture:Show()
	end
end

function LSAM_MainFrame:ShowAnchor()
	if LSAM_Anchor == nil then
		LSAM_Anchor = CreateFrame("Frame", "LSAM_Anchor", LSAM_MainFrame)
		LSAM_Anchor:SetWidth(64)
		LSAM_Anchor:SetHeight(32)
		LSAM_Anchor:SetPoint("BOTTOMLEFT", LSAM_MainFrame, "TOPLEFT", 0, 0)
		local LSAM_AnchorTexture = LSAM_Anchor:CreateTexture(nil, "BORDER")
		LSAM_AnchorTexture:SetTexture(130942)
		LSAM_AnchorTexture:SetAllPoints(LSAM_Anchor)
		LSAM_Anchor:SetMovable(true)
		LSAM_Anchor:EnableMouse(true)
		LSAM_Anchor:RegisterForDrag("LeftButton")
		LSAM_Anchor:SetScript("OnDragStart", function()
			LSAM_MainFrame:StartMoving()
			LSAM_MainFrame:SetUserPlaced(false)
		end)
		LSAM_Anchor:SetScript("OnDragStop", function()
			LSAM_MainFrame:StopMovingOrSizing()
			LSAM_Options["Point1"], _, LSAM_Options["Point2"], LSAM_Options["Point3"], LSAM_Options["Point4"] =
				LSAM_MainFrame:GetPoint(
					1
				)
		end)
		LSAM_MainFrame:SetMovable(true)
		LSAM_Anchor:Show()
	else
		LSAM_Anchor:Show()
	end
end

function LSAM_MainFrame:DrawInterface()
	LSAM_MainFrame:SetPoint(
		LSAM_Options["Point1"],
		UIParent,
		LSAM_Options["Point2"],
		LSAM_Options["Point3"],
		LSAM_Options["Point4"]
	)
	if LSAM_Options["Vertical"] then
		LSAM_MainFrame:SetSize(101, 512)
	else
		LSAM_MainFrame:SetSize(512, 101)
	end
	LSAM_MainFrame:SetScale(LSAM_Options["Scale"])

	if LSAM_Options["Back"] then
		LSAM_MainFrame:ShowBack()
	end

	if LSAM_Options["Anchor"] then
		LSAM_MainFrame:ShowAnchor()
	end

	local LSAM_TargetButtons = {}
	for i = 1, 8 do
		LSAM_TargetButtons[i] = CreateFrame("Button", "LSAM_TargetButtons" .. i, LSAM_MainFrame)
		LSAM_TargetButtons[i]:SetSize(64, 64)
		LSAM_TargetButtons[i]:SetNormalTexture(137000 + i)
		LSAM_TargetButtons[i]:SetHighlightTexture(137000 + i, "ADD")
		if LSAM_Options["Vertical"] then
			LSAM_TargetButtons[i]:SetPoint("TOPLEFT", LSAM_MainFrame, "TOPLEFT", 0, -64 * (i - 1))
		else
			LSAM_TargetButtons[i]:SetPoint("TOPLEFT", LSAM_MainFrame, "TOPLEFT", 64 * (i - 1), 0)
		end
		LSAM_TargetButtons[i]:RegisterForClicks("LeftButtonDown")
		LSAM_TargetButtons[i]:SetScript("OnClick", function()
			SetRaidTarget("target", i)
		end)
		LSAM_TargetButtons[i]:Show()
	end

	local LSAM_FlareButtons = {}
	for i = 1, 8 do
		LSAM_FlareButtons[i] = CreateFrame(
			"Button",
			"LSAM_FlareButtons" .. i,
			LSAM_MainFrame,
			"SecureActionButtonTemplate"
		)
		LSAM_FlareButtons[i]:SetSize(32, 32)
		LSAM_FlareButtons[i]:SetNormalTexture("Interface\\AddOns\\LightSpellAdvancedMarker\\Flare_icon_" .. i .. ".tga")
		LSAM_FlareButtons[i]:SetHighlightTexture(
			"Interface\\AddOns\\LightSpellAdvancedMarker\\Flare_icon_" .. i .. ".tga",
			"ADD"
		)
		if LSAM_Options["Vertical"] then
			LSAM_FlareButtons[i]:SetPoint("TOPRIGHT", LSAM_MainFrame, "TOPRIGHT", 0, -53.33 * (i - 1))
		else
			LSAM_FlareButtons[i]:SetPoint("BOTTOMLEFT", LSAM_MainFrame, "BOTTOMLEFT", 53.33 * (i - 1), 0)
		end
		LSAM_FlareButtons[i]:RegisterForClicks("LeftButtonDown")
		LSAM_FlareButtons[i]:SetAttribute("type", "macro")
		LSAM_FlareButtons[i]:SetAttribute("macrotext", "/cwm " .. i .. "\n/wm " .. i)
		LSAM_FlareButtons[i]:Show()
	end

	LSAM_ClearAllButton = CreateFrame("Button", "LSAM_ClearAllButton", LSAM_MainFrame, "SecureActionButtonTemplate")
	LSAM_ClearAllButton:SetSize(32, 32)
	LSAM_ClearAllButton:SetNormalAtlas("transmog-icon-revert")
	LSAM_ClearAllButton:SetHighlightAtlas("transmog-icon-revert", "ADD")
	if LSAM_Options["Vertical"] then
		LSAM_ClearAllButton:SetPoint("TOPRIGHT", LSAM_MainFrame, "TOPRIGHT", 0, -53.33 * 8)
	else
		LSAM_ClearAllButton:SetPoint("BOTTOMLEFT", LSAM_MainFrame, "BOTTOMLEFT", 53.33 * 8, 0)
	end
	LSAM_ClearAllButton:RegisterForClicks("LeftButtonDown")
	LSAM_ClearAllButton:SetAttribute("type", "macro")
	LSAM_ClearAllButton:SetAttribute("macrotext", "/cwm 0")
	LSAM_ClearAllButton:Show()

	LSAM_ReadyButton = CreateFrame("Button", "LSAM_ReadyButton", LSAM_MainFrame)
	LSAM_ReadyButton:SetSize(32, 32)
	LSAM_ReadyButton:SetNormalAtlas("GarrMission_EncounterBar-CheckMark")
	LSAM_ReadyButton:SetHighlightAtlas("GarrMission_EncounterBar-CheckMark", "ADD")
	if LSAM_Options["Vertical"] then
		LSAM_ReadyButton:SetPoint("TOPRIGHT", LSAM_MainFrame, "TOPRIGHT", 0, -53.33 * 9)
	else
		LSAM_ReadyButton:SetPoint("BOTTOMLEFT", LSAM_MainFrame, "BOTTOMLEFT", 53.33 * 9, 0)
	end
	LSAM_ReadyButton:RegisterForClicks("LeftButtonDown")
	LSAM_ReadyButton:SetScript("OnClick", function()
		DoReadyCheck()
	end)
	LSAM_ReadyButton:Show()
end

function LSAM_MainFrame:ReDrawInterface()
	LSAM_MainFrame:ClearAllPoints()
	LSAM_MainFrame:SetPoint(
		LSAM_Options["Point1"],
		UIParent,
		LSAM_Options["Point2"],
		LSAM_Options["Point3"],
		LSAM_Options["Point4"]
	)
	if LSAM_Options["Vertical"] then
		LSAM_MainFrame:SetSize(101, 512)
	else
		LSAM_MainFrame:SetSize(512, 101)
	end
	LSAM_MainFrame:SetScale(LSAM_Options["Scale"])

	for i = 1, 8 do
		_G["LSAM_TargetButtons" .. i]:ClearAllPoints()
		if LSAM_Options["Vertical"] then
			_G["LSAM_TargetButtons" .. i]:SetPoint("TOPLEFT", LSAM_MainFrame, "TOPLEFT", 0, -64 * (i - 1))
		else
			_G["LSAM_TargetButtons" .. i]:SetPoint("TOPLEFT", LSAM_MainFrame, "TOPLEFT", 64 * (i - 1), 0)
		end
	end

	for i = 1, 8 do
		_G["LSAM_FlareButtons" .. i]:ClearAllPoints()
		if LSAM_Options["Vertical"] then
			_G["LSAM_FlareButtons" .. i]:SetPoint("TOPRIGHT", LSAM_MainFrame, "TOPRIGHT", 0, -53.33 * (i - 1))
		else
			_G["LSAM_FlareButtons" .. i]:SetPoint("BOTTOMLEFT", LSAM_MainFrame, "BOTTOMLEFT", 53.33 * (i - 1), 0)
		end
	end

	LSAM_ClearAllButton:ClearAllPoints()
	if LSAM_Options["Vertical"] then
		LSAM_ClearAllButton:SetPoint("TOPRIGHT", LSAM_MainFrame, "TOPRIGHT", 0, -53.33 * 8)
	else
		LSAM_ClearAllButton:SetPoint("BOTTOMLEFT", LSAM_MainFrame, "BOTTOMLEFT", 53.33 * 8, 0)
	end

	LSAM_ReadyButton:ClearAllPoints()
	if LSAM_Options["Vertical"] then
		LSAM_ReadyButton:SetPoint("TOPRIGHT", LSAM_MainFrame, "TOPRIGHT", 0, -53.33 * 9)
	else
		LSAM_ReadyButton:SetPoint("BOTTOMLEFT", LSAM_MainFrame, "BOTTOMLEFT", 53.33 * 9, 0)
	end

	if LSAM_Options["Back"] then
		LSAM_MainFrame:ShowBack()
	elseif LSAM_Options["Back"] == false and LSAM_MainFrameTexture ~= nil then
		LSAM_MainFrameTexture:Hide()
	end

	if LSAM_Options["Anchor"] then
		LSAM_MainFrame:ShowAnchor()
	elseif LSAM_Options["Anchor"] == false and LSAM_Anchor ~= nil then
		LSAM_Anchor:Hide()
	end
end

function LSAM_MainFrame:ReSetOptions()
	_G["LSAM_Options_ScaleSlider"]:SetValue(LSAM_Options["Scale"])
	_G["LSAM_Options_AlphaSlider"]:SetValue(LSAM_Options["Alpha"])
	_G["LSAM_Options_BackAlphaSlider"]:SetValue(LSAM_Options["BackAlpha"])
end
--------------------Main function------------------------------------------------------
function LSAM_MainFrame:OnEvent(LSAM_EventName, LSAM_AddonName, ...)
	if LSAM_EventName ~= "ADDON_LOADED" and LSAM_AddonName ~= "LightSpellAdvancedMarker" then
		return
	end
	LSAM_MainFrame:UnregisterEvent("ADDON_LOADED")

	-----------------------Default options-------------------------------------------------
	if not LSAM_GlobalOptions then
		LSAM_GlobalOptions = {
			["Point1"] = "CENTER",
			["Point2"] = "CENTER",
			["Point3"] = 0,
			["Point4"] = 0,
			["Scale"] = 0.5,
			["Alpha"] = 0.7,
			["Back"] = false,
			["Anchor"] = true,
			["Vertical"] = false,
			["BackAlpha"] = 0.5,
		}
	end

	if not LSAM_PerChar then
		LSAM_PerChar = false
	end

	-----------------------Session options-------------------------------------------------
	if LSAM_PerChar then
		LSAM_Options = LSAM_CharacterOptions
	else
		LSAM_Options = LSAM_GlobalOptions
	end

	-----------------------Preparing interface---------------------------------------------
	LSAM_MainFrame:DrawInterface()

	-----------------------Show interface--------------------------------------------------
	LSAM_MainFrame:Show()

	-----------------------Option page-----------------------------------------------------
	LSAM_OptionsFrame = CreateFrame("Frame", "LSAM_OptionsFrame", UIParent)
	LSAM_OptionsFrame.name = "LightSpellAdvancedMarker"

	local LSAM_Options_Header = LSAM_OptionsFrame:CreateFontString(
		"LSAM_Options_Header",
		"ARTWORK",
		"GameFontNormalLarge"
	)
	LSAM_Options_Header:SetPoint("TOPLEFT", 16, -16)
	LSAM_Options_Header:SetText("LightSpell's Advanced Marker")

	local LSAM_Options_CenterButton = CreateFrame(
		"Button",
		"LSAM_Options_CenterButton",
		LSAM_OptionsFrame,
		"UIPanelButtonTemplate, SecureHandlerBaseTemplate, SecureHandlerClickTemplate"
	)
	LSAM_Options_CenterButton:SetSize(220, 22)
	LSAM_Options_CenterButton:SetPoint("TOPLEFT", 20, -48)
	LSAM_Options_CenterButton:SetText("Reset Position")
	LSAM_Options_CenterButton:RegisterForClicks("LeftButtonDown")
	LSAM_Options_CenterButton:SetScript("OnClick", function()
		LSAM_Options["Point1"], LSAM_Options["Point2"], LSAM_Options["Point3"], LSAM_Options["Point4"] =
			"CENTER", "CENTER", 0, 0
		LSAM_MainFrame:ClearAllPoints()
		LSAM_MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end)

	local LSAM_Options_AnchorButton = CreateFrame(
		"Button",
		"LSAM_Options_AnchorButton",
		LSAM_OptionsFrame,
		"UIPanelButtonTemplate, SecureHandlerBaseTemplate, SecureHandlerClickTemplate"
	)
	LSAM_Options_AnchorButton:SetSize(220, 22)
	LSAM_Options_AnchorButton:SetPoint("TOPLEFT", 250, -48)
	LSAM_Options_AnchorButton:SetText("Switch Anchor")
	LSAM_Options_AnchorButton:RegisterForClicks("LeftButtonDown")
	LSAM_Options_AnchorButton:SetScript("OnClick", function()
		if LSAM_Options["Anchor"] then
			LSAM_Options["Anchor"] = false
			LSAM_Anchor:Hide()
		else
			LSAM_Options["Anchor"] = true
			LSAM_MainFrame:ShowAnchor()
		end
	end)

	local LSAM_Options_ScaleSlider = CreateFrame(
		"Slider",
		"LSAM_Options_ScaleSlider",
		LSAM_OptionsFrame,
		"OptionsSliderTemplate"
	)
	_G["LSAM_Options_ScaleSliderText"]:SetText("Scale")
	LSAM_Options_ScaleSlider:SetSize(220, 22)
	LSAM_Options_ScaleSlider:SetPoint("TOPLEFT", 250, -92)
	LSAM_Options_ScaleSlider:SetMinMaxValues(0.05, 1.5)
	LSAM_Options_ScaleSlider:SetValueStep(0.05)
	LSAM_Options_ScaleSlider:SetValue(LSAM_Options["Scale"])
	LSAM_Options_ScaleSlider:SetScript("OnValueChanged", function()
		LSAM_Options["Scale"] = LSAM_Options_ScaleSlider:GetValue()
		LSAM_MainFrame:SetScale(LSAM_Options["Scale"])
	end)

	local LSAM_Options_AlphaSlider = CreateFrame(
		"Slider",
		"LSAM_Options_AlphaSlider",
		LSAM_OptionsFrame,
		"OptionsSliderTemplate"
	)
	_G["LSAM_Options_AlphaSliderText"]:SetText("Alpha")
	LSAM_Options_AlphaSlider:SetSize(220, 22)
	LSAM_Options_AlphaSlider:SetPoint("TOPLEFT", 20, -92)
	LSAM_Options_AlphaSlider:SetMinMaxValues(0.1, 1)
	LSAM_Options_AlphaSlider:SetValueStep(0.05)
	LSAM_Options_AlphaSlider:SetValue(LSAM_Options["Alpha"])
	LSAM_Options_AlphaSlider:SetScript("OnValueChanged", function()
		LSAM_Options["Alpha"] = LSAM_Options_AlphaSlider:GetValue()
		LSAM_MainFrame:SetAlpha(LSAM_Options["Alpha"])
	end)

	local LSAM_Options_VerticalButton = CreateFrame(
		"Button",
		"LSAM_Options_VerticalButton",
		LSAM_OptionsFrame,
		"UIPanelButtonTemplate, SecureHandlerBaseTemplate, SecureHandlerClickTemplate"
	)
	LSAM_Options_VerticalButton:SetSize(450, 22)
	LSAM_Options_VerticalButton:SetPoint("TOPLEFT", 20, -124)
	LSAM_Options_VerticalButton:SetText("Switch Vertical/Horizontal")
	LSAM_Options_VerticalButton:RegisterForClicks("LeftButtonDown")
	LSAM_Options_VerticalButton:SetScript("OnClick", function()
		if LSAM_Options["Vertical"] then
			LSAM_Options["Vertical"] = false
		else
			LSAM_Options["Vertical"] = true
		end
		LSAM_MainFrame:ReDrawInterface()
	end)

	local LSAM_Options_BackButton = CreateFrame(
		"Button",
		"LSAM_Options_BackButton",
		LSAM_OptionsFrame,
		"UIPanelButtonTemplate, SecureHandlerBaseTemplate, SecureHandlerClickTemplate"
	)
	LSAM_Options_BackButton:SetSize(220, 22)
	LSAM_Options_BackButton:SetPoint("TOPLEFT", 20, -168)
	LSAM_Options_BackButton:SetText("Switch Background")
	LSAM_Options_BackButton:RegisterForClicks("LeftButtonDown")
	LSAM_Options_BackButton:SetScript("OnClick", function()
		if LSAM_Options["Back"] then
			LSAM_Options["Back"] = false
			LSAM_MainFrameTexture:Hide()
		else
			LSAM_Options["Back"] = true
			LSAM_MainFrame:ShowBack()
		end
	end)

	local LSAM_Options_BackAlphaSlider = CreateFrame(
		"Slider",
		"LSAM_Options_BackAlphaSlider",
		LSAM_OptionsFrame,
		"OptionsSliderTemplate"
	)
	_G["LSAM_Options_BackAlphaSliderText"]:SetText("Background Alpha")
	LSAM_Options_BackAlphaSlider:SetSize(220, 22)
	LSAM_Options_BackAlphaSlider:SetPoint("TOPLEFT", 250, -168)
	LSAM_Options_BackAlphaSlider:SetMinMaxValues(0.1, 1)
	LSAM_Options_BackAlphaSlider:SetValueStep(0.05)
	LSAM_Options_BackAlphaSlider:SetValue(LSAM_Options["BackAlpha"])
	LSAM_Options_BackAlphaSlider:SetScript("OnValueChanged", function()
		LSAM_Options["BackAlpha"] = LSAM_Options_BackAlphaSlider:GetValue()
		if LSAM_MainFrameTexture ~= nil then
			LSAM_MainFrameTexture:SetColorTexture(0, 0, 0, LSAM_Options["BackAlpha"])
		end
	end)

	local LSAM_Options_InsetFrame = CreateFrame(
		"Frame",
		"LSAM_Options_InsetFrame",
		LSAM_OptionsFrame,
		"InsetFrameTemplate"
	)
	LSAM_Options_InsetFrame:SetPoint("TOPLEFT", 20, -204)
	LSAM_Options_InsetFrame:SetSize(450, 32)

	local LSAM_Options_AllRadio = CreateFrame(
		"CheckButton",
		"LSAM_Options_AllRadio",
		LSAM_Options_InsetFrame,
		"UIRadioButtonTemplate"
	)
	LSAM_Options_AllRadio:SetPoint("TOPLEFT", 8, -8)
	_G["LSAM_Options_AllRadioText"]:SetText("Options for all characters")
	LSAM_Options_AllRadio:SetChecked(not LSAM_PerChar)

	local LSAM_Options_PerCharRadio = CreateFrame(
		"CheckButton",
		"LSAM_Options_PerCharRadio",
		LSAM_Options_InsetFrame,
		"UIRadioButtonTemplate"
	)
	LSAM_Options_PerCharRadio:SetPoint("TOPLEFT", 233, -8)
	_G["LSAM_Options_PerCharRadioText"]:SetText("Options for this character")
	LSAM_Options_PerCharRadio:SetChecked(LSAM_PerChar)

	LSAM_Options_AllRadio:SetScript("OnClick", function()
		LSAM_PerChar = false
		LSAM_Options = LSAM_GlobalOptions
		LSAM_MainFrame:ReSetOptions()
		LSAM_MainFrame:ReDrawInterface()
	end)
	LSAM_Options_PerCharRadio:SetScript("OnClick", function()
		LSAM_MainFrame:CopyOptions()
		LSAM_PerChar = true
		LSAM_Options = LSAM_CharacterOptions
		LSAM_MainFrame:ReSetOptions()
		LSAM_MainFrame:ReDrawInterface()
	end)

	LSAM_Options_AllRadio:SetScript("PostClick", function()
		LSAM_Options_AllRadio:SetChecked(not LSAM_PerChar)
		LSAM_Options_PerCharRadio:SetChecked(LSAM_PerChar)
	end)
	LSAM_Options_PerCharRadio:SetScript("PostClick", function()
		LSAM_Options_AllRadio:SetChecked(not LSAM_PerChar)
		LSAM_Options_PerCharRadio:SetChecked(LSAM_PerChar)
	end)

	-----------------------Register option page--------------------------------------------
	InterfaceOptions_AddCategory(LSAM_OptionsFrame)

	--------------------End of main function-----------------------------------------------
end

--------------------Initialization (2 stage)-------------------------------------------
LSAM_MainFrame:SetScript("OnEvent", LSAM_MainFrame.OnEvent)
