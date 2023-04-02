class Game
  attr_reader :num_tries, :secret_code

    #Constructor
  def initialize(secret_code = generate_secret_code)
    @num_tries = 12
    @secret_code = secret_code
  end

  #Check if the user guess is correct
  def check_secret_code(user_code)

    generated_code = @secret_code.to_s.split('') #randomly generate or assigned
    user_code = user_code.to_s.split('')

    selected_digits = []
    #select numbers that appears in the secret code
    generated_code.each do |num|
      if user_code.include?(num)
        selected_digits << num
        user_code.delete_at(user_code.index(num))
      end
    end


    #check no possibility of no valid numbers
    if selected_digits.empty?
      puts "There\'s no #{user_code.uniq.join('\'s, ')}\'s"
      return false
    end

    #if the secret code is guessed correctly, output winning message
    if selected_digits == generated_code
      puts "you win!"
      return true
    elsif selected_digits.length == 4 
      puts "you now have all the numbers, just not in the right order."
      return false
    end

    
    #check if the are number in correct place and in incorrect place
    if selected_digits.length > 0
      red_pegs = []
      white_pegs = []
      
      selected_digits.each_with_index do |number, index|
        if number == generated_code[index]
          red_pegs.push(number) #store correct guess individual numbers
        else
          white_pegs.push(number) #store wrong placed individual numbers
        end
      end
      empty_pegs = user_code #store numbers not in the secret code

      puts "#{(red_pegs.length > 0)? "We know where #{red_pegs.join(', ')} are. " : ""} #{(white_pegs.length > 0)? "The #{white_pegs.join(', ')} are in wrong order." : "" } #{(empty_pegs.length > 0)? "There\'s no #{empty_pegs.join(', ')}." : ""}"
      return false
    end
  end


  
  
end

#secret code guesser class
class CodeBreaker < Game
  def initialize
    super(generate_secret_code)
  end

  def generate_secret_code
    random_code = Random.new
    random_code.rand(1111..9999)
  end


end

#secret code maker class
class CodeMaker < Game
  def initialize(secret_code)
    super(secret_code)
  end
end



mode = nil

begin
  puts "Welcome to Mastermind game"
  puts "Choose mode:\n 1. CodeBreaker\n 2. CodeMaker"
  mode = gets.chomp.to_i

  if mode != 1 && mode != 2
    puts "Invalid Selection"
    sleep(0.8)
    system("clear")
  end
end until mode == 1 or mode == 2

if mode == 1
  mastermind = CodeBreaker.new #instance of chosen mode
elsif mode == 2
  print "Enter the secret code: "
  secret_code = gets.chomp
  
  #if user types out of ranges secret code
  while secret_code.to_s.length != 4 && !(1111..9999).include?(secret_code) do
        print "Please enter 4 digit secret code, range(1111..9999): "
        secret_code = gets.chomp 
  end
    
  mastermind = CodeMaker.new(secret_code.to_s) #instance of chosen mode
end
attempts = mastermind.num_tries.to_i
system("clear")
  

puts "Welcome to Mastermind - Guess the secret code from range (1111 - 9999)."
until attempts == 0 do
  
    #prompt user guess code
  print "\nAttempt: #{13 - attempts} - Enter your 4 digit guess secret code: "
  guessed_code = gets.chomp.to_s
  if guessed_code.length > 4 
    next
  end

  #output feedback if not guess correctly, end if guessed correctly
  if mastermind.check_secret_code(guessed_code) == true
    break
  end
  attempts -= 1
end 

#output loss message if user loses
if attempts == 0 && !mastermind.check_secret_code(guessed_code)
  puts "you lose, the secret code is #{mastermind.secret_code}"
end

