import Principal "mo:base/Principal";
import Text "mo:base/Text";

actor {

    type networks_interface = actor {
        get_raw_data: (Text) -> async Text;
        get_stable_raw_text: () -> async Text;
    };

    var networks : ?networks_interface = null; 

    public func setup_networks(c : Principal) {
        networks := ?(actor (Principal.toText(c)) : networks_interface);
    };

    public func fetch_raw_data(url: Text) : async Text {
        switch (networks) {
            case (null) { 
                return "Networks not set up"; // Retorna uma mensagem se networks não foi inicializado
            };
            case (?n) { 
                return await n.get_raw_data(url); // Chama a função do canister de redes
            };
        }
    };

    public func fetch_stable_raw_text() : async Text {
        switch (networks) {
            case (null) { 
                return "Networks not set up"; // Retorna uma mensagem se networks não foi inicializado
            };
            case (?n) { 
                return await n.get_stable_raw_text(); // Chama a função do canister de redes
            };
        }
    };
}

