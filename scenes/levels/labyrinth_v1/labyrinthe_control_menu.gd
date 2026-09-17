extends LeftSideControlPanelMenu


@onready var timer: Timer = %Timer
@onready var check_button: CheckButton = %CheckButton


var animating: bool = true


func _ready() -> void:
	check_button.button_pressed = true


func _toggle_doors() -> void:
	if animating: return
	
	if LabyrintheMurChangeant.portes_ouvertes == LabyrintheMurChangeant.GroupesMurs.MURS_VERT:
		return
	
	if LabyrintheMurChangeant.portes_ouvertes == LabyrintheMurChangeant.GroupesMurs.MURS_ROUGES:
		LabyrintheMurChangeant.ouvrir_murs(LabyrintheMurChangeant.GroupesMurs.MURS_BLEU)
	else:
		LabyrintheMurChangeant.ouvrir_murs(LabyrintheMurChangeant.GroupesMurs.MURS_ROUGES)
	timer.start()
	animating = true


func _on_timer_timeout() -> void:
	animating = false


func _on_check_button_toggled(toggled_on: bool) -> void:
	LabyrintheMurChangeant.show_wall_color(toggled_on)


func _on_back_to_wait_room_pressed() -> void:
	change_scene("res://scenes/waiting_room/waiting_room.tscn")
