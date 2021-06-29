extends Control
"""
Godot audio sample manager
"""
onready var DirectoryBrowser := $PanelContainer/MarginContainer/DirectoryBrowser
onready var Playback := $MarginContainer/Workbench/Playback
onready var Playlist := $MarginContainer/Workbench/Playlist
onready var Export := $MarginContainer/Workbench/Export
onready var BrowserHelp := $PanelContainer/MarginContainer/DirectoryBrowser/BrowserHelp
onready var PlaybackHelp := $MarginContainer/Workbench/PlaybackHelp
onready var InfoBox := $MarginContainer/Workbench/InfoBox
onready var MessageBox := $MarginContainer/Workbench/MessageBox

func _ready() -> void:
	VisualServer.set_default_clear_color(Color("464655"))

	DirectoryBrowser.connect("directory_changed", Playlist, "load_files_from_folder")
	DirectoryBrowser.connect("directory_changed", Playback, "directory_changed")
	DirectoryBrowser.connect("directory_changed", PlaybackHelp, "close")

	Playback.connect("show_help", BrowserHelp, "show")
	Playback.connect("show_help", PlaybackHelp, "show")
	Playback.connect("show_info", InfoBox, "show")

	Playlist.connect("play_audio", Playback, "play_audio")
	Playlist.connect("stop_audio", Playback, "stop_audio")
	Playlist.connect("export_finished", Export, "export_finished")

	Export.connect("export_files", Playlist, "export_files")
	Export.connect("clear_export", Playlist, "clear_export")
	Export.connect("display_message", MessageBox, "display_message")


