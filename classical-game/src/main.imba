import {Howl} from 'howler'
import {works} from "./works.imba"
import {composers} from "./composers.imba"
import {periods} from "./periods.imba"
import {forms} from "./forms.imba"
import {instrumentations} from "./instrumentations.imba"

global css body height:100% bgc:orange1 font-family:'Hedvig Letters Serif', serif font-size:1rem @768:1.5rem @1024:1.75rem
	button font-family:'Hedvig Letters Serif' box-shadow: 2px 2px 3px gray9 font-size:1rem @768:1.5rem @1024:1.75rem bgc:yellow3 bgc@hover@1024:yellow4 color:gray9 font-weight:bold p:.5rem border:1px border-radius:5px transition: background-color 0.3s ease
	.container width:90% display:block margin-left:auto margin-right:auto
	.intro-h1 font-size:1.5rem @768:2rem @1024:2.5rem text-align:center
	.start-image width:80% @1024:50% @1500:800px rd:10px box-shadow: 2px 2px 3px gray9 display:block margin-left:auto margin-right:auto margin-top:0.5rem @768:0.75rem @1024:1rem margin-bottom:2rem @768:2rem @1024:3rem
	.intro-text text-align:center width:60% margin-left:auto margin-right:auto
	.intro-button-div display:flex justify-content:center p:1rem
	.header display:flex justify-content:space-between bgc:yellow3 pl:1rem @1024:2rem pr:1rem @1024:2rem font-size:.75rem @768:1rem @1024:1.25rem font-weight:bold rd:10px
	.work-title font-size:1rem @768:1.5rem @1024:1.75rem text-align:center pt:.5rem
	# .period font-size:.75rem @768:1rem @1024:1.25rem text-align:center
	# .composed-in font-size:.75rem @768:1rem @1024:1.25rem text-align:center
	.two-buttons display:flex justify-content:center align-items:center pt:.5rem
	.bold-text font-weight:bold
	.response font-size:1.5rem @768:2rem @1024:2.5rem text-align:center pt:.5rem @1024:0 margin-top:30px margin-bottom:30px
	.end-message font-size:1.5rem @768:2rem @1024:2.5rem text-align:center pt:.5rem
	.reset-button display:block margin:auto

tag question

	prop stage

	css p font-size:1.5rem @768:2rem @1024:2.5rem text-align:center pt:.5rem @1024:0 margin-top:30px margin-bottom:30px @1024:50px

	<self>
		if stage === "composers" 
			<p> "🎼 Who is the composer of this piece?"
		else if stage === "periods"
			<p> "🎼 During which period was this piece written?"
		else if stage === "forms"
			<p> "🎼 What form is this piece?"
		else if stage === "instrumentations"
			<p> "🎼 What instrumentation is this piece for?"

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
	prop choiceOneImage
	prop choiceTwoImage
	prop choiceThreeImage
	prop choiceFourImage
	prop answerSheet

	css .choice-container display:grid width:100% grid-template-columns:50% 50% @1024:25% 25% 25% 25% grid-template-rows:50% 50% @1024:100%
		.choice display:flex flex-direction:column justify-content:flex-start align-items:center
		.choice2 display:flex flex-direction:column justify-content:flex-start align-items:center pt:20px @1024:0px
		.portrait width:100px @768:190px rd:10px box-shadow: 2px 2px 3px gray9
		.choice-button font-size:.65rem @768:.95rem @1024:1.2rem display:block margin:auto mt:15px mb:10px


	<self>
		<div .choice-container>
			<div .choice>
				<img .portrait @click=emit("validateAnswer", choiceOne) src=choiceOneImage>
				<button .choice-button @click=emit("validateAnswer", choiceOne)> choiceOne
			<div .choice>
				<img .portrait @click=emit("validateAnswer", choiceTwo) src=choiceTwoImage>
				<button .choice-button @click=emit("validateAnswer", choiceTwo)> choiceTwo
			<div .choice2>
				<img .portrait @click=emit("validateAnswer", choiceThree) src=choiceThreeImage>
				<button .choice-button @click=emit("validateAnswer", choiceThree)> choiceThree
			<div .choice2>
				<img .portrait @click=emit("validateAnswer", choiceFour) src=choiceFourImage>
				<button .choice-button @click=emit("validateAnswer", choiceFour)> choiceFour
tag response

	prop response
	prop responseImage

	css .response-portrait width:200px @768:250px @1024:300px rd:10px box-shadow: 2px 2px 3px gray9 display:block margin-left:auto margin-right:auto
		
	<self>
		<p .response> response
		<img .response-portrait src=responseImage>

tag app

	prop work
	prop sound
	prop howl
	prop startOfGame = yes
	prop endOfGame = no
	prop stage
	prop response = null
	prop responseImage = null
	prop points = 0

	# handling works
	prop numberOfWorks = Object.keys(works).length
	prop arrayOfNumbers = []
	prop shuffledArrayOfNumbers = []
	prop currentWorkIndex = -1

	# handling composers
	prop numberOfComposers = Object.keys(composers).length
	prop arrayOfX
	prop arrayOfComposers
	prop arrayOfPeriods
	prop arrayOfForms
	prop arrayOfInstrumentations
	
	# handling choices
	prop choiceOne
	prop choiceTwo
	prop choiceThree
	prop choiceFour
	prop choiceOneImage
	prop choiceTwoImage
	prop choiceThreeImage
	prop choiceFourImage
	prop answerSheet
	prop answered?
	prop stopped?
	
	# called by functions
	def playSound
		if sound != null
			sound.stop()
			sound.unload()
			sound = null
		sound = new Howl({src: work.src})
		stopped? = no
		sound.play();

	# called by functions
	def stopSound
		if sound != null
			stopped? = yes
			sound.stop()

	# called by button click
	def stopOrPlay
		if stopped? === no
			stopped? = yes
			sound.stop()
		else 
			stopped? = no
			sound = new Howl({src: work.src})
			sound.play()

	def playFromBeginning
		playSound()

	def validateAnswer answer
		console.log answerSheet
		if answer.detail === answerSheet
			response = "🎼 Correct! The answer is {answerSheet}."
			if stage === "composers"
				responseImage = composers[answerSheet].image
			else if stage === "periods"
				responseImage = periods[answerSheet].image
			else if stage === "forms"
				responseImage = forms[answerSheet].image
			else if stage === "instrumentations"
				responseImage = instrumentations[answerSheet].image
			answered? = yes
			points += 1
		else
			response = "🎼 Incorrect! The answer is {answerSheet}."
			if stage === "composers"
				responseImage = composers[answerSheet].image
			else if stage === "periods"
				responseImage = periods[answerSheet].image
			else if stage === "forms"
				responseImage = forms[answerSheet].image
			else if stage === "instrumentations"
				responseImage = instrumentations[answerSheet].image
			answered? = yes	

	def stageAndShuffle input, value
		const auxiliaryArray = []
		for object in Object.keys(input)
			auxiliaryArray.push(object)
		let indexOfCurrentX = auxiliaryArray.indexOf(value)
		if indexOfCurrentX != -1
			auxiliaryArray.splice(indexOfCurrentX, 1)
		shuffleArray(auxiliaryArray)
		arrayOfX = auxiliaryArray.slice(0, 3)
		arrayOfX.push(value)
		shuffleArray(arrayOfX)

	def nextQuestion
		response = null
		responseImage = null

	def nextComposer
		stopSound()
		currentWorkIndex += 1
		stage = "composers"
		if currentWorkIndex >= numberOfWorks
			endOfGame = yes
		else
			work = works[shuffledArrayOfNumbers[currentWorkIndex]]
			arrayOfComposers = []
			answered? = no			
			stageAndShuffle(composers, work.composer)
			populateComposers()
			playSound()

	def nextPeriod
		stage = "periods"
		arrayOfPeriods = []
		answered? = no			
		stageAndShuffle(periods, work.period)
		populatePeriods()

	def nextForm
		stage = "forms"
		arrayOfForms = []
		answered? = no			
		stageAndShuffle(forms, work.form)
		populateForms()

	def nextInstrumentation
		stage = "instrumentations"
		arrayOfInstrumentations = []
		answered? = no			
		stageAndShuffle(instrumentations, work.instrumentation)
		populateInstrumentations()
	
	def shuffleArray array
		for i in [array.length - 1...0] by -1
			let j = Math.floor(Math.random() * (i + 1))
			let temp = array[i]
			array[i] = array[j]
			array[j] = temp
		array

	def populateComposers
		choiceOne = arrayOfX[0]
		choiceTwo = arrayOfX[1]
		choiceThree = arrayOfX[2]
		choiceFour = arrayOfX[3]
		choiceOneImage = composers[choiceOne].image
		choiceTwoImage = composers[choiceTwo].image
		choiceThreeImage = composers[choiceThree].image
		choiceFourImage = composers[choiceFour].image
		answerSheet = work.composer

	def populatePeriods
		choiceOne = arrayOfX[0]
		choiceTwo = arrayOfX[1]
		choiceThree = arrayOfX[2]
		choiceFour = arrayOfX[3]
		choiceOneImage = periods[choiceOne].image
		choiceTwoImage = periods[choiceTwo].image
		choiceThreeImage = periods[choiceThree].image
		choiceFourImage = periods[choiceFour].image
		answerSheet = work.period

	def populateForms
		choiceOne = arrayOfX[0]
		choiceTwo = arrayOfX[1]
		choiceThree = arrayOfX[2]
		choiceFour = arrayOfX[3]
		choiceOneImage = forms[choiceOne].image
		choiceTwoImage = forms[choiceTwo].image
		choiceThreeImage = forms[choiceThree].image
		choiceFourImage = forms[choiceFour].image
		answerSheet = work.form

	def populateInstrumentations
		choiceOne = arrayOfX[0]
		choiceTwo = arrayOfX[1]
		choiceThree = arrayOfX[2]
		choiceFour = arrayOfX[3]
		choiceOneImage = instrumentations[choiceOne].image
		choiceTwoImage = instrumentations[choiceTwo].image
		choiceThreeImage = instrumentations[choiceThree].image
		choiceFourImage = instrumentations[choiceFour].image
		answerSheet = work.instrumentation

	def setup
		for i in [0...numberOfWorks]
			arrayOfNumbers.push(i)
		shuffledArrayOfNumbers = shuffleArray(arrayOfNumbers)

	def startGame
		startOfGame = no
		nextComposer()

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
			<div .header>
				<p> "End of game"
				<p> "Points: {points}"
			<p .end-message> if points === 1 then "You scored {points} point out of {numberOfWorks*4}!" else "You scored {points} points out of {numberOfWorks*4}!"
			<button .reset-button @click=reset> "Play again"
		else if startOfGame
			<div .container>
				<h1 .intro-h1> "Classical Music Guessing Game"
				<img .start-image src="https://joseph.ptesquad.com/game/images/orchestra.png">
				<p .intro-text> "🎼 Let's test your knowledge of classical music."
				<p .intro-text> "🎼 Once you click 'Start', you'll be played various pieces in turn and asked questions about each one."
				<p .intro-text> "🎼 You'll only get one try at each answer. You can skip if you don't know (though you might as well guess). Best of luck."
				<div .intro-button-div>
					<button @click=startGame> "Start"
		else
			<div .header>	
				<p> "#{currentWorkIndex + 1}"
				<p> "Points: {points}"
			<div .container>	
				<p .work-title> 
					<span .bold-text> "Title: " 
					"{work.title}"
				<div .two-buttons>
					if stage === "instrumentations"
						<button @click=nextComposer> "Progress"
					else if stage === "composers"
						<button @click=nextPeriod> "Next question"
					else if stage === "periods"
						<button @click=nextForm> "Next question"
					else if stage === "forms"
						<button @click=nextInstrumentation> "Next question"
					# <button @click=stopOrPlay> if stopped? === yes then "Play music" else "Stop music"
					<button @click=playFromBeginning [ml:10px]> "Play piece from start again"
				<question [display:none]=answered?
					stage=stage>
				<choices [display:none]=answered?
					choiceOne=choiceOne 
					choiceTwo=choiceTwo
					choiceThree=choiceThree
					choiceFour=choiceFour
					choiceOneImage=choiceOneImage
					choiceTwoImage=choiceTwoImage
					choiceThreeImage=choiceThreeImage
					choiceFourImage=choiceFourImage
					answerSheet=answerSheet
					@validateAnswer=validateAnswer(e)>
				if answered?===yes
					<response response=response responseImage=responseImage>			
		<game-footer>

imba.mount <app>
