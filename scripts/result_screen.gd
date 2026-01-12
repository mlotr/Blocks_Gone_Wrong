extends Control

# --- EXPORT VARIABLES ---
# Trascina qui la scena del Menu Principale (TitleScreen.tscn)
@export var title_screen_scene: String = "res://scenes/title_screen.tscn" 

# --- ONREADY VARIABLES ---
@onready var title_label: Label = $CenterContainer/TitleLabel
#@onready var message_label: Label = $CenterContainer/MessageLabel
@onready var restart_btn: BaseButton = $CenterContainer/RestartButton
@onready var menu_btn: BaseButton = $CenterContainer/MenuButton

func _ready() -> void:
	# Nascondiamo la scena all'inizio se per caso è visibile nell'editor
	visible = false
	
	# Connessione segnali bottoni
	restart_btn.pressed.connect(_on_restart_pressed)
	menu_btn.pressed.connect(_on_menu_pressed)

# --- PUBLIC FUNCTIONS ---

## Chiamata dal GameManager per mostrare la vittoria
func show_victory() -> void:
	title_label.text = "VICTORY!"
	#message_label.text = "Castle Destroyed!"
	_show_screen()

## Chiamata dal GameManager per mostrare la sconfitta
func show_game_over() -> void:
	title_label.text = "GAME OVER"
	#message_label.text = "Out of lives..."
	_show_screen()

# --- PRIVATE FUNCTIONS ---

func _show_screen() -> void:
	visible = true
	# Importante: Mette in pausa il gioco sotto (blocca fisica e tutto)
	get_tree().paused = true
	
	# Animazione opzionale di comparsa (es. Fade In o Pop Up)
	modulate.a = 0.0
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # Il tween deve funzionare anche in pausa!
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _on_restart_pressed() -> void:
	# Togliamo la pausa prima di ricaricare, altrimenti la nuova scena parte bloccata!
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	# Usa change_scene_to_file con il path stringa
	get_tree().change_scene_to_file(title_screen_scene)
