Script "stack_PasswordDemo_button_id_1017"

/*
# Name: button "Login" of card id 1002 of stack "PasswordDemo"
# ID: button id 1017 of card id 1002 of stack "PasswordDemo"
*/


on mouseUp
   local tCheckHash, tCorrectHash, tPassword, tSalt, tUserName
   
   put field "UserName" into tUserName
   
   if not getAccount(tUserName, tSalt, tCorrectHash) then
      // in production, probably would just report "Incorrect login"
      put "Account does not exist" into field "Status"
      exit mouseUp
   end if
   
   // generate the hash from the provided password
   put field "Password" into tPassword
   put hmac.b64(tPassword, tSalt, "sha3-256") into tCheckHash
   
   // check that they match
   if tCorrectHash is tCheckHash then
      put "Login success" into field "Status"
   else
      put "Incorrect login" into field "Status"
   end if
end mouseUp
