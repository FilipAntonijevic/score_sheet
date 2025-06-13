class_name Player extends Control

@onready var player_name = $PlayerName
@onready var player_score = $PlayerScore


signal remove_this_player(player: Player)

func _ready() -> void:
	player_name.connect("remove_this_player", Callable(self, "_on_remove_this_player"))

func _on_remove_this_player() -> void:
	emit_signal("remove_this_player", self)
