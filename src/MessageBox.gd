extends Control
"""
Message Box
"""

func _ready() -> void:
	modulate.a = 1
	hide()


func display_message(_text:String, _color:Color=Config.THEME_COLOR_RED) -> void:
	modulate.a = 1
	show()
	get("custom_styles/panel").bg_color = _color
	$MarginContainer/HBoxContainer/Label.text = _text
	$Timer.start()


func _on_Timer_timeout() -> void:
	$AnimationPlayer.play("hide")


func _on_Close_pressed() -> void:
	$Timer.stop()
	_on_Timer_timeout()
