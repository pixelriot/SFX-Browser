extends HBoxContainer
"""
Playback
"""
signal show_help
signal show_info
var is_looping = false
onready var AudioPlayer := $AudioStreamPlayer


func _on_Play_pressed() -> void:
	if AudioPlayer.playing:
		AudioPlayer.stop()
	elif AudioPlayer.stream:
		AudioPlayer.play()
	set_play_icon()


func _on_Loop_toggled(button_pressed: bool) -> void:
	is_looping = button_pressed

	if AudioPlayer.playing:
		AudioPlayer.stop()
		if (AudioPlayer.stream is AudioStreamOGGVorbis
		or AudioPlayer.stream is AudioStreamMP3):
			AudioPlayer.stream.loop = button_pressed
		elif AudioPlayer.stream is AudioStreamSample:
			AudioPlayer.stream.loop_mode = 1 if button_pressed else 0
		AudioPlayer.play()


func _on_Info_pressed() -> void:
	emit_signal("show_info")


func _on_Help_pressed() -> void:
	emit_signal("show_help")


func _on_AudioStreamPlayer_finished() -> void:
	set_play_icon()


func play_audio(file_path:String="") -> void:
	if file_path:
		var stream = AudioImport.loadfile(file_path, is_looping)

#		var new_path = copy_file_to_user_folder(file_path)
#		yield(get_tree(), "idle_frame")
#		yield(get_tree(), "idle_frame")
#		yield(get_tree(), "idle_frame")
#		var s = load(new_path)
#		var stream = s

		if stream:
			AudioPlayer.stream = stream
	AudioPlayer.play()
	set_play_icon()


#func copy_file_to_user_folder(file_path:String="") -> String:
#	var dir = Directory.new()
#	var new_file_name = OS.get_user_data_dir() + "/" + file_path.get_file()
#	dir.copy(file_path, new_file_name)
#	return new_file_name


func stop_audio() -> void:
	AudioPlayer.stop()
	set_play_icon()


func set_play_icon() -> void:
	if AudioPlayer.playing:
		$Play.icon = load("res://assets/ic_stop.svg")
	elif AudioPlayer.stream:
		$Play.icon = load("res://assets/ic_autoplay.svg")


func directory_changed(_folder_path:String) -> void:
	AudioPlayer.stop()
	AudioPlayer.stream = null
	set_play_icon()



