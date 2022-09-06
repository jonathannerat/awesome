local M = {}

--- Map table using ipairs to iterate the table
---@generic T
---@generic U
---@param t {[number]: T}
---@param f fun(value: T, index: number): U
---@return {[number]: U}
M.imap = function (t, f)
    local o = {}

    for i, v in ipairs(t) do
        o[i] = f(v, i)
    end

    return o
end

--- Map table using pairs to iterate the table
---@generic T
---@generic U
---@param t {[string]: T}
---@param f fun(value: T, key: string): U
---@return {[string]: U}
M.map = function (t, f)
    local o = {}

    for k, v in pairs(t) do
        o[k] = f(v, k)
    end

    return o
end

return M
