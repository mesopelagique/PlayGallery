/*
Opens the component behind card $1.

Written out one branch per card rather than dispatched by name, on purpose: the
compiler then checks all twenty-three. If a component fails to load, this base stops
compiling and names the method it could not find, instead of failing silently at
the click.

Order matches the gallery layout: games, then graphical components, then effects.
*/
#DECLARE($index : Integer)

Case of

			//______________________________________________________
		: ($index=1)

			PLAY_Arcanoid

			//______________________________________________________
		: ($index=2)

			PLAY_2048

			//______________________________________________________
		: ($index=3)

			PLAY_Taquin

			//______________________________________________________
		: ($index=4)

			PLAY_Puissance4D

			//______________________________________________________
		: ($index=5)

			PLAY_Memory4D

			//______________________________________________________
		: ($index=6)

			PLAY_EscapingButton

			//______________________________________________________
		: ($index=7)

			PLAY_Snake

			//______________________________________________________
		: ($index=8)

			PLAY_Gemboard

			//______________________________________________________
		: ($index=9)

			PLAY_Toast

			//______________________________________________________
		: ($index=10)

			PLAY_SegmentedControl

			//______________________________________________________
		: ($index=11)

			PLAY_FlipList

			//______________________________________________________
		: ($index=12)

			PLAY_ActivityIndicator

			//______________________________________________________
		: ($index=13)

			PLAY_ToggleSwitch

			//______________________________________________________
		: ($index=14)

			PLAY_Badge

			//______________________________________________________
		: ($index=15)

			PLAY_Stepper

			//______________________________________________________
		: ($index=16)

			PLAY_SkeletonLoader

			//______________________________________________________
		: ($index=17)

			PLAY_Accordion

			//______________________________________________________
		: ($index=18)

			PLAY_ProgressBar

			//______________________________________________________
		: ($index=19)

			PLAY_ColorPicker

			//______________________________________________________
		: ($index=20)

			PLAY_CommandPalette

			//______________________________________________________
		: ($index=21)

			PLAY_MatrixRain

			//______________________________________________________
		: ($index=22)

			PLAY_Confetti

			//______________________________________________________
		: ($index=23)

			PLAY_NyanCat

			//______________________________________________________
End case
