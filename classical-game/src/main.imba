import {Howl} from 'howler'
import {works} from "./works.imba"
import {composers} from "./composers.imba"

global css body c:warm2 bg:warm8 ff:Arial inset:0 d:vcc

tag app

	css .portrait height:200px

	prop work
	prop sound
	prop howl
	prop endOfGame = false

	# handling works
	prop numberOfWorks = Object.keys(works).length;
	prop arrayOfNumbers = []
	prop shuffledArrayOfNumbers = []
	prop currentWorkIndex = -1

	# handling composers
	prop numberOfComposers = Object.keys(composers).length;
	prop arrayOfComposers = []
	
	prop choiceOne
	prop choiceTwo
	prop choiceThree
	prop choiceFour
	
	def playSound
		if sound != null
			sound.stop()
			sound.unload()
			sound = null
		sound = new Howl({src: work.src});
		sound.play();

	def stop
		sound.stop()

	def stageAndShuffleComposers
		const auxiliaryArray = []
		for composer in Object.values(composers)
			auxiliaryArray.push(composer.name)
		let index = auxiliaryArray.indexOf(work.composer)
		if index != -1
			auxiliaryArray.splice(index, 1)
		shuffleArray(auxiliaryArray)
		arrayOfComposers = auxiliaryArray.slice(0, 3)
		arrayOfComposers.push(work.composer)
		shuffleArray(arrayOfComposers)
		console.log(arrayOfComposers)

	def populateChoices
		choiceOne = arrayOfComposers[0]
		choiceTwo = arrayOfComposers[1]
		choiceThree = arrayOfComposers[2]
		choiceFour = arrayOfComposers[3]

	def nextWork
		currentWorkIndex += 1
		if currentWorkIndex >= numberOfWorks
			endOfGame = true
		else
			arrayOfComposers = []
			work = works[shuffledArrayOfNumbers[currentWorkIndex]]
			console.log {work}
			stageAndShuffleComposers()
			populateChoices()
	
	def shuffleArray array
		for i in [array.length - 1...0] by -1
			let j = Math.floor(Math.random() * (i + 1))
			let temp = array[i]
			array[i] = array[j]
			array[j] = temp
		array

	def setup
		for i in [0...numberOfWorks]
			arrayOfNumbers.push(i)
		shuffledArrayOfNumbers = shuffleArray(arrayOfNumbers)
		console.log(shuffledArrayOfNumbers)
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
			<br>
			<button @click=console.log(e)> choiceOne
			<button @click=console.log(e)> choiceTwo
			<button @click=console.log(e)> choiceThree
			<button @click=console.log(e)> choiceFour
			# <img.portrait src=composers["Johann Strauss II"].image>

imba.mount <app>
