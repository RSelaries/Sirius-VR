@tool
class_name LabyrinthV2DoorBase
extends Node3D


const CONCRETE_2 = preload("uid://ebuwauy2j27e")
const WALL_MATERIAL = preload("uid://doa1jko6igydq")



@export var discreet := false:
	set(value):
		discreet = value
		if csg_box_3d_46:
			mat = WALL_MATERIAL if value else CONCRETE_2


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var csg_box_3d_46: CSGBox3D = $CSGBox3D46


var mat: StandardMaterial3D:
	get(): return csg_box_3d_46.material
	set(value):
		if csg_box_3d_46:
			csg_box_3d_46.material = value
		else:
			print("csgbox not found")


func _ready() -> void:
		mat = WALL_MATERIAL if discreet else CONCRETE_2


func open_door() -> void:
	animation_player.play("opening")
