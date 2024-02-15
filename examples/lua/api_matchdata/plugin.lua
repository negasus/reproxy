local log = require('log')

return function(reproxy)
    log.info('            reproxy.route.destination: ', reproxy.route.destination)
    log.info('                  reproxy.route.alive: ', reproxy.route.alive)
    log.info('          reproxy.route.mapper.server: ', reproxy.route.mapper.server)
    log.info('        reproxy.route.mapper.srcMatch: ', reproxy.route.mapper.srcMatch)
    log.info('             reproxy.route.mapper.dst: ', reproxy.route.mapper.dst)
    log.info('      reproxy.route.mapper.providerID: ', reproxy.route.mapper.providerID)
    log.info('        reproxy.route.mapper.pingURL: ', reproxy.route.mapper.pingURL)
    log.info('      reproxy.route.mapper.matchType: ', reproxy.route.mapper.matchType)
    log.info('   reproxy.route.mapper.redirectType: ', reproxy.route.mapper.redirectType)
    log.info(' reproxy.route.mapper.assetsLocation: ', reproxy.route.mapper.assetsLocation)
    log.info('  reproxy.route.mapper.assetsWebRoot: ', reproxy.route.mapper.assetsWebRoot)
    log.info('      reproxy.route.mapper.assetsSPA: ', reproxy.route.mapper.assetsSPA)

    reproxy.next()
end
