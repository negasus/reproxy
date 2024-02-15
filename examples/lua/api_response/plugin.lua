local log = require('log')

return function(reproxy)
    reproxy.next({ captureResponse = true })

    log.info('reproxy.response.statusCode: ', reproxy.response.statusCode)
    log.info('      reproxy.response.body: ', reproxy.response.body)
    log.info('      header content-length: ', reproxy.response.header.get('content-length'))

    reproxy.response.header.set('X-Bar', 'baz')
    reproxy.response.statusCode = 201
    reproxy.response.body = 'new response body'
end
