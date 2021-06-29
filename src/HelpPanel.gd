extends PanelContainer
"""
Help Panels
"""

func _ready() -> void:
	for label in $MarginContainer/HBoxContainer.get_children():
		if label is Label:
			label.text = tr(label.name.to_upper())
	if Config.CONFIGDATA["main"]["folder_path"]:
		hide()
	else:
		show()


func close(_path=null) -> void:
	_on_Close_pressed()


func _on_Close_pressed() -> void:
	$AnimationPlayer.play("hide")


func show() -> void:
	modulate.a = 1
	.show()


