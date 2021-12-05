lu = require('luaunit')

Test = {}

function Test:test_1()
    lu.assert_equals(true, false)
end

function Test:test_solve_part_one()
    local input = 'foo'
    lu.assert_equals(true, false)
end

function Test:test_solve_part_two()
    local input = 'foo'
    lu.assert_equals(true, false)
end

os.exit(lu.run())
