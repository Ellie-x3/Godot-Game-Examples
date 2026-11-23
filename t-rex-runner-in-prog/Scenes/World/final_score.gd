extends Label

func _on_visibility_changed() -> void:
	text = str(Game.score).pad_zeros(5)
