extends Control

@onready var text_input = $VBoxContainer/TextEdit
@onready var submit_button = $VBoxContainer/Button
@onready var status_label = $VBoxContainer/Label2
@onready var title_label = $VBoxContainer/Label

var http_request: HTTPRequest

# Google Form details
const GOOGLE_FORM_ID = "1FAIpQLSdcS5Jzin1uTYqjd72eM_ksNP4ujLi4GN6tmzqFCU95Tm_e-A"
const GOOGLE_FORM_ENTRY_ID = "entry.1258281281"

func _ready():
	print("Script started")
	
	# Initialize HTTP request
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Connect signals
	submit_button.pressed.connect(_on_submit_pressed)
	http_request.request_completed.connect(_on_request_completed)
	
	print("Button signal connected: ", submit_button.pressed.is_connected(_on_submit_pressed))
	print("HTTP request signal connected: ", http_request.request_completed.is_connected(_on_request_completed))
	
	# Set initial UI text
	status_label.text = ""
	title_label.text = "Share Your Feedback"
	submit_button.text = "Submit Feedback"
	
	print("Initialization complete")

func _on_submit_pressed() -> void:
	print("Submit button pressed!")
	
	if text_input.text.strip_edges().is_empty():
		status_label.text = "Please enter your feedback first!"
		print("Empty feedback detected")
		return
	
	submit_button.disabled = true
	status_label.text = "Sending..."
	
	print("Sending feedback: ", text_input.text)
	
	# Prepare the form data
	var feedback_text = text_input.text.uri_encode()
	var form_data = "%s=%s" % [GOOGLE_FORM_ENTRY_ID, feedback_text]
	
	# Format the URL
	var url = "https://docs.google.com/forms/d/e/%s/formResponse" % GOOGLE_FORM_ID
	
	print("Attempting to send to URL: ", url)
	print("Form data: ", form_data)
	
	# Add headers with content length
	var headers = [
		"Content-Type: application/x-www-form-urlencoded",
		"Content-Length: " + str(form_data.length()),
		"User-Agent: Mozilla/5.0"
	]
	
	# Make the request
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, form_data)
	
	if error != OK:
		status_label.text = "Error code: " + str(error)
		submit_button.disabled = false
		print("Request error: ", error)

func _on_request_completed(result, response_code, headers, body):
	print("Request completed!")
	print("Result: ", result)
	print("Response code: ", response_code)
	
	submit_button.disabled = false
	
	if result == HTTPRequest.RESULT_SUCCESS or response_code == 200 or response_code == 302:
		status_label.text = "Thank you for your feedback!"
		text_input.text = ""
		await get_tree().create_timer(2.0).timeout
		status_label.text = ""
	else:
		status_label.text = "Error sending feedback (Code: " + str(response_code) + ")"
		print("Response headers: ", headers)
		if body:
			print("Response body: ", body.get_string_from_utf8())
