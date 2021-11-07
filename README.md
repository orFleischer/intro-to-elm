# Starting a New Elm Project in Intellij with the Elm Plugin

1. `mkdir <name of the folder and also the project>`
2. `git init`
3. `touch .gitignore` create the *.gitignore* file
4. Start new project in *Intellij, the project folder is the 
   folder you created earlier
5. `echo <files> >> .gitignore` adding stuff to .gitignore
6. `elm reactor --port=8080` to run the elm server on port 8080
7. `elm install <package-name>` like 8elm/http* and whatnot in order
   to add dependencies
8. `npm install -g elm-format` can be then used to format code on *Intellij*

[Elm official website beginners tutorials](https://guide.elm-lang.org/)