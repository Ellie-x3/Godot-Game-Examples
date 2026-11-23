extends Marker2D

const SMALL_OBSTACLE_SCENE: PackedScene = preload("uid://sm2lnier0n1e")

@export var min_gap: float = 40 
@export var max_gap: float = 220

@onready var timer: Timer = $Timer
@onready var container: Node2D = $Container

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	_spawn()

	Game.game_restart.connect(_on_game_restart)

func _physics_process(delta: float) -> void:
	if Game.is_frozen:
		timer.paused = true
	else: timer.paused = false

func _spawn() -> void:
	var speed: float = maxf(absf(Game.game_speed), 1.0)
	var gap: float = 0.32 * speed + randf_range(min_gap, max_gap)
	var t: float = gap / speed
	timer.start(t)

func _on_timeout() -> void:
	var ob: ObstacleSmall = SMALL_OBSTACLE_SCENE.instantiate()
	ob.obstacle_type = randi_range(0, 3) as ObstacleSmall.ObstacleSmallType
	container.add_child(ob)
	_spawn()

func _on_game_restart() -> void:
	for obs: Node2D in container.get_children():
		obs.queue_free()

	_spawn()
