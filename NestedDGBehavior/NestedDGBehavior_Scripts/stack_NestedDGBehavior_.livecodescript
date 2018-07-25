Script "stack_NestedDGBehavior_"

/*
# Name: stack "NestedDGBehavior"
# ID: stack "NestedDGBehavior"
*/


//>CONSTANTS
constant kDGStack = "RevDataGridLibraryBehaviorsDataGridButtonBehavior"


on preOpenStack
   local tEndLine, tStartLine, tDGScript
   
   put the script of stack kDGStack into tDGScript
   if lineoffset("sResourceStack", tDGScript) is 0 then
      /* insert updated script into the DG script */
      put lineoffset("function _ResourceStack", tDGScript) into tStartLine
      put lineoffset("end _ResourceStack", tDGScript) into tEndLine
      put the text of field "Script" of card id 1002 of me \
            into line tStartLine to tEndLine of tDGScript
      set the script of stack kDGStack to tDGScript
   end if
   
   pass preOpenStack
end preOpenStack

