```lua
--!strict
-- LocalScript para criar a interface (GUI) do painel "DEATHLYRAGE"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configurações visuais
local PANEL_COLOR = Color3.fromRGB(30, 30, 30)
local ACCENT_COLOR = Color3.fromRGB(255, 0, 0) -- Vermelho para destaque
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local BORDER_RADIUS = UDim.new(0, 8) -- Cantos arredondados
local FONT = Enum.Font.SourceSansBold
local FONT_SIZE = Enum.FontSize.Size14

-- Funções para criar elementos da GUI
local function createScreenGui(name: string): ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = name
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 10 -- Para garantir que fique acima de outras GUIs
    sg.Parent = PlayerGui
    return sg
end

local function createFrame(parent: GuiObject, name: string, size: UDim2, position: UDim2, color: Color3, transparency: number, cornerRadius: UDim?): Frame
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency
    frame.BorderSizePixel = 0
    frame.Parent = parent

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = cornerRadius
        corner.Parent = frame
    end
    return frame
end

local function createTextLabel(parent: GuiObject, name: string, text: string, size: UDim2, position: UDim2, color: Color3, transparency: number, font: Enum.Font, fontSize: Enum.FontSize, textXAlignment: Enum.TextXAlignment, textYAlignment: Enum.TextYAlignment): TextLabel
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundColor3 = color
    label.BackgroundTransparency = transparency
    label.TextColor3 = TEXT_COLOR
    label.TextScaled = false
    label.TextSize = fontSize.Value
    label.Font = font
    label.Text = text
    label.TextXAlignment = textXAlignment
    label.TextYAlignment = textYAlignment
    label.Parent = parent
    return label
end

local function createTextButton(parent: GuiObject, name: string, text: string, size: UDim2, position: UDim2, color: Color3, transparency: number, font: Enum.Font, fontSize: Enum.FontSize, textXAlignment: Enum.TextXAlignment, textYAlignment: Enum.TextYAlignment, cornerRadius: UDim?): TextButton
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color
    button.BackgroundTransparency = transparency
    button.TextColor3 = TEXT_COLOR
    button.TextScaled = false
    button.TextSize = fontSize.Value
    button.Font = font
    button.Text = text
    button.TextXAlignment = textXAlignment
    button.TextYAlignment = textYAlignment
    button.BorderSizePixel = 0
    button.Parent = parent

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = cornerRadius
        corner.Parent = button
    end
    return button
end

local function createToggleSwitch(parent: GuiObject, name: string, size: UDim2, position: UDim2, initialState: boolean): Frame
    local toggleFrame = createFrame(parent, name, size, position, Color3.fromRGB(50, 50, 50), 0, BORDER_RADIUS)
    toggleFrame.ClipsDescendants = true

    local toggleButton = createTextButton(toggleFrame, "ToggleButton", "", UDim2.new(0, size.X.Offset / 2, 1, 0), UDim2.new(0, 0, 0, 0), ACCENT_COLOR, 0, FONT, FONT_SIZE, Enum.TextXAlignment.Center, Enum.TextYAlignment.Center, BORDER_RADIUS)
    toggleButton.ZIndex = 2

    local state = initialState

    local function updateToggleVisual()
        if state then
            toggleButton.BackgroundColor3 = ACCENT_COLOR
            toggleButton:TweenPosition(UDim2.new(0.5, 0, 0, 0), "Out", "Quad", 0.2, true)
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            toggleButton:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.2, true)
        end
    end

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggleVisual()
        -- Aqui você pode disparar um evento ou chamar uma função para a funcionalidade associada
        print(name .. " is now: " .. tostring(state))
    end)

    updateToggleVisual()
    return toggleFrame, function() return state end
end

-- Cria o ScreenGui principal
local MainScreenGui = createScreenGui("DeathlyRagePanel")

-- Cria o Frame principal do painel
local MainPanel = createFrame(MainScreenGui, "MainPanel", UDim2.new(0, 700, 0, 450), UDim2.new(0.5, -350, 0.5, -225), PANEL_COLOR, 0, BORDER_RADIUS)
MainPanel.Active = true -- Para permitir arrastar
MainPanel.Draggable = true -- Para permitir arrastar

-- Título do painel
createTextLabel(MainPanel, "Title", "DEATHLYRAGE", UDim2.new(0, 200, 0, 30), UDim2.new(0.02, 0, 0.02, 0), PANEL_COLOR, 1, FONT, Enum.FontSize.Size24, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

-- Frame para as abas (esquerda)
local TabsFrame = createFrame(MainPanel, "TabsFrame", UDim2.new(0, 150, 1, -40), UDim2.new(0, 0, 0, 40), Color3.fromRGB(25, 25, 25), 0, nil)

-- Frame para o conteúdo das abas (direita)
local ContentFrame = createFrame(MainPanel, "ContentFrame", UDim2.new(1, -150, 1, -40), UDim2.new(0, 150, 0, 40), Color3.fromRGB(35, 35, 35), 0, nil)

-- Layout para as abas
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Vertical
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabsFrame

-- Dicionário para armazenar os frames de conteúdo de cada aba
local tabContents = {}
local currentActiveTab: TextButton = nil

local function createTabButton(tabName: string)
    local tabButton = createTextButton(TabsFrame, tabName .. "Tab", tabName, UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 0, 0), Color3.fromRGB(40, 40, 40), 0, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center, BORDER_RADIUS)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.TextWrapped = true
    tabButton.TextScaled = false
    tabButton.TextSize = FONT_SIZE.Value
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, 0)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" -- Substituir por ícones reais se tiver
    icon.Parent = tabButton

    local tabContentFrame = createFrame(ContentFrame, tabName .. "Content", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), ContentFrame.BackgroundColor3, 0, nil)
    tabContentFrame.Visible = false
    tabContents[tabName] = tabContentFrame

    tabButton.MouseButton1Click:Connect(function()
        if currentActiveTab then
            currentActiveTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabContents[currentActiveTab.Name:gsub("Tab", "")].Visible = false
        end
        tabButton.BackgroundColor3 = ACCENT_COLOR
        tabContentFrame.Visible = true
        currentActiveTab = tabButton
    end)

    return tabButton, tabContentFrame
end

-- Cria as abas e seus conteúdos
local AimbotTab, AimbotContent = createTabButton("AIMBOT")
local VisualsTab, VisualsContent = createTabButton("VISUALS")
local ExploitsTab, ExploitsContent = createTabButton("EXPLOITS")
local SettingsTab, SettingsContent = createTabButton("SETTINGS")

-- Ativa a primeira aba por padrão
VisualsTab.MouseButton1Click:Connect(function() end)() -- Simula um clique para ativar a aba Visuals

-- Conteúdo da aba VISUALS
local VisualsLayout = Instance.new("UIListLayout")
VisualsLayout.FillDirection = Enum.FillDirection.Vertical
VisualsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
VisualsLayout.Padding = UDim.new(0, 10)
VisualsLayout.Parent = VisualsContent

createTextLabel(VisualsContent, "EspSettingsTitle", "Esp Settings", UDim2.new(1, 0, 0, 30), UDim2.new(0, 10, 0, 10), VisualsContent.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

-- Opções de ESP
local function createEspOption(parentFrame: GuiObject, optionName: string, initialState: boolean)
    local optionFrame = createFrame(parentFrame, optionName .. "Option", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 0), parentFrame.BackgroundColor3, 1, nil)
    local optionLayout = Instance.new("UIListLayout")
    optionLayout.FillDirection = Enum.FillDirection.Horizontal
    optionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    optionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    optionLayout.Padding = UDim.new(0, 10)
    optionLayout.Parent = optionFrame

    createTextLabel(optionFrame, optionName .. "Label", optionName, UDim2.new(0, 150, 1, 0), UDim2.new(0, 0, 0, 0), optionFrame.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)
    local toggle, getState = createToggleSwitch(optionFrame, optionName .. "Toggle", UDim2.new(0, 40, 0, 20), UDim2.new(0, 0, 0, 0), initialState)
    toggle.Parent = optionFrame

    return getState
end

-- Adiciona as opções de ESP na aba Visuals
local drawLinesState = createEspOption(VisualsContent, "Draw Lines", false)
local drawBoxState = createEspOption(VisualsContent, "Draw Box", false)
local drawHealthBarState = createEspOption(VisualsContent, "Draw Health Bar", false)
local drawNameState = createEspOption(VisualsContent, "Draw Name", false)
local drawDistanceState = createEspOption(VisualsContent, "Draw Distance", false)
local drawSkeletonState = createEspOption(VisualsContent, "Draw Skeleton", false)
local drawWeaponState = createEspOption(VisualsContent, "Draw Weapon", false)

-- Exemplo de como acessar o estado de um toggle
-- print("Draw Lines initial state: " .. tostring(drawLinesState()))

-- Conteúdo da aba AIMBOT (exemplo)
local AimbotLayout = Instance.new("UIListLayout")
AimbotLayout.FillDirection = Enum.FillDirection.Vertical
AimbotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
AimbotLayout.Padding = UDim.new(0, 10)
AimbotLayout.Parent = AimbotContent

createTextLabel(AimbotContent, "AimbotSettingsTitle", "Aimbot Settings", UDim2.new(1, 0, 0, 30), UDim2.new(0, 10, 0, 10), AimbotContent.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

local aimbotToggle, getAimbotState = createEspOption(AimbotContent, "Aimbot Enable", false)

-- Função para abrir/fechar o painel com uma tecla (ex: Insert)
local UserInputService = game:GetService("UserInputService")
local panelVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessedEvent then
        panelVisible = not panelVisible
        MainPanel.Visible = panelVisible
    end
end)

-- Esconde o painel por padrão, para ser aberto com a tecla Insert
MainPanel.Visible = false

print("DeathlyRage Panel GUI Loaded!")
```
```lua
--!strict
-- LocalScript para criar a interface (GUI) do painel "DEATHLYRAGE"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configurações visuais
local PANEL_COLOR = Color3.fromRGB(30, 30, 30)
local ACCENT_COLOR = Color3.fromRGB(255, 0, 0) -- Vermelho para destaque
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local BORDER_RADIUS = UDim.new(0, 8) -- Cantos arredondados
local FONT = Enum.Font.SourceSansBold
local FONT_SIZE = Enum.FontSize.Size14

-- Funções para criar elementos da GUI
local function createScreenGui(name: string): ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = name
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 10 -- Para garantir que fique acima de outras GUIs
    sg.Parent = PlayerGui
    return sg
end

local function createFrame(parent: GuiObject, name: string, size: UDim2, position: UDim2, color: Color3, transparency: number, cornerRadius: UDim?): Frame
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency
    frame.BorderSizePixel = 0
    frame.Parent = parent

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = cornerRadius
        corner.Parent = frame
    end
    return frame
end

local function createTextLabel(parent: GuiObject, name: string, text: string, size: UDim2, position: UDim2, color: Color3, transparency: number, font: Enum.Font, fontSize: Enum.FontSize, textXAlignment: Enum.TextXAlignment, textYAlignment: Enum.TextYAlignment): TextLabel
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundColor3 = color
    label.BackgroundTransparency = transparency
    label.TextColor3 = TEXT_COLOR
    label.TextScaled = false
    label.TextSize = fontSize.Value
    label.Font = font
    label.Text = text
    label.TextXAlignment = textXAlignment
    label.TextYAlignment = textYAlignment
    label.Parent = parent
    return label
end

local function createTextButton(parent: GuiObject, name: string, text: string, size: UDim2, position: UDim2, color: Color3, transparency: number, font: Enum.Font, fontSize: Enum.FontSize, textXAlignment: Enum.TextXAlignment, textYAlignment: Enum.TextYAlignment, cornerRadius: UDim?): TextButton
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color
    button.BackgroundTransparency = transparency
    button.TextColor3 = TEXT_COLOR
    button.TextScaled = false
    button.TextSize = fontSize.Value
    button.Font = font
    button.Text = text
    button.TextXAlignment = textXAlignment
    button.TextYAlignment = textYAlignment
    button.BorderSizePixel = 0
    button.Parent = parent

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = cornerRadius
        corner.Parent = button
    end
    return button
end

local function createToggleSwitch(parent: GuiObject, name: string, size: UDim2, position: UDim2, initialState: boolean): Frame
    local toggleFrame = createFrame(parent, name, size, position, Color3.fromRGB(50, 50, 50), 0, BORDER_RADIUS)
    toggleFrame.ClipsDescendants = true

    local toggleButton = createTextButton(toggleFrame, "ToggleButton", "", UDim2.new(0, size.X.Offset / 2, 1, 0), UDim2.new(0, 0, 0, 0), ACCENT_COLOR, 0, FONT, FONT_SIZE, Enum.TextXAlignment.Center, Enum.TextYAlignment.Center, BORDER_RADIUS)
    toggleButton.ZIndex = 2

    local state = initialState

    local function updateToggleVisual()
        if state then
            toggleButton.BackgroundColor3 = ACCENT_COLOR
            toggleButton:TweenPosition(UDim2.new(0.5, 0, 0, 0), "Out", "Quad", 0.2, true)
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            toggleButton:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.2, true)
        end
    end

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggleVisual()
        -- Aqui você pode disparar um evento ou chamar uma função para a funcionalidade associada
        print(name .. " is now: " .. tostring(state))
    end)

    updateToggleVisual()
    return toggleFrame, function() return state end
end

-- Cria o ScreenGui principal
local MainScreenGui = createScreenGui("DeathlyRagePanel")

-- Cria o Frame principal do painel
local MainPanel = createFrame(MainScreenGui, "MainPanel", UDim2.new(0, 700, 0, 450), UDim2.new(0.5, -350, 0.5, -225), PANEL_COLOR, 0, BORDER_RADIUS)
MainPanel.Active = true -- Para permitir arrastar
MainPanel.Draggable = true -- Para permitir arrastar

-- Título do painel
createTextLabel(MainPanel, "Title", "DEATHLYRAGE", UDim2.new(0, 200, 0, 30), UDim2.new(0.02, 0, 0.02, 0), PANEL_COLOR, 1, FONT, Enum.FontSize.Size24, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

-- Frame para as abas (esquerda)
local TabsFrame = createFrame(MainPanel, "TabsFrame", UDim2.new(0, 150, 1, -40), UDim2.new(0, 0, 0, 40), Color3.fromRGB(25, 25, 25), 0, nil)

-- Frame para o conteúdo das abas (direita)
local ContentFrame = createFrame(MainPanel, "ContentFrame", UDim2.new(1, -150, 1, -40), UDim2.new(0, 150, 0, 40), Color3.fromRGB(35, 35, 35), 0, nil)

-- Layout para as abas
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Vertical
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabsFrame

-- Dicionário para armazenar os frames de conteúdo de cada aba
local tabContents = {}
local currentActiveTab: TextButton = nil

local function createTabButton(tabName: string)
    local tabButton = createTextButton(TabsFrame, tabName .. "Tab", tabName, UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 0, 0), Color3.fromRGB(40, 40, 40), 0, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center, BORDER_RADIUS)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.TextWrapped = true
    tabButton.TextScaled = false
    tabButton.TextSize = FONT_SIZE.Value
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, 0)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" -- Substituir por ícones reais se tiver
    icon.Parent = tabButton

    local tabContentFrame = createFrame(ContentFrame, tabName .. "Content", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), ContentFrame.BackgroundColor3, 0, nil)
    tabContentFrame.Visible = false
    tabContents[tabName] = tabContentFrame

    tabButton.MouseButton1Click:Connect(function()
        if currentActiveTab then
            currentActiveTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabContents[currentActiveTab.Name:gsub("Tab", "")].Visible = false
        end
        tabButton.BackgroundColor3 = ACCENT_COLOR
        tabContentFrame.Visible = true
        currentActiveTab = tabButton
    end)

    return tabButton, tabContentFrame
end

-- Cria as abas e seus conteúdos
local AimbotTab, AimbotContent = createTabButton("AIMBOT")
local VisualsTab, VisualsContent = createTabButton("VISUALS")
local ExploitsTab, ExploitsContent = createTabButton("EXPLOITS")
local SettingsTab, SettingsContent = createTabButton("SETTINGS")

-- Ativa a primeira aba por padrão
VisualsTab.MouseButton1Click:Connect(function() end)() -- Simula um clique para ativar a aba Visuals

-- Conteúdo da aba VISUALS
local VisualsLayout = Instance.new("UIListLayout")
VisualsLayout.FillDirection = Enum.FillDirection.Vertical
VisualsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
VisualsLayout.Padding = UDim.new(0, 10)
VisualsLayout.Parent = VisualsContent

createTextLabel(VisualsContent, "EspSettingsTitle", "Esp Settings", UDim2.new(1, 0, 0, 30), UDim2.new(0, 10, 0, 10), VisualsContent.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

-- Opções de ESP
local function createEspOption(parentFrame: GuiObject, optionName: string, initialState: boolean)
    local optionFrame = createFrame(parentFrame, optionName .. "Option", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 0), parentFrame.BackgroundColor3, 1, nil)
    local optionLayout = Instance.new("UIListLayout")
    optionLayout.FillDirection = Enum.FillDirection.Horizontal
    optionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    optionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    optionLayout.Padding = UDim.new(0, 10)
    optionLayout.Parent = optionFrame

    createTextLabel(optionFrame, optionName .. "Label", optionName, UDim2.new(0, 150, 1, 0), UDim2.new(0, 0, 0, 0), optionFrame.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)
    local toggle, getState = createToggleSwitch(optionFrame, optionName .. "Toggle", UDim2.new(0, 40, 0, 20), UDim2.new(0, 0, 0, 0), initialState)
    toggle.Parent = optionFrame

    return getState
end

-- Adiciona as opções de ESP na aba Visuals
local drawLinesState = createEspOption(VisualsContent, "Draw Lines", false)
local drawBoxState = createEspOption(VisualsContent, "Draw Box", false)
local drawHealthBarState = createEspOption(VisualsContent, "Draw Health Bar", false)
local drawNameState = createEspOption(VisualsContent, "Draw Name", false)
local drawDistanceState = createEspOption(VisualsContent, "Draw Distance", false)
local drawSkeletonState = createEspOption(VisualsContent, "Draw Skeleton", false)
local drawWeaponState = createEspOption(VisualsContent, "Draw Weapon", false)

-- Exemplo de como acessar o estado de um toggle
-- print("Draw Lines initial state: " .. tostring(drawLinesState()))

-- Conteúdo da aba AIMBOT (exemplo)
local AimbotLayout = Instance.new("UIListLayout")
AimbotLayout.FillDirection = Enum.FillDirection.Vertical
AimbotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
AimbotLayout.Padding = UDim.new(0, 10)
AimbotLayout.Parent = AimbotContent

createTextLabel(AimbotContent, "AimbotSettingsTitle", "Aimbot Settings", UDim2.new(1, 0, 0, 30), UDim2.new(0, 10, 0, 10), AimbotContent.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

local aimbotToggle, getAimbotState = createEspOption(AimbotContent, "Aimbot Enable", false)

-- Função para abrir/fechar o painel com uma tecla (ex: Insert)
local UserInputService = game:GetService("UserInputService")
local panelVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessedEvent then
        panelVisible = not panelVisible
        MainPanel.Visible = panelVisible
    end
end)

-- Esconde o painel por padrão, para ser aberto com a tecla Insert
MainPanel.Visible = false

print("DeathlyRage Panel GUI Loaded!")
```
updateToggleVisual()
        -- Aqui você pode disparar um evento ou chamar uma função para a funcionalidade associada
        print(name .. " is now: " .. tostring(state))
    end)

    updateToggleVisual()
    return toggleFrame, function() return state end
end

-- Cria o ScreenGui principal
local MainScreenGui = createScreenGui("DeathlyRagePanel")

-- Cria o Frame principal do painel
local MainPanel = createFrame(MainScreenGui, "MainPanel", UDim2.new(0, 700, 0, 450), UDim2.new(0.5, -350, 0.5, -225), PANEL_COLOR, 0, BORDER_RADIUS)
MainPanel.Active = true -- Para permitir arrastar
MainPanel.Draggable = true -- Para permitir arrastar

-- Título do painel
createTextLabel(MainPanel, "Title", "DEATHLYRAGE", UDim2.new(0, 200, 0, 30), UDim2.new(0.02, 0, 0.02, 0), PANEL_COLOR, 1, FONT, Enum.FontSize.Size24, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

-- Frame para as abas (esquerda)
local TabsFrame = createFrame(MainPanel, "TabsFrame", UDim2.new(0, 150, 1, -40), UDim2.new(0, 0, 0, 40), Color3.fromRGB(25, 25, 25), 0, nil)

-- Frame para o conteúdo das abas (direita)
local ContentFrame = createFrame(MainPanel, "ContentFrame", UDim2.new(1, -150, 1, -40), UDim2.new(0, 150, 0, 40), Color3.fromRGB(35, 35, 35), 0, nil)

-- Layout para as abas
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Vertical
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabsFrame

-- Dicionário para armazenar os frames de conteúdo de cada aba
local tabContents = {}
local currentActiveTab: TextButton = nil

local function createTabButton(tabName: string)
    local tabButton = createTextButton(TabsFrame, tabName .. "Tab", tabName, UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 0, 0), Color3.fromRGB(40, 40, 40), 0, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center, BORDER_RADIUS)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.TextWrapped = true
    tabButton.TextScaled = false
    tabButton.TextSize = FONT_SIZE.Value
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, 0)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" -- Substituir por ícones reais se tiver
    icon.Parent = tabButton

    local tabContentFrame = createFrame(ContentFrame, tabName .. "Content", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), ContentFrame.BackgroundColor3, 0, nil)
    tabContentFrame.Visible = false
    tabContents[tabName] = tabContentFrame

    tabButton.MouseButton1Click:Connect(function()
        if currentActiveTab then
            currentActiveTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabContents[currentActiveTab.Name:gsub("Tab", "")].Visible = false
        end
        tabButton.BackgroundColor3 = ACCENT_COLOR
        tabContentFrame.Visible = true
        currentActiveTab = tabButton
    end)

    return tabButton, tabContentFrame
end

-- Cria as abas e seus conteúdos
local AimbotTab, AimbotContent = createTabButton("AIMBOT")
local VisualsTab, VisualsContent = createTabButton("VISUALS")
local ExploitsTab, ExploitsContent = createTabButton("EXPLOITS")
local SettingsTab, SettingsContent = createTabButton("SETTINGS")

-- Ativa a primeira aba por padrão
VisualsTab.MouseButton1Click:Connect(function() end)() -- Simula um clique para ativar a aba Visuals

-- Conteúdo da aba VISUALS
local VisualsLayout = Instance.new("UIListLayout")
VisualsLayout.FillDirection = Enum.FillDirection.Vertical
VisualsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
VisualsLayout.Padding = UDim.new(0, 10)
VisualsLayout.Parent = VisualsContent

createTextLabel(VisualsContent, "EspSettingsTitle", "Esp Settings", UDim2.new(1, 0, 0, 30), UDim2.new(0, 10, 0, 10), VisualsContent.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

-- Opções de ESP
local function createEspOption(parentFrame: GuiObject, optionName: string, initialState: boolean)
    local optionFrame = createFrame(parentFrame, optionName .. "Option", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 0), parentFrame.BackgroundColor3, 1, nil)
    local optionLayout = Instance.new("UIListLayout")
    optionLayout.FillDirection = Enum.FillDirection.Horizontal
    optionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    optionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    optionLayout.Padding = UDim.new(0, 10)
    optionLayout.Parent = optionFrame

    createTextLabel(optionFrame, optionName .. "Label", optionName, UDim2.new(0, 150, 1, 0), UDim2.new(0, 0, 0, 0), optionFrame.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)
    local toggle, getState = createToggleSwitch(optionFrame, optionName .. "Toggle", UDim2.new(0, 40, 0, 20), UDim2.new(0, 0, 0, 0), initialState)
    toggle.Parent = optionFrame

    return getState
end

-- Adiciona as opções de ESP na aba Visuals
local drawLinesState = createEspOption(VisualsContent, "Draw Lines", false)
local drawBoxState = createEspOption(VisualsContent, "Draw Box", false)
local drawHealthBarState = createEspOption(VisualsContent, "Draw Health Bar", false)
local drawNameState = createEspOption(VisualsContent, "Draw Name", false)
local drawDistanceState = createEspOption(VisualsContent, "Draw Distance", false)
local drawSkeletonState = createEspOption(VisualsContent, "Draw Skeleton", false)
local drawWeaponState = createEspOption(VisualsContent, "Draw Weapon", false)

-- Exemplo de como acessar o estado de um toggle
-- print("Draw Lines initial state: " .. tostring(drawLinesState()))

-- Conteúdo da aba AIMBOT (exemplo)
local AimbotLayout = Instance.new("UIListLayout")
AimbotLayout.FillDirection = Enum.FillDirection.Vertical
AimbotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
AimbotLayout.Padding = UDim.new(0, 10)
AimbotLayout.Parent = AimbotContent

createTextLabel(AimbotContent, "AimbotSettingsTitle", "Aimbot Settings", UDim2.new(1, 0, 0, 30), UDim2.new(0, 10, 0, 10), AimbotContent.BackgroundColor3, 1, FONT, FONT_SIZE, Enum.TextXAlignment.Left, Enum.TextYAlignment.Center)

local aimbotToggle, getAimbotState = createEspOption(AimbotContent, "Aimbot Enable", false)

-- Função para abrir/fechar o painel com uma tecla (ex: Insert)
local UserInputService = game:GetService("UserInputService")
local panelVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessedEvent then
        panelVisible = not panelVisible
        MainPanel.Visible = panelVisible
    end
end)

-- Esconde o painel por padrão, para ser aberto com a tecla Insert
MainPanel.Visible = false

print("DeathlyRage Panel GUI Loaded!")
```
