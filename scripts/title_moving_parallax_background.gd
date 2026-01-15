extends ParallaxBackground

@export var scroll_speed: float = 100.0

func _process(delta: float) -> void:
	# Move offset towards the left
	scroll_offset.x -= scroll_speed * delta
