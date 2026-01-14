class_name AudioButton extends TextureButton

@export var hover_sound: AudioStream
@export var click_sound: AudioStream

# --- STAATIC VARIABLES (shared by all buttons) ---
# Save last time sound played in the whole game
static var last_hover_time: int = 0
# Minimum time (in milliseconds) between hover sounds
const HOVER_COOLDOWN_MS: int = 100 

var hover_audio_player: AudioStreamPlayer
var click_audio_player: AudioStreamPlayer

func _ready() -> void:
	# Setup Hover Player
	hover_audio_player = AudioStreamPlayer.new()
	add_child(hover_audio_player)
	hover_audio_player.bus = "UI"
	hover_audio_player.stream = hover_sound
	# Max polyphony helps for double hovering on same button 
	hover_audio_player.max_polyphony = 2 
	
	# Setup Click Player
	click_audio_player = AudioStreamPlayer.new()
	add_child(click_audio_player)
	click_audio_player.bus = "UI"
	click_audio_player.stream = click_sound
	click_audio_player.max_polyphony = 2
	
	# Connect signals
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_pressed)

func _on_hover() -> void:
	if not hover_sound: return
	
	# --- DEBOUNCE LOGIC ---
	var current_time = Time.get_ticks_msec()
	
	# If too few time --> return
	if current_time - last_hover_time < HOVER_COOLDOWN_MS:
		return
	
	# Update time and sound
	last_hover_time = current_time
	
	# Play SFX
	hover_audio_player.play()

func _on_pressed() -> void:
	if click_sound:
		click_audio_player.pitch_scale = 1.0
		click_audio_player.play()
