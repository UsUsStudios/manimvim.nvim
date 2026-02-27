local M = {}

local previous = ""

function M.render_no_args(play)
	M.render({ M.config.rendering.quality }, play)
end

function M.render(args, play) -- args is quality
	local scenes = M.get_scenes()
	if previous ~= "" and has_value(scenes, previous) then
		table.insert(scenes, 1, previous .. " (last picked)")
	end

	vim.ui.select(scenes, {
		prompt = "Select a scene to render: ",
	}, function(choice)
		if choice then
			if choice ~= previous .. " (last picked)" then
				previous = choice
				M.render_scene(choice, args, play)
			else
				M.render_scene(previous, args, play)
			end
		else
			print("Render cancelled")
		end
	end)
end

function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true -- Item found
		end
	end
	return false -- Item not found after checking all elements
end

function M.get_scenes()
	local cmd = string.format(
		[[python3 -c "
import ast
with open('%s') as f:
    tree = ast.parse(f.read())
    print('\\n'.join([n.name for n in ast.walk(tree) if isinstance(n, ast.ClassDef) and not n.name.startswith('_')]))
"]],
		vim.fn.expand("%:p")
	)

	local result = vim.fn.system(cmd)

	if vim.v.shell_error == 0 then
		local classes = vim.split(result, "\n")
		if classes[#classes] == "" then
			table.remove(classes)
		end
		return classes
	end
	return {}
end

function M.get_current_python()
	-- Check if we're already in a virtual environment
	local has_venv = vim.fn.exists("$VIRTUAL_ENV") == 1
	if has_venv then
		local venv = os.getenv("VIRTUAL_ENV")
		print("Currently in virtual environment: " .. venv)

		local python_paths = {
			-- Unix/Linux/macOS
			venv .. "/bin/python3",
			venv .. "/bin/python",
			-- Windows
			venv .. "/Scripts/python.exe",
			venv .. "/Scripts/python",
		}

		for _, path in ipairs(python_paths) do
			if vim.fn.filereadable(path) == 1 and vim.fn.executable(path) == 1 then
				return path
			end
		end
		return nil
	end

	-- Check which Python is being used
	local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
	if python_path then
		return python_path
	end

	return nil
end

function M.render_scene(scene, quality, play)
	local filename = vim.fn.expand("%:p")
	local python = M.get_current_python()
	if python then
		if play then
			vim.cmd("!" .. python .. " -m manim -pq" .. quality .. " " .. filename .. " " .. scene)
		else
			vim.cmd("!" .. python .. " -m manim -q" .. quality .. " " .. filename .. " " .. scene)
		end
	end
end

return M
