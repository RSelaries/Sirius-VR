@tool
extends ColorRect


@onready var watcher_camera: WatcherCamera = %WatcherCamera


func _draw() -> void:
	draw_circle(watcher_camera.get_player_position(), 20.0, Color.RED)


func _physics_process(_delta: float) -> void:
	queue_redraw()
