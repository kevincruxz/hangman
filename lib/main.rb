class Save
    def initialize(name, stickman, current_word)
        @name = name
        @stickman = stickman
        @word = current_word
    end

    def method_name
        
    end
end

def select_word
    word = ''
    while true
        random_num = rand(1..9894)
        word = IO.readlines('dictionary.txt')[random_num].chomp
        break if word.length >= 5 && word.length <= 12
    end
    word
end

def display_game_state()
    draw_stickman()
    puts "\n\n\n#{$current_word.join}"
end

def draw_stickman()
    str = "==|\n  |\n"
    str += '  O' if $current_misses >= 1
    str += "\n  |" if $current_misses == 2
    str += "\n/ |" if $current_misses == 3
    str += "\n/ | \\" if $current_misses == 4
    str += "\n/ | \\\n /" if $current_misses == 5
    str += "\n/ | \\\n / \\" if $current_misses == 6
    puts str
end

def check_if_correct(user_elec)
    # loop through the word checking each letter if it is equal to the letter user provided
    # if it is equal then in that position of current_guessed replace the _ with the letter
    # continue through the word
    correct = false
    $goal_word.split('').each_with_index do |letter, i|
        if letter == user_elec
            $current_word[i] = " #{letter.upcase} "
            correct = true
        end
    end
    $current_misses += 1 if correct == false
end

def ask_letter
    print 'Write your next guess (a-z): '
    letter = gets.chomp
    while letter.length != 1 || letter.downcase.ord < 97 ||   letter.downcase.ord > 122
        puts "Wrong input, try again."
        print 'Write your next guess (a-z): '
        letter = gets.chomp
    end
    letter
end

def game
    while true
        display_game_state()
        letter = ask_letter()
        check_if_correct(letter)
        if $current_word.join.downcase == $goal_word
            puts "Congrats you guessed it!"
            break
        elsif $current_misses == 6
            draw_stickman()
            puts "\nOh man you lost :("
            puts "The word was \"#{$goal_word.upcase}\""
            break
        end
    end
end

$goal_word = select_word()
$current_word = Array.new($goal_word.length, ' _ ')
$current_misses = 0
game()


# At the beginning display a select menu which contains load game, new game and some instructions
# if the user selects load game, check inside the saves dir for any saved games
# if there are any, the display them and ask for what file you want to load

# if it is a new game then load the file dictionary select a random word
# if the word is higher= than 5 an lower= than 12 then select that word and break
# if not repeat the process

# can make the save process in a class with objects
# make the stickman in an array and draw the stickman form it