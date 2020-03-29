## 1. Listening Device

Below we have a listening device. It lets us record something that is said and store it for later use. In general, this is how the device should be used:

Listen for something, and if anything is said, record it for later use. If nothing is said, then do not record anything.

``` ruby
class Device
  def initialize
    @recordings = []
  end

  def record(recording)
    @recordings << recording
  end
end
```

Anything that is said is retrieved by this listening device via a block. If nothing is said, then no block will be passed in. The listening device can also output the most recent recording using a `Device#play` method.

Sample Use:
``` ruby
listener = Device.new
listener.listen { "Hello World!" }
listener.listen
listener.play # Outputs "Hello World!"
```

ANSWER:
``` ruby
class Device
  def initialize
    @recordings = []
  end

  def record(recording)
    @recordings << recording
  end

  def listen
    recording = yield if block_given?
    record(recording) if recording
  end

  def play
    puts @recordings.last unless @recordings.empty?
  end
end
```


## 2. Text Analyzer - Sandwich Code

Fill out the rest of the Ruby code below so it prints output like that shown in "Sample Output." You should read the text from a simple text file that you provide. (We also supply some example text below, but try the program with your text as well.)

Read the text file in the #process method and pass the text to the block provided in each call. Everything you need to work on is either part of the #process method or part of the blocks. You need no other additions or changes.

The text you use does not have to produce the same numbers as the sample output but should have the indicated format.

LS ANSWER:
``` ruby
class TextAnalyzer
  def process
    file = File.open('sample_text.txt', 'r')
    yield(file.read)
    file.close
  end
end

analyzer = TextAnalyzer.new
analyzer.process { |text| puts "#{text.split("\n\n").count} paragraphs" }
analyzer.process { |text| puts "#{text.split("\n").count} lines" }
analyzer.process { |text| puts "#{text.split(' ').count} words" }
```


## 3. 