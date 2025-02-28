# res://tests/test_feedback_ui.gd
extends "res://addons/gut/test.gd"

###############################################################
# HELPER FUNCTIONS
###############################################################

# Instantiate the feedback UI scene.
func setup_feedback_ui() -> Control:
	var scene = preload("res://feedback.tscn").instantiate()
	# Add to the scene tree so _ready() is invoked.
	get_tree().root.add_child(scene)
	return scene

# Clean up the test instance.
func teardown_feedback_ui(ui: Control) -> void:
	ui.queue_free()

###############################################################
# UNIT TESTS: Test individual methods/functions.
###############################################################

func test_empty_feedback_unit():
	# Arrange
	var ui = setup_feedback_ui()
	ui.text_input.text = ""
	# Act
	ui._on_submit_pressed()
	# Assert
	assert_eq(ui.status_label.text, "Please enter your feedback first!", "Unit: Should warn if feedback is empty")
	teardown_feedback_ui(ui)

func test_submit_feedback_success_unit():
	# Arrange
	var ui = setup_feedback_ui()
	ui.text_input.text = "Great game!"
	# Act
	ui._on_submit_pressed()
	# Immediately, the UI should disable the button and show "Sending..."
	assert_true(ui.submit_button.disabled, "Unit: Submit button should be disabled while sending")
	assert_eq(ui.status_label.text, "Sending...", "Unit: Status should display 'Sending...'")
	
	# Simulate a successful HTTP response by manually emitting the signal.
	ui.http_request.emit_signal("request_completed", HTTPRequest.RESULT_SUCCESS, 200, [], PackedByteArray())
	
	# Assert post-response UI updates.
	assert_false(ui.submit_button.disabled, "Unit: Submit button should be re-enabled after response")
	assert_eq(ui.status_label.text, "Thank you for your feedback!", "Unit: Status should thank the user")
	assert_eq(ui.text_input.text, "", "Unit: Feedback input should be cleared")
	teardown_feedback_ui(ui)

###############################################################
# VALIDATION TESTS: Validate high-level component (use-case)
###############################################################

func test_feedback_validation_empty_and_filled():
	# Arrange: Instance the UI.
	var ui = setup_feedback_ui()
	
	# Validation: Check that whitespace-only input is treated as empty.
	ui.text_input.text = "    "  # Only spaces
	ui._on_submit_pressed()
	assert_eq(ui.status_label.text, "Please enter your feedback first!", "Validation: Should warn for whitespace-only feedback")
	
	# Now, provide valid feedback.
	ui.text_input.text = "Nice work!"
	ui._on_submit_pressed()
	assert_eq(ui.status_label.text, "Sending...", "Validation: Should display 'Sending...' on valid feedback")
	# Simulate success.
	ui.http_request.emit_signal("request_completed", HTTPRequest.RESULT_SUCCESS, 200, [], PackedByteArray())
	assert_eq(ui.status_label.text, "Thank you for your feedback!", "Validation: Should thank the user after submission")
	teardown_feedback_ui(ui)

###############################################################
# INTEGRATION TESTS: Verify interactions among components.
###############################################################

func test_feedback_ui_integration_with_http():
	# Arrange: Instance the UI.
	var ui = setup_feedback_ui()
	ui.text_input.text = "Integration test feedback"
	ui._on_submit_pressed()
	
	# Check that the HTTPRequest node is connected to the response handler.
	var connected = ui.http_request.is_connected("request_completed", Callable(ui, "_on_request_completed"))
	assert_true(connected, "Integration: HTTPRequest should be connected to _on_request_completed")
	
	# Now simulate an error response.
	ui.http_request.emit_signal("request_completed", 1, 500, ["Content-Type: text/html"], PackedByteArray())
	assert_true(ui.status_label.text.begins_with("Error:"), "Integration: Should show an error message on failure")
	teardown_feedback_ui(ui)

###############################################################
# SYSTEM TESTS: Test the software in a different environment.
###############################################################

func test_feedback_system_full() -> void:
	# Arrange: Instance the UI and provide valid feedback.
	var ui = setup_feedback_ui()
	ui.text_input.text = "System test feedback"
	
	# Act: Simulate pressing the submit button.
	ui._on_submit_pressed()
	
	# Await the "request_completed" signal from the HTTPRequest node.
	var response = await ui.http_request.request_completed
	# response is an Array containing the signal parameters: [result, response_code, headers, body]
	var result = response[0]
	var response_code = response[1]
	
	# Assert: Check that the HTTP response code is 200.
	assert_eq(response_code, 200, "System: HTTP response code should be 200")
	
	# Assert: Check that the final status message is as expected.
	assert_eq(ui.status_label.text, "Thank you for your feedback!", "System: Should see success message after HTTP request completes.")
	
	teardown_feedback_ui(ui)
