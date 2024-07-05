extends Node2D

# Constants for the different tile types
enum TileType { GRASS, DIRT, WATER, SAND }

# Tile size
const TILE_SIZE = 16

# View distance (how far the terrain generates around the player)
const VIEW_DISTANCE = 10

# Noise object for terrain generation
var noise = FastNoiseLite.new()

# Dictionary to store generated chunks
var generated_chunks = {}

# Reference to the player node
@onready var player = get_parent().get_node("Player")

# Reference to the tilemap node
@onready var terrain = get_parent().get_node("Terrain")

func _ready():
	# Configure noise parameters
	noise.seed = randi()
	#noise.octaves = 4
	#noise.period = 20.0
	#noise.persistence = 0.5

	# Generate initial terrain
	update_terrain()

func _process(delta):
	update_terrain()

func update_terrain():
	# Get the player's current position in tile coordinates
	var player_tile_pos = Vector2(
		int(player.position.x / TILE_SIZE),
		int(player.position.y / TILE_SIZE)
	)

	# Determine the chunk position
	var chunk_size = 16
	var player_chunk_pos = Vector2(
		int(player_tile_pos.x / chunk_size),
		int(player_tile_pos.y / chunk_size)
	)

	# Generate chunks around the player
	for x in range(player_chunk_pos.x - VIEW_DISTANCE, player_chunk_pos.x + VIEW_DISTANCE + 1):
		for y in range(player_chunk_pos.y - VIEW_DISTANCE, player_chunk_pos.y + VIEW_DISTANCE + 1):
			var chunk_pos = Vector2(x, y)
			if not generated_chunks.has(chunk_pos):
				generate_chunk(chunk_pos, chunk_size)


func generate_chunk(chunk_pos, chunk_size):
	for x in range(chunk_size):
		for y in range(chunk_size):
			var tile_x = chunk_pos.x * chunk_size + x
			var tile_y = chunk_pos.y * chunk_size + y
			var tile_type = choose_tile_type(tile_x, tile_y)
			if tile_type == "grass":
				terrain.set_cell(0, Vector2(tile_x, tile_y), 0, Vector2i(0, 2))
			elif tile_type == "flower":
				terrain.set_cell(0, Vector2(tile_x, tile_y), 0, Vector2i(1, 2))
			elif tile_type == "water":
				terrain.set_cell(0, Vector2(tile_x, tile_y), 0, Vector2i(2, 2))
			
				
	generated_chunks[chunk_pos] = true


func choose_tile_type(x, y):
	var type : String = ""
	# Get noise value for the position
	var noise_value = noise.get_noise_2d(x, y)
	# Choose tile type based on noise value ranges
	if noise_value > 0:
		type = "grass"
	elif noise_value > -0.2:
		type = "flower"
	else:
		type = "water"
		
	return type
