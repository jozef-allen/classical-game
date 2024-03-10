import {Howl} from 'howler'
import {works} from "./works.imba"
import {composers} from "./composers.imba"

global css body c:warm2 bg:warm8 ff:Arial inset:0 d:vcc

tag choices

	prop choiceOne
	prop choiceTwo
	prop choiceThree
	prop choiceFour

	<self>
		<button @click=emit("validateAnswer", choiceOne)> choiceOne
		<button @click=emit("validateAnswer", choiceTwo)> choiceTwo
		<button @click=emit("validateAnswer", choiceThree)> choiceThree
		<button @click=emit("validateAnswer", choiceFour)> choiceFour
		# <img.portrait src=composers["Johann Strauss II"].image>

tag app

	css .portrait height:200px

	prop work
	prop sound
	prop howl
	prop startOfGame = yes
	prop endOfGame = no
	prop response = null

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

	def stopSound
		if sound != null
			sound.stop()

	def validateAnswer answer
		if answer.detail === work.composer
			response = "Correct!"
		else
			response = "Incorrect!"

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

	def nextWork
		stopSound()
		currentWorkIndex += 1
		if currentWorkIndex >= numberOfWorks
			endOfGame = yes
		else
			arrayOfComposers = []
			response = null
			work = works[shuffledArrayOfNumbers[currentWorkIndex]]
			stageAndShuffleComposers()
			populateChoices()
			playSound()
	
	def shuffleArray array
		for i in [array.length - 1...0] by -1
			let j = Math.floor(Math.random() * (i + 1))
			let temp = array[i]
			array[i] = array[j]
			array[j] = temp
		array

	def populateChoices
		choiceOne = arrayOfComposers[0]
		choiceTwo = arrayOfComposers[1]
		choiceThree = arrayOfComposers[2]
		choiceFour = arrayOfComposers[3]

	def setup
		for i in [0...numberOfWorks]
			arrayOfNumbers.push(i)
		shuffledArrayOfNumbers = shuffleArray(arrayOfNumbers)
		nextWork()

	def startGame
		startOfGame = no

	
	<self>
		if endOfGame
			<h1> "End of game"
		else if startOfGame
			<button @click=startGame> "Start"
		else	
			<h1> "Title: {work.title}"
			# <h2> "Composer: {work.composer}"
			<h3> "Period: {work.period}"
			<h4> "Composed in: {work.composedIn}"
			<button @click=nextWork> "Next"
			# <button @click=playSound> "Play"
			<button @click=stopSound> "Stop"
			<br>
			<choices 
				choiceOne=choiceOne 
				choiceTwo=choiceTwo
				choiceThree=choiceThree
				choiceFour=choiceFour
				@validateAnswer=validateAnswer(e)>
			<div> response

imba.mount <app>
