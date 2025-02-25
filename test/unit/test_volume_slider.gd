extends GutTest

var vol_slider = load('res://Game_Files/Scripts/VolumeSlider.gd')  
	
func test_value():
	var v = vol_slider.new()
	assert_not_null(v.value)

func test_change_value():
	var v = vol_slider.new()
	v.bus_name = "Master"
	v._on_value_changed(0)
	assert_almost_eq(db_to_linear(AudioServer.get_bus_volume_db(v.bus_index)), 0.0,.01)
