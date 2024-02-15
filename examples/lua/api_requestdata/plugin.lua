local log = require('log')

return function(reproxy)
    reproxy.request.readBody()

    log.info('     reproxy.request.proto: ', reproxy.request.proto)
    log.info('    reproxy.request.method: ', reproxy.request.method)
    log.info('reproxy.request.remoteAddr: ', reproxy.request.remoteAddr)
    log.info('reproxy.request.requestURI: ', reproxy.request.requestURI)
    log.info('      reproxy.request.host: ', reproxy.request.host)
    log.info('       header content-type: ', reproxy.request.header.get('content-type'))
    log.info('      reproxy.request.body: ', reproxy.request.body)

    reproxy.request.header.set('X-Foo', 'bar')
    reproxy.request.header.delete('user-agent')

    reproxy.next()
end
