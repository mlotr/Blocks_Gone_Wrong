extends CanvasLayer

# Trascina qui la scena LifeUI.tscn
@export var life_scene: PackedScene 
@onready var lives_container = $Control/HBoxContainer

# Crea i cuori all'inizio
func setup_lives(amount: int):
	# Pulisci eventuali rimasugli (utile se riusi l'oggetto)
	for child in lives_container.get_children():
		child.queue_free()
	
	for i in range(amount):
		var life = life_scene.instantiate()
		lives_container.add_child(life)

# Chiamata quando si perde una vita
func drop_life(index: int):
	# Ottieni il cuore corrispondente all'indice (es. l'ultimo della lista)
	var lives = lives_container.get_children()
	if index >= 0 and index < lives.size():
		lives[index].lose_life_visual()
