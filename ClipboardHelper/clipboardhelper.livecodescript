script "clipboardhelper"

on makeClipboardPlainText
   local tClip, tRawType
   
   if the platform is "MacOS" then
      put "public.utf8-plain-text" into tRawType   -- OSX
   else if the platform is "Linux" then
      put "text/plain;charset=utf-8" into tRawType -- Linux
   else if the platform contains "Win" then
      put "CF_UNICODE" into tRawType -- Windows
   end if
   
   lock the clipBoard
   put the rawClipboardData[tRawType] into tClip
   set the rawClipboardData to empty
   set the rawClipboardData[tRawType] to tClip
   unlock the clipBoard
end makeClipboardPlainText


on updateClipboardHtmlText
   -- convert HTMLText to format appropriate for the system clipboard
   local tClipboard
   
   lock clipboard
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
   unlock clipboard
end updateClipboardHtmlText