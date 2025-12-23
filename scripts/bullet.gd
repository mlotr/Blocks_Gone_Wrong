extends RigidBody2D

# --- SIGNALS ---
# Signal emitted when the bullet hits something (useful for camera shake or UI)
signal hit_something

# --- EXPORT VARIABLES ---
@export var speed: float = 800.0
@export var boomerang_speed: float = 1000.0

# --- PRIVATE VARIABLES ---
# Tracks if the bullet has hit a block at least once
var _has_hit_block: bool = false
# Tracks if the player is currently clicking to recall the bullet
var _is_returning: bool = false

# --- ONREADY VARIABLES ---
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Connect the body_entered signal to our function to detect hits
	# Ensure "Contact Monitor" is ON and "Max Contacts Reported" > 0 in Inspector
	self.body_entered.connect(_on_body_entered)

func _input(event: InputEvent) -> void:
	# The boomerang mechanic activates ONLY after the first hit
	if _has_hit_block:
		if event.is_action_pressed("click"): # Replace with your action name
			_is_returning = true
		elif event.is_action_released("click"):
			_is_returning = false

func _physics_process(_delta: float) -> void:
	# If the player is holding the mouse button, override the velocity
	if _is_returning:
		_move_towards_mouse()

# --- PUBLIC FUNCTIONS ---

## Initial launch of the bullet from the Cannon
func launch(direction: Vector2) -> void:
	self.linear_velocity = direction.normalized() * speed

# --- PRIVATE FUNCTIONS ---

## Logic to steer the bullet towards the current mouse position
func _move_towards_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	# Calculate direction from bullet to mouse
	var direction = (mouse_pos - global_position).normalized()
	
	# We directly set linear_velocity to give the player snappy control
	# The bullet will stop bouncing and "fly" towards the cursor
	linear_velocity = direction * boomerang_speed
	
	# Optional: Rotate the bullet to face the direction of travel
	rotation = linear_velocity.angle()

## Detection logic for hitting StaticBody2D blocks
func _on_body_entered(body: Node) -> void:
	# Check if the object hit has the 'take_damage' method (our Blocks)
	if body.has_method("take_damage"):
		body.take_damage()
		
		# Once we hit a block, we unlock the boomerang ability
		if not _has_hit_block:
			_has_hit_block = true
			# Visual feedback when the ability unlocks (e.g., change color)
			sprite.modulate = Color(0.5, 1.5, 0.5) # Glowing green tint
		
		hit_something.emit()

## Clean up when the bullet leaves the play area
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
