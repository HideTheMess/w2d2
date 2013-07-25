# class PosNode
#   attr_accessor :parent
#   attr_reader :children
#
#   def initialize(pos, delta, range, piece)
#     @pos = pos
#     @delta = delta
#     @range = range
#     @piece = piece
#
#     @parent = nil
#     @children = []
#   end
#
#   def add_child(node)
#     @children << node
#     node.parent = self
#   end
#
#   def dfs_valid_moves
#     return if range == 0 ||
#
#     @delta.each do |del| || !@piece.pos_open?(pos[0] + del[], pos[1])
#
#     end
#   end
#
# end

class Piece
  attr_accessor :pos
  attr_reader :side

  def initialize(side, board, pos)
    @side, @board, @pos = side, board, pos
  end

  # def pos
#     @board.get_pos(self)
#   end

  def valid_moves(range, delta)
    possible_array = possible_moves(range, delta)
    # p possible_array
    # Deal w/ other pieces in the way
    valid_array = []

    possible_array.each do |leg|
      # next_flag = false
      valid_leg = leg
      leg.each_with_index do |possible_pos, i|
        # unless i == leg.size - 1
        next if pos_open?(possible_pos) #|| next_flag == true
        # end

        if pos_enemy?(possible_pos)
          valid_leg = leg[0..i]
          p valid_array
          p 'friend'
          # next_flag = true
          break
        else
          valid_leg = leg[0...i]
          p valid_array
          p'foe'
          # next_flag = true
          break
        end

      end
      valid_array += valid_leg
    end
    p valid_array
    valid_array
  end

  def possible_moves(range, delta)
    possible_array = []

    return if range == 0

    delta.each do |del|
      a = possible_leg(@pos, 1, range, del)
      possible_array << a
      #p a
    end

    possible_array.delete_if { |el| el.empty? }
    # p possible_array
    p possible_array
    possible_array
  end

  def possible_leg(pos, mult, range, delta_leg)
    del_pos = [pos[0] + (delta_leg[0] * mult), pos[1] + (delta_leg[1] * mult)]
    return [] if mult > range || del_pos[0] < 0 || del_pos[0] > 7 || del_pos[1] < 0 || del_pos[1] > 7


    leg_array = [del_pos]
    #p leg_array

    leg_array += possible_leg(@pos, mult + 1, range, delta_leg)
    # p leg_array

    leg_array
  end

  def valid_moves2(range, delta)
    moves = []
    (1..range).each do |range|
      delta.each do |delta|
        x = delta.first * range
        y = delta.last * range
        move_pos = [self.pos.first + x, self.pos.last + y]
        if self.pos_open?(move_pos)
          moves << move_pos
        else
          moves << move_pos if self.pos_enemy?(move_pos)
          break
        end
      end
    end
    moves
  end


  def pos_open?(pos)
    # @board.get_piece(pos).nil?
    row, col = pos

    @board.board[row][col].nil?
  end

  def pos_enemy?(pos)

    # @board.get_piece(pos).side == self.side
    row, col = pos

    @board.board[row][col].side == self.side
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
  DELTA = [[1, 0], [-1, 0]]
  RANGE = 1


  def initialize(side, board, pos)
    super(side, board, pos)
  end

  def valid_moves
    # call diagonal moves here
    # and other moves
    # ....
    # return an array of all valid moves
    pawn_deltas = []

    if self.side == :black

      forward = [self.pos.first + 1, self.pos.last]
      right = [self.pos.first + 1, self.pos.last + 1]
      left = [self.pos.first + 1, self.pos.last - 1]
      pawn_deltas << [1, 0] if self.pos_open?(forward)
      pawn_deltas << [1, 1] if self.pos_enemy?(right)
      pawn_deltas << [1, -1] if self.pos_enemy?(left)
    else

      forward = [self.pos.first - 1, self.pos.last]
      right = [self.pos.first - 1, self.pos.last + 1]
      left = [self.pos.first - 1, self.pos.last - 1]
      pawn_deltas << [-1, 0] if self.pos_open?(forward)
      pawn_deltas << [-1, 1] if self.pos_enemy?(right)
      pawn_deltas << [-1, -1] if self.pos_enemy?(left)
    end

    super(RANGE, pawn_deltas)



  end

  def valid_moves1
    super(RANGE, DELTA)
  end

end

class Bishop < Piece
  DELTA = [[-1, -1], [1, 1], [-1, 1], [1, -1]]
  RANGE = 8
  def initialize(side, board, pos)
    super(side, board, pos)
  end

  def valid_moves
    super(RANGE, DELTA)
  end

end

class Knight < Piece
  DELTA = [[2, 1], [-2, 1], [2, -1], [-2, -1],
          [1, 2], [-1, 2], [1, -2], [-1, -2]]
  RANGE = 1
  def initialize(side, board, pos)
    super(side, board, pos)
  end

    def valid_moves
    super(RANGE, DELTA)
  end

end

class Rook < Piece
  DELTA = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  RANGE = 8
  def initialize(side, board, pos)
    super(side, board, pos)
  end

    def valid_moves
    super(RANGE, DELTA)
  end

end

class King < Piece
  DELTA = [[0, 1], [0, -1], [1, 0], [-1, 0], [-1, -1], [1, 1], [-1, 1], [1, -1]]
  RANGE = 1
  def initialize(side, board, pos)
    super(side, board, pos)
  end

  def valid_moves
    super(RANGE, DELTA)
  end

end

class Queen < Piece
  DELTA = [[0, 1], [0, -1], [1, 0], [-1, 0], [-1, -1], [1, 1], [-1, 1], [1, -1]]
  RANGE = 1
  def initialize(side, board, pos)
    super(side, board, pos)
  end

  def valid_moves
    super(RANGE, DELTA)
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

    same_side = same_side?(piece_current_location, player)
    # p piece_current_location.valid_moves
    if piece_current_location.valid_moves.include?(to)# && same_side # Debug

      #piece_next_location = piece_current_location
      @board[from[0]][from[1]].pos = to
      @board[to[0]][to[1]] = @board[from[0]][from[1]]
      #piece_current_location = nil
      @board[from[0]][from[1]] = nil
    else
      puts "Invalid move, try again"
    end
  end

  def same_side?(piece1, piece2)
    return piece1.side == piece2.side
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

  def get_piece(pos)
    @board[pos.first][pos.last]

  end

  def get_pos(piece)
    @board.each_with_index do |row, i|
      row.each_with_index do |el, j|
        return [i, j] if piece == el
      end
    end

    nil
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
      @board[1][i] = Pawn.new(:black, self)
      @board[6][i] = Pawn.new(:white, self)
   end

    [0, 7].each do |row|
      8.times do |col|
        side = :white if row == 7
        side = :black if row == 0
        @board[row][col] = Rook.new(side, self, [row, col]) if [0, 7].include?(col)
        @board[row][col] = Knight.new(side, self, [row, col]) if [1, 6].include?(col)
        @board[row][col] = Bishop.new(side, self, [row, col]) if [2, 5].include?(col)
        @board[row][col] = Queen.new(side, self, [row, col]) if col == 3
        @board[row][col] = King.new(side, self, [row, col]) if col == 4
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
  attr_reader :board # Debug

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

game = ChessGame.new
game.play