class_name Player_score extends Control

@onready var show_plus_and_minus_button = $Show_plus_and_minus_buttons
@onready var plus_button = $Plus_button
@onready var minus_button = $Minus_button

@onready var shader = $shader

@onready var score_label = $Score_label
@onready var change_score = $ColorRect
@onready var change_score_label = $ColorRect/change_score_label

var score: float  = 0
var focused := false
var operation = ""

var press_start_time  := 0.0
var long_press_threshold  := 0.5

func _ready():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0)
	score_label.add_theme_stylebox_override("normal", style)
	score_label.add_theme_stylebox_override("focus", style)
	score_label.add_theme_stylebox_override("read_only", style)
	
	change_score_label.add_theme_stylebox_override("normal", style)
	change_score_label.add_theme_stylebox_override("focus", style)
	change_score_label.add_theme_stylebox_override("read_only", style)
	show_plus_and_minus_button.connect("gui_input", _on_show_plus_and_minus_button_gui_input)

func _on_show_plus_and_minus_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			press_start_time = Time.get_ticks_msec() / 1000.0
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var held_time = Time.get_ticks_msec() / 1000.0 - press_start_time
			if held_time >= long_press_threshold:
				_on_long_press()
			else:
				_on_short_press()
				
func _on_short_press() -> void:
	if unfocus_other_areas():
		if focused or GlobalInfo.focused_area == null:
			show_plus_and_minus_button.hide()
			plus_button.show()
			minus_button.show()
			shader.show()
			focus()
		
func _on_long_press() -> void:
	if unfocus_other_areas():
		if focused or GlobalInfo.focused_area == null:
			score_label.editable = true
			score_label.grab_focus()
			score_label.caret_column = score_label.text.length() 
			focus()
		
func _on_plus_button_pressed() -> void:
	if unfocus_other_areas():
		if focused or GlobalInfo.focused_area == null:
			plus_button.hide()
			minus_button.hide()
			shader.hide()
			change_score_label.text = ""
			change_score.show()
			change_score_label.editable = true
			change_score_label.grab_focus()
			operation = "plus"
			focus()
			
func _on_minus_button_pressed() -> void:
	if unfocus_other_areas():
		if focused or GlobalInfo.focused_area == null:
			plus_button.hide()
			minus_button.hide()
			shader.hide()
			change_score_label.text = ""
			change_score.show()
			change_score_label.editable = true
			change_score_label.grab_focus()
			operation = "minus"
			focus()
		
func _on_change_score_label_text_submitted(_new_text: String) -> void:
	change_score.hide()
	if operation == "plus":
		score += float(change_score_label.text)
	else:
		score -= float(change_score_label.text)
	change_score_label.text = ""
	score_label.set_text(str(score))
	minus_button.hide()
	plus_button.hide()
	show_plus_and_minus_button.show()
	unfocus()


func _on_score_label_text_submitted(new_text: String) -> void:
	score = float(new_text)
	score_label.editable = false
	unfocus()

func unfocus() -> void:
	score_label.editable = false
	show_plus_and_minus_button.show()
	plus_button.hide()
	minus_button.hide()
	change_score_label.text = ""
	change_score.hide()
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
