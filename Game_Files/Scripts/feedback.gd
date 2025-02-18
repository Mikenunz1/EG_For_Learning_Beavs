extends Control

@onready var text_input = $VBoxContainer/TextEdit
@onready var submit_button = $VBoxContainer/Button
@onready var status_label = $VBoxContainer/Label2
@onready var title_label = $VBoxContainer/Label

var http_request: HTTPRequest

# Replace these with your Google Form details
const GOOGLE_FORM_ID = "your-form-id"
const GOOGLE_FORM_ENTRY_ID = "entry.1234567890"  # Your form entry ID

func _ready():
    http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_request_completed)
    
    submit_button.pressed.connect(_on_submit_pressed)
    
    status_label.text = ""
    title_label.text = "Share Your Feedback"
    submit_button.text = "Submit Feedback"

func _on_submit_pressed():
    if text_input.text.strip_edges().is_empty():
        status_label.text = "Please enter your feedback first!"
        return
    
    if not _check_internet_connection():
        status_label.text = "No internet connection. Please try again later."
        return
    
    submit_button.disabled = true
    status_label.text = "Sending feedback..."
    
    # Format data for Google Forms
    var feedback_text = text_input.text.uri_encode()
    var url = "https://docs.google.com/forms/d/%s/formResponse?%s=%s" % [
        GOOGLE_FORM_ID,
        GOOGLE_FORM_ENTRY_ID,
        feedback_text
    ]
    
    # Send as GET request (Google Forms doesn't accept POST from external sources)
    var error = http_request.request(url)
    
    if error != OK:
        status_label.text = "Error sending feedback. Please try again."
        submit_button.disabled = false

func _on_request_completed(result, response_code, headers, body):
    submit_button.disabled = false
    
    # Google Forms will return a redirect, which counts as success
    if result == HTTPRequest.RESULT_SUCCESS or response_code == 302:
        status_label.text = "Thank you for your feedback!"
        text_input.text = ""  # Clear the input
        await get_tree().create_timer(2.0).timeout
        status_label.text = ""
    else:
        status_label.text = "Error sending feedback. Please try again."

func _check_internet_connection() -> bool:
    var http = HTTPClient.new()
    var error = http.connect_to_host("8.8.8.8", 53)
    
    if error != OK:
        return false
    
    while http.get_status() == HTTPClient.STATUS_CONNECTING or \
          http.get_status() == HTTPClient.STATUS_RESOLVING:
        http.poll()
        await get_tree().create_timer(0.1).timeout
    
    return http.get_status() == HTTPClient.STATUS_CONNECTED
