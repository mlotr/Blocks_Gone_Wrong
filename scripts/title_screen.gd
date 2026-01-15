extends Control

# --- EXPORT VARIABLES ---
@export var level_scene: PackedScene

# Link to portfolio/github
@export var portfolio_url: String = "https://github.com/mlotr"

# --- ONREADY VARIABLES ---
@onready var play_btn: TextureButton = $MenuContainer/PlayButton
@onready var quit_btn: TextureButton = $MenuContainer/QuitButton
@onready var portfolio_btn: TextureButton = $MenuContainer/PortfolioButton
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# 1. Connect signals
	play_btn.pressed.connect(_on_play_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	
	# Connect portfolio button only if it exists in the scene
	if portfolio_btn:
		portfolio_btn.pressed.connect(_on_portfolio_pressed)
	
	# 2. Handle Platform specifics
	# If running on Web (HTML5), the Quit button is useless/confusing
	#if OS.has_feature("web"):
		#quit_btn.visible = false
	
	# 3. Start Intro Animation
	if anim_player.has_animation("fade_in"):
		anim_player.play("fade_in")
		
	# 4. Set up cursor (hotspot in center)
	var cursor = load("res://UI/pointer_c_shaded.png")
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16, 16))

# --- SIGNAL CALLBACKS ---

func _on_play_pressed() -> void:
	# Prevent double clicks
	play_btn.disabled = true
	
	# Transition Logic:
	# 1. Play fade OUT animation (Screen goes black)
	if anim_player.has_animation("fade_out"):
		anim_player.play("fade_out")
		
		# Wait for the animation to finish
		await anim_player.animation_finished
	
	# 2. Change Scene
	if level_scene:
		get_tree().change_scene_to_packed(level_scene)
	else:
		push_error("TitleScreen: No Level Scene assigned in Inspector!")

func _on_quit_pressed() -> void:
	# Simply quits the application
	get_tree().quit()

func _on_portfolio_pressed() -> void:
	# Opens the URL in the default browser
	OS.shell_open(portfolio_url)
