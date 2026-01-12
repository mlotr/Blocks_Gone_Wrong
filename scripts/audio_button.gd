class_name AudioButton extends TextureButton

# Carica i suoni una volta sola (o usa un AudioAutoload globale)
# Assicurati di trascinare i file .wav/.mp3 nell'Inspector se vuoi cambiarli per bottone
@export var hover_sound: AudioStream
@export var click_sound: AudioStream

# Creiamo un player audio interno al volo se non vogliamo sporcare la scena
var _audio_player: AudioStreamPlayer

func _ready() -> void:
	# Setup Audio Player
	_audio_player = AudioStreamPlayer.new()
	add_child(_audio_player)
	
	# Connessioni segnali interni
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_pressed)

func _on_hover() -> void:
	if hover_sound:
		_audio_player.stream = hover_sound
		
		# Random pitch 
		#_audio_player.pitch_scale = randf_range(0.95, 1.05)
		_audio_player.stop()
		_audio_player.play()

func _on_pressed() -> void:
	if click_sound:
		_audio_player.stream = click_sound
		_audio_player.pitch_scale = 1.0
		_audio_player.stop()
		_audio_player.play()
