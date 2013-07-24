class Piece
  attr_reader :side

  def initialize(pos, side, board)
    @pos, @side, @board = pos, side, board
    @on_board = false
  end

  def to_s
    piece_hash = {
      King => 'O',
      Queen => 'Q',
      Bishop => 'B',
      Knight => 'K',
      Rook => 'R',
      Pawn => 'P'
    }
    if @side == :black
      piece_hash[self.class]
    else
      piece_hash[self.class].downcase
    end
  end

end


class Pawn < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end

  def valid_moves
    valid_moves = []

    if @side == :black
      valid_moves << [@pos[0] + 2, @pos[1]] if @pos[0] == 1

      if @board.board[@pos[0] + 1][@pos[1]].nil?
        valid_moves << [@pos[0] + 1, @pos[1]]
      end

      # Possible enemy locations

      possible_enemy = @board.board[@pos[0] + 1][@pos[1] - 1]
      unless possible_enemy.nil? || possible_enemy.side == @side
        valid_moves << [@pos[0] + 1, @pos[1] - 1]
      end
      possible_enemy = @board.board[@pos[0] + 1][@pos[1] + 1]
      unless possible_enemy.nil? || possible_enemy.side == @side
        valid_moves << [@pos[0] + 1, @pos[1] + 1]
      end
    else # :white
      valid_moves << [@pos[0] - 2, @pos[1]] if @pos[0] == 6
      if @board.board[@pos[0] - 1][@pos[1]].nil?
        valid_moves << [@pos[0] - 1, @pos[1]]
      end

      # Possible enemy locations
      possible_enemy = @board.board[@pos[0] - 1][@pos[1] - 1]
      unless possible_enemy.nil? || possible_enemy.side == @side
        valid_moves << [@pos[0] - 1, @pos[1] - 1]
      end


      possible_enemy = @board.board[@pos[0] - 1][@pos[1] + 1]
      unless possible_enemy.nil? || possible_enemy.side == @side
        valid_moves << [@pos[0] - 1, @pos[1] + 1]
      end
    end
    p @side
    p valid_moves
    valid_moves
  end
end

class Bishop < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end

  def valid_moves

  end
end

class Knight < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end

  def valid_moves

  end
end

class Rook < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end

  def valid_moves

  end
end

class King < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end

  def valid_moves

  end
end

class Queen < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end

  def valid_moves

  end
end





class Board
  attr_reader :board

  def initialize
    generate_board
    initialize_pieces
  end

  def display_board

    8.times do |row|
      print "#{8 - row} "

      @board[row].each do |piece|
        piece.nil? ? print(". ") : print("#{piece.to_s} ")
      end
      puts ''
    end
    puts '  a b c d e f g h'
  end

  def move_piece(from, to, player)
    # validate moves, if okay then move
    #
    #
    piece_current_location = @board[from[0]][from[1]]
    piece_next_location = @board[to[0]][to[1]]

    if piece_current_location.valid_moves.include?(to) && piece_current_location.side == player.side

      #piece_next_location = piece_current_location
      @board[to[0]][to[1]] = @board[from[0]][from[1]]
      #piece_current_location = nil
      @board[from[0]][from[1]] = nil
    else
      puts "Invalid move, try again"
    end
  end

  # TODO: Make this work
  def move_piece2(from, to)
    # validate moves, if okay then move
    #
    #

    if get_piece(from[0], from[1]).valid_moves.include?(to)

      #piece_next_location = piece_current_location
#      get_piece(to[0], to[1]) = get_piece(from[0], from[1])
      #piece_current_location = nil
#      get_piece(from[0], from[1]) = nil
    else
      puts "Invalid move, try again"
    end
  end

  def get_piece(x, y)
    @board[x][y]

  end




  private
  def generate_board
    @board = []
    8.times do |idx|
      @board << []
      8.times { @board[idx] << nil }
    end
    @board
  end

  def initialize_pieces
    8.times do |i|
      @board[1][i] = Pawn.new([1, i], :black, self)
      @board[6][i] = Pawn.new([6, i], :white, self)
    end

    [0, 7].each do |row|
      8.times do |col|
        side = :white if row == 7
        side = :black if row == 0
        @board[row][col] = Rook.new([row, col], side, self) if [0, 7].include?(col)
        @board[row][col] = Knight.new([row, col], side, self) if [1, 6].include?(col)
        @board[row][col] = Bishop.new([row, col], side, self) if [2, 5].include?(col)
        @board[row][col] = Queen.new([row, col], side, self) if col == 3
        @board[row][col] = King.new([row, col], side, self) if col == 4
      end
    end
  end

end

class HumanPlayer
  attr_reader :side

  def initialize(board, side)
    @board, @side = board, side
  end

  def play_turn
    @board.display_board

    user_input = self.get_input
    # If you move a piece opposite your side, u suck

    self.move_piece(user_input)
  end

  def get_input
    puts "please input moves: eg. f1, g1"
    raw_input = gets.chomp.split(", ")
    from = HumanPlayer.pos_convert(raw_input.first)
    to = HumanPlayer.pos_convert(raw_input.last)
    p [from, to]
    [from, to]
  end

  def move_piece(pos)
    from = pos.first
    to = pos.last

    @board.move_piece(from, to, self)
  end

  def self.pos_convert(user_pos)
    user_pos.split('')
    board_pos = [8 - user_pos[1].to_i, (user_pos[0].ord - 97) ]

    board_pos
  end
end

class ChessGame

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(@board, :white)
    @player2 = HumanPlayer.new(@board, :black)

  end


  def play
    while true
      @player1.play_turn
      @player2.play_turn
    end

  end


end



