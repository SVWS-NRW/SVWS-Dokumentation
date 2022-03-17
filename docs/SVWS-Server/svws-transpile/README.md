# svws-transpile

2022-01-05
Ich werde jetzt gleich eine Version in den dev-Branch integrieren, die vollständig kompiliert, 
allerdings den Ordner "...core/adt/*" beim Transpilieren mit JSweet ignoriert. 
Die dortigen Datenstrukturen sollen also noch nicht in anderen Klassen genutzt werden! 
Sie sind erstmal nur für das Testen mit dem Transpiler gedacht. Dort sind einige Sachen drinnen, 
wo JSweet zur Zeit an seine Grenzen stößt, die ich aber unbedingt in unserem Transpiler funktional enthalten haben möchte... 
Sobald unser neuer Transpiler fertig ist werde ich noch weitere Datenstrukturen dort plazieren, 
die dann sowohl für Java als auch für Typescript gedacht sind. Das wird aber noch dauern...