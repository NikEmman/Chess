# fix not_threatened_by_enemy_piece?(column, board) for king

# this method does not consider other conditions that might put the king in check,
# such as moving a piece that was blocking an enemy’s attack on the king.
# maybe it should be in game class?

# ----------pawn en-passant move--------------
# There is one special rule, called taking en-passant. When a pawn makes a double step from the second row to the fourth row,
# and there is an enemy pawn on an adjacent square on the fourth row,
# then this enemy pawn in the next move may move diagonally to the square that was passed over by the double-stepping pawn,
# which is on the third row. In this same move, the double-stepping pawn is taken.
# This taking en-passant must be done directly: if the player who could take en-passant does not do this in the first move
# after the double step, this pawn cannot be taken anymore by an en-passant move.

# pawn promotion
