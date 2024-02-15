local kv = require('kv')
local log = require('log')

local cacheKey = 'CACHE_KEY'
local cacheTimeout = '1m'

return function(reproxy)
    local v, errGet = kv.get(cacheKey)
    if errGet == nil then
        reproxy.response.body = v
        return
    end

    reproxy.next({ captureResponse = true })

    local errSet = kv.set(cacheKey, reproxy.response.body, cacheTimeout)
    if errSet ~= nil then
        log.error('error set to kv', errSet)
    end
end
