import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Error "mo:base/Error";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";

import Types "types";

actor {

	// store in stable the http_response
    stable var stable_decoded_raw_text: Text = ""; 

    public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
        let transformed : Types.CanisterHttpResponsePayload = {
            status = raw.response.status;
            body = raw.response.body;
            headers = [
                {
                    name = "Content-Security-Policy";
                    value = "default-src 'self'";
                },
                { name = "Referrer-Policy"; value = "strict-origin" },
                { name = "Permissions-Policy"; value = "geolocation=(self)" },
                {
                    name = "Strict-Transport-Security";
                    value = "max-age=63072000";
                },
                { name = "X-Frame-Options"; value = "DENY" },
                { name = "X-Content-Type-Options"; value = "nosniff" },
            ];
        };
        transformed;
    };
  
    public func get_raw_data(url: Text) : async Text {
        let ic : Types.IC = actor ("aaaaa-aa");

        let request_headers = [
            { name = "Host"; value = "raw.githubusercontent.com" },
            { name = "User-Agent"; value = "parsekoto" },
        ];

        let transform_context : Types.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        let http_request : Types.HttpRequestArgs = {
            url = url;
            max_response_bytes = null; 
            headers = request_headers;
            body = null; 
            method = #get;
            transform = ?transform_context;
        };

        Cycles.add(230_949_972_000);
        
        let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

        let response_body: Blob = Blob.fromArray(http_response.body);
        let decoded_text: Text = switch (Text.decodeUtf8(response_body)) {
            case (null) { "No value returned" };
            case (?y) { y };
        };

        stable_decoded_raw_text := decoded_text; 

        decoded_text
    };

    public query func get_stable_raw_text() : async Text {
		return stable_decoded_raw_text;
    };
};

