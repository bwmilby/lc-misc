Script "stack_ChainBehVarTest_button_id_1004"

/*
# Name: button "Object2" of card id 1002 of stack "ChainBehVarTest"
# ID: button id 1004 of card id 1002 of stack "ChainBehVarTest"
# Behavior: button id 1005 of stack "ChainBehVarTest"
*/


on mouseDown
   put "=====" & lf before field "results"
   put "mouseDown:" && the abbrev name of me & lf before field "results"
   setBehavior1Var (the short name of me && the seconds)
   setBehavior2Var the seconds
end mouseDown
