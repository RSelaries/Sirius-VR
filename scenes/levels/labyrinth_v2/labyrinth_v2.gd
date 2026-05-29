extends Node


@export var labyrinth_size := Vector2(60.75, 60.75)


@export var player_camera: XRCamera3D
@onready var control_panel_menu_loader: ControlPanelMenuLoader = %ControlPanelMenuLoader
@onready var debug_sun: DirectionalLight3D = $DebugSun


func _ready() -> void:
	debug_sun.hide()
	debug_sun.queue_free()


func _physics_process(_delta: float) -> void:
	ControlPanel.send_information({
		"player_position": Vector2(
			player_camera.global_position.x,
			player_camera.global_position.z
		),
		"player_rotation": player_camera.global_rotation.y,
	})
