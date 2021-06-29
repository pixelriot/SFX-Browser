extends VBoxContainer
"""
Directory Browser
"""
signal directory_changed(new_directory)
var current_directory : String
onready var Tree := $Tree
onready var FileDialog := $FileDialog
onready var BrowserHelp := $BrowserHelp

func _ready() -> void:
	$Load.text = tr("LOAD")

	yield(get_tree().current_scene, "ready")
	if Config.CONFIGDATA["main"]["folder_path"]:
		Tree.show()
		BrowserHelp.hide()
		current_directory = Config.CONFIGDATA["main"]["folder_path"]
		add_tree_items(current_directory)
		emit_signal("directory_changed", current_directory)
	else:
		Tree.hide()


func _on_FileDialog_dir_selected(dir: String) -> void:
	Tree.show()
	BrowserHelp.hide()
	current_directory = dir
	Tree.clear()
	add_tree_items(dir)

	Config.CONFIGDATA["main"]["folder_path"] = current_directory
	Config.save_config()
	emit_signal("directory_changed", current_directory)


func _on_Load_pressed():
	FileDialog.current_dir = current_directory
	FileDialog.window_title = tr("LOAD_POPUP")
	var popup_size = Vector2(800, 400)
	var popup_position = OS.window_size/2 - popup_size/2
	FileDialog.popup(Rect2(popup_position, popup_size))


func _on_Tree_item_selected() -> void:
	var item = Tree.get_selected()
	var path = current_directory + item.get_meta("path_in_tree")
	emit_signal("directory_changed", path)
	call_deferred("add_tree_items", path, item)


func add_tree_items(path:String, _root=null) -> void:
	var files = get_subdirectories(path.replace("//", "/"))
	var path_in_tree : String
	if not _root:
		_root = Tree.create_item()
	else:
		path_in_tree = _root.get_meta("path_in_tree")

	var item_children = get_tree_item_children(_root)
	for i in files:
		if i in item_children:
			continue
		var item = Tree.create_item(_root)
		item.set_text(0, i)
		item.set_meta("path_in_tree", path_in_tree + "/" + i)


func get_tree_item_children(root:TreeItem) -> Array:
	var item_children = []
	var ti = root.get_children()
	while ti:
		item_children.append(ti.get_text(0))
		ti = ti.get_next()
	return item_children


func get_subdirectories(path:String) -> Array:
	var directories = []

	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (dir.current_is_dir()
			and not file_name.begins_with(".")):
				directories.append(file_name)
			file_name = dir.get_next()
	dir.list_dir_end()

	directories.sort()
	return directories

