@tool class_name ObstacleSmall
extends Area2D

@export var obstacle_type: ObstacleSmallType = ObstacleSmallType.CACTUS:
	set(v):
		obstacle_type = v
		if sprite:
			sprite.region_rect = region_specs[obstacle_type]
		
		if collision:
			collision.shape.size = collision_specs[obstacle_type]

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

enum ObstacleSmallType {
	CACTUS,
	TREE,
	SPIKE,
	BOX,
}

func _ready() -> void:
	collision.shape = collision.shape.duplicate()
	sprite.region_rect = region_specs[obstacle_type]
	collision.shape.size = collision_specs[obstacle_type]

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	global_position.x += Game.game_speed * delta

var region_specs: Dictionary = {
	ObstacleSmallType.CACTUS: Rect2(126, 108, 18, 18),
	ObstacleSmallType.TREE: Rect2(108, 108, 18, 18),
	ObstacleSmallType.SPIKE: Rect2(144, 54, 18, 18),
	ObstacleSmallType.BOX: Rect2(108, 18, 18, 18)
}

var collision_specs: Dictionary = {
	ObstacleSmallType.CACTUS: Vector2(8, 18),
	ObstacleSmallType.TREE: Vector2(8, 18),
	ObstacleSmallType.SPIKE: Vector2(14, 5.5),
	ObstacleSmallType.BOX: Vector2(14, 16)
}