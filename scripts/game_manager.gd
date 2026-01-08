extends Node

@export var total_lives: int = 3
@export var hud_path: NodePath
# Opzionale: trascina qui la scena del Game Over / Victory
@export var result_screen_scene: PackedScene 

var _current_lives: int
var _blocks_remaining: int = 0
var _hud_ref

func _ready():
	_current_lives = total_lives
	
	# 1. Setup HUD
	if hud_path:
		_hud_ref = get_node(hud_path)
		_hud_ref.setup_lives(total_lives)
	
	# 2. Conta i blocchi
	# IMPORTANTE: Assicurati che i blocchi siano nel gruppo "Destructible"
	var blocks = get_tree().get_nodes_in_group("Destructible")
	_blocks_remaining = blocks.size()
	
	# 3. Connetti i segnali dei blocchi
	for block in blocks:
		# Assumiamo che il blocco emetta un segnale 'destroyed'
		if block.has_signal("destroyed"): 
			block.destroyed.connect(_on_block_destroyed)
			
	# Nota: Per il Bullet, poiché viene istanziato dinamicamente dal Cannone,
	# non possiamo connetterlo qui nel _ready. 
	# Useremo un segnale globale o un metodo chiamato dal Bullet stesso.

# Funzione chiamata dal Bullet quando esce dallo schermo
# (Vedi sotto come chiamarla)
func _on_life_lost():
	if _current_lives <= 0: return # Già morto
	
	_current_lives -= 1
	
	# Aggiorna l'HUD (toglie l'ultimo cuore rimasto)
	if _hud_ref:
		_hud_ref.drop_life(_current_lives)
	
	print("Vite rimaste: ", _current_lives)
	
	if _current_lives <= 0:
		_game_over()

func _on_block_destroyed():
	_blocks_remaining -= 1
	print("Blocchi rimasti: ", _blocks_remaining)
	
	if _blocks_remaining <= 0:
		_victory()

func _game_over():
	print("GAME OVER")
	# Qui istanzierai la scena ResultScreen col testo "LOSE"
	# O semplicemente ricarichi la scena dopo un timer
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene() # Placeholder

func _victory():
	print("VICTORY")
	# Idem come sopra
