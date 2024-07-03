extends TileMap

var size = 200
var fnl := FastNoiseLite.new()

func _ready():
	fnl.seed = randi()
	generate_map()
	
	
func generate_map():
	for x in size:
		for y in size:
			var noise_value = fnl.get_noise_2d(x, y)
			if noise_value < 0.2:
				set_cell(0, Vector2i(x, y), 0, Vector2(1, 1))
