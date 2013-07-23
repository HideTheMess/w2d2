class Piece
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


end

class Bishop < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end
end

class Knight < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end
end

class Rook < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end
end

class King < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end
end

class Queen < Piece
  def initialize(pos, side, board)
    super(pos, side, board)
  end
end

class Board
  def initialize
    generate_board
    initialize_pieces
  end

  def display_board

    8.times do |row|
      print "#{8-row} "

      @board[row].each do |piece|
        print "#{piece.to_s} "
      end
      puts ''
    end
    puts '  a b c d e f g h'
  end

  def in_to_out_convert(user_pos)
    user_pos.split('')

    board_pos = [user_pos[1].to_i - 1, 8 - (user_pos[0].ord - 97) ]
    board_pos
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



