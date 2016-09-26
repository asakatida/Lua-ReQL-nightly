use Test::Nginx::Socket::Lua;

our $HttpConfig = <<'_EOC_';
    lua_package_path 'src/?.lua;src/?/?.lua;;';
    error_log logs/error.log debug;
_EOC_

no_long_string();

run_tests();

__DATA__

=== Connect
--- http_config eval: $::HttpConfig
--- config
    location /t {
      content_by_lua "
        local r = require 'rethinkdb'
        local m = require 'Test.More'

        m.plan('no_plan')

        local c, err = r.connect('127.0.0.1')

        if err then
          m.ok(false, err.message())
        else
          m.type_ok(c, 'table', 'Connection failed')
        end

        m.done_testing()
      ";
    }
--- request
GET /t
--- response_body: pass
--- no_error_log
[error]
