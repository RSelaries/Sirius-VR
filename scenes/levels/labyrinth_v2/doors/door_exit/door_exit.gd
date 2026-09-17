class_name LabyrinthV2DoorExit
extends Node3D


const NUMBER_OF_SWITCH = 2

@onready var door_base: LabyrinthV2DoorBase = %DoorBase

static var active_switches: int = 0:
	set = _set_active_switches


func _set_active_switches(value: int) -> void:
	active_switches = value
	if value >= NUMBER_OF_SWITCH:
		door_base.open_door()
