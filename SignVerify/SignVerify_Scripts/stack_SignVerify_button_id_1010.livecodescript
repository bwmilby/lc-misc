Script "stack_SignVerify_button_id_1010"

/*
# Name: button "ChooseFile" of card id 1002 of stack "SignVerify"
# ID: button id 1010 of card id 1002 of stack "SignVerify"
*/


on mouseUp
   answer file "Select a file to sign:"
   if the result is not "Cancel" then
      put it into field "FileToSign"
   end if
end mouseUp
