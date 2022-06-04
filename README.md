# Interactive_text
Flutter widget that enable user to generate sentences with some options 

# How to use
Start typing words in the Text area and the preview widget will render all words typed.
however, if it found any of these words: -- cat,dog,mouse -- it will render them differently cause these words gives you suggestions.
click on the words, to open and pick a suggestion.

you can add more sentences by pressing the labeled button. 
you can click on the title of the sentence to change it and you set active sentence by pressing anywhere inside it

# Architecture and design
You can learn more about how this widget is designed and what were the requirments by reading files in [docs](./documentation/)
architecture overview looks like this ![architecture overview](./documentation/interactive%20text%20widget.jpg)

# Unit tests
Unit tests covers only the critical path, mainly the text change detection algorthim and it's integration. so, make sure to run the tests and pass them if you change any of the following (Util.getChangeIndex() , Util.getStartingIndex(), PredictionMakerFieldController)


# Building for web
Run the auto build bat file 
Command: webBuildAndPublish.bat

or follow the steps below:
1. flutter build web --release --base-href /interactive_text_flutter/ 
1. copy contents of build/web to docs/
1. duplicate your index.html and rename it to 404.html
1. git push

# demo
1. find interactive link: https://xeyad.github.io/interactive_text_flutter/
1. check demo video in docs/demo.mp4