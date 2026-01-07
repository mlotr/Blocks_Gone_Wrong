extends CharacterBody2D

# --- EXPORT VARIABLES ---
@export var bullet_scene: PackedScene
@export var move_speed: float = 300.0

# Control the power of the shot directly from the Cannon
@export var bullet_initial_speed: float = 800.0 

# --- PRIVATE VARIABLES ---
var _current_bullet: Node = null

# --- ONREADY VARIABLES ---
@onready var gun_sprite: Sprite2D = $GunSprite
@onready var muzzle: Marker2D = $GunSprite/Muzzle
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var shot_sfx = $ShotSFX

func _process(_delta: float) -> void:
	_handle_input()
	_handle_movement()

func _handle_movement() -> void:
	var direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.y = direction * move_speed
	else:
		velocity.y = move_toward(velocity.y, 0, move_speed)
	move_and_slide()

func _handle_input() -> void:
	if Input.is_action_just_pressed("click"):
		if not is_instance_valid(_current_bullet):
			_fire()

func _fire() -> void:
	if not bullet_scene: return
	
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	
	# Pass the speed variable to the launch function
	if bullet_instance.has_method("launch"):
		bullet_instance.launch(Vector2.RIGHT, bullet_initial_speed)
	
	_current_bullet = bullet_instance
	
	# Play recoil animation
	if anim_player.has_animation("recoil"):
		anim_player.play("recoil")
		
	# Play SFX
	shot_sfx.play()
