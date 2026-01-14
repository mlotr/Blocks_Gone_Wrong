class_name AudioButton extends TextureButton

@export var hover_sound: AudioStream
@export var click_sound: AudioStream

var hover_audio_player: AudioStreamPlayer
var click_audio_player: AudioStreamPlayer

func _ready() -> void:
	# Setup Audio Players
	hover_audio_player = AudioStreamPlayer.new()
	add_child(hover_audio_player)
	hover_audio_player.bus = "UI"
	
	if hover_sound:
		hover_audio_player.stream = hover_sound
	
	click_audio_player = AudioStreamPlayer.new()
	add_child(click_audio_player)
	click_audio_player.bus = "UI"
	
	if click_sound:
		click_audio_player.stream = click_sound
	
	# Connect internal signals
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_pressed)

func _on_hover() -> void:
		hover_audio_player.play()

func _on_pressed() -> void:
	if click_sound:
		click_audio_player.play()
