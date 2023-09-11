#!/usr/bin/env lua

local inspect = require 'inspect'

--[[
local function assert()
    print()
    print()
end
--]]

--assert = assert

-- Сравнивает два аргумента рекурсивно на равенство. Возвращает истину если
-- все элементы таблицы равны между собой. 
-- XXX: userdata и thread ?
function EQ(t1, t2) 
    print('t1, t2', t1, t2)
    if type(t1) == "table" and type(t2) == "table" then
        local index1, value1 = next(t1, nil)
        print('     index1, value1', index1, value1)

        -- Случай двух пустых таблиц
        if not index1 and not value1 then
            local index2, value2 = next(t2, nil)
            print('     index2, value2', index2, value2)
            if not index2 and not value2 then
                print("tr")
                return true
            else
                print("fls")
                return false
            end
        end

        print('t1', inspect(t1))
        print('t2', inspect(t2))
       
        -- Таблица с суффиксом _mod предназначена для модификации
        local values2keys1, values2keys1_mod = {}, {}
        while index1 do
            values2keys1[value1] = true
            values2keys1_mod[value1] = true
            index1, value1 = next(t1, index1)
        end
        print('values2keys1', inspect(values2keys1))

        -- Таблица с суффиксом _mod предназначена для модификации
        local values2keys2, values2keys2_mod = {}, {}
        index2, value2 = next(t2, index2)
        while index2 do
            values2keys2[value2] = true
            values2keys2_mod[value2] = true
            index2, value2 = next(t2, index2)
        end
        print('values2keys2', inspect(values2keys2))

        local tmp_index, tmp_value = next(values2keys1, nil)
        while tmp_index do
            -- Здесь происходит поиск, сравнение и удаление. Сравнение
            -- заменить вызовом EQ() для тождественности пустых таблиц
            --if EQ(tmp_index, values2keys2_mod[tmp_index]) then
            do
                -- TODO: использовать значения, а не индекс
                values2keys2_mod[tmp_index] = nil
            end
            tmp_index, tmp_value = next(values2keys1, tmp_index)
        end

        local tmp_index, tmp_value = next(values2keys2, nil)
        while tmp_index do
            --if EQ(tmp_index, values2keys1_mod[tmp_index]) then
            do
                values2keys1_mod[tmp_index] = nil
            end
            tmp_index, tmp_value = next(values2keys2, tmp_index)
        end
        
        print('values2keys1_mod', inspect(values2keys1_mod))
        print('values2keys2_mod', inspect(values2keys2_mod))

        local mod1_num = 0
        local tmp_index, tmp_value = next(values2keys2_mod, nil)
        while tmp_index do
            mod1_num = mod1_num + 1
            tmp_index, tmp_value = next(values2keys2_mod, tmp_index)
        end

        local mod2_num = 0
        local tmp_index, tmp_value = next(values2keys1_mod, nil)
        while tmp_index do
            mod2_num = mod2_num + 1
            tmp_index, tmp_value = next(values2keys1_mod, tmp_index)
        end

        print("mod1_num", mod1_num)
        print("mod2_num", mod2_num)

        return mod1_num == 0 and mod2_num == 0 

    elseif type(t1) == type(t2) and t1 == t2 then
        -- XXX: userdata и thread ?
        return true
    end

    return false
end

local tmp1 = {[-1] = "D", 1, 2, 3, "HUI", sub = { 0, 3, "Z", function() end }, }
local tmp2 = {[-1] = "D", 1, 2, 3, "HUI", sub = { 0, 3, "Z", function() end }, }

--[[
local index, value1 = next(tmp1, nil)
while index do
    print('index, value1', index, value1)
    index, value1 = next(tmp1, index)
    local value2 = tmp2[index]
    --if (type(value1) ==
end

local index, value = next(tmp2, nil)
while index do
    print('index, value', index, value)
    index, value = next(tmp2, index)
end
--]]

if function() end == function() end then
    print("functions are equal")
else
    print("this is different function")
end

local function F()
end
local ref_F = F;

if F == ref_F then
    print("function and its reference are equal")
end

assert(EQ(1, 1) == true)
assert(EQ(1, 0) == false)
assert(EQ("1", 0) == false)
assert(EQ("1", false) == false)

assert(EQ("s1", "s1") == true)
assert(EQ("", "s1") == false)

assert(EQ(true, false) == false)
assert(EQ(false, false) == true)
assert(EQ(true, true) == true)

assert(EQ(function() end, function() end) == false)
assert(EQ(F, ref_F) == true)

assert(EQ({}, {}) == true)
assert(EQ({3, 2, 1}, {3, 2, 1}) == true)

--      ключ
--        |  значение
--        ↓    ↓
-- t1 = {[1] = 3, [2] = 2, [3] = 1}
-- t2 = {[1] = 1, [2] = 2, [3] = 3}) == true)
assert(EQ({3, 2, 1}, {1, 2, 3}) == true)
assert(EQ({3, 2}, {3, 2, 1}) == false)
assert(EQ({"G", "O", "V", }, {"O", "G", "V"}) == true)
assert(EQ({"G", "", "V", }, {"O", "G", "V"}) == false)
assert(EQ({1, true}, {true, 1}) == true)
assert(EQ({{}}, {{}}) == true)
assert(EQ({{1}}, {{1}}) == true)
assert(EQ(  {{1, { k = 1}}},
            {{{k = 1}, 1}}) == true)

assert(EQ(
    { k = {1, 2, 3}},
    { k = {1, 2, 3}}
), true)
assert(EQ(
    { k = {1, 2, 3}},
    { k = {3, 1, 2}}
), true)
assert(EQ(
    { k = {1, 2, 3}},
    { _k = {3, 1, 2}}
), false)
assert(EQ(
    { k = {1, 2, 3}},
    { _k = {}}
), false)
