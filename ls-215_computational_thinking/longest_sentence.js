/* eslint-disable no-console */
function longestSentence(text) {
  const longest = {
    wordCount: 0,
    sentence: '',
  };

  const splitSentences = () => text.match(/\w[^.?!]*?[.!?]/g);

  const displaySentenceStats = () => {
    console.log(longest.sentence);
    console.log('');
    console.log(`The longest sentence has ${longest.wordCount} words.`);
  };

  const sentences = splitSentences();

  for (let index = 0; index < sentences.length; index += 1) {
    const currentSentence = sentences[index];
    const words = currentSentence.split(' ');

    if (words.length > longest.wordCount) {
      longest.wordCount = words.length;
      longest.sentence = currentSentence;
    }
  }

  displaySentenceStats();
}
