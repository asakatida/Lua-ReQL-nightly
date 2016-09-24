use Test::Nginx::Socket::Lua;

plan tests => repeat_each() * (3 * blocks());

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

        local c, err = r.connect()

        if err then
          ngx.print(err.msg)
          error(err.message())
        end

        assert(c, 'Connection failed')

        ngx.print('pass')
      ";
    }
--- request
GET /t
--- response_body: pass
--- no_error_log
[error]
