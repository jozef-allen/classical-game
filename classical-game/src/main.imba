import {Howl} from 'howler'
import {works} from "./works.imba"
import {composers} from "./composers.imba"

global css body c:warm2 bg:warm8 ff:Arial inset:0 d:vcc

tag question

	<self>
		<p> "Who is the composer of this piece?"


tag choices

	prop choiceOne
	prop choiceTwo
	prop choiceThree
	prop choiceFour
	prop hideChoices

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
	prop points = 0

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
	prop answered? = no
	
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
			response = "Correct! The answer was {work.composer}."
			answered? = yes
			points += 1
		else
			response = "Incorrect! The answer was {work.composer}."
			answered? = yes
		

	def stageAndShuffleComposers
		const auxiliaryArray = []
		for composer in Object.values(composers)
			auxiliaryArray.push(composer.name)
		let indexOfCurrentComposer = auxiliaryArray.indexOf(work.composer)
		if indexOfCurrentComposer != -1
			auxiliaryArray.splice(indexOfCurrentComposer, 1)
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
			answered? = no
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

	def startGame
		startOfGame = no
		nextWork()

	def reset
		arrayOfNumbers = []
		for i in [0...numberOfWorks]
			arrayOfNumbers.push(i)
		shuffledArrayOfNumbers = shuffleArray(arrayOfNumbers)
		currentWorkIndex = -1
		response = null
		points = 0
		endOfGame = no
		startOfGame = yes

	
	<self>
		if endOfGame
			<h1> if points === 1 then "You scored {points} point!" else "You scored {points} points!"
			<button @click=reset> "Go again"
		else if startOfGame

			<p> "Welcome to this classical music guessing game."
			<p> "Once you click 'Start', you'll be played various pieces of music and it's your job to answer questions about each."
			<p> "You only get one try at each answer."
			<p> "Good luck."

			<button @click=startGame> "Start"
		else	
			<h1> "Title: {work.title}"
			# <h2> "Composer: {work.composer}"
			<h3> "Period: {work.period}"
			<h4> "Composed in: {work.composedIn}"
			<button @click=nextWork> if answered? === yes then "Next" else "Skip"
			# <button @click=playSound> "Play"
			<button @click=stopSound> "Stop music"
			<br>
			<question>
			<choices [display:none]=answered?
				choiceOne=choiceOne 
				choiceTwo=choiceTwo
				choiceThree=choiceThree
				choiceFour=choiceFour
				@validateAnswer=validateAnswer(e)>
			<div> response
			<div> "Points: {points}"

imba.mount <app>
