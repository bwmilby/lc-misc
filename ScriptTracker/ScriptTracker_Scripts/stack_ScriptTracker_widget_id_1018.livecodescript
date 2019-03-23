Script "stack_ScriptTracker_widget_id_1018"

/*
# Name: widget "Help" of card "Tracker" of stack "ScriptTracker"
# ID: widget id 1018 of card id 1002 of stack "ScriptTracker"
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
      launch url "https://github.com/bwmilby/lc-misc/blob/master/ScriptTracker/README.md"
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
