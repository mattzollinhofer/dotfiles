local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- def method
  s("def", {
    t("def "), i(1, "method_name"), t({"", "  "}), i(2),
    t({"", "end"})
  }),

  -- pry debug
  s("pry", { t("binding.pry") }),

  -- Rails logger
  s("log", { t("Rails.logger.debug "), i(1, '"message"') }),
}
