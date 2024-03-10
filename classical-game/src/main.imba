import {Howl} from 'howler'
import {works} from "./works.imba"

global css body c:warm2 bg:warm8 ff:Arial inset:0 d:vcc

tag player

	prop work
	prop sound
	prop howl
	prop endOfGame = false
	prop numberOfWorks = Object.keys(works).length;
	prop arrayOfNumbers = []
	prop shuffledArray = []
	prop currentWorkIndex = -1
	

	def nextWork
		currentWorkIndex += 1
		if currentWorkIndex >= numberOfWorks
			endOfGame = true
		else
			work = works[shuffledArray[currentWorkIndex]]
			console.log {work}

	def shuffleArray array
		for i in array
			let j = i + Math.floor(Math.random() * (array.length - i))
			let temp = array[j]
			array[j] = array[i]
			array[i] = temp
		array
		
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
		for i in [0...numberOfWorks]
			arrayOfNumbers.push(i)
		console.log(arrayOfNumbers)
		shuffledArray = shuffleArray(arrayOfNumbers)
		console.log(shuffledArray)
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
