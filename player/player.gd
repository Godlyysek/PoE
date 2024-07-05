extends CharacterBody2D

var speed = 75.0

@onready var player_sprite : Sprite2D = get_node("Sprite2D")
var flipped = false

var stamina = 50
var base_health = 50

var level = 1
var xp = 0
var xp_needed = 100


func _ready():
	player_sprite = get_node("Sprite2D")


func _physics_process(delta):
	movement()


func movement():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if(direction):
		velocity = direction * speed  # Changed from position update to velocity
		
		if direction.x < 0 and not flipped:  # Combined conditions to a single line
			flipped = true
			player_sprite.flip_h = true
		elif direction.x > 0 and flipped:  # Combined conditions to a single line
			flipped = false
			player_sprite.flip_h = false

	else:
		velocity = Vector2.ZERO
		
	move_and_slide()  # Use velocity for movement








# PLAYER STATS

var base_physical_damage = 10 * self.level
var base_inc_physical_damage = 1
var base_more_physical_damage = 1

var base_magic_damage = 1
var base_inc_magic_damage = 1
var base_more_magic_damage = 1

var base_true_damage = 1
var base_inc_true_damage = 1
var base_more_true_damage = 1

var base_attack_speed = 1
var base_inc_attack_speed = 1
var base_more_attack_speed = 1

var base_cast_speed = 1
var base_inc_cast_speed = 1
var base_more_cast_speed = 1

var base_inc_damage_over_time = 1
var base_damage_over_time_multiplier = 1

var base_move_speed_multiplier = 1

# PROJECTILE STATS

var base_projectile_speed_multiplier = 1
var base_projectile_number = 1
var base_projectile_damage_multiplier = 1
var base_projectile_pierce = 0


