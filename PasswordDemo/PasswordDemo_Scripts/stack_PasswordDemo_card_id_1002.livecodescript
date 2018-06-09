Script "stack_PasswordDemo_card_id_1002"

/*
# Name: card id 1002 of stack "PasswordDemo"
# ID: card id 1002 of stack "PasswordDemo"
*/


//>CONSTANTS
constant kSaltLength = 8


function generateSalt
   return randombytes(kSaltLength)
end generateSalt


-----


function getAccount pUserName, @rSalt, @rHash
   local tAccountInfo
   
   filter the text of field "Accounts" with (pUserName & tab & "*") into tAccountInfo
   if tAccountInfo is empty then
      return false
   else
      set the itemdel to tab
      put base64decode(item 2 of tAccountInfo) into rSalt
      put item 3 of tAccountInfo into rHash
      return true
   end if
end getAccount


-----


function hash pMsg, pCipher
   // Generic hash function that allows the demo to work in LC8 and LC9
   
   set the itemdel to "."
   if item 1 of the version >= 9 then
      return messageDigest(pMsg, pCipher)
   else
      if pCipher begins with "sha" then
         return sha1Digest(pMsg)
      else
         return md5Digest(pMsg)
      end if
   end if
end hash


function hash.hex pMsg, pKey, pCipher
   return binToHex(hash(pMsg, pKey, pCipher))
end hash.hex


function hash.b64 pMsg, pKey, pCipher
   return base64encode(hash(pMsg, pKey, pCipher))
end hash.b64


-----
// Based on code from Mark Smith
// http://www.webring.org/l/rd?ring=runtimerevoluti1;id=15;
//      url=http%3A%2F%2Fmarksmith%2Eon-rev%2Ecom%2Frevstuff%2F
// https://tools.ietf.org/html/rfc2104
-----


function hmac pMsg, pKey, pCipher
   if length(pKey) > 64 then put hash(pKey, pCipher) into pKey
   repeat 64 - length(pKey)
      put null after pKey
   end repeat
   
   repeat for each byte c in pKey
      put numtobyte(bytetonum(c) bitXor 54) after ipad
      put numtobyte(bytetonum(c) bitXor 92) after opad
   end repeat
   
   return hash(opad & hash(ipad & pMsg, pCipher), pCipher)
end hmac


function hmac.hex pMsg, pKey, pCipher
   return binToHex(hmac(pMsg, pKey, pCipher))
end hmac.hex


function hmac.b64 pMsg, pKey, pCipher
   return base64encode(hmac(pMsg, pKey, pCipher))
end hmac.b64


-----
// Based on code from Mark Smith
// http://www.webring.org/l/rd?ring=runtimerevoluti1;id=15;
//      url=http%3A%2F%2Fmarksmith%2Eon-rev%2Ecom%2Frevstuff%2F
-----


private function binToHex pString
   local tHex, tTemp
   
   repeat for each byte c in pString
      get bytetonum(c)
      put baseconvert(it,10,16) into tTemp
      if it < 16 then put "0" before tTemp
      put tTemp after tHex
   end repeat
   return tolower(tHex)
end binToHex


private function hexToBin pString
   local tBin
   
   repeat with n = 1 to length(pString) - 1 step 2
      put numtobyte(baseconvert(byte n to n + 1 of pString, 16, 10)) after tBin
   end repeat
   return tBin
end hexToBin
