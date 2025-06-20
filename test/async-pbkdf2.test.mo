/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : lib.test.mo
* Description       : test
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 19/06/2025		nirvana369 		implement
******************************************************************/

import {test; suite} "mo:test/async";
import Debug "mo:base/Debug";
import Utils "../src/utils";
import PBKDF2 "../src/lib";
import Sha512 "./sha512";
import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";

actor class AsyncTest() = this {

    let principalId = Principal.fromActor(this);

    type TEST_ACTOR = actor {
        run: (sha512Actor : Principal, pwd : PBKDF2.PBKDFInput, salt : PBKDF2.PBKDFInput, iterations : Nat, keyLen : Nat) -> async (Text); 
    };

    type SHA512_ACTOR = actor {
        hash: ([Nat8]) -> async ([Nat8]);
    };

    let testActor: TEST_ACTOR = actor(Principal.toText(principalId));

    public func run(id: Principal, pwd : PBKDF2.PBKDFInput, salt : PBKDF2.PBKDFInput, iterations : Nat, keyLen : Nat) : async (Text) {
        let sha512 : SHA512_ACTOR = actor(Principal.toText(id));
        let r = await PBKDF2.async_pbkdf2(sha512.hash, pwd, salt, iterations, keyLen);
        let hex = Utils.bytesToHex(r);
        return hex;
    };
    
    public func runTests() : async () {

        Cycles.add(4_000_000_000_000);
        let sha512 = await Sha512.Sha512();
        let principalId = Principal.fromActor(sha512);

        await suite("PBKDF2-SHA512-1", func() : async ()  {

            let VECTORS = [
                // {
                //     password = #hex "70617373776f7264";
                //     salt = #hex "73616c74";
                //     iterations = 15000;
                //     keyLen = 128;
                //     output = "d82201f122fafdb1c66882946b2815fa7e17638015a9bcb1dc56a652f324de9615d4ac12a2b47da8dd3d4d94baf56d60b15a4960dd106f96e0917f935c39d4261fcbb050ded21ba8e6d1c28913953e4eb65faefe92d32298a816093fa1788db2011674171005a34625464adc50fc3931c08915baad73ccafa17bcf31652193a8";
                // }
                // ,
                // {
                //     iterations = 12345;
                //     password = #hex "aabbccddeeff";
                //     salt = #hex "ffeeddccbbaa";
                //     keyLen = 64;
                //     output = "fec841d0b2c19bd48a7dab64baa19b5a3b40d6017c021f6462f9877eec94acc87a25f6db1c12a2df219bc70a5ca764254b8d7151ab1edeb500453581aea20971";
                // },
                {
                    password = #text "fun chest brief dignity card enable horn useless champion pool spirit borrow robust useless card capital deliver seek exotic hybrid scale artist rebuild cactus";
                    salt = #text "ability reduce away dizzy minute basic snake purity scheme better torch add cement vintage silk museum pulse brand crater toilet gym garment shuffle group";
                    iterations = 10000;
                    keyLen = 64;
                    output = "addef8ea06b062f11cbb1d9d8916d91b4d83be03bc15a454e4ea3479cce1a453a40a6a485fee746d0aa193f89e5a76a8396d58098e44dd626a561584114e719a";
                },
                {
                    password = #text "";
                    salt = #text "";
                    iterations = 10000;
                    keyLen = 64;
                    output = "49b4a7213dfcee4eaddec1e21ea6fc8b9a2c465ae7cd504f411eee6b21d2e5ef76348ae1a9eaa81b55556d13a2434d09022cc407d9136246ef352805f4b4abb5";
                }
            ];

            for (input in VECTORS.vals()) {
                await test("PBKDF2_SHA512 simple test | " # input.output, func(): async ()  {
                        let hex = await testActor.run(principalId, input.password, input.salt, input.iterations, input.keyLen);
                        assert(hex == input.output);
                });
            };
        });

    };
}