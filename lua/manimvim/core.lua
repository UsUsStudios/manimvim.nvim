local M = {}

local previous = ""

function M.render()
	local scenes = { "CreateCircle" }
	if previous ~= "" then
		table.insert(scenes, 1, previous .. " (last picked)")
	end

	vim.ui.select(scenes, {
		prompt = "Select a scene to render: ",
	}, function(choice)
		if choice then
			if choice ~= previous .. " (last picked)" then
				previous = choice
				M.render_scene(choice)
			else
				M.render_scene(previous)
			end
		else
			print("Render cancelled")
		end
	end)
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

function M.render_scene(scene)
	local filename = vim.fn.expand("%:p")
	local python = M.get_current_python()
	if python then
		vim.cmd("!" .. python .. " -m manim -pql " .. filename .. " " .. scene)
	end
end

return M
