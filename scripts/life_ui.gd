extends Control

# --- ONREADY VARIABLES ---
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
	
