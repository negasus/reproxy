local kv = require('kv')
local log = require('log')

-- limit 5 requests per 10 seconds per IP

local limitCount = 5
local limitDuration = '10s'

return function(reproxy)

    -- get IP from remoteAddr like 1.2.3.4:10203
    local ip = string.sub(reproxy.request.remoteAddr, 1, string.find(reproxy.request.remoteAddr, ":") - 1)

    local key = 'RATE_LIMIT_' .. ip

    local count, errCount = kv.get(key)
    if errCount ~= nil then
        -- if variable is not exists (or storage error), set counter to 1 and continue request
        local errSet = kv.set(key, tostring(1), limitDuration)
        if errSet ~= nil then
            log.error('error set kv', key, errSet)
        end
        reproxy.next()
        return
    end

    local c = tonumber(count)

    if c >= limitCount then
        reproxy.response.statusCode = 429
        return
    end

    local errUpdate = kv.update(key, tostring(c + 1))
    if errUpdate ~= nil then
        log.error('error update kv', key, errUpdate)
    end

    reproxy.next()
end

