extends HBoxContainer

var hearts: Array[TextureRect]

const FULL_HEART_REGION: Rect2 = Rect2(72, 36, 18, 18)
const EMPTY_HEART_REGION: Rect2 = Rect2(108, 36, 18, 18)

func _ready() -> void:
    for child: TextureRect in get_children():
        hearts.append(child)
    
    Game.player_hit.connect(_on_player_hit)
    Game.game_restart.connect(_on_game_reset)

func _on_player_hit() -> void:
    for i: int in range(hearts.size() - 1, -1, -1):
        if hearts[i].texture.region == EMPTY_HEART_REGION:
            continue

        hearts[i].texture.region = EMPTY_HEART_REGION
        break

func _on_game_reset() -> void:
    for heart: TextureRect in hearts:
        heart.texture.region = FULL_HEART_REGION