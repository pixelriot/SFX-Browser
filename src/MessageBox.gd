extends Control
"""
Message Box
"""

func _ready() -> void:
	modulate.a = 1
	hide()


func display_message(_text:String) -> void:
	modulate.a = 1
	show()
	$MarginContainer/HBoxContainer/Label.text = _text
	$Timer.start()


func _on_Timer_timeout() -> void:
	$AnimationPlayer.play("hide")


func _on_Close_pressed() -> void:
	$Timer.stop()
	_on_Timer_timeout()
