Script "stack_ChainBehVarTest_button_id_1006"

/*
# Name: button "Behavior2" of card id 1002 of stack "ChainBehVarTest"
# ID: button id 1006 of card id 1002 of stack "ChainBehVarTest"
*/


local sBehavior2Var

on mouseUp pMouseButton
   put "=====" & lf before field "results"
   put "this me:" && the abbrev name of this me & lf before field "results"
   put "mouseUp:" && the abbrev name of me & lf before field "results"
end mouseUp

on mouseEnter
   put "=====" & lf before field "results"
   put "sBehavior2Var is" && sBehavior2Var & lf before field "results"
   put "mouseEnter:" && the abbrev name of me & lf before field "results"
end mouseEnter

on setBehavior2Var pValue
   put "=====" & lf before field "results"
   put "sBehavior2Var was" && sBehavior2Var & lf before field "results"
   put pValue into sBehavior2Var
   put "sBehavior2Var is" && sBehavior2Var & lf before field "results"
end setBehavior2Var

function getBehavior2Var
   return sBehavior2Var
end getBehavior2Var
