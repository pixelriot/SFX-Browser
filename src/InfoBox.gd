extends PanelContainer
"""
Info Box
"""

func _ready() -> void:
	var version = ProjectSettings["application/config/version"]
	var _text = ""
	_text += tr("APP_INFO") % [version] + "\n"
	_text += "[url=https://github.com/pixelriot/SFX-Browser]" + "Visit us on Github" + "[/url]" + "\n"

	$MarginContainer/HBoxContainer/RichTextLabel.bbcode_enabled = true
	$MarginContainer/HBoxContainer/RichTextLabel.bbcode_text = _text
	hide()


func close(_path=null) -> void:
	_on_Close_pressed()


func _on_Close_pressed() -> void:
	$AnimationPlayer.play("hide")


func show() -> void:
	modulate.a = 1
	.show()


func _on_RichTextLabel_meta_clicked(meta) -> void:
	OS.shell_open(meta)
