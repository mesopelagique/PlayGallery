/*
CardFx — the press a card gives back before its component opens, animated by
Hero (cs.hero). This base calls cs.hero itself, so Hero is a direct dependency and
is declared as one: CI checks out only what dependencies.json names, and relying
on it arriving behind another component builds locally but not on a runner.

A card is four objects — the panel, the logo, the name, the blurb — so a press has
to move all four as one. It is a TRANSLATION, not a scale: shrinking a text
object's box makes 4D re-wrap the line inside it, and the blurb would visibly
reflow mid-animation. Moving keeps every glyph where it was.

The dialog that a component opens is modal, so it must not be opened until the
animation has been seen: the launch hangs off the last tween's .then(), never
alongside it.
*/

property transition : cs.hero.ElementTransition
property cards : Integer:=19
property homes : Collection      // [i] -> the four objects' resting top, read from the form
property pending : Integer:=-1
property busy : Boolean:=False

property dip : Real:=5           // how far the card sinks under the click
property _parts : Collection:=["card"; "logo"; "name"; "blurb"]

Class constructor($transition : cs.hero.ElementTransition)

	This.transition:=$transition
	This.homes:=[]

	var $i : Integer

	For ($i; 1; This.cards)

		var $home : Object:={}
		var $part : Text

		For each ($part; This._parts)

			var $name : Text:=$part+"_"+String($i)
			$home[$part]:=cs.hero.ElementState.new($name).top

		End for each

		This.homes.push($home)

	End for

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// A card was clicked: press it, and let the press decide when to launch
Function press($i : Integer)

	If (This.busy)

		return

	End if

	This.busy:=True
	This.pending:=$i

	This._move($i; This.dip; 80; "easeOutQuad"; Formula(Form.fx._spring()))

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// …and back up, overshooting a little
Function _spring()

	This._move(This.pending; 0; 260; "easeOutBack"; Formula(Form.fx._launch()))

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Only now, with the press fully seen, hand over to the component
Function _launch()

	var $i : Integer:=This.pending

	This.busy:=False
	This.pending:=-1

	LAUNCH_ENTRY($i)

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/*
Move a whole card by $offset from its resting place.

The four parts share one duration and one curve, so they travel locked together.
Only the panel carries $then: the others would fire the same callback three more
times over.
*/
Function _move($i : Integer; $offset : Real; $duration : Real; $easing : Text; $then : 4D.Function)

	var $home : Object:=This.homes[$i-1]
	var $part : Text

	For each ($part; This._parts)

		var $animation : cs.hero.ElementAnimation:=This.transition.animate($part+"_"+String($i))\
			.to({top: $home[$part]+$offset})\
			.duration($duration)\
			.easing($easing)

		If ($part="card")

			$animation.then($then)

		End if

		$animation.start()

	End for each
