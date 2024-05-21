return {
  {
    'stevearc/overseer.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'stevearc/dressing.nvim' },
    config = function()
      local overseer = require 'overseer'
      local log = require 'overseer.log'

      local function get_dofile(opts)
        local is_dofile = function(name)
          name = name:lower()
          return name == 'dofile' or name == '.dofile'
        end
        return vim.fs.find(is_dofile, { upward = true, type = 'file', path = opts.dir })[1]
      end
      local function get_nxconfig(opts)
        local is_nxconfig = function(name)
          name = name:lower()
          return name == 'nx.json'
        end
        return vim.fs.find(is_nxconfig, { upward = true, type = 'file', path = opts.dir })[1]
      end

      local nx = {
        name = 'nx',
        cache_key = function(opts)
          return get_nxconfig(opts)
        end,
        condition = {
          callback = function(opts)
            if vim.fn.executable 'nx' == 0 then
              return false, 'Command "nx" not found'
            end
            if not get_nxconfig(opts) then
              return false, 'No nx.json found'
            end
            return true
          end,
        },
        generator = function(opts, cb)
          local ret = {}
          local function nx(args, cbi)
            local jobid = vim.fn.jobstart({ 'nx', 'show', '--json', table.unpack(args) }, {
              cwd = opts.dir,
              stdout_buffered = true,
              on_stdout = vim.schedule_wrap(function(j, output)
                local ok, data = pcall(vim.json.decode, table.concat(output, ''))
                if not ok then
                  log:error('nx produced invalid json: %s\n%s', data, output)
                  cbi(nil)
                  return
                end
                assert(data)
                cbi(data)
              end),
            })
            if jobid == 0 then
              log:error "Passed invalid arguments to 'nx'"
              cbi(nil)
            elseif jobid == -1 then
              log:error "'nx' is not executable"
              cbi(nil)
            end
          end

          nx({ 'projects' }, function(projects)
            if projects == nil then
              cb(ret)
              return
            end

            local active = 0
            for _, project in ipairs(projects) do
              active = active + 1
              nx({ 'project', project }, function(data)
                if data == nil then
                  goto continue
                end
                for target_name, target in pairs(data.targets) do
                  table.insert(ret, {
                    name = string.format('nx run %s:%s', project, target_name),
                    -- desc = recipe.doc,
                    -- priority = k == data.first and 55 or 60,
                    priority = 60,
                    params = {},
                    builder = function(params)
                      local cmd = { 'nx', 'run', string.format('%s:%s', project, target_name) }
                      return {
                        cmd = cmd,
                      }
                    end,
                  })
                end
                ::continue::
                active = active - 1
                if active == 0 then
                  cb(ret)
                end
              end)
            end
          end)
        end,
      }
      local dofile = {
        name = 'dofile',
        cache_key = function(opts)
          return get_dofile(opts)
        end,
        condition = {
          callback = function(opts)
            if vim.fn.executable 'do' == 0 then
              return false, 'Command "do" not found'
            end
            if not get_dofile(opts) then
              return false, 'No dofile found'
            end
            return true
          end,
        },
        generator = function(opts, cb)
          local ret = {}
          local jid = vim.fn.jobstart({ 'do', '--unstable', '--dump', '--dump-format', 'json' }, {
            cwd = opts.dir,
            stdout_buffered = true,
            on_stdout = vim.schedule_wrap(function(j, output)
              local ok, data = pcall(vim.json.decode, table.concat(output, ''), { luanil = { object = true } })
              if not ok then
                log:error('do produced invalid json: %s\n%s', data, output)
                cb(ret)
                return
              end
              assert(data)
              for k, recipe in pairs(data.recipes) do
                if recipe.private then
                  goto continue
                end
                local params_defn = {}
                for _, param in ipairs(recipe.parameters) do
                  local param_defn = {
                    default = param.default,
                    type = param.kind == 'singular' and 'string' or 'list',
                    delimiter = ' ',
                  }
                  -- We don't want "star" arguments to be optional = true because then we won't show the
                  -- input form. Instead, let's set a default value and filter it out in the builder.
                  if param.kind == 'star' and param.default == nil then
                    if param_defn.type == 'string' then
                      param_defn.default = ''
                    else
                      param_defn.default = {}
                    end
                  end
                  params_defn[param.name] = param_defn
                end
                table.insert(ret, {
                  name = string.format('do %s', recipe.name),
                  desc = recipe.doc,
                  priority = k == data.first and 25 or 30,
                  params = params_defn,
                  builder = function(params)
                    local cmd = { 'do', recipe.name }
                    for _, param in ipairs(recipe.parameters) do
                      local v = params[param.name]
                      if v then
                        if type(v) == 'table' then
                          vim.list_extend(cmd, v)
                        elseif v ~= '' then
                          table.insert(cmd, v)
                        end
                      end
                    end
                    return {
                      cmd = cmd,
                    }
                  end,
                })
                ::continue::
              end
              cb(ret)
            end),
          })
          if jid == 0 then
            log:error "Passed invalid arguments to 'do'"
            cb(ret)
          elseif jid == -1 then
            log:error "'do' is not executable"
            cb(ret)
          end
        end,
      }

      overseer.register_template(dofile)
      overseer.register_template(nx)
      overseer.setup()
    end,
  },
}
