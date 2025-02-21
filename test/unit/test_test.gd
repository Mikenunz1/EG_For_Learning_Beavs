extends GutTest


func test_passes():
	assert_eq(1,1, "test passed 1=1")

func test_fails():
	assert_eq("hello","goodbye","test failed")
