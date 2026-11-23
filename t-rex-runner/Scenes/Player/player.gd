class_name Player
extends CharacterBody2D

@export var jump_height: float = 45
@export var time_to_peak: float = 0.32
@export var time_to_fall: float = 0.32
@export var hang_threshold: float = 40
@export var hang_gravity_scale: float = 0.65

@onready var jump_velocity := -2.0 * jump_height / time_to_peak
@onready var jump_gravity := 2.0 * jump_height / (time_to_peak * time_to_peak)
@onready var fall_gravity := 2.0 * jump_height / (time_to_fall * time_to_fall)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var health: int = 3:
	set(v):
		if health >= 0:
			health = clamp(v, 0, 3)
		
		if health == 0: _died()

var player_state: PlayerState = PlayerState.RUNNING
enum PlayerState {
	IDLE,
	RUNNING,
	HIT,
	DUCKING,
	DEAD
}

var speed_jump_multiplier: float:
	get:
		return max(clampf(inverse_lerp(Game.MIN_SPEED, Game.MAX_SPEED, Game.game_speed), 1.0, 0.0), 0.7)

func _ready() -> void:
	Game.game_restart.connect(_reset)

func _physics_process(delta: float) -> void:

	if player_state == PlayerState.DEAD: return

	match player_state:
		PlayerState.IDLE: return
		PlayerState.DEAD: return
		PlayerState.RUNNING: _running(delta)
		PlayerState.HIT: _hit(delta)
		PlayerState.DUCKING: _duck()
	
	move_and_slide()

func _running(delta: float) -> void:
	sprite.play("Run")
	var g: float = jump_gravity if velocity.y < 0.0 else fall_gravity

	if not is_on_floor() and absf(velocity.y) < hang_threshold:
		g *= hang_gravity_scale

	velocity.y += (g / speed_jump_multiplier) * delta

	if Input.is_action_pressed("Duck") and is_on_floor():
		player_state = PlayerState.DUCKING
		return

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

func _hit(delta: float) -> void:
	velocity.y *= 0.5

func _duck() -> void:
	sprite.play("Duck")

	if Input.is_action_just_released("Duck"):
		player_state = PlayerState.RUNNING
		return

func _died() -> void:
	sprite.pause()
	Game.player_died()

func _reset() -> void:
	player_state = PlayerState.RUNNING
	health = 3

func _on_hurt_box_area_entered(area: Area2D) -> void:
	area.set_collision_layer_value(3, false) #avoid double hit
	Game.player_hit.emit()
	player_state = PlayerState.HIT
	sprite.play("Hurt")
	Game.freeze_game()

	await sprite.animation_finished
	
	health -= 1

	if health <= 0: return

	player_state = PlayerState.RUNNING
	Game.continue_game()
