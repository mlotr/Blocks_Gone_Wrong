extends Camera2D

# --- EXPORT VARIABLES ---
@export var cannon_path: NodePath
@export var smooth_speed: float = 5.0
@export var offset_x: float = 300.0 # To keep the action slightly to the right

# --- PRIVATE VARIABLES ---
var _cannon: Node2D
var _target: Node2D

func _ready() -> void:
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
