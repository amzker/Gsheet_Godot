# Gsheet_Godot
Connecting Google Sheet into godot with READ and WRITE access


# YouTube Video Tutorial
## Those who came from youtube video select branch v1
[![VIDEO](https://img.youtube.com/vi/jeg0boRWdxM/hqdefault.jpg)](https://www.youtube.com/watch?v=jeg0boRWdxM)
# Appscript code
```javascript
function doGet(e) {
  var action = e.parameter.action;
  
  switch (action) {
	case 'fetch_notes_list':
	  return fetchNotesList();
	case 'fetch_notes_content':
	  return fetchNotesContent(e.parameter.id);
	default:
	  return ContentService.createTextOutput("Invalid action");
  }
}

function doPost(e) {
  var action = e.parameter.action;
  
  switch (action) {
	case 'create_new_note':
	  return createNewNote(e.postData.contents);
	case 'save_existing_note':
	  return saveExistingNote(e.postData.contents);
	case 'delete_note':
	  return deleteNote(e.postData.contents);
	default:
	  return ContentService.createTextOutput("Invalid action");
  }
}

function createNewNote(data) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var jsonData = JSON.parse(data);
  var id = getNextId(sheet); 
  var title = jsonData.title;
  var text = jsonData.text;
  
  if (!title || !text) {
	return ContentService.createTextOutput("Title and text are required");
  }

  sheet.appendRow([id, title, text]);
  return ContentService.createTextOutput("New note created with ID: " + id);
}

function saveExistingNote(data) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var jsonData = JSON.parse(data);
  var id = parseInt(jsonData.id, 10);
  var title = jsonData.title;
  var text = jsonData.text;
  
  if (!id || !title || !text) {
	return ContentService.createTextOutput("ID, title, and text are required");
  }
						 // getRange(rowno , columnno)
  var range = sheet.getRange(2, 1, sheet.getLastRow() - 1, 3);
  var values = range.getValues();
  
  for (var i = 0; i < values.length; i++) {
	if (values[i][0] === id) {
	  sheet.getRange(i + 2, 2).setValue(title);  // Update title
	  sheet.getRange(i + 2, 3).setValue(text);   // Update text
	  return ContentService.createTextOutput("Note with ID " + id + " updated.");
	}
  }
  return ContentService.createTextOutput("Note with ID " + id + " not found.");
}

function fetchNotesList() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var range = sheet.getRange(2, 1, sheet.getLastRow() - 1, 2);  // Get ID and Title columns
  var values = range.getValues();
  var notesList = [];
  
  for (var i = 0; i < values.length; i++) {
	notesList.push({ id: values[i][0], title: values[i][1] });
  }
  
  return ContentService.createTextOutput(JSON.stringify(notesList))
	.setMimeType(ContentService.MimeType.JSON);
}

function fetchNotesContent(id) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var noteId = parseInt(id, 10);
  
  if (!noteId) {
	return ContentService.createTextOutput("ID is required");
  }
  
  var range = sheet.getRange(2, 1, sheet.getLastRow() - 1, 3);
  var values = range.getValues();
  
  for (var i = 0; i < values.length; i++) {
	if (values[i][0] === noteId) {
	  var note = { id: values[i][0], title: values[i][1], text: values[i][2] };
	  return ContentService.createTextOutput(JSON.stringify(note))
		.setMimeType(ContentService.MimeType.JSON);
	}
  }
  return ContentService.createTextOutput("Note with ID " + noteId + " not found.");
}

function deleteNote(data) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var jsonData = JSON.parse(data);
  var id = parseInt(jsonData.id, 10);
  
  if (!id) {
	return ContentService.createTextOutput("ID is required");
  }
  
  var range = sheet.getRange(2, 1, sheet.getLastRow() - 1, 3);
  var values = range.getValues();
  
  for (var i = 0; i < values.length; i++) {
	if (values[i][0] === id) {
	  sheet.deleteRow(i + 2);  // Delete the row with the matching ID
	  return ContentService.createTextOutput("Note with ID " + id + " deleted.");
	}
  }
  return ContentService.createTextOutput("Note with ID " + id + " not found.");
}

function getNextId(sheet) {
  var lastRow = sheet.getLastRow();
  if (lastRow === 1) return 1;  // No data yet
  
  var lastId = sheet.getRange(lastRow, 1).getValue();
  return lastId + 1;
}

```

# READING DATA FROM SHEET [GET]

```gdscript
func make_http_get_request(endpoint: String, params: Dictionary = {}) -> void:
	var url = app_url + "?action=" + endpoint
	for key in params.keys():
		url += "&" + key + "=" + str(params[key])

	var request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_request_completed)
	request.request(url)
	
	
func _on_request_completed(result, response_code, headers, body) -> void:
	if response_code == 200:
		
		var res = body.get_string_from_utf8()
		var json_result = JSON.parse_string(res)
```

# SENDING DATA/WRITING DATA TO SHEET [POST]
```gdscript
func make_http_post_request(endpoint: String, data: Dictionary) -> void:
	var url = app_url + "?action=" + endpoint
	#var json_data = JSON(data)
	var json_data = JSON.new().stringify(data)
	
	var request = HTTPRequest.new()
	add_child(request)
	print(url, json_data)
	request.connect("request_completed", _on_request_completed)
	request.request(url,  ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_data)
```
