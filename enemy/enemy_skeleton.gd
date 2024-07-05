extends CharacterBody2D

const SPEED = 70.0

var player : CharacterBody2D
var player_position : Vector2

var player_detection_distance : int = 300

enum State { IDLE, FOLLOW, ATTACK }
var current_state = State.IDLE
var attack_timer = 0.0
var attack_cooldown


func _ready():
	player = get_parent().get_node("Player")
	player_position = player.position
	
	attack_cooldown = 1 / (base_attack_speed * base_increased_attack_speed)


func _physics_process(delta):
	if player:
		match current_state:
			State.IDLE:
				idle_state(delta)
			State.FOLLOW:
				follow_state(delta)
			State.ATTACK:
				attack_state(delta)


func idle_state(delta):
	# Transition to FOLLOW state if player is within detection range
	if is_player_in_range(player_detection_distance):
		current_state = State.FOLLOW


func follow_state(delta):
	if is_player_in_range(attack_range):
		# Transition to ATTACK state if player is within attack range
		current_state = State.ATTACK
		attack_timer = attack_cooldown
		velocity = Vector2.ZERO
	else:
		# Follow the player
		move_towards_player(delta)
		if !is_player_in_range(player_detection_distance):
			# Transition to IDLE state if player is out of detection range
			current_state = State.IDLE


func attack_state(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		perform_attack()
		attack_timer = attack_cooldown
	if !is_player_in_range(attack_range):
		# Transition to FOLLOW state if player moves out of attack range
		current_state = State.FOLLOW


func is_player_in_range(range):
	return global_position.distance_to(player.global_position) < range


func move_towards_player(delta):
	var direction = (player.global_position - global_position).normalized()
	self.velocity = direction * self.SPEED
	
	move_and_slide()


func perform_attack():
	print("Attacking player")
	# You can add logic to deal damage to the player here



func take_damage(damage):
	self.health -= damage
	if self.health <= 0:
		die()


func die():
	queue_free()


# ENEMY STATS

var health

var base_physical_damage
var base_increased_physical_damage
var base_more_physical_damage

var base_attack_speed = 0.5
var base_increased_attack_speed = 1

var attack_range = 30

