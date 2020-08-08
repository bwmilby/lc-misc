Script "stack_ChainBehVarTest_button_id_1003"

/*
# Name: button "Object1" of card id 1002 of stack "ChainBehVarTest"
# ID: button id 1003 of card id 1002 of stack "ChainBehVarTest"
# Behavior: button id 1005 of stack "ChainBehVarTest"
*/


on mouseDown pButtonNumber
   put "=====" & lf before field "results"
   put "mouseDown:" && the abbrev name of me & lf before field "results"
   setBehavior1Var the short name of me
   setBehavior2Var the short id of me   
end mouseDown
