class_name Interface
extends CanvasLayer

@onready var score_container: Control = %ScoreContainer
@onready var gameover_container: Control = %GameOverScreen

func _physics_process(delta: float) -> void:
    match Game.game_state:
        
        Game.GameState.PLAYING:
            score_container.show()
            gameover_container.hide()
        Game.GameState.DEAD:
            score_container.hide()
            gameover_container.show()