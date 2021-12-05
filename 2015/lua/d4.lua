lu = require('luaunit')
md5 = require('md5')

function validate_hash(hash, zeroes)
    return hash:sub(1, zeroes) == ('0'):rep(zeroes)
end

function mine_hash(secret, zeroes)
    local i = 0
    repeat
        i = i + 1
        local hash = md5.sumhexa(secret .. i)
    until validate_hash(hash, zeroes)
    return i
end

Test = {}

function Test:test_validate_hash()
    lu.assert_equals(validate_hash('000001dbbfa', 5), true)
    lu.assert_equals(validate_hash('010001dbbfa', 5), false)
end

function Test:test_mine_hash()
    local secret = 'abcdef'
    lu.assert_equals(mine_hash(secret, 5), 609043)
end

function Test:test_solve_part_one()
    local secret = 'bgvyzdsv'
    lu.assert_equals(mine_hash(secret, 5), 254575)
end

function Test:test_solve_part_two()
    local secret = 'bgvyzdsv'
    lu.assert_equals(mine_hash(secret, 6), 1038736)
end

os.exit(lu.run())
