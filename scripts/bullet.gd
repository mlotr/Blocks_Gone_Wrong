extends RigidBody2D

signal hit_something

# --- EXPORT VARIABLES ---
# The speed used when redirecting the bullet with the mouse
@export var redirect_speed: float = 1000.0

# --- PRIVATE VARIABLES ---
# Tracks if the bullet currently has a "charge" to be redirected
var _has_charge: bool = false
# Current speed to maintain velocity consistency
var _current_speed: float = 0.0

# --- ONREADY VARIABLES ---
@onready var sprite: Sprite2D = $Sprite2D
@onready var voice_sfx = $Sounds/VoiceSFX

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	# Set default color
	sprite.modulate = Color(1, 1, 1, 1)
	

func _input(event: InputEvent) -> void:
	# Input is handled ONLY if we have a charge available
	if _has_charge and event.is_action_pressed("click"):
		_redirect_bullet()

# --- PUBLIC FUNCTIONS ---

## Initial launch called by Cannon
func launch(direction: Vector2, speed: float) -> void:
	_current_speed = speed
	self.linear_velocity = direction.normalized() * speed
	
	# Play voice SFX
	if not voice_sfx.playing:
		voice_sfx.play()

# --- PRIVATE FUNCTIONS ---

## Applies the redirection logic
func _redirect_bullet() -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Apply new velocity immediately
	# We use redirect_speed to give it a "dash" feeling, or reuse _current_speed
	self.linear_velocity = direction * redirect_speed
	
	# Consume the charge
	_has_charge = false
	
	# Visual feedback: Turn off the glow
	sprite.modulate = Color(1, 1, 1, 0.7)
	
	# Rotate sprite to face movement
	rotation = direction.angle()

## Collision Logic
func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		hit_something.emit()
		
		# Play voice SFX
		if not voice_sfx.playing:
			voice_sfx.play()
		
		# RECHARGE MECHANIC:
		# Every time we hit a block, we regain the ability to redirect
		if not _has_charge:
			_has_charge = true
			# Visual feedback: Glow up!
			sprite.modulate = Color(1.5, 1.5, 0.5, 1.0) # Bright Yellow/Gold
			
			# Optional: Play a "Recharge" sound here

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
