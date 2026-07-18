//%attributes = {}
// Open the gallery. Each card launches its component; closing it returns here.
var $formName:=Replace string:C233(Current method name:C684; "PLAY_"; "")
var $window:=Open form window:C675($formName; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
DIALOG:C40($formName)
CLOSE WINDOW:C154($window)
