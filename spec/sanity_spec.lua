describe('sanity', function()
  it('test', function()
    local r = assert.is_table(require('rethinkdb'))
    if pcall(require, 'mm') then
      require'mm'(r)
    end
  end)
end)
