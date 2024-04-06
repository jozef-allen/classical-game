# Classical Music Quiz

## Goal

To create an educational game and teach myself Imba along the way.

## Live version

[Classical Music Quiz](https://classical-music-quiz.com/) 

## Technologies used

- Imba 
- JavaScript
- JSON
- Node.js
- Howler.js
- Netlify
- Render
- Audacity

## Planning

### Concept

I've been getting into classical music of late so thought this would be a great topic for a multiple choice guessing game: you could listen to a piece of music and answer some questions about it. You'd get points for each correct answer, and I planned to implement a high score table at the end so you could register your name if you scored enough points. I also wanted two levels of difficulty - one for beginners and one to test experts.

### Gathering the assets

Using mainly https://musopen.org/, I sourced 20 recordings from the public domain. For the 'easy' level I gathered some of the most famous pieces I could think of across a variety of periods and instrumentations. For the 'less easy' level I went for more obscure pieces from famous composers. In Audacity I edited each piece down to 60 seconds that would play during the game, and normalised all pieces to be the same volume. I also found images to represent each answer choice and optimised those without losing quality.

## Code process

### Setting up

I first wanted to get the music playing in rounds/set up a system where you could move through each round. I initially started using Howler.js (JavaScript audio library) to handle the playback as I'd seen it in Scrimba's Imba tutorial. 

I knew the various categories of possible answers would need to sit in objects. Here I would associate each answer with an image. The keys of those objects would be compared to values in ```works.imba```, another big object which holds all the info associated with each piece of music.

I created the ```choices``` and ```response``` tags to make use of Imba's component-based way of working, and these housed the functionality for the possibles choices to each question, and the subsequent screen which tells you whether you were right or wrong. I used multiple flags to switch between 'screens'. Of course, I made use of Imba's intuitive syntax for passing properties between tags.

### Styling

I wanted to try using Imba's built in named colours to help create a nice colour palette, and I settled on an orange look. I made a lot of use of border radius too to keep everything looking pleasant and rounded. Fairly early on I made the whole layout fully responsive, then was able to concentrate on adding to the logic.

### Making progress

I was so impressed with how intuitive Imba is at letting you create the building blocks that make up your app. There were a few challenges along the way though, especially because the Imba documentation isn't fully fleshed out yet. The language is obviously based on JavaScript, but there are a few things that you need to know Imba's particular syntax for. This leads me into some of the challenges I faced on this project:

For the timer that ticks down during each round I wanted to use ```setInterval``` to call a method every 1000 milliseconds. Just calling this as below didn't seem to work. 
```
timer = setInterval decrementTimer, 1000
```
Running ```decrementTimer``` through ```setInterval``` seemed to change the prop I was relying on into an ```undefined``` value. I could find some similar queries on Stack Overflow but nothing specific to Imba, so I asked if anyone on the [Imba Discord](https://discord.com/invite/mkcbkRw) knew a solution and within a couple of hours I got back some help which led me to use the below, and then my timer was working.
```
timer = setInterval decrementTimer.bind(self), 1000
```
I'm now binding the ```self``` (which refers to the current component instance) to the ```decrementTimer``` function. This ensures that when ```decrementTimer``` is called as a callback for ```setInterval```, it retains access to the component's properties and methods through ```self```.

Another challenge was with Howler.js - on implementing my 'pause music' feature, I found I couldn't get it to cache the audio files and start and stop the music without redownloading the MP3 each time. This would not be ideal, so in the end I tried the vanilla JavaScript ```audio``` capabilities, which worked as I wanted, and I found the audio loaded faster this way anyway - double win.

### Building the API

As my quiz was really coming together, I knew I wanted functionality where, if players' scores were high enough, they could add them to a high score board. To do this I wrote a simple Node.js API that would run on Render. It stores the top 10 player names and their scores, and it can receive two types of requests - GET and POST. It also limits the JSON array to only holding 10 players/scores. The app decides whether a score is high enough to register and then makes the request, and then the leaderboard updates in front of the user. I thought this might offer more playback potential as you challenge other users.

### Asking for help testing

When the game was in a decent place, I posted it on the [Classical Music Subreddit](https://www.reddit.com/r/classicalmusic/) for some feedback. In terms of functionality and UX, people seemed to get along with the game fine. The main feedback was that one of my types of questions (on 'form') didn't make a lot of sense - it's hard to categorise pieces into just one answer in terms of form. I'd felt this while making it, and so for now decided to remove that type of question, but do plan to put it back in once I've figured out how the answers should work.

As I say, there weren't really any issues with the functionality, so I'm happy for the quiz to be up now with ten rounds in both levels of difficulty. I used Netlify to deploy it with a custom domain.

## Wins

- I've made simple games before but I feel this is my most fleshed-out and best looking one. I feel it's pretty fun, especially if you're into the subject matter.
- I've learnt a lot about the practicalities of working with Imba, and I wouldn't want to go back to vanilla JavaScript now. I hope the documentation can continue to improve as the language grows, but it's for sure an improvement on so many niggly areas of JS.
- It's good to know I can use Imba for frontend, and also link it up with APIs/servers. Again, there wasn't a great deal of documentation for the API interactions online, but now I have a good working reference for myself in this project when it comes to API calls.
- I was proud to come up with all the logic for this on my own. I'm really happy with the way the app pulls from the objects, then creates a randomised number array to cycle through the music tracks. I refactored my methods down so they could be reused over and over with as little code as possible.

## Future improvements?

As I say, I'd like to figure out exactly how I can put the questions on forms back in eventually - it purely depends on my knowledge of music, not coding! And now the game and its systems are all in place, I can simply keep adding works from new composers, and maybe create new 'levels'.
