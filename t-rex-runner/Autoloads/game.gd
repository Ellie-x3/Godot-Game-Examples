extends Node

signal game_speed_changed(speed: float)
signal player_hit
signal game_restart

const MIN_SPEED: float = -100
const MAX_SPEED: float = -230
const MAX_SCORE: int = 99999
const SCORE_COEF: float = 0.025 #COEf from https://chromium.googlesource.com/chromium/src/+/b45a812bd11badbfde8bf00cb9122536dccee7d5/components/neterror/resources/offline.js
const SPEEDUP_EVERY: int = 25

var game_state: GameState = GameState.START
enum GameState {
    START,
    PLAYING,
    DEAD
}

var hold_speed: float = 0.0
var is_frozen: bool = false

var score: int = 0
var _next_speedup = SPEEDUP_EVERY
var distance: float = 0

var game_speed: float = -100:
    set(v):
        if v != game_speed: game_speed_changed.emit(v)
        if v == 0:
            game_speed = 0
        else:
            game_speed = clamp(absf(v), absf(MIN_SPEED), absf(MAX_SPEED)) * -1

func _ready() -> void:
    game_state = GameState.PLAYING
    process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
    distance += game_speed * delta
    score = absi(int(distance * SCORE_COEF))

    if score >= _next_speedup:
        game_speed -= 10
        _next_speedup += SPEEDUP_EVERY

func _input(event: InputEvent) -> void:
    if not game_state == GameState.DEAD: return

    if Input.is_action_just_pressed("Jump"): _reset_game()

func freeze_game() -> void:
    hold_speed = game_speed
    game_speed = 0.0
    is_frozen = true

func continue_game() -> void:
    game_speed = hold_speed
    is_frozen = false

func player_died() -> void:
    freeze_game()
    game_state = GameState.DEAD

func _reset_game() -> void:
    score = 0
    distance = 0
    game_speed = MIN_SPEED
    game_state = GameState.PLAYING
    game_restart.emit()
    is_frozen = false