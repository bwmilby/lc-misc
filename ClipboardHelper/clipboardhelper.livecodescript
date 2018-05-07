script "clipboardhelper"

on extensionInitialize
   if the target is not me then
      pass extensionInitialize
   end if
   
   insert the script of me into back
end extensionInitialize

on extensionFinalize
   if the target is not me then
      pass extensionFinalize
   end if
   
   remove the script of me from back
end extensionFinalize
---------------------------------------------------------------------


-- PR 6293 for bug 19206 should mostly eliminate the need for this
-- handler since the developer can specify what type of data to copy.
-- This handler will copy the UTF8 plain text representation off the
-- clipboard, clear the clipboard, and place that representation back
-- as the only representation on the clipboard.
on makeClipboardPlainText
   local tClip, tRawType
   
   if the platform is "MacOS" then
      put "public.utf8-plain-text" into tRawType   -- OSX
   else if the platform is "Linux" then
      put "text/plain;charset=utf-8" into tRawType -- Linux
   else if the platform contains "Win" then
      put "CF_UNICODETEXT" into tRawType -- Windows
   end if
   
   lock the clipBoard
   put the rawClipboardData[tRawType] into tClip
   set the rawClipboardData to empty
   set the rawClipboardData[tRawType] to tClip
   unlock the clipBoard
end makeClipboardPlainText


-- This handler is to partially address bug 18699.  There is no way to
-- remove a single representation from the clipboard, so when styled
-- text is needed, this can be used to make the HTML on the system
-- clipboard be a more accurate representation of the styled text.
-- If text only is needed, the above handler should be used.
on updateClipboardHtmlText
   local tClipboard
   
   lock the clipboard
   put the fullClipboardData["HTMLtext"] into tClipboard

   -- retain empty lines
   replace "<p></p>" with "<div><br /></div>" in tClipboard

   -- eliminate double spacing
   replace "<p>" with "<div>" in tClipboard
   replace "</p>" with "</div>" in tClipboard

   -- retain multiple spaces
   replace "  " with "&nbsp;&nbsp;" in tClipboard
   replace "&nbsp; " with "&nbsp;&nbsp;" in tClipboard
   replace "> <" with ">&nbsp;<" in tClipboard

   set the fullClipboardData["html"] to tClipboard
   unlock the clipboard
end updateClipboardHtmlText
