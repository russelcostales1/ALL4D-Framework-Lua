--@Author: Russel Costales

local rep = game:GetService("ReplicatedStorage")

local Network = {_events = {}; direct = require(rep.shared.internal.network)}

function Network:_checkDataTypes(passedArgumentName)
      if not typeof(passedArgumentName) == "string" then
            error(("Attempt to fire but passed arg @name is not type (string"))
      end
      if not self._events[passedArgumentName] then
            error(("No event found with name %s"):format(passedArgumentName))
      end
end

function Network:connect(name, callback)
      self:_checkDataTypes(name)
      if typeof(callback) ~= "function" then
            error("Network connect argument @callback is not a function")
      end
      if self._events[name]:IsA("RemoteEvent") then
            self._events[name].OnClientEvent:Connect(callback)
      end
end

function Network:fire(name, ...)
      self:_checkDataTypes(name)
      self._events[name]:FireServer(...)
end

function Network:invoke(name, ...)
      self:_checkDataTypes(name)
      return self._events[name]:InvokeServer(...)
end

function Network:_main()
      for _, remote in ipairs(rep.shared.internal.remotes:GetChildren()) do
            self._events[remote.Name] = remote
      end
      self._main = nil
end
Network:_main()

return Network