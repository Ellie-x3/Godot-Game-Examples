extends Parallax2D

func _ready() -> void:
    autoscroll.x = Game.game_speed
    Game.game_speed_changed.connect(func(speed: float) -> void: 
        autoscroll.x = speed
        )

