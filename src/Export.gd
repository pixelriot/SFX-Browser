extends HBoxContainer
"""
Export
"""
signal export_files(path)
signal display_message(message)
signal clear_export
onready var Export := $Export
onready var FolderPath := $FolderPath
onready var FileDialog := $FileDialog
var export_path : String

func _ready() -> void:
	$Clear.text = tr("CLEAR")
	Export.text = tr("EXPORT")

	if Config.CONFIGDATA["main"]["export_path"]:
		export_path = Config.CONFIGDATA["main"]["export_path"]
		FolderPath.text = export_path


func _on_Clear_pressed() -> void:
	emit_signal("clear_export")


func _on_ExportPath_pressed() -> void:
	FileDialog.window_title = tr("EXPORT_POPUP")
	var popup_size = Vector2(800, 400)
	var popup_position = OS.window_size/2 - popup_size/2
	FileDialog.popup(Rect2(popup_position, popup_size))


func _on_FileDialog_dir_selected(dir: String) -> void:
	export_path = dir
	FolderPath.text = export_path
	Config.CONFIGDATA["main"]["export_path"] = export_path
	Config.save_config()


func _on_Export_pressed():
	if export_path == "":
		_on_ExportPath_pressed()
	else:
		emit_signal("export_files", export_path)


func export_finished(amount:int) -> void:
	if amount == 0:
		emit_signal("display_message", tr("NO_EXPORT_FILES"))
	else:
		emit_signal("display_message", tr("EXPORT_INFO") % [str(amount), export_path])



