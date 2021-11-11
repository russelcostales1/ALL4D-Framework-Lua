--@Author: Russel Costales

local WClient = {}

local function run(t)
      for _, content in pairs(t) do
            if typeof(content) == "table" then
                  if typeof(content.run) == "function" then
                        task.spawn(function()
                              content:run()
                        end)
                  end
            end
      end
end

local function wrap(self, folder)
      local content = {}
      for _, module in pairs(folder:GetChildren()) do
            if module:IsA("Folder") then
                  wrap(module)
            end
            content[module.Name] = require(module)
            if typeof(content[module.Name]) == "table" then
                  setmetatable(content[module.Name], {__index = self})
                  if typeof(content[module.Name].init) == "function" then
                        content[module.Name]:init()
                  end
            end
      end
      self[folder.Name] = content
end

local function main()
      local self = WClient
      self.network = require(script.network)

      for _, folder in pairs(script:GetChildren()) do
            if folder:IsA("Folder") then
                  wrap(self, folder)
            end
      end
      for _, content in pairs(self) do
            run(content)
      end
end
main()