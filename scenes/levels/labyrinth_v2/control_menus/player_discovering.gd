@tool
extends TextureRect

const ICON = preload("uid://bxtkpdp36jwvj")

@export var base_color := Color.BLACK
@export_range(64, 200, 1, "suffix:px") var visibility_range := 128


var drawable_texture: DrawableTexture2D
var radial_gradiant: GradientTexture2D
var can_draw := false


@onready var watcher_camera: WatcherCamera = %WatcherCamera


func _ready() -> void:
	await get_tree().process_frame
	
	drawable_texture = DrawableTexture2D.new()
	drawable_texture.setup(int(size.x), int(size.y), DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, base_color)
	texture = drawable_texture
	
	radial_gradiant = GradientTexture2D.new()
	radial_gradiant.width = visibility_range
	radial_gradiant.height = visibility_range
	radial_gradiant.gradient = Gradient.new()
	radial_gradiant.gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	radial_gradiant.gradient.offsets = PackedFloat32Array([0.0, 1.0])
	radial_gradiant.gradient.colors = PackedColorArray([Color.WHITE, Color.TRANSPARENT])
	radial_gradiant.fill = GradientTexture2D.FILL_RADIAL
	radial_gradiant.fill_from = Vector2(0.5, 0.5)
	radial_gradiant.fill_to = Vector2(1.0, 0.5)
	
	can_draw = true


func _physics_process(_delta: float) -> void:
	if not can_draw: return
	draw_gradient()


func draw_gradient() -> void:
	if not radial_gradiant: return
	
	var player_pos := watcher_camera.get_player_position()
	var gradient_size := radial_gradiant.get_size()
	player_pos -= gradient_size / 2.0
	drawable_texture.blit_rect(Rect2i(player_pos, gradient_size), radial_gradiant)
