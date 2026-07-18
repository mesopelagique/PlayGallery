/*
The gallery launches each dependency through its shared method.

Every game and effect publishes exactly one entry point — PLAY_<name>, marked
//%attributes = {"shared":true} — so the host can call it by name. That is the
whole contract between this base and the components.

A click does not launch straight away: cs.CardFx presses the card first, and the
component is opened from the end of that animation. The dialog is modal, so
opening it any earlier would swallow the press.
*/

Case of

		//______________________________________________________
	: (Form event code=On Load)

		Form.transition:=cs.hero.ElementTransition.new()
		Form.fx:=cs.CardFx.new(Form.transition)

		//______________________________________________________
	: (Form event code=On Timer)

		Form.transition.onTimer()

		//______________________________________________________
	: (Form event code=On Clicked)

		If (Position("play_"; FORM Event.objectName)=1)

			// play_1 .. play_8
			Form.fx.press(Num(Substring(FORM Event.objectName; 6)))

		End if

		//______________________________________________________
	: (Form event code=On Unload)

		SET TIMER(0)

		//______________________________________________________
End case
