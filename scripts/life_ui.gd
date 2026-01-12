extends Control

@onready var sprite = $Sprite2D
@onready var broken_particles = $BrokenParticles
@onready var broken_sfx = $BrokenSFX

func lose_life_visual():
	# Hide heart
	sprite.visible = false
	
	# Emit particles
	broken_particles.restart()
	
	# Play sfx
	if broken_sfx.stream:
		broken_sfx.play()
	
	# Non facciamo queue_free() subito, altrimenti il suono si taglia.
	# Le particelle e il suono continueranno, ma il cuore è "visivamente" andato.
