require 'json'

class WordCloud
  def initialize(input, type)
    @input = JSON.parse(input)
    @output = ""
    @wordhash = Hash.new
    @tfarray = Array.new
    @idfarray = Array.new
    @type = type
    @tfidfhash = Hash.new
  end

  def parse
    # Check if it is a single doc
    if @type == "single"
      # Get tfidf info
      @tfarray.push(wordCount(@input))
      idfhash = Hash.new
      @tfarray[0].each do |t|
        idfhash[t[0]] = 1
      end
      @idfarray.push(idfhash)
      tfidf(@tfarray[0], @idfarray[0])

      # Format output
      @output = " "
      @input.each do |j|
        if (j[1] != nil) && (j[1].is_a? String)
          @output = @output + "<b>" + j[0] + ": " + "</b>" + formatField(j[1], @tfidfhash) + "<br />"
        else
          @output = @output + "<b>" + j[0].to_s + ": " + "</b>" + j[1].to_s + "<br />"
        end
      end
      @output = @output + "<br />"


    # Handle multiple docs
    elsif @type == "multiple"
      docnum = 0
      @input.each do |i|
        docnum += 1
        @tfarray.push(wordCount(i))
      end
      tfidf(@tfarray, idf(@tfarray, docnum))

      index = 0
      @input.each do |i|
        i.each do |j|
          if (j[1] != nil) && (j[1].is_a? String)
            @output = @output + "<b>" + j[0] + ": " + "</b>" + formatField(j[1], @tfidfhash) + "<br />"
          else
            @output = @output + "<b>" + j[0] + ": " + "</b>" + j[1].to_s + "<br />"
          end
        end
        index += 1
        @output = @output + "<br />"
      end
    end
    
    return @output
  end

  # Count the number of words in documents
  def wordCount(doc)
    @wordhash = Hash.new

    doc.each do |j|
      if (j[1] != nil) && (j[1].is_a? String)
        splitinput = j[1].split(" ")
        splitinput.each do |w|
          if w.include? "\\n"
            w.gsub!("\\n", "<br />")
          end
          
          # Add or increment
          if @wordhash[w]
            @wordhash[w] += 1
          else
            @wordhash[w] = 1
          end
        end
      end
    end

    # Get tf
    terms = @wordhash.length
    @tf = Hash.new
    @wordhash.each do |h|
      @tf[h[0]] = h[1].to_f/terms.to_f
    end
    
    return @tf
  end

  # Calculate tf-idf
  def tfidf(tf, idf)
    # Add support for one doc
    tf.each do |t|
      t.each do |r|
        if idf[r[0]]
          @tfidfhash[r[0]] = idf[r[0]]*r[1]
        end
      end
    end

    return @tfidfhash
  end

  # Calculate idf
  def idf(tfarray, docnum)
    idfhash = Hash.new
    
    tfarray.each do |h|
      h.each do |w|
        if idfhash[w[0]]
          idfhash[w[0]] += 1
        else
          idfhash[w[0]] = 1
        end
      end
    end

    # Calculate idf
    idfcalchash = Hash.new
    idfhash.each do |i|
      idfcalchash[i[0]] = Math.log(docnum.to_f/i[1].to_f)
    end

    return idfcalchash
  end

  def formatField(field, wordhash)
    splitinput = field.split(/ /)
    output = ""
    
    splitinput.each do |w|
      if w =~ /\n/
        w.gsub!(/\n/, "<br />")
      end

      if wordhash[w]
        # Set size
        size = 10.to_f + (wordhash[w]*2500.to_f)
        
        # Do formatting
        if size > 25
          size = 25
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
