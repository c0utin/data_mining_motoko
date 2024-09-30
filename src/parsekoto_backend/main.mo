import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Float "mo:base/Float";
import JSON "mo:serde/JSON";

import Types "types";

actor {

    type networks_interface = actor {
        get_raw_data: (Text) -> async Text;
        get_stable_raw_json: () -> async Text;
    };

    var networks: ?networks_interface = null; 

    public func setup_networks(c: Principal) {
        networks := ?(actor (Principal.toText(c)) : networks_interface);
    };

    public func fetch_raw_data(url: Text) : async Text {
        switch (networks) {
            case (null) { 
                return "Networks not set up"; 
            };
            case (?n) { 
                return await n.get_raw_data(url); 
            };
        }
    };

    public func fetch_stable_raw_json() : async Types.Result<Types.StudentRecord, Types.ParseError> {
        switch (networks) {
            case (?n) { 

                let decoded_text =  await n.get_stable_raw_json(); 

				let json_result = JSON.fromText(decoded_text, null);
				let json_blob = switch (json_result) {
					case (#ok(blob)) { blob };
					case (#err(e)) {
						return #err({ message = "Failed to parse JSON: " # e });
					};
				};

				let student_record: ?Types.StudentRecord = from_candid(json_blob);
				switch (student_record) {
					case (?record) { return #ok(record) };
					case null { return #err({ message = "Failed to convert JSON into StudentRecord" }) };
				}

            };
        }
    };




	let mock: [Types.StudentRecord] = [
		{
			studytime = 10;
			higher = "Yes";
			absences = 2;
			failures = "No";
		},
		{
			studytime = 15;
			higher = "No";
			absences = 5;
			failures = "Yes";
		},
		{
			studytime = 8;
			higher = "Yes";
			absences = 1;
			failures = "No";
		}
	];

	public func calculateDistance(a: Types.StudentRecord, b: Types.StudentRecord): async Float {
		let studytimeDiff = Float.abs(Float.fromInt(a.studytime) - Float.fromInt(b.studytime));
		let absencesDiff = Float.abs(Float.fromInt(a.absences) - Float.fromInt(b.absences));
		return studytimeDiff + absencesDiff;
	};

	public func calculateAllDistances(newRecord: Types.StudentRecord): async [(Types.StudentRecord, Float)] {
		var distances: [(Types.StudentRecord, Float)] = [];

		for (mockRecord in mock.vals()) { 
			let distance = await calculateDistance(newRecord, mockRecord);
			distances := Array.append(distances, [(mockRecord, distance)]);
		};

		return distances;
	};

};

