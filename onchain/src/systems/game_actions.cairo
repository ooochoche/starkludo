use starkludo::models::{game::{Game, GameTrait, GameMode, GameStatus}, player::{Player}};
use starknet::{ContractAddress, get_block_timestamp};

#[starknet::interface]
trait IGameActions<T> {
    fn create(
        ref self: T,
        game_mode: GameMode,
        player_green: felt252,
        player_yellow: felt252,
        player_blue: felt252,
        player_red: felt252,
        number_of_players: u8
    ) -> usize;
    fn start(ref self: T);
    fn join(ref self: T);
    fn move(ref self: T);
    fn roll(ref self: T);
}

#[dojo::contract]
mod GameActions {
    use core::array::ArrayTrait;
    use super::{IGameActions, Game, GameTrait, GameMode, Player, GameStatus};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameCreated {
        #[key]
        pub game_id: usize,
        pub timestamp: u64
    }

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn create(
            ref self: ContractState,
            game_mode: GameMode,
            player_green: felt252,
            player_yellow: felt252,
            player_blue: felt252,
            player_red: felt252,
            number_of_players: u8,
        ) -> usize {
            // Get default world
            let mut world = self.world_default();

            let game_id = 999;
            let timestamp = get_block_timestamp();

            // Get the account address of the caller
            let caller = get_caller_address();

            // Create a new game
            let new_game: Game = GameTrait::new(
                game_id,
                caller,
                game_mode,
                player_red,
                player_blue,
                player_yellow,
                player_green,
                number_of_players
            );

            world.write_model(@new_game);

            world.emit_event(@GameCreated { game_id, timestamp });

            game_id
        }

        fn start(ref self: ContractState) {}

        fn join(ref self: ContractState) {}

        fn move(ref self: ContractState) {}

        fn roll(ref self: ContractState) {}
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Use the default namespace "starkludo". This function is handy since the ByteArray
        /// can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"starkludo")
        }
    }
}
