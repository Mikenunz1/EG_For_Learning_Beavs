extends GutTest

var vol_slider = load("res://Game_Files/Scenes/UI/VolumeSlider.tscn")  
var v = null

func before_each():
	v = vol_slider.instantiate()
	get_tree().root.add_child(v)
	
func test_value():
	assert_not_null(v.value)

func test_change_value():
	v.bus_name = "Master"
	v._on_value_changed(0)
	assert_almost_eq(db_to_linear(AudioServer.get_bus_volume_db(v.bus_index)), 0.0,.01)
