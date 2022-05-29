# Getting Started

These utility modules can be required using [Wally](https://wally.run), a package manager built for Roblox.

## Wally Configuration

Once Wally is installed, run `wally init` on your project directory. This will create a brand new `wally.toml` file.

You can then add any utilities you would like to your project as dependancies. For example:

```toml
[package]
name = "your_name/your_project"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
UIComponent = "virshal/uicomponent@0.1.3"
```

To install or update these dependancies, run `wally install` within your project's terminal. Wally will then create a folder called 'Packages' with all of your installed dependancies!

## Rojo Configuration

I would suggest checking out [this guide by Sleitnick](https://sleitnick.github.io/RbxUtil/docs/intro#rojo-configuration) for his RbxUtil modules, which inspired this guide!

## Usage Example

Information about the respective packages can be found in the [API section](/api).

Below is an example of a script using installed dependancies:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Reference the packages folder:
local Packages = ReplicatedStorage.Packages

-- Require package:
local UIComponent = require(ReplicatedStorage.Packages.UIComponent)

local CreateInstance = UIComponent.CreateInstance

-- Use the module:
local Button = UIComponent.new()

function Button:Build()
    self.button = CreateInstance "TextButton" {
        Size = UDim2.new(0, 200, 0, 50),
        Text = "Click Me!"
        TextColor3 = self.props.textColor,
        Parent = self.props.parent
    }
end

local gui = CreateInstance("ScreenGui", {Parent = LOCAL_PLAYER.PlayerGui})

local newButton = Button{textColor = Color3.new(1, 0.5, 0.5), parent = gui}
```