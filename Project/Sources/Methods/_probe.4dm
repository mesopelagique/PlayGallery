// temporary — isolates each path resolution, run with tool4d
var $package : 4D.Folder:=Folder(Folder("/PACKAGE").platformPath; fk platform path)

LOG EVENT(Into system standard outputs; "A base="+$package.platformPath+"\n"; Information message)

var $a : 4D.Folder:=$package.folder("../Confetti")
LOG EVENT(Into system standard outputs; "B relative="+$a.platformPath+" exists="+String($a.exists)+"\n"; Information message)

var $b : 4D.Folder:=Folder("/Users/phimage/Documents/GitHub/Hero")
LOG EVENT(Into system standard outputs; "C absolute="+$b.platformPath+" exists="+String($b.exists)+"\n"; Information message)

var $c : 4D.Folder:=Folder("/nowhere/at/all")
LOG EVENT(Into system standard outputs; "D missing exists="+String($c.exists)+"\n"; Information message)

var $env : Object:=JSON Parse(File("/PACKAGE/environment4d.json").getText())
LOG EVENT(Into system standard outputs; "E env="+JSON Stringify($env)+"\n"; Information message)
