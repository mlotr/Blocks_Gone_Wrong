extends CharacterBody2D

# --- EXPORT VARIABLES ---
# Drag and drop the Bullet.tscn here in the Inspector
@export var bullet_scene: PackedScene
@export var move_speed: float = 300.0

# --- PRIVATE VARIABLES ---
# Keeps track of the active bullet to prevent firing multiple times
# and to separate "Shooting" input from "Boomerang" input.
var _current_bullet: Node = null

# --- ONREADY VARIABLES ---
@onready var gun_sprite: Sprite2D = $GunSprite
@onready var muzzle: Marker2D = $GunSprite/Muzzle
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	_handle_input()
	_handle_movement()

# --- PRIVATE FUNCTIONS ---

func _handle_movement() -> void:
	# Get input for vertical movement (W/S or Up/Down arrows)
	# Assuming you have defined "ui_up" and "ui_down" or custom actions in Project Settings
	var direction = Input.get_axis("ui_up", "ui_down")
	
	if direction:
		velocity.y = direction * move_speed
	else:
		velocity.y = move_toward(velocity.y, 0, move_speed)
	
	move_and_slide()

func _handle_input() -> void:
	# Logic: We can only fire if there is NO active bullet in the scene.
	# If a bullet exists, the mouse click is handled by the Bullet script (Boomerang logic).
	if Input.is_action_just_pressed("click"): # Ensure "click" is mapped to Left Mouse Button
		if not is_instance_valid(_current_bullet):
			_fire()

func _fire() -> void:
	if not bullet_scene:
		push_warning("Cannon: No Bullet Scene assigned!")
		return
	
	# 1. Instantiate the bullet
	var bullet_instance = bullet_scene.instantiate()
	
	# 2. Set the position to the Muzzle's global position
	bullet_instance.global_position = muzzle.global_position
	
	# 3. Add the bullet to the main scene (not as a child of the cannon!)
	# We use get_tree().current_scene or get_parent() to ensure it moves independently
	get_parent().add_child(bullet_instance)
	
	# 4. Launch the bullet
	# We assume shooting to the RIGHT (Vector2.RIGHT)
	if bullet_instance.has_method("launch"):
		bullet_instance.launch(Vector2.RIGHT)
	
	# 5. Store reference to prevent spamming
	_current_bullet = bullet_instance
	
	# 6. Play visual feedback
	if anim_player.has_animation("recoil"):
		anim_player.play("recoil")
