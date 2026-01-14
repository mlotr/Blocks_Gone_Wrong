extends Camera2D

# --- EXPORT VARIABLES ---
@export var cannon_path: NodePath
@export var smooth_speed: float = 5.0
@export var offset_x: float = 300.0 # To keep the action slightly to the right

# Shake variables
@export var can_shake: bool = true
@export var standard_strength: float = 30.0
@export var standard_duration: float = 0.35
@export var max_shake_strength: float = 50.0

# --- PRIVATE VARIABLES ---
var _cannon: Node2D
var _target: Node2D


# Shake variables
var rng := RandomNumberGenerator.new()
var base_offset: Vector2
var shake_strength: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0

func _ready() -> void:
	rng.randomize()
	base_offset = offset
	
	if cannon_path:
		_cannon = get_node(cannon_path)
		_target = _cannon
	

func _process(delta: float) -> void:
	# 1. Determine the target
	_find_target()
	
	# 2. Smoothly follow the target
	if is_instance_valid(_target):
		var desired_position = _target.global_position
		
		# Optional: Keep the camera centered slightly ahead or behind?
		# For now, let's just center on the object but maybe limit Y movement
		
		# Use lerp for smooth movement
		global_position = global_position.lerp(desired_position, smooth_speed * delta)
		
		if shake_timer > 0.0:
			shake_timer -= delta
			
			# Normalized time (1 → 0)
			var t := shake_timer / shake_duration
			
			# Decadimento smooth
			#var current_strength := lerpf(0.0, shake_strength, t)
			var current_strength = max(lerpf(0.0, shake_strength, t), 1.2)
			
			offset = base_offset + random_offset(current_strength)
		else:
			offset = base_offset

# Logic to switch between Cannon and Bullet
func _find_target() -> void:
	# Check if there is a Bullet in the "Hitpanel" group or just look for RigidBody2D?
	# Better approach: Look for the specific bullet node in the scene tree logic.
	# Since Bullet is added to Level1, we can search for it.
	
	# Let's assume the Bullet is in a Group called "Projectiles" 
	# (Remember to add the Bullet scene to this group in the Node tab!)
	var bullets = get_tree().get_nodes_in_group("Projectiles")
	
	if bullets.size() > 0:
		# Follow the first active bullet
		_target = bullets[0]
	else:
		# Fallback to Cannon
		_target = _cannon
		

# Logic for camera shake
func random_offset(strength: float) -> Vector2:
	return Vector2(
		rng.randf_range(-strength, strength),
		rng.randf_range(-strength, strength)
	)

func apply_shake(strength: float, duration: float):
	if not can_shake:
		return
	
	shake_strength = clamp(strength, 0.0, max_shake_strength)
	shake_duration = max(duration, 0.01)
	shake_timer = shake_duration
	
func apply_standard_shake():
	apply_shake(standard_strength, standard_duration)
