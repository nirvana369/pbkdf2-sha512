import nacl "mo:tweetnacl";

actor class Sha512() = this {
    
    public shared func hash(bytes : [Nat8]) : async [Nat8] {
        nacl.hash(bytes);
    };
}