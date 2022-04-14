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
    announcer = "\n\n\n#{$current_word.join(' ')}"
    announcer += "  Incorrect letters used: #{$used_letters.join(' ')}" if $used_letters.length >= 1
    puts announcer
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
    correct = false
    $goal_word.split('').each_with_index do |letter, i|
        if letter == user_elec.downcase
            if $current_word[i] == letter.upcase
                puts "\nYou alredy guessed that letter!"
                return
            else
                $current_word[i] = letter.upcase
                correct = true
            end
        end
    end
    if correct == false
        $current_misses += 1
        $used_letters.push(user_elec) unless $used_letters.any?(user_elec)
    end
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
            display_game_state()
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
$current_word = Array.new($goal_word.length, '_')
$current_misses = 0
$used_letters = []
game()


# At the beginning display a select menu which contains load game, new game and some instructions
# if the user selects load game, check inside the saves dir for any saved games
# if there are any, the display them and ask for what file you want to load