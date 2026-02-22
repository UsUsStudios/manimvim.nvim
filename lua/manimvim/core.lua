local M = {}

local previous = ""

function M.render()
	local scenes = { "hi", "hello" }
	if previous ~= "" then
		table.insert(scenes, 1, previous .. " (last picked)")
	end

	vim.ui.select(scenes, {
		prompt = "Select a scene to render: ",
	}, function(choice)
		if choice then
			print("selected " .. choice)
			if choice ~= previous .. " (last picked)" then
				previous = choice
			end
		else
			print("cancelled")
		end
	end)
end

return M
