local lib = require('./lib')

return function(reproxy)
    local res = lib.mul(2, 3)

    reproxy.response.header.add('mul-res', res)

    reproxy.next({ captureResponse = true })
end
