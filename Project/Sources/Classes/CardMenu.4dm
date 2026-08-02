/*
CardMenu — what a card offers on a right-click: the project on GitHub, or the copy
of it that 4D loaded, shown on disk.

It is kept out of cs.CardFx because a contextual click must not press the card. The
press exists to be seen before a modal dialog covers the gallery; this menu opens
nothing on the form, so there is nothing to wait for.

Both answers are read from the files the Dependency manager itself uses, never
repeated here:

  • the repository — Project/Sources/dependencies.json, where the components are
    declared. A card can then never point at a repository this base does not use.

  • the folder — dependencies-lock.json, written next to the project, which records
    for every dependency the folder it was loaded from. For a component downloaded
    from a GitHub release that is the local cache — still a real folder, and the
    one that is actually running. A component redirected to a working copy through
    environment4d.json is looked up there first, since that file overrides the rest.

Neither is guaranteed: no lock file yet, a component that never loaded, a project
opened from a built application where the sources are gone. A missing answer
disables its item rather than removing it, so the menu always reads the same.
*/

property dependencies : Collection  // card index -> the component it plays
property repositories : Object      // component name -> its repository URL

Class constructor()

	/*
	The gallery order: the order the cards are laid out in, and the order LAUNCH_ENTRY
	branches on. Only the first entry needs a second look — the card is labelled
	"Arcanoid", the component is ArcanoidGame.
	*/
	This.dependencies:=["ArcanoidGame"; "2048"; "Taquin"; "Puissance4D"; "Memory4D"; "EscapingButton"; "Toast"; "SegmentedControl"; "FlipList"; "ActivityIndicator"; "MatrixRain"; "Confetti"]

	This.repositories:=This._repositories()

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/*
The card the mouse is over, 0 between cards.

The cards are read from the form rather than from a table of positions: cs.CardFx
moves them while a press plays, and only the form knows where they are right now.
*/
Function cardUnderMouse() : Integer

	var $x; $y : Real
	var $button : Integer
	MOUSE POSITION($x; $y; $button)  // local, so already in form coordinates

	var $index : Integer

	For ($index; 1; This.dependencies.length)

		var $left; $top; $right; $bottom : Integer
		OBJECT GET COORDINATES(*; "card_"+String($index); $left; $top; $right; $bottom)

		If (($x>=$left) & ($x<=$right) & ($y>=$top) & ($y<=$bottom))

			return $index

		End if

	End for

	return 0

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// A card was right-clicked: the two ways out of the gallery, at the mouse
Function show($index : Integer)

	If (($index<1) | ($index>This.dependencies.length))

		return

	End if

	var $name : Text:=This.dependencies[$index-1]
	var $repository : Text:=This._repository($name)
	var $folder : 4D.Folder:=This._folder($name)

	// an item is disabled by an opening parenthesis — Pop up menu's own syntax
	var $items : Collection:=[]

	$items.push(This._item("Open on GitHub"; $repository#""))
	$items.push(This._item("Show in Finder"; $folder#Null))

	// dismissing the menu returns 0, so the choice has to be read before it is judged
	var $choice : Integer:=Pop up menu($items.join(";"))

	Case of

			//______________________________________________________
		: ($choice=1)

			OPEN URL($repository)

			//______________________________________________________
		: ($choice=2)

			// the folder itself, revealed inside its parent
			SHOW ON DISK($folder.platformPath)

			//______________________________________________________
	End case

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// An item, greyed out when there is nothing behind it
Function _item($label : Text; $enabled : Boolean) : Text

	If ($enabled)

		return $label

	End if

	return "("+$label

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The repository URL of every component this project declares
Function _repositories() : Object

	var $repositories : Object:={}
	var $declared : Object:=This._read(File("/SOURCES/dependencies.json"))

	If ($declared.dependencies=Null)

		return $repositories

	End if

	var $name : Text

	For each ($name; $declared.dependencies)

		If (Value type($declared.dependencies[$name])=Is object)

			var $entry : Object:=$declared.dependencies[$name]

			// every component here is on GitHub; a "gitlab" entry would need its own host
			If (Value type($entry.github)=Is text)

				$repositories[$name]:="https://github.com/"+$entry.github

			End if

		End if

	End for each

	return $repositories

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _repository($name : Text) : Text

	If (Value type(This.repositories[$name])=Is text)

		return This.repositories[$name]

	End if

	return ""

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The folder $name was loaded from, or Null when there is nothing to show
Function _folder($name : Text) : 4D.Folder

	var $folder : 4D.Folder:=This._overriddenFolder($name)

	If ($folder#Null)

		return $folder

	End if

	return This._lockedFolder($name)

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/*
The folder environment4d.json redirects $name to, if it does.

That file is the local override — it wins over dependencies.json, so it is read
first. It may sit in the package folder or in any folder above it, hence the walk
up, and hence the platform path: "/PACKAGE" is a filesystem root, and a folder
built on it stays inside it — its .parent stops there.

Its values are either a path — what we are after — or a { github } object for a
repository shared by several projects. Only the first is a folder.
*/
Function _overriddenFolder($name : Text) : 4D.Folder

	var $folder : 4D.Folder:=Folder(Folder("/PACKAGE").platformPath; fk platform path)

	While ($folder#Null)

		var $declared : Object:=This._read($folder.file("environment4d.json"))

		If ($declared.dependencies#Null)

			If (Value type($declared.dependencies[$name])=Is text)

				return This._existing(This._at($folder; $declared.dependencies[$name]))

			End if

		End if

		$folder:=$folder.parent

	End while

	return Null

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The folder $path names, read from $base when it is relative to it
Function _at($base : 4D.Folder; $path : Text) : 4D.Folder

	Case of

			//______________________________________________________
		: (Position("file://"; $path)=1)

			return Folder(Substring($path; 8))

			//______________________________________________________
		: (Position("/"; $path)=1)

			return Folder($path)

			//______________________________________________________
	End case

	return $base.folder($path)

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/*
The folder the lock file records for $name.

dependencies-lock.json is written next to the project, in the userPreferences folder
of whoever opened it — the only place the cache a GitHub release was downloaded to
is written down. It holds system paths, hence the conversion.
*/
Function _lockedFolder($name : Text) : 4D.Folder

	var $locked : Object:=This._read(This._lockFile())

	If ($locked.dependencies=Null)

		return Null

	End if

	var $entry : Object:=$locked.dependencies[$name]

	If ($entry=Null)

		return Null

	End if

	If (Value type($entry.path)#Is text)

		return Null

	End if

	// a dependency the manager could not find is written down with an empty path
	If ($entry.path="")

		return Null

	End if

	return This._existing(Folder(Convert path system to POSIX($entry.path)))

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The lock file, under the preferences folder that carries its owner's name.
	// Read through fullName: .name would stop at the dot and hand back "userPreferences"
Function _lockFile() : 4D.File

	var $folder : 4D.Folder

	For each ($folder; Folder("/PACKAGE").folders())

		If (Position("userPreferences."; $folder.fullName)=1)

			var $file : 4D.File:=$folder.file("dependencies-lock.json")

			If ($file.exists)

				return $file

			End if

		End if

	End for each

	return Null

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _existing($folder : 4D.Folder) : 4D.Folder

	If ($folder=Null)

		return Null

	End if

	If (Not($folder.exists))

		return Null

	End if

	return $folder

	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// A file that may not be there: an empty object, never an error
Function _read($file : 4D.File) : Object

	If ($file=Null)

		return {}

	End if

	If (Not($file.exists))

		return {}

	End if

	return JSON Parse($file.getText())
