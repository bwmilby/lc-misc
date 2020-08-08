Script "stack_ChainBehVarTest_button_id_1005"

/*
# Name: button "Behavior1" of card id 1002 of stack "ChainBehVarTest"
# ID: button id 1005 of card id 1002 of stack "ChainBehVarTest"
# Behavior: button id 1006 of stack "ChainBehVarTest"
*/


local sBehavior1Var

on mouseUp pMouseButton
   put "=====" & lf before field "results"
   put "sBehavior2Var is" && getBehavior2Var() & lf before field "results"
   put "sBehavior1Var is" && sBehavior1Var & lf before field "results"
   put "this me:" && the abbrev name of this me & lf before field "results"
   put "mouseUp:" && the abbrev name of me & lf before field "results"
end mouseUp

on setBehavior1Var pValue
   put "=====" & lf before field "results"
   put "sBehavior1Var was" && sBehavior1Var & lf before field "results"
   put pValue into sBehavior1Var
   put "sBehavior1Var is" && sBehavior1Var & lf before field "results"
end setBehavior1Var

function getBehavior1Var
   return sBehavior1Var
end getBehavior1Var
