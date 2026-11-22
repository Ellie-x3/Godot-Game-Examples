extends Label

func _ready() -> void:
    _on_game_turn_changed()

func _on_game_turn_changed() -> void:
    match Game.x_turn:
        true:
            text = "X"
            label_settings.font_color = Color.hex(0xfa403dff)
        false:
            text = "O"
            label_settings.font_color = Color.hex(0x00d55bff)
