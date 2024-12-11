#[cfg(test)]
mod tests {
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef
    };

    use starkludo::systems::game_actions::{
        GameActions, IGameActionsDispatcher, IGameActionsDispatcherTrait
    };
    use starkludo::models::game::{Game, m_Game};
    use starkludo::models::player::{Player, m_Player};

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "starkludo", resources: [
                TestResource::Model(m_Game::TEST_CLASS_HASH),
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Contract(GameActions::TEST_CLASS_HASH),
                TestResource::Event(GameActions::e_GameCreated::TEST_CLASS_HASH),
            ].span()
        };

        ndef
    }

    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"starkludo", @"GameActions")
                .with_writer_of([dojo::utils::bytearray_hash(@"starkludo")].span())
        ].span()
    }

    #[test]
    fn test_world() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());
    }
}
