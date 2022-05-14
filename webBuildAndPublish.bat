@ECHO OFF
ECHO Building project for web and publishing to git
ECHO flutter build web --release --base-href /interactive_text_flutter/ 
call flutter build web --release --base-href /interactive_text_flutter/ 

ECHO copy contents of build/web to docs/
call xcopy "build/web" "docs" /y /i

ECHO duplicate your index.html and rename it to 404.html
call xcopy "docs\index.html" "docs\404.html" /Y

ECHO git add and commit all with message "new web version"
call git add .
call git commit -m "new web version"

ECHO git push
call git push

ECHO Congrats, everything is ready. updates should appear on this link https://xeyad.github.io/interactive_text_flutter/ within few short minutes 
