--@Author: Russel Costales
-- Bindable stuff to prevent direct references

local NetworkShared = {_events = {}}
local mt = {__index = NetworkShared}

function NetworkShared:connect(name, callback)
      if typeof(name) ~= "string" then
            error(("Attempt to connect an event but passed name is not type (string"))
      end
      if not self._events[name] then
            error(("Cannot find bindable with name %s to connect to"):format(name))
      end
      if self._events[name]:IsA("BindableEvent") then
            self._events[name].Event:Connect(callback)
      elseif self._events[name]:IsA("BindableFunction") then
            self._events[name].OnInvoke = callback
      end
end

function NetworkShared:invoke(name, ...)
      if typeof(name) ~= "string" then
            error(("Attempt to fire an event but passed name is not type (string"))
      end
      if not self._events[name] then
            error(("No bindable with name %s"):format(name))
      end
      return self._events[name]:Invoke(name, ...)
end

function NetworkShared:fire(name, ...)
      if typeof(name) ~= "string" then
            error(("Attempt to fire an event but passed name is not type (string"))
      end
      if not self._events[name] then
            error(("No bindable with name %s"):format(name))
      end
      self._events[name].Event:Fire(name, ...)
end

function NetworkShared:create(name, canYield)
      if typeof(name) ~= "string" then
            error(("Attempt to create a bindable but passed name is not type (string)"))
      end
      if self._events[name] then
            error(("Created an existing bindable: %s"):format(name))
      end
      self._events[name] = canYield and Instance.new("BindableFunction") or Instance.new("BindableEvent")
end

return NetworkShared