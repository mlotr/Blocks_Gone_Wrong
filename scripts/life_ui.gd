extends Control

@onready var sprite = $Sprite2D
#@onready var particles = $CPUParticles2D
#@onready var audio = $AudioStreamPlayer

func lose_life_visual():
	# Nascondi il cuore
	sprite.visible = false
	
	# Riproduci effetti
	#particles.restart()
	#if audio.stream:
		#audio.play()
	
	# Non facciamo queue_free() subito, altrimenti il suono si taglia.
	# Le particelle e il suono continueranno, ma il cuore è "visivamente" andato.
