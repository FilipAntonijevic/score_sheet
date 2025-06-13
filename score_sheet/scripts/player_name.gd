extends Control

@onready var show_remove_and_edit_button = $show_remove_and_edit_button
@onready var remove_button = $remove_player
@onready var edit_button = $edit_player_name
@onready var name_label = $name
@onready var shader = $ColorRect

var player_name = ""
var focused := false

signal remove_this_player()

func _ready() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0)
	name_label.add_theme_stylebox_override("normal", style)
	name_label.add_theme_stylebox_override("focus", style)
	name_label.add_theme_stylebox_override("read_only", style)
	
func _on_show_remove_and_edit_button_pressed() -> void:
	if unfocus_other_areas():
		if focused or GlobalInfo.focused_area == null:
			show_remove_and_edit_button.hide()
			remove_button.show()
			edit_button.show()
			shader.show()
			focus()

func _on_edit_player_name_pressed() -> void:
	if unfocus_other_areas():
		if focused or GlobalInfo.focused_area == null:
			remove_button.hide()
			edit_button.hide()
			shader.hide()
			name_label.editable = true
			name_label.grab_focus()
			focus()

func _on_remove_player_pressed() -> void:
	if unfocus_other_areas():
		if focused or GlobalInfo.focused_area == null:
			emit_signal("remove_this_player")
			unfocus()
		
func _on_name_text_submitted(new_text: String) -> void:
	player_name = new_text
	name_label.editable = false
	show_remove_and_edit_button.show()
	unfocus()

func unfocus() -> void:
	name_label.editable = false
	show_remove_and_edit_button.show()
	remove_button.hide()
	edit_button.hide()
	shader.hide()
	focused = false
	GlobalInfo.focused_area = null

func focus() -> void:
	focused = true
	GlobalInfo.focused_area = self

func unfocus_other_areas() -> bool:
	if focused == false:
		if GlobalInfo.focused_area != null:
			GlobalInfo.focused_area.unfocus()
			return false
	return true
