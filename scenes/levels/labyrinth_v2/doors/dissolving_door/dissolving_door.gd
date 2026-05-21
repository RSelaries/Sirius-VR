extends Node3D


@onready var mesh: CSGBox3D = $Mesh


func _set_dissolve_value(value: float) -> void:
	var mat := mesh.material as ShaderMaterial
	mat.set_shader_parameter("mesh.material", value)


func _on_detect_player_area_area_entered(_area: Area3D) -> void:
	get_tree().create_tween().tween_method(_set_dissolve_value, 0.15, 1.0, 2.0)
