extends StaticBody2D 

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
	# Load texture dynamically (with safety control)
	var texture_path = "res://brick_assets/" + block_color + "/brick_low_1.png"
	
	if ResourceLoader.exists(texture_path):
		particles.texture = load(texture_path)
	
# --- PUBLIC FUNCTIONS ---

## Called by the Bullet when it collides with this block.
func take_damage() -> void:
	_current_hits += 1
	
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
	# 'set_deferred' is crucial for physics bodies to avoid crashes during physics calculations
	collision_shape.set_deferred("disabled", true)
	
	# 2. Hide visual
	sprite.visible = false
	
	# 3. Particle explosion
	#particles.amount_ratio = 1.0
	particles.amount *= 10
	particles.explosiveness = 1.0
	broken_sfx.play()
	particles.restart()
	
	# 4. Wait and free
	await particles.finished and broken_sfx.finished
	queue_free()

func _shake_block() -> void:
	var tween = create_tween()
	var original_offset = Vector2.ZERO # Or default value
	
	# Shake using offset
	tween.tween_property(sprite, "offset", original_offset + Vector2(-5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_offset + Vector2(5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_offset + Vector2(-5, 0), 0.05)
	tween.tween_property(sprite, "offset", original_offset, 0.05)
