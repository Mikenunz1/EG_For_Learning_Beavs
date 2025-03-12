# Latest Test Results

\---  GUT  \---  
\[INFO\]:  using \[/github/home/.local/share/godot/app\_userdata/EGF\_Learning\_Beavers\] for temporary output.  
Godot version:  4.3.0  
GUT version:  9.3.1

res://test/unit/test\_boundaries.gd  
\* test\_right\_boundary  
    \-- Awaiting 15 frame(s) \--   
Starting position: (27314.6, 200\)  
Expected boundary: 27814.6  
Final position: (27614.6, 200\)  
\* test\_left\_boundary  
    \-- Awaiting 15 frame(s) \--   
Starting position: (516.75, 200\)  
Expected boundary: 16.75  
Final position: (216.75, 200\)  
\* test\_top\_boundary  
    \-- Awaiting 15 frame(s) \--   
Starting position: (200, 509\)  
Expected boundary: 9  
Final position: (200, 209\)  
\* test\_bottom\_boundary  
    \-- Awaiting 15 frame(s) \--   
Starting position: (200, 5888\)  
Expected boundary: 6388  
Final position: (200, 6188\)  
4/4 passed.

res://test/unit/test\_feedback\_ui.gd  
\* test\_empty\_feedback\_unit  
Script started  
Feedback UI initialized  
Submit button pressed\!  
Empty feedback detected  
\* test\_submit\_feedback\_success\_unit  
Script started  
Feedback UI initialized  
Submit button pressed\!  
Sending feedback: Great game\!  
Attempting to send to URL: https://docs.google.com/forms/d/e/1FAIpQLSdcS5Jzin1uTYqjd72eM\_ksNP4ujLi4GN6tmzqFCU95Tm\_e-A/formResponse  
Form data: entry.366340186=Great%20game%21  
Request completed\!  
Result: 0  
Response code: 200  
\* test\_feedback\_validation\_empty\_and\_filled  
Script started  
Feedback UI initialized  
Submit button pressed\!  
Empty feedback detected  
Submit button pressed\!  
Sending feedback: Nice work\!  
Attempting to send to URL: https://docs.google.com/forms/d/e/1FAIpQLSdcS5Jzin1uTYqjd72eM\_ksNP4ujLi4GN6tmzqFCU95Tm\_e-A/formResponse  
Form data: entry.366340186=Nice%20work%21  
Request completed\!  
Result: 0  
Response code: 200  
\* test\_feedback\_ui\_integration\_with\_http  
Script started  
Feedback UI initialized  
Submit button pressed\!  
Sending feedback: Integration test feedback  
Attempting to send to URL: https://docs.google.com/forms/d/e/1FAIpQLSdcS5Jzin1uTYqjd72eM\_ksNP4ujLi4GN6tmzqFCU95Tm\_e-A/formResponse  
Form data: entry.366340186=Integration%20test%20feedback  
Request completed\!  
Result: 1  
Response code: 500  
Response headers: \["Content-Type: text/html"\]  
\* test\_feedback\_system\_full  
Script started  
Feedback UI initialized  
Submit button pressed\!  
Sending feedback: System test feedback  
Attempting to send to URL: https://docs.google.com/forms/d/e/1FAIpQLSdcS5Jzin1uTYqjd72eM\_ksNP4ujLi4GN6tmzqFCU95Tm\_e-A/formResponse  
Form data: entry.366340186=System%20test%20feedback  
Request completed\!  
Result: 0  
Response code: 200  
5/5 passed.

res://test/unit/test\_player\_demo.gd  
\* test\_player\_exists  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_game\_group  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_set\_player\_position  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_set\_manager\_position  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_move\_right  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_move\_left  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_move\_down  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_move\_up  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
8/8 passed.

res://test/unit/test\_player\_movement\_audio.gd  
\* test\_movement\_audio  
Script started  
Feedback UI initialized  
    \-- Awaiting 1 frame(s) \-- WAIT  
1/1 passed.

res://test/unit/test\_swimming.gd  
\* test\_game\_exists  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_game\_restart  
    \-- Awaiting 1 frame(s) \-- WAIT  
\* test\_movement  
    \-- Awaiting 1 frame(s) \-- WAIT  
3/3 passed.

res://test/unit/test\_swimming\_sfx.gd  
\* test\_movement\_audio  
    \-- Awaiting 1 frame(s) \-- WAIT  
1/1 passed.

res://test/unit/test\_test.gd  
\* test\_test  
1/1 passed.

res://test/unit/test\_volume\_slider.gd  
\* test\_value  
\* test\_change\_value  
2/2 passed.

\==============================================  
\= Run Summary  
\==============================================

\---- Totals \----  
Scripts           8  
Tests             25  
  Passing         25  
Asserts           45  
Time              1.147s

\---- All tests passed\! \----

Results saved to ./test\_results.xml

Test count:  25  
Fail count:  0  
Passrate:  1  
Success:  true