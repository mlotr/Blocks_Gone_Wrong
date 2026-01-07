extends ParallaxBackground

@export var scroll_speed: float = 100.0

func _process(delta: float) -> void:
	# Sposta l'offset verso sinistra
	scroll_offset.x -= scroll_speed * delta
