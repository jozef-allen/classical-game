import {Howl} from 'howler'
import {works} from "./works.imba"
import {composers} from "./composers.imba"

global css body height:100% bgc:orange1 font-family:'Hedvig Letters Serif', serif font-size:1rem @768:1.5rem @1024:1.8rem
	h1 font-size:1.5rem @768:2.5rem @1024:3rem text-align:center
	button font-family:'Hedvig Letters Serif' box-shadow: 1px 1px 1px font-size:1.25rem @768:1.75rem @1024:2rem bgc:yellow3 bg@hover:yellow4 color:gray9 font-weight: bold p:1rem border:1px border-radius:5px transition: background-color 0.3s ease
	.startImage width:80% @1024:50% @1500:800px rd:10px box-shadow: 5px 5px 10px gray9 display:block margin-left:auto margin-right:auto margin-top:0.5rem @768:0.75rem @1024:1rem margin-bottom:2rem @768:4rem @1024:5rem
	.portrait height:200px
	.container width:90% display:block margin-left:auto margin-right:auto
	.introText text-align:center
	.introButtonDiv display:flex justify-content:center p:1rem

tag question

	<self>
		<p> "Who is the composer of this piece?"

tag game-footer

	prop currentYear = new Date().getFullYear()

	css p text-align:center font-size:.75rem @768:1rem @1024:1.25rem pt:3rem

	<self>
		<p> "By "
			<a href="https://joseph.ptesquad.com/"> "Joe Allen" 
			" © {currentYear}"

tag choices

	prop choiceOne
	prop choiceTwo
	prop choiceThree
	prop choiceFour

	<self>
		<img.portrait src=composers[choiceOne].image>
		<button @click=emit("validateAnswer", choiceOne)> choiceOne
		<br>
		<img.portrait src=composers[choiceTwo].image>
		<button @click=emit("validateAnswer", choiceTwo)> choiceTwo
		<br>
		<img.portrait src=composers[choiceThree].image>
		<button @click=emit("validateAnswer", choiceThree)> choiceThree
		<br>
		<img.portrait src=composers[choiceFour].image>
		<button @click=emit("validateAnswer", choiceFour)> choiceFour

tag app

	prop work
	prop sound
	prop howl
	prop startOfGame = yes
	prop endOfGame = no
	prop response = null
	prop responseImage = null
	prop points = 0

	# handling works
	prop numberOfWorks = Object.keys(works).length;
	prop arrayOfNumbers = []
	prop shuffledArrayOfNumbers = []
	prop currentWorkIndex = -1

	# handling composers
	prop numberOfComposers = Object.keys(composers).length;
	prop arrayOfComposers = []
	
	# handling choices
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
			responseImage = <img .portrait src=composers[work.composer].image>
			answered? = yes
			points += 1
		else
			response = "Incorrect! The answer was {work.composer}."
			responseImage = <img .portrait src=composers[work.composer].image>
			answered? = yes	

	def stageAndShuffleComposers
		const auxiliaryArray = []
		for composer in Object.keys(composers)
			auxiliaryArray.push(composer)
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
			responseImage = null
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
		<div.container>

				<h1> "Classical Music Guessing Game"
				if endOfGame
					<h1> if points === 1 then "You scored {points} point!" else "You scored {points} points!"
					<button @click=reset> "Play again"
				else if startOfGame
					<img .startImage src="https://joseph.ptesquad.com/game/images/orchestra.png">
					<p .introText> "🎼 Welcome to this classical music guessing game."
					<p .introText> "🎼 Once you click 'Start', you'll be played various pieces of music and it's your job to answer questions about it."
					<p .introText> "🎼 You only get one try at each answer. Best of luck."
					<div .introButtonDiv>
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
					<div> responseImage
					<div> "Points: {points}"
				<game-footer>

imba.mount <app>
