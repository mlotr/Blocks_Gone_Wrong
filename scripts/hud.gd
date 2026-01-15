extends CanvasLayer

# --- EXPORT VARIABLES ---
@export var life_scene: PackedScene 

# --- ONREADY VARIABLES ---
@onready var lives_container = $Control/HBoxContainer
@onready var fallback_sfx = $FallbackSFX

# Create hearts
func setup_lives(amount: int):
	# Clean
	for child in lives_container.get_children():
		child.queue_free()
	
	# Instantiate
	for i in range(amount):
		var life = life_scene.instantiate()
		lives_container.add_child(life)

# Called when life lost
func drop_life(index: int):
	# Get heart corresponding to index
	var lives = lives_container.get_children()
	if index >= 0 and index < lives.size():
		lives[index].lose_life_visual()
		
	# Play fallback sfx
	fallback_sfx.play()
		
	
