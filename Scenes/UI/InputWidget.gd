extends HBoxContainer

export var action_name := "jump"

var is_waiting_for_key: bool = false setget set_is_waiting_for_key
onready var button: Button = $MarginContainer/Button
onready var icon: TextureRect = $Icon
onready var awaiting_input: Label = $AwaitingInput


func _ready() -> void:
	InputHelper.connect("device_changed", self, "_on_device_changed")
	InputHelper.connect("action_key_changed", self, "_on_action_key_changed")
	InputHelper.connect("action_button_changed", self, "_on_action_button_changed")
	update_icon(InputHelper.has_gamepad())
	button.text = action_name
	self.is_waiting_for_key = false


func _input(event) -> void:
	if not is_waiting_for_key: return
	InputHelper.identify_current_input_device(event)
	accept_event()
	
	if event is InputEventMouseButton and event.is_pressed():
		self.is_waiting_for_key = false
		SoundManager.play_ui_sound(Globals.UI_BACK)
	if event is InputEventKey and event.is_pressed():
		InputHelper.set_action_key(action_name, event.as_text())
		self.is_waiting_for_key = false
		SoundManager.play_ui_sound(Globals.UI_ON)
		update_icon(false)
	elif event is InputEventJoypadButton and event.is_pressed():
		InputHelper.set_action_button(action_name, event.button_index)
		InputHelper.identify_current_input_device(event)
		self.is_waiting_for_key = false
		SoundManager.play_ui_sound(Globals.UI_ON)
		update_icon(true)


func update_icon(has_gamepad: bool = false) -> void:
	var current_device := InputHelper.guess_device_name()
	if not has_gamepad or current_device == InputHelper.DEVICE_KEYBOARD:
		icon.texture = InputHelper.get_keyboard_icon(action_name)
	else:
		icon.texture = InputHelper.get_gamepad_icon(action_name)


### Setters


func set_is_waiting_for_key(next_is_waiting_for_key: bool) -> void:
	is_waiting_for_key = next_is_waiting_for_key
	if is_waiting_for_key:
		button.disabled = true
		icon.hide()
		awaiting_input.show()
	else:
		button.disabled = false
		icon.show()
		awaiting_input.hide()


### Signals


func _on_Button_pressed() -> void:
	self.is_waiting_for_key = true
	SoundManager.play_ui_sound(Globals.UI_OFF)


func _on_device_changed(device: String, index: int) -> void:
	update_icon(device != InputHelper.DEVICE_KEYBOARD)

func _on_action_key_changed(_action_name: String, key: String) -> void:
	if action_name == _action_name:
		update_icon(false)

func _on_action_button_changed(_action_name: String, button: int) -> void:
	if action_name == _action_name:
		update_icon(true)
