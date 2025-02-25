# FeedbackUI.tscn
extends Control

# Email configuration
const SMTP_SERVER = "s"
const SMTP_PORT = 587
const SENDER_EMAIL = ""
const SENDER_PASSWORD = ""
const RECIPIENT_EMAIL = "game-feedback@yourdomain.com"

# Node references
@onready var feedback_text = $VBoxContainer/FeedbackText
@onready var send_button = $VBoxContainer/SendButton
@onready var status_label = $VBoxContainer/StatusLabel

func _ready():
    # Initialize UI elements
    status_label.hide()
    send_button.connect("pressed", _on_send_button_pressed)

func _on_send_button_pressed():
    if feedback_text.text.strip_edges() == "":
        show_status("Please enter your feedback first.", true)
        return
    
    # Disable button while sending
    send_button.disabled = true
    status_label.text = "Sending feedback..."
    status_label.show()
    
    # Create HTTP request node
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.connect("request_completed", _on_request_completed)
    
    # Prepare email data
    var email_data = {
        "feedback": feedback_text.text,
        "timestamp": Time.get_datetime_string_from_system(),
        "platform": OS.get_name()
    }
    
    # Convert to JSON
    var json = JSON.stringify(email_data)
    
    # Make the HTTP request (you'll need to set up your own endpoint)
    var error = http_request.request(
        "https://your-api-endpoint.com/send-feedback",
        ["Content-Type: application/json"],
        HTTPClient.METHOD_POST,
        json
    )
    
    if error != OK:
        show_status("Failed to send feedback. Please check your internet connection.", true)
        send_button.disabled = false

func _on_request_completed(result, response_code, headers, body):
    if response_code == 200:
        show_status("Thank you! Your feedback has been sent successfully.", false)
        feedback_text.text = ""
    else:
        show_status("Failed to send feedback. Please try again later.", true)
    
    send_button.disabled = false

func show_status(message: String, is_error: bool):
    status_label.text = message
    status_label.modulate = Color.RED if is_error else Color.GREEN
    status_label.show()
    
    # Hide status after 3 seconds
    await get_tree().create_timer(3.0).timeout
    status_label.hide()
