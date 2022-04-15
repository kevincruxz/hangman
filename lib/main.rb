require 'csv'

class Save
    def initialize(goal_word, current_word, current_misses, used_letters)
        @goal_word = goal_word
        @current_word = current_word
        @current_misses = current_misses
        @used_letters = used_letters
        serialize
    end

    def serialize
        print "How you want to name your save? : "
        file_name = gets.chomp
        File.open("saves/#{file_name}.csv", 'w') do |file|
            file.puts "goal_word,current_word,current_misses,used_letters\n#{@goal_word},#{@current_word.join},#{@current_misses},#{@used_letters.join}"
        end
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

def ask_letter(add)
    print "Write your next guess#{add}: "
    letter = gets.chomp
    return letter if letter == 'save'
    while letter.length != 1 || letter.downcase.ord < 97 || letter.downcase.ord > 122
        puts "Wrong input, try again."
        print 'Write your next guess (a-z): '
        letter = gets.chomp
    end
    letter
end

def game
    add = ''
    while true
        display_game_state()
        letter = ask_letter(add)
        if letter == 'save'
            Save.new($goal_word, $current_word, $current_misses, $used_letters)
        else
            check_if_correct(letter)
        end
        if $current_word.join.downcase == $goal_word
            display_game_state()
            puts 'Congrats you guessed it!'
            break
        elsif $current_misses == 6
            draw_stickman()
            puts "\nOh man you lost :("
            puts "The word was \"#{$goal_word.upcase}\""
            break
        end
        add = ' (or type save to save your current game)'
    end
end

def search_file
    exists = false
    until exists
        print 'Write the name of the file you want to load: '
        filename = gets.chomp
        if File.file?("saves/#{filename}")
            filename = filename.split('')
            filename.pop(4)
            filename = filename.join
            exists = true
        elsif File.file?("saves/#{filename}.csv")
            exists = true
        end
        if !exists
            puts "Couldn't find that file. (1) Try again (2) Exit"
            response = gets.chomp
            return if response == '2'
        end
    end
    load_game(filename)
end

def load_game(filename)
    content = CSV.open("saves/#{filename}.csv",
        headers: true,
        header_converters: :symbol
    )
    content.each do |line|
        $goal_word = line[:goal_word]
        $current_word = line[:current_word].split('')
        $current_misses = line[:current_misses].to_i
        $used_letters = line[:used_letters].split('')
    end
    game
end

def start_game
    str = ''
    str += 'Hello! welcome to hangman, this is a game where you have to guess a secret word before '
    str += "\nthe little stickman gets hanged."
    str += "\nEvery turn type a letter, if it is in the word it will be revealed, if not, a bodypart "
    str += "\nof the stickman will be drawed."
    str += "\n\nAlso you're able to save your game every turn, and reload it simply rerunning the program."
    str += "\n\n(1) New Game   (2) Load Game"
    str += "\nChoose an option (1 or 2): "
    print str
    election = gets.chomp
    game if election == '1'
    search_file if election == '2'
end

$goal_word = select_word()
$current_word = Array.new($goal_word.length, '_')
$current_misses = 0
$used_letters = []
start_game
