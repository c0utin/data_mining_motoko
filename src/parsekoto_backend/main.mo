import Principal "mo:base/Principal";
import Float "mo:base/Float";
import Text "mo:base/Text";
import Array "mo:base/Array";
import JSON "mo:serde/JSON";
import Types "types";

actor {

    stable var stable_decoded_student: [Types.StudentRecord] = [];

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
            case (null) { return "Networks not set up"; };
            case (?n) { return await n.get_raw_data(url); };
        }
    };

    public func fetch_stable_raw_json() : async Types.Result<Types.StudentRecord, Types.ParseError> {
        switch (networks) {
            case (?n) {
                let decoded_text = await n.get_stable_raw_json();

                let json_result = JSON.fromText(decoded_text, null);
                let json_blob = switch (json_result) {
                    case (#ok(blob)) { blob };
                    case (#err(e)) { return #err({ message = "Failed to parse JSON: " # e }); };
                };

                let student_record: ?Types.StudentRecord = from_candid(json_blob);
                switch (student_record) {
                    case (?record) {
                        stable_decoded_student := Array.append(stable_decoded_student, [record]);
                        return #ok(record);
                    };
                    case null { return #err({ message = "Failed to convert JSON into StudentRecord" }); };
                };
            };
            case null { return #err({ message = "Networks not set up" }); };
        }
    };

	public query func get_stable_decoded_student(): async [Types.StudentRecord]{
		return stable_decoded_student;
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

	public func calculateAllDistancesMock(newRecord: Types.StudentRecord): async [(Types.StudentRecord, Float)] {
		var distances: [(Types.StudentRecord, Float)] = [];

		for (mockRecord in mock.vals()) { 
			let distance = await calculateDistance(newRecord, mockRecord);
			distances := Array.append(distances, [(mockRecord, distance)]);
		};

		return distances;
	};


	public func calculateAllDistances(newRecord: Types.StudentRecord): async [(Types.StudentRecord, Float)] {
		var distances: [(Types.StudentRecord, Float)] = [];

		for (realRecord in stable_decoded_student.vals()) { 
			let distance = await calculateDistance(newRecord, realRecord);
			distances := Array.append(distances, [(realRecord, distance)]);
		};

		return distances;
	};

};

