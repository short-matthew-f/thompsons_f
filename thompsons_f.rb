class Letter
  
  def initialize(letter_string)
    if letter_string.nil?
      nil
    else
      if letter_string[0] == '-'
        @sign = '-'
        @generator = letter_string[1]
        temp_array = letter_string.split('_')
        @index = temp_array[1].to_i
      else 
        @sign = ''
        @generator = letter_string[0]
        temp_array = letter_string.split('_')
        @index = temp_array[1].to_i      
      end
    end
  end
  
  def to_s
    "#@sign#@generator\_#@index"
  end

  def increment!
    @index += 1
    self
  end
  
  def decrement!
    @index -= 1
    self
  end
  
  def ==(letter)
    unless letter.nil?
      if self.index==letter.index and self.generator==letter.generator and self.sign==letter.sign
        return true
      else
        return false
      end
    end
    return self.nil?
  end
  
  def invert
    Letter.new(self.to_s).invert!
  end
  
  def invert!
    if @sign == ''
      @sign = '-'
    else 
      @sign = ''
    end
    self
  end
  
  def sign
    @sign
  end
  
  def generator
    @generator
  end  

  def index
    @index
  end

end

###

class Word

  def initialize(word)
    @letter_array = Array.new
    if word.nil?
      nil
    else
      word.split('.').each do |letter|
        @letter_array << Letter.new(letter)
      end
      self.normalize
    end
    self
  end
  
  def hash
    (self.to_s).hash
  end
  
  def eql?(compare)
    self == compare    
  end

  def ==(compare)
    self.to_s == compare.to_s
  end
      
  def to_s
    if @letter_array[0].nil?
      ''
    else
      word_array = Array.new
      @letter_array.each do |letter|
        word_array << letter.to_s
      end
      word_array * '.'
    end
  end
  
  def [](index)
    @letter_array[index]
  end
  
  def []=(index,letter)
    @letter_array[index]=Letter.new(letter)
  end
  
  def each
    size=@letter_array.size
    (0..size-1).each do |i|
      yield @letter_array[i]
    end
  end
  
  def size
    @letter_array.size
  end

  def invert!
    @letter_array.reverse!
    @letter_array.each do |letter|
      letter.invert!
    end
    self
  end
  
   def invert
    Word.new(self.to_s).invert!
  end
    
  def delete_letter!(i)
    @letter_array.delete_at(i)
  end
  
  def remove_inverses!
    i=0
    until self[i+1].nil?
      if self[i]==self[i+1].invert
        self.delete_letter!(i)
        self.delete_letter!(i)
        i=0
      else 
        i+=1
      end
    end
    self
  end
  
  def remove_inverses
    Word.new(self.to_s).remove_inverses!
  end
  
  def swap!(i,j)
    @letter_array[i], @letter_array[j] = @letter_array[j], @letter_array[i]
    self
  end
  
  def normalize
    i=0
    until self[i+1].nil?
      case self[i].sign
      when ''
        case self[i+1].sign
        when ''
          if self[i].index > self[i+1].index
            self.swap!(i,i+1)
            self[i+1].increment!
            i=-1
          end
          self.remove_inverses!
        when '-'
          self.remove_inverses!
        end
      when '-'
        case self[i+1].sign
        when ''
          if self[i].index < self[i+1].index
            self.swap!(i,i+1)
            self[i].increment!
            i=-1
          elsif self[i].index > self[i+1].index
            self.swap!(i,i+1)
            self[i+1].increment!
            i=-1
          else
            
          end
          self.remove_inverses!
        when '-'
          if self[i].index < self[i+1].index
            self.swap!(i,i+1)
            self[i].increment!
            i=-1
          end
          self.remove_inverses!
        end        
      end
      i+=1
    end
    self
  end
  
end

###

def multiply(word1,word2)
  if (word1.nil? && word2.nil?)
    Word.new(nil)
  elsif word1.nil?
    Word.new(word2)
  elsif word2.nil?
    Word.new(word1)
  else
    Word.new(word1.to_s+'.'+word2.to_s)
  end
  
end

###

def conjugate(word1,word2)
  
  multiply(multiply(word2.invert,word1),word2)
  
end

###

def commutate(word1,word2)
  
  multiply(conjugate(word2.invert,word1),word2)
  
end


a=Word.new('a')
b=Word.new('b')

puts commutate(a,b)
puts conjugate(a,b)

###


# current methods & classes... a.k.a. Documentation!
#
# -- Letter -- Each instance has three variables, @sign, @letter, @index, they are modified by the following methods 
# Letter - to_s changes a letter that looks like ('','x',4) to a string that looks like 'x_4'
# Letter - change_to(a,b,c) changes a letter like ('','x',4) to a letter like ('-','x',23)
# Letter - invert, invert! changes the sign of a letter, i.e. ('','x',4) will change to ('-','x',4)
# Letter - increment!, decrement! will add or subtract one from the index of a letter
# Letter - == will test two letters for equality 
# Letter - index, generator, sign will return the components of the letter.  e.g. let.sign will return '-' if let is ('-','x',4)
#
# -- Word -- Each instance has one major variable, @letter_array, which is an array of Letters.  It is modified by the following 
#            methods
# Word - to_s changes @letter_array to a string, unless it is empty.  in that case it returns 'emtpy word'
# Word - [], []= allows access or assignment to a specific letter in @letter_array
# Word - each allows loops whose variable are the letters in @letter_array
# Word - size returns how many letters are in @letter_array
# Word - invert, invert! calls Letter.invert on all letters on @letter_array, then reverses the order of @letter_array
# Word - delete_letter! removes a letter in @letter_array
# Word - swap(i,j) swaps the letters at position i and j
# Word - remove_inverses, remove_inverses! looks for '-x_i.x_i' or 'x_i.-x_i' in a string.  when it finds it, it removes them.
# Word - normalize will look for any out of place letters, and remove them

