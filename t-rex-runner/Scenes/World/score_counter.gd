extends Label

func _physics_process(delta: float) -> void:
    text = str(Game.score).pad_zeros(5)