use Test::Nginx::Socket::Lua;

plan tests => repeat_each() * (3 * blocks());

our $HttpConfig = <<'_EOC_';
    lua_package_path 'src/?.lua;src/?/?.lua;;';
    error_log logs/error.log debug;
_EOC_

no_long_string();

run_tests();

__DATA__

=== Query
--- http_config eval: $::HttpConfig
--- config
    location /t {
      content_by_lua "
        local r = require 'rethinkdb'

        local reql_db = 'dbtest'
        local reql_table = 'test'
        local document_name = 'test document'
        local document = {
          name = document_name
        }

        local c, conn_err = r.connect()

        if conn_err then
          ngx.print(conn_err.msg)
          error(conn_err.message())
        end

        assert(c, 'Connection failed')

        -- init db
        r.reql.db_create(reql_db).run(c).to_array()
        c.use(reql_db)
        local cur, err = r.reql.table_create(reql_table).run(c)

        if err then
          error(err.message())
        end

        cur.to_array()

        -- remove data
        cur, err = r.reql.table(reql_table).delete().run(c)

        if err then
          error(err.message())
        end

        cur.to_array()

        -- insert doc
        cur, err = r.reql.table(reql_table).insert(document).run(c)

        if err then
          error(err.message())
        end

        _, err = cur.to_array()

        if err then
          error(err.message())
        end

        cur, err = r.reql.table(reql_table).run(c)

        if err then
          error(err.message())
        end

        local arr, err = cur.to_array()

        if err then
          error(err.message())
        end

        assert(#arr == 1, 'Wrong array length')

        assert(arr[1].name == document_name, 'Wrong document name')

        ngx.print('pass')
      ";
    }
--- request
GET /t
--- response_body: pass
--- no_error_log
[error]
