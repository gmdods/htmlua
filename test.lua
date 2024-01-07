local html = require "html"

local test_div = html.div {
	html.p { "Hello" }, html.p { "World" }, html.p { hidden = true, "!" } }
assert(tostring(test_div) == "<div><p>Hello</p><p>World</p><p hidden>!</p></div>", "div")

local test_style = html.div {
	class = { "great", "awesome" },
	html.p { "Hello" }, html.p { style = { ["color"] = "blue" }, "World" } }
assert(tostring(test_style) == "<div class=\"great awesome\"><p>Hello</p>" ..
	"<p style=\"color: blue;\">World</p></div>", "styles")

local test_a = html.a {
	href = "https://www.lua.org", class = { "link" }, "Link" }
assert(tostring(test_a) ==
	"<a class=\"link\" href=\"https://www.lua.org\">Link</a>", "a")

local test_button = html.button {
	class = { "click" }, onclick = { "add(this)" }, "Click" }
assert(tostring(test_button) ==
	"<button class=\"click\" onclick=\"add(this)\">Click</button>", "button")

print("end")
