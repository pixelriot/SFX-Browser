extends HBoxContainer
"""
Item Container
"""
var file_path : String

func set_data(idx:String, _file_path:String) -> void:
	file_path = _file_path
	$Idx.text = idx
	$File.text = file_path.get_file()
	if file_path in Config.FAVOURITES:
		$Favourite.pressed = true
	unfocus()


func set_additional_data(length:float) -> void:
	$Length.text = ( str(length).pad_decimals(2) )


func get_file_path() -> String:
	return file_path


func get_export_name() -> String:
	return $ExportName.text


func clear_export() -> void:
	$ExportName.text = ""


func _on_ItemContainer_focus_entered() -> void:
	modulate.a = 1
	$Icon.modulate.a = 1


func unfocus() -> void:
	modulate.a = 1
	$Icon.modulate.a = 0


func _on_Favourite_toggled(button_pressed: bool) -> void:
	if button_pressed:
		if not file_path in Config.FAVOURITES:
			Config.FAVOURITES.append(file_path)
	else:
		if file_path in Config.FAVOURITES:
			Config.FAVOURITES.erase(file_path)


func toggle_favourite() -> void:
	$Favourite.pressed = not $Favourite.pressed


