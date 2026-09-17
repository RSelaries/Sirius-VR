extends Node3D


var hand_inside: bool = false
var switched_on: bool = false

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var hand_sprite: Sprite3D = %HandSprite


func _on_hand_pose_area_area_entered(area: Area3D) -> void:
	if area.name == "RightHandArea":
		hand_inside = true


func _on_hand_pose_area_area_exited(area: Area3D) -> void:
	if area.name == "RightHandArea":
		hand_inside = false


func _physics_process(delta: float) -> void:
	if switched_on: return
	
	if texture_progress_bar.value >= 1.0:
		switched_on = true
		get_tree().create_tween().tween_property(hand_sprite, "material_override:emission", Color.WHITE, 0.5)
		get_tree().create_tween().tween_property(texture_progress_bar, "value", 0.0, 0.1)
		LabyrinthV2DoorExit.active_switches += 1
		return
	
	if hand_inside:
		texture_progress_bar.value = clampf(texture_progress_bar.value + (0.5 * delta), 0.0, 1.0)
	else:
		texture_progress_bar.value = clampf(texture_progress_bar.value - (3 * delta), 0.0, 1.0)
