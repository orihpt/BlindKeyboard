# Blind Keyboard
This is an open-source project that demonstrates how a keyboard for blind people can be made in Flutter.
The simple idea is that the system remembers the coordinates of where on the keyboard the user has pressed and then uses that to predict what the user is typing.

## Demo
As you can see, the keyboard can't always guess the word I mean to type. When it gets the word wrong, I just swipe down for the next word suggestion.

[Hebrew Keyboard Demo](https://github.com/orihpt/BlindKeyboard/assets/52978143/ca90be87-7d48-43b2-aeb6-715273b635b8)
<video src="https://github.com/orihpt/BlindKeyboard/assets/52978143/ca90be87-7d48-43b2-aeb6-715273b635b8" height="100">
  
[English Keyboard Demo](https://github.com/orihpt/BlindKeyboard/assets/52978143/4904ecfe-866c-4bef-8f82-a0aafe1862f3)
<video src="https://github.com/orihpt/BlindKeyboard/assets/52978143/4904ecfe-866c-4bef-8f82-a0aafe1862f3" height="100">

## How It Works
When you type a word, the system remembers the x and y coordinates of where you pressed on the keyboard. It then uses this data to predict what you are typing. The system uses a simple algorithm to predict the word you are typing. The algorithm is as follows:

1. The system knows the length of the word you are typing - this is the number of times you pressed on the keyboard.
2. From the dictionary, the system loads all the words that have the same length as the word you are typing.
3. The system searches for the 7 words that have the shortest distance from the coordinates you pressed to the coordinates of the word in the dictionary.
4. The user can hear the most likely word that the system found, and if it's not correct, they can swipe for the next word suggestion.

To speed up the search, I pre-made KD-trees for each word length using Matlab. This way, the system can quickly find the 7 words that have the shortest distance from the coordinates you pressed to the coordinates of the word in the dictionary.

For more information about KD-trees, see [Wikipedia](https://en.wikipedia.org/wiki/K-d_tree).

The KD-trees are stored in assets/Lang/[he for Hebrew, en for English]/words/tree_[Word Length].json.

### Hebrew Keyboard Challenges
Implementing the Hebrew keyboard took more effort than the English keyboard.

That is because words in Hebrew contains prefixes.
For example, "The House" in Hebrew is "הבית":
- "ה" means "The"
- "בית" means "House"

This gets even more complicated when you use many prefixes in one word.
For example, "And when the house" in Hebrew is "וכשהבית":
- "ו" means "And"
- "כש" means "When"
- "ה" means "The"
- "בית" means "House"

My first idea to solve the problem was to add all of the prefixes for each word in the dictionary. However, this was not practical because the number of prefixes in the dictionary is very large, and the number of words is even larger.

In the end, I decided to make special KD-trees for the prefixes. This is how it works:
1. When a word is typed, the system searches for the word in the dictionary.
2. The system also takes in mind if the word can contain any prefixes (from its length).
3. The system searches for the 7 words that have the shortest distance from the coordinates you pressed to the coordinates of the word in the dictionary.

For example, if you type "הבית" (The House), the system will search for the word "הבית" in the dictionary and also for the prefix "ה" in the dictionary. The system will then search for the 7 words that have the shortest distance from the coordinates you pressed to the coordinates of the word in the dictionary.

## How to Run
1. Clone the repository
2. Install the Flutter SDK
3. Run the command `flutter run` in the root directory of the project

For more help on how to run the project, see the [Flutter documentation](https://flutter.dev/docs/get-started/install).
Please note that you might need a phone emulator to run the app. You can also use a physical phone:
- On Windows, you can use an Android phone.
- On macOS, you can use both Android and iOS phones (iPhones).

## About the Development
This was actually my first app in Flutter :) I made it before a job interview to show that I could learn Flutter quickly. I had never used Flutter before, but I had some experience with iOS and Android application development. I made the app in less than two weeks, and I was very happy with the result. I got the job, and I have been working with Flutter ever since.
