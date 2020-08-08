Script "stack_ChainBehVarTest_button_id_1009"

/*
# Name: button "Reset Var" of card id 1002 of stack "ChainBehVarTest"
# ID: button id 1009 of card id 1002 of stack "ChainBehVarTest"
*/


on mouseUp
   put empty into field "results"
   dispatch "setBehavior1Var" to button "Object1" with ""
   dispatch "setBehavior2Var" to button "Object1" with ""
   dispatch "setBehavior1Var" to button "Object2" with ""
   dispatch "setBehavior2Var" to button "Object2" with ""
end mouseUp
