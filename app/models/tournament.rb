class Tournament < ApplicationRecord
    has_many :results
    has_and_belongs_to_many :nfts, optional: true


    def play
        array_of_fighters = []

        nft1 = self.nfts.first
        nft2 = self.nfts.second
        nft3 = self.nfts.third
        nft4 = self.nfts.fourth

        array_of_fighters.push nft1, nft2, nft3, nft4

        prize_pool = 0.2 * array_of_fighters.length

        fight_card = array_of_fighters.shuffle.each_slice(2).to_a

        # Resolve the first round
        round1_fight1_winner = fight_card[0][0].fight(fight_card[0][1])
        round1_fight1_winner = round1_fight1_winner.won_fights.last.loser

        round1_fight2_winner = fight_card[1][0].fight(fight_card[1][1])
        round1_fight2_winner = round1_fight2_winner.won_fights.last.loser

        # Perform the updates on THE RESULT for the fights (give them the right round number and the correct prize pool)
        round1_fight1_winner.won_fights.last.update tournament_id: Tournament.last.id, round_number: 1, total_prize_pool: (prize_pool)
        round1_fight2_winner.won_fights.last.update tournament_id: Tournament.last.id, round_number: 1, total_prize_pool: (prize_pool)

        # Resolve the second round
        tournament_winner = round1_fight1_winner.fight(round1_fight2_winner)
        runner_up = tournament_winner.won_fights.last.loser

        # Perform the updates on THE RESULT for the fights (give them the right round number and the correct prize pool)
        tournament_winner.won_fights.last.update tournament_id: Tournament.last.id, round_number: 2, total_prize_pool: (prize_pool)

        @new_tournament = Tournament.new
        @new_tournament.save

        tournament_winner
    end

end