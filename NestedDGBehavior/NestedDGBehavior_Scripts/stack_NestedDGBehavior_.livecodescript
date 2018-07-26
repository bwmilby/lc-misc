Script "stack_NestedDGBehavior_"

/*
# Name: stack "NestedDGBehavior"
# ID: stack "NestedDGBehavior"
*/


//>CONSTANTS
constant kDGStack8 = "RevDataGridLibrary"
constant kDGStack9 = "RevDataGridLibraryBehaviorsDataGridButtonBehavior"


on preOpenStack
   local tEndLine, tStartLine, tDGScript
   
   if char 1 of the version is in (6,7,8) then
      put the script of button id 1005 of stack kDGStack8 into tDGScript
   else
      put the script of stack kDGStack9 into tDGScript
   end if
   
   if lineoffset("sResourceStack", tDGScript) is 0 then
      /* insert updated script into the DG script */
      put lineoffset("function _ResourceStack", tDGScript) into tStartLine
      put lineoffset("end _ResourceStack", tDGScript) into tEndLine
      put the text of field "Script" of card id 1002 of me \
            into line tStartLine to tEndLine of tDGScript
      
      if char 1 of the version is in (6,7,8) then
         set the script of button id 1005 of stack kDGStack8 to tDGScript
      else
         set the script of stack kDGStack9 to tDGScript
      end if
   end if
   
   pass preOpenStack
end preOpenStack

