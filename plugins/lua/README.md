# Lua Plugins

## About

> todo

You can see examples in [examples](../../examples/lua) directory.

## Usage

```bash
reproxy --lua.enabled --lua.file=/path/to/plugin1.lua --lua.file=/path/to/plugin2.lua
```

Lua script should return a function that accepts `reproxy` object as an argument.

```lua
return function(reproxy)
    reproxy.next()
end
```

## reproxy

`reproxy` allows you to access and modify request and response data.

### Match data

```
reproxy.route.destination                   readonly, string
reproxy.route.alive                         readonly, bool
reproxy.route.mapper.server                 readonly, string
reproxy.route.mapper.srcMatch               readonly, string
reproxy.route.mapper.dst                    readonly, string
reproxy.route.mapper.providerID             readonly, string
reproxy.route.mapper.pingURL                readonly, string
reproxy.route.mapper.matchType              readonly, number
reproxy.route.mapper.redirectType           readonly, number
reproxy.route.mapper.assetsLocation         readonly, string
reproxy.route.mapper.assetsWebRoot          readonly, string
reproxy.route.mapper.assetsSPA              readonly, bool
```

### Request

```
reproxy.request.proto                                   readonly, string
reproxy.request.method                                  readonly, string
reproxy.request.remoteAddr                              readonly, string
reproxy.request.requestURI                              readonly, string
reproxy.request.host                                    readonly, string
reproxy.request.readBody()                              callable, fill reproxy.request.body field, returns error
reproxy.request.body                                    read (without readBody() returns nil) / write
reproxy.request.header.get(name)                        callable, returns string value
reproxy.request.header.set(name, value)                 callable
reproxy.request.header.add(name, value)                 callable
reproxy.request.header.delete(name)                     callable
reproxy.request.header.each(function(key, value))       callable
```

### Response

> For interaction with response fields you must call `next` function with `captureResponse = true` option
> ```lua
> return function(reproxy)
>   reproxy.next({ captureResponse = true })
> end
> ```

```
reproxy.response.statusCode                             read/write, number
reproxy.response.body                                   read/write, string
reproxy.response.header.get(name)                       callable, returns string
reproxy.response.header.set(name, value)                callable
reproxy.response.header.add(name, value)                callable
reproxy.response.header.delete(name)                    callable
reproxy.response.header.each(function(key, value))      callable
```

### Next

You should call `next` function to pass request to the next plugin or to the destination server.

```
reproxy.next(options)                       callable, options is not required
```

Available options

```
{
  captureResponse: true                     default: false
}
```

Use `captureResponse` option to capture response data. After calling `next` function, you can access/modify response data.

## Modules

Reproxy provides some modules that can be used in Lua plugins.

### log

Print log messages to the reproxy log stdout.

```
local log = require('log')

log.debug(args...)                          callable
log.info(args...)                           callable
log.warn(args...)                           callable
log.error(args...)                          callable
```

### kv

Module KV allows you to store data in key-value storage. At the moment, data is stored in memory and is not persistent. 
If you want to use different storage, for example, Redis, you can implement your own KV module or create an issue.

All KV data is shared between all plugins and all requests.

> `key` and `value` should be strings

```
local kv = require('kv')

kv.set(key, value, [timeout])               callable, returns error
kv.get(key)                                 callable, returns value and error
kv.delete(key)                              callable, returns error
kv.update(key, value)                       callable, returns error
```

Not required argument `timeout` for `set` function should have format go duration string. See more about the format [here](https://golang.org/pkg/time/#ParseDuration). 
If `timeout` is specified, then `value` will be deleted after `timeout`.

### http

Module HTTP allows you to make HTTP requests.

```
local http = require('http')

http.MethodGet                              returns GET
http.MethodHead                             returns HEAD             
http.MethodPost                             returns POST
http.MethodPut                              returns PUT
http.MethodPatch                            returns PATCH
http.MethodDelete                           returns DELETE
http.MethodConnect                          returns CONNECT
http.MethodOptions                          returns OPTIONS
http.MethodTrace                            returns TRACE

http.get(url)                               callable, returns response and error
http.post(url, contentType, body)           callable, returns response and error
http.request(method, url, [options])        callable, returns response and error
```

Available options for methods `request`. All fields are not required

```
{
    timeout = '30s',                        go duration string, default 30s
    body = '',                              string, default empty
    headers = {                             string/string table, default empty
        ['Content-Type'] = 'application/json',
        Authorization = 'foobar'            
    }
}
```

Response object

```
{
    code = 200,
    body = 'response body content',
    headers = {
        key = value
    }
}
```
