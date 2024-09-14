extends Node2D

var app_url = "https://script.google.com/macros/s/AKfycbwoYoCCisqtU_q-mI-yZDm8MdlzmZwqV_d1ZJF44j8Nhbt7LrTm6i-dIOcpY3BfHwsDuA/exec"

@onready var note_text = $note_text
@onready var title = $title  
@onready var note_list = $note_list 

func _ready() -> void:
	fetch_notes_list()

# Make a GET request to the API
func make_http_get_request(endpoint: String, params: Dictionary = {}) -> void:
	var url = app_url + "?action=" + endpoint
	for key in params.keys():
		url += "&" + key + "=" + str(params[key])

	var request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_request_completed)
	request.request(url)

# Make a POST request to the API
func make_http_post_request(endpoint: String, data: Dictionary) -> void:
	var url = app_url + "?action=" + endpoint
	#var json_data = JSON(data)
	var json_data = JSON.new().stringify(data)
	
	var request = HTTPRequest.new()
	add_child(request)
	print(url, json_data)
	request.connect("request_completed", _on_request_completed)
	request.request(url,  ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_data)


# Handles the request completion
func _on_request_completed(result, response_code, headers, body) -> void:
	if response_code == 200:
		
		var res = body.get_string_from_utf8()
		var json_result = JSON.parse_string(res)
		print(res)
		print(json_result)
		
		if json_result:
			var data = json_result
			if typeof(data) == TYPE_ARRAY:
				note_list.clear()
				for note in data:
					note_list.add_item(str(note["id"]) + ": " + note["title"])
			else:
				# If it's not a list, it is note content , dont make like me , create proper separate functions , here i am just prototyping
				note_text.text = data["text"]
				title.text = data["title"]
		else:
			print("JSON parse error")
	else:
		print("Error with response code: ", response_code, result, body.get_string_from_utf8())

func save_note(method: String, id = null) -> void:
	var note_data = {
		"title": title.text,
		"text": note_text.text
	}
	if id != null:
		note_data["id"] = id
	await make_http_post_request(method, note_data)

func delete_note_by_id(id: int) -> void:
	var note_data = {
		"id": id
	}
	await make_http_post_request("delete_note", note_data)

func get_selected_note_id():
	var selected_items = note_list.get_selected_items()
	if selected_items.size() > 0:
		var item: String = note_list.get_item_text(selected_items[0])
		var id = item.split(":")[0].strip_edges()
		return int(id)
	return null

func get_selected_note_id_from_index(index: int) -> int:
	var item: String = note_list.get_item_text(index)
	var id = item.split(":")[0].strip_edges()
	return int(id)

func fetch_notes_list() -> void:
	make_http_get_request("fetch_notes_list")

func fetch_notes_text(id: int) -> void:
	make_http_get_request("fetch_notes_content", {"id": id})


func _on_save_button_pressed() -> void:
	await save_note("create_new_note")
	await fetch_notes_list()


func _on_update_pressed() -> void:
	var selected_id = get_selected_note_id()
	if selected_id != null:
		await save_note("save_existing_note", selected_id)
		await fetch_notes_list()

func _on_delete_pressed() -> void:
	var selected_id = get_selected_note_id()
	if selected_id != null:
		await delete_note_by_id(selected_id)
		await fetch_notes_list()

func _on_note_list_item_selected(index: int) -> void:
	var selected_id = get_selected_note_id_from_index(index)
	if selected_id != null:
		fetch_notes_text(selected_id)


func _on_refresh_pressed() -> void:
	fetch_notes_list()
