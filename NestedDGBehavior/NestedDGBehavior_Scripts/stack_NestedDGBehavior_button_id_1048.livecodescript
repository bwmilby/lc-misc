Script "stack_NestedDGBehavior_button_id_1048"

/*
# Name: button "Show DG Script" of card id 1002 of stack "NestedDGBehavior"
# ID: button id 1048 of card id 1002 of stack "NestedDGBehavior"
*/


//>CONSTANTS
constant kDGStack = "RevDataGridLibraryBehaviorsDataGridButtonBehavior"


on mouseUp pMouseButton
   local tLine
   
   put lineoffset("function _ResourceStack", the script of \
         stack kDGStack) into tLine
   edit script of stack kDGStack at tLine - 1
end mouseUp
