import {Howl} from 'howler'

global css body c:warm2 bg:warm8 ff:Arial inset:0 d:vcc

tag play-button

	prop fur-elise = new Howl({src: 'https://upload.wikimedia.org/wikipedia/commons/7/7b/FurElise.ogg'})

	def play
		fur-elise.stop()
		fur-elise.play()

	def stop
		fur-elise.stop()
	
	<self>
		<button @click=play> "Play"
		<button @click=stop> "Stop"

imba.mount <play-button>
