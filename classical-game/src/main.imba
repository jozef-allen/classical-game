import {Howl} from 'howler'
import {works} from "./works.imba"

global css body c:warm2 bg:warm8 ff:Arial inset:0 d:vcc

class Work
		prop title
		prop composer
		prop period
		prop composedIn
		prop form
		prop instrumentation
		prop recordedIn
		prop recordedBy
		prop src

		constructor item
			title = item.title
			composer = item.composer
			period = item.period
			composedIn = item.composedIn
			form = item.form
			instrumentation = item.instrumentation
			recordedIn = item.recordedIn
			recordedBy = item.recordedBy
			src = item.src

tag player

	prop sound
	prop currentWorkIndex = -1
	prop shuffledWorks = works
	prop howl
	prop work
	prop endOfGame = false

	def nextWork
		currentWorkIndex += 1
		if currentWorkIndex >= 6
			endOfGame = true
		else
			work = shuffledWorks[currentWorkIndex]
			console.log {work}
		
	def playSound
		if sound != null
			sound.stop()
			sound.unload()
			sound = null
		sound = new Howl({src: work.src});
		sound.play();

	def stop
		sound.stop()

	def setup
		nextWork()
	
	<self>
		if endOfGame
			<h1> "End of game"
		else
			<h1> "Title: {work.title}"
			<h2> "Composer: {work.composer}"
			<h3> "Period: {work.period}"
			<h4> "Composed in: {work.composedIn}"
			<button @click=nextWork> "Next"
			<button @click=playSound> "Play"
			<button @click=stop> "Stop"

imba.mount <player>
