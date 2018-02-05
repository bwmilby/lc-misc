script "pinchzoom"

-- Source code was converted from an example found here:
-- https://groups.google.com/forum/#!topic/PhoneGap/QpXAzVo_Fi8

-- Unsure of the original license.

on setAsBehavior pTarget
   set the behavior of pTarget to the long id of this me
end setAsBehavior

local panning, \
      zooming, \
      startX0, startY0, \
      startX1, startY1, \
      endX0, endY0, \
      endX1, endY1, \
      startDistanceBetweenFingers, \
      endDistanceBetweenFingers, \
      pinchRatio, \
      imgWidth, imgHeight, \
      currentContinuousZoom, \
      currentOffsetX, currentOffsetY, \
      currentWidth, currentHeight, \
      newContinuousZoom, \
      newHeight, newWidth, \
      newOffsetX, newOffsetY, \
      centerPointStartX, centerPointStartY, \
      centerPointEndX, centerPointEndY, \
      translateFromZoomingX, translateFromZoomingY, \
      translateFromTranslatingX, translateFromTranslatingY, \
      translateTotalX, translateTotalY, \
      percentageOfImageAtPinchPointX, \
      percentageOfImageAtPinchPointY

local sTouchArray, sTouch0, sTouch1
local sZoomObj


on touchStart pID
   if sZoomObj is empty then
      -- Change this to specify object
      put the long id of me into sZoomObj

      put the width of sZoomObj into imgWidth
      put the height of sZoomObj into imgHeight
      put the left of sZoomObj into currentOffsetX
      put the top of sZoomObj into currentOffsetY

      put imgWidth into currentWidth
      put imgHeight into currentHeight

      put 1.0 into currentContinuousZoom
   end if
end touchStart


on touchMove pID, pX, pY
   -- capture current position
   put pX into sTouchArray[pID]["x"]
   put pY into sTouchArray[pID]["y"]

   -- since the touch start doesn't include location, need to handle
   -- the calculations here
   if sTouchArray[pID]["started"] is empty then
      put true into sTouchArray[pID]["started"]
      if the number of lines of the keys of sTouchArray is 1 then
         put pID into sTouch0
         put pX into startX0
         put pY into startY0
      else if the number of lines of the keys of sTouchArray is 2 then
         put pID into sTouch1
         put sTouchArray[sTouch0]["x"] into startX0
         put sTouchArray[sTouch0]["y"] into startY0
         put pX into startX1
         put pY into startY1
         put ((startX0 + startX1) / 2.0) into centerPointStartX
         put ((startY0 + startY1) / 2.0) into centerPointStartY
         put (centerPointStartX - currentOffsetX) / currentWidth \
               into percentageOfImageAtPinchPointX
         put (centerPointStartY - currentOffsetY) / currentHeight \
               into percentageOfImageAtPinchPointY
         put sqrt((startX1-startX0)^2 + (startY1-startY0)^2) \
               into startDistanceBetweenFingers
      end if
      updatePanZoomState
      exit touchMove
   end if

   -- record the end touch locations for the move
   if panning then
      put pX into endX0
      put pY into endY0
   else if zooming then
      put sTouchArray[sTouch0]["x"] into endX0
      put sTouchArray[sTouch0]["y"] into endY0
      put sTouchArray[sTouch1]["x"] into endX1
      put sTouchArray[sTouch1]["y"] into endY1
   end if

   updateImage
end touchMove


on touchEnd pID
   put true into sTouchArray[pID]["ended"]
   updateImage
end touchEnd


on updateImage
   lock screen
   if panning then
      put endX0 - startX0 into translateFromTranslatingX
      put endY0 - startY0 into translateFromTranslatingY
      put currentOffsetX + translateFromTranslatingX into newOffsetX
      put currentOffsetY + translateFromTranslatingY into newOffsetY
   else if zooming then
      -- Calculate current distance between points to get new-to-old
      -- pinch ratio and calc width and height
      put sqrt((endX1-endX0)^2 + (endY1-endY0)^2) \
            into endDistanceBetweenFingers
      put endDistanceBetweenFingers/startDistanceBetweenFingers \
         into pinchRatio
      put pinchRatio * currentContinuousZoom into newContinuousZoom
      put imgWidth * newContinuousZoom into newWidth
      put imgHeight * newContinuousZoom into newHeight

      -- Get the point between the two touches, relative to upper-left
      -- corner of image
      put ((endX0 + endX1) / 2.0) into centerPointEndX
      put ((endY0 + endY1) / 2.0) into centerPointEndY

      -- This is the translation due to pinch-zooming
      put (currentWidth - newWidth) * percentageOfImageAtPinchPointX \
         into translateFromZoomingX
      put (currentHeight - newHeight) * percentageOfImageAtPinchPointY \
         into translateFromZoomingY

      -- And this is the translation due to translation of the
      -- centerpoint between the two fingers
      put centerPointEndX - centerPointStartX into \
        translateFromTranslatingX
      put centerPointEndY - centerPointStartY into \
        translateFromTranslatingY

      -- Total translation is from two components:
      --    (1) changing height and width from zooming and
      --    (2) from the two fingers translating in unity
      put translateFromZoomingX + translateFromTranslatingX \
         into translateTotalX
      put translateFromZoomingY + translateFromTranslatingY \
         into translateTotalY

      -- the new offset is the old/current one plus the total
      -- translation component
      put currentOffsetX + translateTotalX into newOffsetX
      put currentOffsetY + translateTotalY into newOffsetY

      -- Set the image attributes on the card
      set the width of sZoomObj to newWidth
      set the height of sZoomObj to newHeight
   end if
   set the left of sZoomObj to newOffsetX
   set the top of sZoomObj to newOffsetY

   -- clear touch array for ended touches after updating
   repeat for each key tKey in sTouchArray
      if sTouchArray[tKey]["ended"] then
         if tKey is sTouch0 then
            put sTouch1 into sTouch0
            put endX1 into endX0
            put endY1 into endY0
         end if
         if panning or zooming then
            put newOffsetX into currentOffsetX
            put newOffsetY into currentOffsetY
         end if
         if zooming then
            put newWidth into currentWidth
            put newHeight into currentHeight
            put newContinuousZoom into currentContinuousZoom
            put endX0 into startX0
            put endY0 into startY0
         end if
         delete variable sTouchArray[tKey]
      end if
   end repeat
   updatePanZoomState
   unlock screen
end updateImage


on updatePanZoomState
   put false into panning
   put false into zooming
   if the number of lines of the keys of sTouchArray is 1 then
      put true into panning
   else if the number of lines of the keys of sTouchArray is 2 then
      put true into zooming
   end if
end updatePanZoomState
