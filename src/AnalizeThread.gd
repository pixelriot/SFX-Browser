extends Node
"""
Analyze Audio Samples
"""
var analysis_finished = false
var _thread
var lengths = []

func analyze_files(file_paths=[]) -> void:
	if _thread:
		var _t = _thread.wait_to_finish()
	_thread = Thread.new()
	_thread.start(self, "_analyze", file_paths)


func _analyze(file_paths=[]) -> void:
	print("analysis files ...")
	analysis_finished = false
	lengths.clear()
	for path in file_paths:
		var stream = AudioImport.loadfile(path)
		if stream:
			lengths.append(stream.get_length())
	analysis_finished = true
	print("... finished")


func get_data()-> Array:
	analysis_finished = false
	return lengths


func _exit_tree():
	if _thread:
		_thread.wait_to_finish()
