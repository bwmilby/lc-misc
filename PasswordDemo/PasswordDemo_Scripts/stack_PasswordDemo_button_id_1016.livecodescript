Script "stack_PasswordDemo_button_id_1016"

/*
# Name: button "Change PW" of card id 1002 of stack "PasswordDemo"
# ID: button id 1016 of card id 1002 of stack "PasswordDemo"
*/


on mouseUp
   local tAccounts, tCheckHash, tCorrectHash, tHash, tNewPassword
   local tPassword, tSalt, tUserName
   
   // first ensure that the new passwords math
   put field "NewPassword1" into tNewPassword
   if tNewPassword is not field "NewPassword2" then
      put "Passwords do not match" into field "Status"
      exit mouseUp
   end if
   
   put field "UserName" into tUserName
   
   if not getAccount(tUserName, tSalt, tCorrectHash) then
      // in production, probably would just report "Incorrect login"
      put "Account does not exist" into field "Status"
      exit mouseUp
   end if
   
   put field "Password" into tPassword
   put hmac.b64(tPassword, tSalt, "sha3-256") into tCheckHash
   
   if tCorrectHash is not tCheckHash then
      put "Old password incorrect" into field "Status"
      exit mouseUp
   end if
   
   // store the new password
   filter the text of field "Accounts" without (tUserName & tab & "*") into tAccounts
   put generateSalt() into tSalt
   put hmac.b64(tNewPassword, tSalt, "sha3-256") into tHash
   put tUserName & tab & base64encode(tSalt) & tab & tHash & lf \
         after tAccounts
   set the text of field "Accounts" to tAccounts
   
   put "Password changed" into field "Status"
end mouseUp
