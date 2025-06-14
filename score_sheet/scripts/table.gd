extends Node2D

@onready var container = $ScrollContainer/VBoxContainer
@onready var control = $ScrollContainer/VBoxContainer/Control

func _on_add_player_button_pressed() -> void:
	if GlobalInfo.focused_area != null:
		GlobalInfo.focused_area.unfocus()
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	
	container.add_child(player)
	player.player_name.name_label.editable = true
	player.player_name.name_label.grab_focus()
	player.player_name.focus()
	GlobalInfo.focused_area = player.player_name
	player.connect("remove_this_player", Callable(self, "_on_remove_this_player"))
	container.move_child(control, container.get_child_count() - 1)

func _on_remove_this_player(player: Player) -> void:
	container.remove_child(player)

func _on_reset_game_pressed() -> void:
	var count = container.get_child_count()
	
	for i in range(0, count - 1):
		var child = container.get_child(i)
		child.player_score.score = 0
		child.player_score.score_label.text = "0"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if GlobalInfo.focused_area != null:
			GlobalInfo.focused_area.unfocus()
			GlobalInfo.focused_area = null


func _clicked_on_focused_area(pos: Vector2) -> bool:
	if GlobalInfo.focused_area == null:
		print('area is nul')
		return false
	else:
		print(GlobalInfo.focused_area.get_global_rect().has_point(pos))
		return GlobalInfo.focused_area.get_global_rect().has_point(pos)
	
func unfocus() -> void:
	var count = container.get_child_count()
	for i in range(0, count - 1):
		var child = container.get_child(i)
		if child.player_name.focused or child.player_score.focused:
			child.unfocus()
			
	GlobalInfo.focused_area = null
	GlobalInfo.something_is_focused = false
	
	
	
