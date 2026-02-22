local M = {}

function M.render()
	vim.ui.select({ "hello", "hi" }, {
		prompt = "Select a scene to render: ",
	}, function(choice)
		if choice then
			print("selected " .. choice)
		else
			print("cancelled")
		end
	end)
end

return M
