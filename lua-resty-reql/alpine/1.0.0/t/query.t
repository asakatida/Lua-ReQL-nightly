use Test::Nginx::Socket::Lua;

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
        local m = require 'Test.More'

        local reql_db = 'dbtest'
        local reql_table = 'test'
        local document_name = 'test document'
        local document = {
          name = document_name
        }

        m.plan('no_plan')

        local c, conn_err = r.connect('127.0.0.1')

        if conn_err then
          m.ok(false, conn_err.message())
        else
          m.type_ok(c, 'table', 'Connection failed')
        end

        if c then
          -- init db
          r.reql.db_create(reql_db).run(c).to_array()
          c.use(reql_db)
          local cur, err = r.reql.table_create(reql_table).run(c)

          m.type_ok(cur, 'table', err and err.message() or 'no message')

          if cur then
            cur.to_array()

            -- remove data
            cur, err = r.reql.table(reql_table).delete().run(c)

            m.type_ok(cur, 'table', err and err.message() or 'no message')

            if cur then
              cur.to_array()

              -- insert doc
              cur, err = r.reql.table(reql_table).insert(document).run(c)

              m.type_ok(cur, 'table', err and err.message() or 'no message')

              if cur then
                _, err = cur.to_array()

                m.type_ok(err, 'nil', err and err.message() or 'no message')

                if cur then
                  cur, err = r.reql.table(reql_table).run(c)

                  m.type_ok(cur, 'table', err and err.message() or 'no message')

                  if cur then
                    local arr, err = cur.to_array()

                    m.is_deeply(arr and #arr, 1, err and err.message() or 'Wrong array length')

                    m.is_deeply(arr[1], document, err and err.message() or 'no message')
                  end
                end
              end
            end
          end
        end

        m.done_testing()
      ";
    }
--- request
GET /t
--- response_body: pass
--- no_error_log
[error]
