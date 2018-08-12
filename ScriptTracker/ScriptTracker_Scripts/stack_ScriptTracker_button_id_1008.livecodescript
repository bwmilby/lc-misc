Script "stack_ScriptTracker_button_id_1008"

/*
# Name: button "StackMenu" of card "Tracker" of stack "ScriptTracker"
# ID: button id 1008 of card id 1002 of stack "ScriptTracker"
*/


on menuPick pItemName
   put pItemName into field "StackName" of this card
   send "textChanged" to field "StackName" of this card
end menuPick


on mouseDown pButtonNumber
   local tStackList, tStacks
   
   if the altkey is down then
      put the mainstacks into tStackList
   else
      put IDEUserMainstacks() into tStackList
   end if
   repeat for each line tStack in tStackList
      if the mode of stack tStack > 0 then
         put tStack & lf after tStacks
      end if
   end repeat
   delete char -1 of tStacks
   set the text of button "StackMenu" to tStacks
end mouseDown


on mouseEnter
   set the hilite of me to true
end mouseEnter


on mouseLeave
   set the hilite of me to false
end mouseLeave
