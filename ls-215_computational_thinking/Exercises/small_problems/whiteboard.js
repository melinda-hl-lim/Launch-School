function searchWord(word, text) {
  const regex = new RegExp(`\\b${word}\\b`, 'gi');
  return text.replace(regex, `**${word.toUpperCase()}**`);
}
