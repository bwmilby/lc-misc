Script "stack_ScriptTrackerPrefs_widget_id_1041"

/*
# Name: widget "SelectEditor" of card "ScriptTracker" of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: widget id 1041 of card id 1034 of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# Widget Kind: com.livecode.widget.svgpath
*/


//>LOCALS
local sMouseIsDown


on mouseDown
   set the hilited of me to true
   put true into sMouseIsDown
   pass mouseDown
end mouseDown


on mouseUp
   set the hilited of me to false
   if sMouseIsDown and the mouseloc is within the rect of me then
      selectEditor
   end if
   put false into sMouseIsDown
end mouseUp


on mouseDoubleUp
   set the hilited of me to false
   put false into sMouseIsDown
end mouseDoubleUp


on mouseLeave
   set the hilited of me to false
   put false into sMouseIsDown
end mouseLeave


on selectEditor
   local tEditor
   
   answer file "Select text editor..."
   put it into tEditor
   if tEditor is not empty then
      put tEditor into field "Editor" of this card
      saveUpdatedPrefs
   end if
end selectEditor
