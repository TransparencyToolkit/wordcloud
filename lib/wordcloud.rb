require 'json'

class WordCloud
  def initialize(input)
    @input = JSON.parse(input)
    @output = ""
    @wordhash = Hash.new
  end

  # Splits corpus on words
  def parse   
    docnum = 0
    @input.each do |i|
      i.each do |j|
        if (j[1] != nil) && (j[1].is_a? String)
          splitinput = j[1].split(" ")
          splitinput.each do |w|
            if w.include? "\\n"
              w.gsub!("\\n", "<br />")
            end
            wordCount(w)
          end
        end
      end
      docnum += 1
    end

    @input.each do |i|
      i.each do |j|
        if (j[1] != nil) && (j[1].is_a? String)
          @output = @output + "<b>" + j[0] + ": " + "</b>" + genOutput(j[1], docnum) + "<br />"
        else
          @output = @output + "<b>" + j[0] + ": " + "</b>" + j[1].to_s + "<br />"
        end
      end
      @output = @output + "<br />"
    end
    return @output
  end

  # Counts number of times a word shows up
  def wordCount(word)
    commonwords = ["the", "and", "of", "a", "to", "is", "in", "its", "The", "on", "as", "for", "has", "will", "As", "or", "have", "while", "While", "that", "out", "such", "also", "by", "said", "with", "than", "only", "into", "an", "one", "other", "but", "for", "from", "<br />", "I", "more", "about", "About", "again", "Again", "against", "all", "are", "at", "be", "being", "been", "can", "could", "did", "do", "don't", "down", "up", "each", "few", "get", "got", "great", "had", "have", "has", "he", "her", "she", "he", "it", "we", "they", "if", "thus", "it's", "hers", "his", "how", "why", "when", "where", "just", "like", "you", "me", "my", "most", "more", "no", "not", "yes", "off", "once", "only", "our", "out", "over", "under", "own", "then", "some", "these", "there", "then", "this", "those", "too", "through", "between", "until", "very", "who", "with", "wouldn't", "would", "was", "were", "itself", "himself", "herself", "which", "make", "during", "before", "after", "if", "any", "become", "around", "several", "them", "their", "however"]

    # Make capitalized array of common words
    commoncaps = Array.new
    commonwords.each do |c|
      commoncaps.push(c.capitalize)
    end

    if (@wordhash[word]) && (!commonwords.include? word) && (!commoncaps.include? word) 
      @wordhash[word] += 1
    else
      @wordhash[word] = 1
    end
  end

  # Generates HTML output based on word size
  def genOutput(input, docnum)
    splitinput = input.split(/ /)
    output = ""
    
    splitinput.each do |w|
      if w =~ /\n/
        w.gsub!(/\n/, "<br />")
      end

      if @wordhash[w]
        size = 10 + @wordhash[w] 
        if @wordhash[w] > 2
         size = size - (docnum*0.1)
        end

        if size > 18
          size = 18
          output = output + " <span style=\"font-size:" + size.to_s + "px\"><b>" + w + "</b></span>"
        else
          output = output + " <span style=\"font-size:" + size.to_s + "px\">" + w + "</span>"
        end
      else
        output = output + " " + w
      end
    end

    return output
  end
end

