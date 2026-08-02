/*
The gallery launches each dependency through its shared method.

Every game and effect publishes exactly one entry point — PLAY_<name>, marked
//%attributes = {"shared":true} — so the host can call it by name. That is the
whole contract between this base and the components.

A click does not launch straight away: cs.CardFx presses the card first, and the
component is opened from the end of that animation. The dialog is modal, so
opening it any earlier would swallow the press.

A right-click plays nothing: cs.CardMenu answers it with the card's repository and
the folder the component was loaded from.
*/

Case of

		//______________________________________________________
	: (Form event code=On Load)

		Form.transition:=cs.hero.ElementTransition.new()
		Form.fx:=cs.CardFx.new(Form.transition)
		Form.menu:=cs.CardMenu.new()

		//______________________________________________________
	: (Form event code=On Timer)

		Form.transition.onTimer()

		//______________________________________________________
	: (Form event code=On Clicked)

		If (Contextual click)  // right-click, or ctrl-click on macOS

			/*
			A contextual click plays nothing. The card is taken from under the mouse and
			not from FORM Event.objectName, so it makes no difference whether the click
			was reported by the button covering the card or by the form under it.
			*/
			Form.menu.show(Form.menu.cardUnderMouse())

		Else

			If (Position("play_"; FORM Event.objectName)=1)

				// play_1 .. play_12
				Form.fx.press(Num(Substring(FORM Event.objectName; 6)))

			End if

		End if

		//______________________________________________________
	: (Form event code=On Unload)

		SET TIMER(0)

		//______________________________________________________
End case
