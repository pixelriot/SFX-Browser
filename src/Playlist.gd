extends ScrollContainer
"""
Playlist
"""
signal play_audio(file_path)
signal stop_audio()
signal export_finished(amount)
var file_list = []
var current_item = null
const ITEM = preload("res://ItemContainer.tscn")
onready var List = $VBoxContainer
onready var AnalizeThread = $AnalizeThread

func _ready() -> void:
	set_process(false)


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_F and event.pressed and not event.is_echo():
		if current_item:
			current_item.toggle_favourite()


func _process(_delta: float) -> void:
	if AnalizeThread.analysis_finished:
		set_process(false)
		var data = AnalizeThread.get_data()
		for i in List.get_child_count():
			List.get_child(i).set_additional_data(data[i])


func load_files_from_folder(_folder_path:String) -> void:
	current_item = null
	file_list.clear()
	file_list = _get_files_from_directory(_folder_path)

	#clear list
	for i in List.get_children():
		i.queue_free()

	#create new list items
	var index_size = str(file_list.size()).length()
	for j in file_list.size():
		var item = ITEM.instance()
		item.set_data(str(j).pad_zeros(index_size), file_list[j])
		List.add_child(item)
		item.connect("focus_entered", self, "_on_item_selected", [item])
		item.connect("gui_input", self, "_on_item_input", [item])

	#start analyze thread
	AnalizeThread.call_deferred("analyze_files", file_list)
	set_process(true)


func _get_files_from_directory(_folder_path:String) -> Array:
	var _file_list = []
	var d = Directory.new()
	d.open(_folder_path)
	d.list_dir_begin()
	var f = d.get_next()
	while (f != ""):
		if f.get_extension() in ["wav", "ogg", "mp3"]:
			_file_list.append(_folder_path + "/" + f)
		f = d.get_next()
	d.list_dir_end()

	_file_list.sort()
	return _file_list


func _on_item_selected(item) -> void:
	if current_item:
		current_item.unfocus()
	current_item = item
	#playback is handled in Playback node
	emit_signal("play_audio", item.get_file_path())


func _on_item_input(event:InputEvent, item:Control) -> void:
	if event is InputEventMouseButton and event.pressed and not event.is_echo():
		if item == current_item:
			if event.button_index == BUTTON_LEFT:
				#restart playback
				emit_signal("play_audio", item.get_file_path())
			elif event.button_index == BUTTON_RIGHT:
				#stop playback
				emit_signal("stop_audio")


func clear_export() -> void:
	for i in List.get_children():
		if i.get_export_name() != "":
			i.clear_export()


func export_files(export_dir:String) -> void:
	var dir = Directory.new()
	var amount = 0
	for i in List.get_children():
		var export_name = i.get_export_name()
		if export_name:
			var extention = i.get_file_path().get_extension()
			dir.copy(i.get_file_path(), export_dir + "/" + export_name + "." + extention)
			amount += 1
	emit_signal("export_finished", amount)

