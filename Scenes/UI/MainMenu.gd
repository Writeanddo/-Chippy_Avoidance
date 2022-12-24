extends Node

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var starting_menu: Control = $UI/StartingMenu
onready var options: Control = $UI/Options


func _ready() -> void:
	Config.load_data()
	options.fetch_and_set_general_setting()
	SoundManager.play_music(preload("res://Audio/Music/Mittsies - Horizon.ogg"))


func _on_StartingMenu_options_pressed() -> void:
	animation_player.play("move_to_options")
	options.focus()


func _on_Options_go_back() -> void:
	animation_player.play("move_to_main_from_options")


func _on_StartingMenu_exit_pressed() -> void:
	get_tree().quit()


func _on_StartingMenu_begin_pressed() -> void:
	get_tree().change_scene_to(Globals.AVOIDANCE)
