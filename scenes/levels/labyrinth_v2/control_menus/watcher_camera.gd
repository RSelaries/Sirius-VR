@tool
class_name WatcherCamera
extends Camera3D


@onready var player_point: TextureRect = %PlayerPoint
@onready var player_position_label: Label = %PlayerPositionLabel


var player_camera: XRCamera3D


func _ready() -> void:
	var _owner := owner as LeftSideControlPanelMenu
	if _owner and Engine.is_editor_hint():
		player_camera = %TestPlayerXR.find_child("XRCamera3D")
	elif _owner:
		player_camera = _owner.xr_scene.find_child("XROrigin3D").find_child("XRCamera3D")


func _physics_process(_delta: float) -> void:
	player_point.pivot_offset_ratio = Vector2(.5, .5)
	player_point.position = get_player_position()
	player_point.rotation = get_player_rotation()
	
	player_position_label.text = "X: %.1f\nY: %.1f" % [player_camera.global_position.x / 3.0, player_camera.global_position.z / 3.0]


func get_player_rotation() -> float:
	return -player_camera.global_rotation.y if player_camera else 0.0


func get_player_position() -> Vector2:
	var player_pos := player_camera.global_position if player_camera else Vector3.ZERO
	return unproject_position(player_pos) - (player_point.size * 0.5)
