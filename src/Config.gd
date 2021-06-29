extends Node
"""
Config
"""
var CONFIG_PATH = OS.get_user_data_dir() + "/config.cfg"
var CONFIGDATA = {	"main":{
						"folder_path": "",
						"export_path": ""
					}}
var FAVOURITES = []


func _init() -> void:
	print("SFX Browser starting")
	print("OS \t" + OS.get_name())
	connect("tree_exiting", self, "save_config")
	load_config()


func load_config() -> void:
	var c = ConfigFile.new()
	var err = c.load(CONFIG_PATH)
	if err == OK:
		for i in CONFIGDATA:
			print("" + str(i))
			for j in CONFIGDATA[i]:
				if c.has_section_key(i, j):
					CONFIGDATA[i][j] = c.get_value(i, j)
					print("--" + str(j) + " = " + str(CONFIGDATA[i][j]))
		FAVOURITES = c.get_value("main", "favourites", [])


func save_config():
	CONFIGDATA["main"]["favourites"] = FAVOURITES

	var c = ConfigFile.new()
	c.load(CONFIG_PATH)
	for i in CONFIGDATA:
		for j in CONFIGDATA[i]:
			c.set_value(i, j, CONFIGDATA[i][j])
	c.save(CONFIG_PATH)


