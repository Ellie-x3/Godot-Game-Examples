class_name Game
extends Node2D

signal turn_changed

static var x_turn: bool = true

const WIN_PATTERNS: Array[Array] = [
	[0, 1, 2], [3,4,5], [6,7,8], #Rows
	[0,3,6], [1,4,7], [2,5,8], #Columns
	[0,4,8], [2,4,6] #Diags
]

var empty_board: Array[String] = ["", "", "", "", "", "", "", "", ""]
var board: Array[String] = ["", "", "", "", "", "", "", "", ""]
var winning_line: Array = []

@onready var cells: Control = %Cells
@onready var tie_label: Label = %Ties
@onready var player1_score: Label = %Player1Score
@onready var player2_score: Label = %Player2Score

var x_score: int = 0:
	set(v):
		x_score = v
		player1_score.text = str(x_score)

var o_score: int = 0:
	set(v):
		o_score = v
		player2_score.text = str(o_score)

var tie_score: int = 0:
	set(v):
		tie_score = v
		tie_label.text = str(tie_score)

@onready var x_label: PackedScene = preload('uid://0mqkf42f6lcc')
@onready var o_label: PackedScene = preload('uid://ei0ibbieo8je')

enum GameState {
	PLAYING,
	WINNER,
	TIED,
}

var game_state: GameState = GameState.PLAYING

func _ready() -> void:

	game_state = GameState.PLAYING

	for button: Button in cells.get_children():
		var callback: Callable = _on_button_pressed.bind(button)
		if not button.pressed.is_connected(callback):
			button.pressed.connect(callback)

func _input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton and (game_state == GameState.WINNER or game_state == GameState.TIED):
		_restart()

func _change_turn() -> void:
	x_turn = !x_turn
	turn_changed.emit()

func _check_for_winner(player_mark: String) -> bool:
	for line: Array in WIN_PATTERNS:
		if board[line[0]] == player_mark and board[line[1]] == player_mark and board[line[2]] == player_mark:
			winning_line = line
			return true
	
	return false

func _check_for_tie() -> bool:
	return not board.has("")

func _winner() -> void:
	game_state = GameState.WINNER

	for button: Button in cells.get_children():
		button.disabled = true

	x_score += 1 if x_turn else 0
	o_score += 1 if not x_turn else 0

	print("WINNER FOUND : ", winning_line)
	_change_turn()

func _tied() -> void:
	if game_state == GameState.WINNER: return

	tie_score += 1
	game_state = GameState.TIED
	_change_turn()

func _restart() -> void:
	for button: Button in cells.get_children():
		if button.get_children():
			button.get_children()[0].queue_free()
		
		button.disabled = false

	board = empty_board.duplicate()
	print(empty_board)
	game_state = GameState.PLAYING

func _on_button_pressed(button: Button) -> void:

	if button.get_children(): return
	var player_mark: String = "X" if x_turn else "O"
	var label: PackedScene = x_label if x_turn else o_label

	button.add_child(label.instantiate())
	button.disabled = true

	board[button.get_index()] = player_mark

	if _check_for_winner(player_mark): _winner()
	if _check_for_tie(): _tied()

	if game_state == GameState.PLAYING: _change_turn()
