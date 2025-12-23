extends Area2D

# --- EXPORT VARIABLES ---
# Standardize the block colors to match Kenney's asset naming conventions or logic
@export_enum("Yellow", "Red", "Green", "Blue", "White", "Black") var block_color: String = "Yellow"

# How many hits this block can take before being destroyed
@export var max_hits: int = 1

# Reference to the particles textures
#@onready var yellow_particles: Texture = preload("res://brick_assets/Yellow/brick_low_1.png")


# --- PRIVATE VARIABLES ---
# Tracks the current number of hits received
var _current_hits: int = 0

# --- ONREADY VARIABLES ---
# Cache references to children nodes to ensure they are ready before use
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $HitParticles
# @onready var collision_shape: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	# Optional: Load texture dynamically based on color if files are named consistently.
	# Example: sprite.texture = load("res://assets/blocks/element_" + block_color.to_lower() + "_square.png")
	particles.texture = load("res://brick_assets/" + block_color + "/brick_low_1.png")
	
	pass

# --- PUBLIC FUNCTIONS ---

## Called by the Bullet when it collides with this block.
func take_damage() -> void:
	_current_hits += 1
	
	# Visual Feedback: Shake the sprite
	_shake_block()
	
	# Visual Feedback: Emit particles
	# We emit a small burst for a hit, or a big burst for destruction
	if _current_hits >= max_hits:
		_destroy_block()
	else:
		_play_hit_feedback()

# --- PRIVATE FUNCTIONS ---

## Handles the logic for a non-lethal hit
func _play_hit_feedback() -> void:
	# 1. Emit particles (ensure One Shot is ON in the inspector)
	particles.restart()
	
	# 2. Change visual state (Optional)
	# e.g., Darken the sprite slightly to show damage
	sprite.modulate = sprite.modulate.darkened(0.1)

## Handles the logic when the block is destroyed
func _destroy_block() -> void:
	# 1. Disable collision to prevent further hits while animation plays
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	
	# 2. Hide the sprite (the block is "gone")
	sprite.visible = false
	
	# 3. Supercharge particles for the explosion effect
	# We increase the amount and spread for the final destruction
	particles.amount_ratio = 1.0 # Ensure max particles
	particles.explosiveness = 1.0
	particles.restart()
	
	# 4. Wait for particles to finish before removing the object
	await particles.finished
	queue_free()

## Creates a tween to shake the sprite slightly, simulating an impact.
## Note: We shake the Sprite, not the Area2D, to keep collision shapes stable.
func _shake_block() -> void:
	var tween = create_tween()
	var original_pos = sprite.offset # Should be (0,0) usually
	
	# Quick vibration effect
	tween.tween_property(sprite, "offset", original_pos + Vector2(-5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_pos + Vector2(5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_pos + Vector2(-5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_pos, 0.05)
