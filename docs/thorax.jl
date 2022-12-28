### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 82e9b800-86da-11ed-20bc-5968599a7ca2
# ╠═╡ show_logs = false
begin
	using Pkg; Pkg.activate(".")
	using Revise, PlutoUI, ImagePhantoms, CairoMakie, Unitful, Images, FileIO, ImageGeoms
	using Unitful: mm, unit, °
end

# ╔═╡ 922209eb-35da-4a35-a294-4f4efbdf90de
TableOfContents()

# ╔═╡ 1464a84a-82fd-4789-8b57-6134c54d6db5
load(joinpath(pwd(), "images", "thorax-diagram.jpg"))

# ╔═╡ 004cf339-53f2-4571-b0ce-8e287905390f
md"""
*Note, the depth is 100 mm*. [Ref](https://www.qrm.de/en/products/thorax-phantom/?type=3451&downloadfile=1720&cHash=27fd6589a8800d48c23d0653841d8d7a)
"""

# ╔═╡ 48c6064c-b05d-49f2-bceb-26ddb5812efb
begin
	deltas = (1mm, 1mm, 1mm)
	dims = (512, 512, 200) # odd
	oversample = 3
end

# ╔═╡ 501d202f-7809-4761-a0ee-c7a658c123df
md"""
## Cuboid Part
"""

# ╔═╡ 43781c94-ba9b-40a3-ac8c-2ae6b3afa847
begin
	center_cuboid = (0mm, 0mm, 0mm)
	width_cuboid = (100mm, 200mm, 100mm)
	angles_cuboid = (0, 0, 0)
	ob_cuboid = cuboid(center_cuboid, width_cuboid, angles_cuboid, 1.0)
end

# ╔═╡ e28b91be-bab8-4c82-b7ce-7f58dfd64791
begin
	ig_cuboid = ImageGeom( ; dims=dims, deltas=deltas, offsets=(0, 0, 0))
	img_cuboid = phantom(axes(ig_cuboid)..., [ob_cuboid])
end;

# ╔═╡ 4b15d4e7-af3f-486a-950c-ba1521b506d3
ig_cuboid

# ╔═╡ accfdc25-36cc-44c6-874b-0cc6b77f40ee
@bind a PlutoUI.Slider(axes(img_cuboid, 3); default=100, show_value=true)

# ╔═╡ 44780f72-660d-4143-85cc-24adca73c222
heatmap(img_cuboid[:, :, a], colormap=:grays)

# ╔═╡ 6b2ed880-de65-4d06-a69d-fbc50e7c5b6d
unique(img_cuboid)

# ╔═╡ d4cda9b6-c05c-4cc0-87d9-7ee51a2bf4d4
md"""
## Left Large Cylinder
"""

# ╔═╡ 13ca6985-8e18-49f3-b6c3-3b3722624c73
begin
	center_left_cyl = (0mm, 0mm, 0mm)
	width_left_cyl = (200mm, 100mm, 100mm)
	angles_left_cyl = (0, 0, 0)
	ob_left_cyl = cylinder(center_left_cyl, width_left_cyl, angles_left_cyl, 1.0f0)
end

# ╔═╡ 571fb81e-20a4-4fd3-8bcf-cfb1f7ab1fb5
begin
	ig_left_cyl = ImageGeom( ; dims=dims, deltas=deltas)
	img_left_cyl = phantom(axes(ig_left_cyl)..., [ob_left_cyl])
end;

# ╔═╡ 24867d19-1dec-4e4c-8dd4-4ff2842c5ee2
ig_left_cyl

# ╔═╡ 3322e62a-95fc-4e23-bb55-67834b45b2b4
@bind b PlutoUI.Slider(axes(img_left_cyl, 3); default=100, show_value=true)

# ╔═╡ 02531f8d-f5d3-4ee7-aeb0-d8c3343ea9fc
heatmap(img_left_cyl[:, :, b], colormap=:grays)

# ╔═╡ 5f9112a0-a5eb-4a65-9f5c-003dc66785ef
unique(img_left_cyl)

# ╔═╡ 23378556-9811-4f87-a7ca-cf7a9a7cd4b0
md"""
## Combine
"""

# ╔═╡ 83817625-6937-4b82-8c10-abdb16c01fbc
objects = [ob_cuboid, ob_left_cyl]

# ╔═╡ 9d80ecc6-9d50-41b1-82d4-20cceeccc4fb
begin
	ig_comb = ImageGeom( ; dims=dims, deltas=deltas)
	img_comb = phantom(axes(ig_comb)..., objects)
end;

# ╔═╡ d82ab84b-10fb-4f79-af10-f301d4e66c66
@bind c PlutoUI.Slider(axes(img_comb, 3); default=100, show_value=true)

# ╔═╡ fafb9e91-153f-4309-aa90-93ffb6157454
heatmap(img_comb[:, :, c], colormap=:grays)

# ╔═╡ Cell order:
# ╠═82e9b800-86da-11ed-20bc-5968599a7ca2
# ╠═922209eb-35da-4a35-a294-4f4efbdf90de
# ╟─1464a84a-82fd-4789-8b57-6134c54d6db5
# ╟─004cf339-53f2-4571-b0ce-8e287905390f
# ╠═48c6064c-b05d-49f2-bceb-26ddb5812efb
# ╟─501d202f-7809-4761-a0ee-c7a658c123df
# ╠═43781c94-ba9b-40a3-ac8c-2ae6b3afa847
# ╠═e28b91be-bab8-4c82-b7ce-7f58dfd64791
# ╠═4b15d4e7-af3f-486a-950c-ba1521b506d3
# ╟─accfdc25-36cc-44c6-874b-0cc6b77f40ee
# ╟─44780f72-660d-4143-85cc-24adca73c222
# ╠═6b2ed880-de65-4d06-a69d-fbc50e7c5b6d
# ╟─d4cda9b6-c05c-4cc0-87d9-7ee51a2bf4d4
# ╠═13ca6985-8e18-49f3-b6c3-3b3722624c73
# ╠═571fb81e-20a4-4fd3-8bcf-cfb1f7ab1fb5
# ╠═24867d19-1dec-4e4c-8dd4-4ff2842c5ee2
# ╟─3322e62a-95fc-4e23-bb55-67834b45b2b4
# ╠═02531f8d-f5d3-4ee7-aeb0-d8c3343ea9fc
# ╠═5f9112a0-a5eb-4a65-9f5c-003dc66785ef
# ╟─23378556-9811-4f87-a7ca-cf7a9a7cd4b0
# ╠═83817625-6937-4b82-8c10-abdb16c01fbc
# ╠═9d80ecc6-9d50-41b1-82d4-20cceeccc4fb
# ╟─d82ab84b-10fb-4f79-af10-f301d4e66c66
# ╟─fafb9e91-153f-4309-aa90-93ffb6157454
