class WordCloud
  def initialize(input)
    @input = input
    @output = ""
    @wordhash = Hash.new
  end

  # Splits corpus on words
  def parse
    splitinput = @input.split(" ")
    
    splitinput.each do |w|
      if w.include? "\\n"
        w.gsub!("\\n", "<br />")
      end
      wordCount(w)
    end

    genOutput
    return @output
  end

  # Counts number of times a word shows up
  def wordCount(word)
    commonwords = ["the", "and", "of", "a", "to", "is", "in", "its", "The", "on", "as", "for", "has", "will", "As", "or", "have", "while", "While", "that", "out", "such", "also", "by", "said", "with", "than", "only", "into", "an", "one", "other", "but", "for", "from", "<br />", "I", "more", "about", "About", "again", "Again", "against", "all", "are", "at", "be", "being", "been", "can", "could", "did", "do", "don't", "down", "up", "each", "few", "get", "got", "great", "had", "have", "has", "he", "her", "she", "he", "it", "we", "they", "if", "thus", "it's", "hers", "his", "how", "why", "when", "where", "just", "like", "you", "me", "my", "most", "more", "no", "not", "yes", "off", "once", "only", "our", "out", "over", "under", "own", "then", "some", "these", "there", "then", "this", "those", "too", "through", "between", "until", "very", "who", "with", "wouldn't", "would"]

    if (@wordhash[word]) && (!commonwords.include? word) 
      @wordhash[word] += 1
    else
      @wordhash[word] = 1
    end
  end

  # Generates HTML output based on word size
  def genOutput
    splitinput = @input.split(" ")
    
    splitinput.each do |w|
      if w.include? "\\n"
        w.gsub!("\\n", "<br />")
      end

      if @wordhash[w]
        size = 10 + @wordhash[w]
        if size > 18
          size = 18
          @output = @output + " <span style=\"font-size:" + size.to_s + "px\"><b>" + w + "</b></span>"
        else
          @output = @output + " <span style=\"font-size:" + size.to_s + "px\">" + w + "</span>"
        end
      end
    end
  end
end

