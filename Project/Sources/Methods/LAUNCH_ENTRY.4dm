/*
Opens the component behind card $1.

Written out one branch per card rather than dispatched by name, on purpose: the
compiler then checks all eighteen. If a component fails to load, this base stops
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

			PLAY_Toast

			//______________________________________________________
		: ($index=8)

			PLAY_SegmentedControl

			//______________________________________________________
		: ($index=9)

			PLAY_FlipList

			//______________________________________________________
		: ($index=10)

			PLAY_ActivityIndicator

			//______________________________________________________
		: ($index=11)

			PLAY_ToggleSwitch

			//______________________________________________________
		: ($index=12)

			PLAY_Badge

			//______________________________________________________
		: ($index=13)

			PLAY_Stepper

			//______________________________________________________
		: ($index=14)

			PLAY_SkeletonLoader

			//______________________________________________________
		: ($index=15)

			PLAY_Accordion

			//______________________________________________________
		: ($index=16)

			PLAY_ProgressBar

			//______________________________________________________
		: ($index=17)

			PLAY_MatrixRain

			//______________________________________________________
		: ($index=18)

			PLAY_Confetti

			//______________________________________________________
End case
