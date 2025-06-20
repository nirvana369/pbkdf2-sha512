/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : lib.mo
* Description       : PBKDF2-SHA512 library interface
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 20/06/2025		nirvana369 		implement
******************************************************************/

import PBKDF2 "./pbkdf2";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Utils "utils";

module {

    public type PBKDFInput = {
        #text : Text;
        #bytes : [Nat8];
        #blob : Blob;
        #hex : Text;
    };

    private func getInput(input : PBKDFInput) : [Nat8] {
        switch (input) {
            case (#text t) Blob.toArray(Text.encodeUtf8(t));
            case (#bytes arr) arr;
            case (#blob b) Blob.toArray(b);
            case (#hex h) Utils.hexToBytes(h);
        };
    };

    public func pbkdf2_sha512(password: PBKDFInput, salt: PBKDFInput, iterations: Nat, keylen: Nat) : [Nat8] {
        let pwd = getInput(password);
        let slt = getInput(salt);
        PBKDF2.pbkdf2_sha512(pwd, slt, iterations, keylen);
    };

    public func pbkdf2(hash: ([Nat8]) -> ([Nat8]), password: PBKDFInput, salt: PBKDFInput, iterations: Nat, keylen: Nat) : [Nat8] {
        let pwd = getInput(password);
        let slt = getInput(salt);
        PBKDF2.pbkdf2(hash, pwd, slt, iterations, keylen);
    };

    public func async_pbkdf2(hash: shared ([Nat8]) -> async ([Nat8]), password: PBKDFInput, salt: PBKDFInput, iterations: Nat, keylen: Nat) : async [Nat8] {
        let pwd = getInput(password);
        let slt = getInput(salt);
        await PBKDF2.async_pbkdf2(hash, pwd, slt, iterations, keylen);
    };
}