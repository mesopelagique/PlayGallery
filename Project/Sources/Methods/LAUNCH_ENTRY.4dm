/*
Opens the component behind card $1.

Written out one branch per card rather than dispatched by name, on purpose: the
compiler then checks all eight. If a component fails to load, this base stops
compiling and names the method it could not find, instead of failing silently at
the click.
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

		PLAY_ActivityIndicator

		//______________________________________________________
	: ($index=8)

		PLAY_MatrixRain

		//______________________________________________________
End case
