extends Control

# --- EXPORT VARIABLES ---
# Main Menu scene (TitleScreen.tscn)
@export var title_screen_scene: String = "res://scenes/title_screen.tscn" 

# --- ONREADY VARIABLES ---
@onready var title_label: Label = $CenterContainer/TitleLabel
#@onready var message_label: Label = $CenterContainer/MessageLabel
@onready var restart_btn: BaseButton = $CenterContainer/RestartButton
@onready var menu_btn: BaseButton = $CenterContainer/MenuButton
@onready var win_sfx = $WinSFX
@onready var lose_sfx = $LoseSFX

func _ready() -> void:
	# Hide scene on ready
	visible = false
	
	# Connect button signals
	restart_btn.pressed.connect(_on_restart_pressed)
	menu_btn.pressed.connect(_on_menu_pressed)

# --- PUBLIC FUNCTIONS ---

## Call from GameManager for win
func show_victory() -> void:
	title_label.text = "VICTORY!"
	#message_label.text = "Castle Destroyed!"
	_show_screen()
	
	# Play SFX
	win_sfx.play()

## Call from GameManager for lose
func show_game_over() -> void:
	title_label.text = "GAME OVER"
	#message_label.text = "Out of lives..."
	_show_screen()
	
	# Play SFX
	lose_sfx.play()

# --- PRIVATE FUNCTIONS ---

func _show_screen() -> void:
	visible = true
	# IMPORTANT	: PAUSE GAME (stops physics and all the rest)
	get_tree().paused = true
	
	# Fade in animation
	modulate.a = 0.0
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # Il tween deve funzionare anche in pausa!
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _on_restart_pressed() -> void:
	# Unpause
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	# Use change_scene_to_file with path string
	get_tree().change_scene_to_file(title_screen_scene)
