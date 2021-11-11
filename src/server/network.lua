--@Author: Russel Costales
-- I like wrapping

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

function Network:register(name, canYield)
      self._events[name] = canYield and Instance.new("RemoteFunction")  or Instance.new("RemoteEvent")
      self._events[name].Parent = rep.shared.internal.remotes
      self._events[name].Name = name
end

function Network:connect(name, callback)
      self:_checkDataTypes(name)
      if typeof(callback) ~= "function" then
            error("Network connect argument @callback is not a function")
      end
      if self._events[name]:IsA("RemoteEvent") then
            self._events[name].OnServerEvent:Connect(callback)
      elseif self._events[name]:IsA("RemoteFunction") then
            self._events[name].OnServerInvoke = callback
      end
end

function Network:fireAll(name, ...)
      self:_checkDataTypes(name)
      self._events[name]:FireAllClients(...)
end

function Network:fire(name, player, ...)
      self:_checkDataTypes(name)
      self._events[name]:FireClient(player, ...)
end

function Network:closeRegistry()
      self.register = function()
            warn("Cannot register an event past initialization!")
      end
end

return Network