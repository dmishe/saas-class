def palindrome?(string)
  # determines whether a given word or phrase is a palindrome
  cleaned = string.gsub(/\W/, '').downcase

  cleaned == cleaned.reverse
end

def count_words(words)
  # Given a string of input, return a hash whose keys are words in the string
  # whose values are the number of times each word appears 

  Hash[words.downcase.scan(/\w+/).group_by { |x|x }.map {|k,v| [k, v.length]}]
end
