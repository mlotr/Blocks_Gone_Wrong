extends StaticBody2D

signal destroyed 

# --- CONFIGURATION ---
# Color -> Max Hits
const COLOR_DATA = {
	"Yellow": 2,
	"Red": 3,
	"Green": 4,
	"Blue": 5,
	"White": 6,
	"Black": 7
}

# --- EXPORT VARIABLES ---
@export_enum("Yellow", "Red", "Green", "Blue", "White", "Black") var block_color: String = "Yellow"
@export var max_hits: int = 1

# --- PRIVATE VARIABLES ---
var _current_hits: int = 0

# --- ONREADY VARIABLES ---
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $HitParticles
@onready var collision_shape = $CollisionPolygon2D 
@onready var hit_sfx = $HitSFX
@onready var broken_sfx = $BrokenSFX

func _ready() -> void:
	# Set max hits according to color
	if block_color in COLOR_DATA:
		max_hits = COLOR_DATA[block_color]
	else:
		max_hits = 1 # Fallback
	
	# Load texture dynamically (with safety control)
	var texture_path = "res://brick_assets/" + block_color + "/brick_low_1.png"
	
	if ResourceLoader.exists(texture_path):
		particles.texture = load(texture_path)
	
	# Duplicate material for each block
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	
# --- PUBLIC FUNCTIONS ---

## Called by the Bullet when it collides with this block.
func take_damage() -> void:
	_current_hits += 1
	# Calculate damage percentage (0.0 to 1.0)
	var damage_percent = float(_current_hits) / float(max_hits)
	
	if sprite.material:
		sprite.material.set_shader_parameter("damage_state", damage_percent)
	_shake_block()
	
	if _current_hits >= max_hits:
		_destroy_block()
	else:
		_play_hit_feedback()

# --- PRIVATE FUNCTIONS ---

func _play_hit_feedback() -> void:
	particles.restart()
	hit_sfx.play()
	sprite.modulate = sprite.modulate.darkened(0.1)

func _destroy_block() -> void:
	# 1. Disable collision immediately so the bullet passes through or doesn't bounce anymore
	collision_shape.set_deferred("disabled", true)
	
	# 2. Hide visual
	sprite.visible = false
	
	# 3. Particle explosion
	#particles.amount_ratio = 1.0
	particles.amount *= 10
	particles.explosiveness = 1.0
	broken_sfx.play()
	particles.restart()
	
	# 3b. Apply camera shake
	get_tree().call_group("Camera", "apply_shake", 20.0, 0.15)
	#get_tree().call_group("Camera", "apply_standard_shake")
	
	# 4. Wait and free
	await particles.finished 
	await broken_sfx.finished
	
	destroyed.emit()
	await particles.finished
	
	queue_free()

func _shake_block() -> void:
	var tween = create_tween()
	var original_offset = Vector2.ZERO # Or default value
	
	# Shake using offset
	tween.tween_property(sprite, "offset", original_offset + Vector2(-5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_offset + Vector2(5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_offset + Vector2(-5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_offset, 0.05)
