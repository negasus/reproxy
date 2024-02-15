local log = require('log')
local kv = require('kv')

return function(reproxy)
    local k, err = kv.get('foo')
    if err then
        k = '0'
        kv.set('foo', k)
    end
    local v = tonumber(k)

    v = v + 1

    kv.update('foo', tostring(v))

    log.info('request #', v)

    reproxy.next()
end
