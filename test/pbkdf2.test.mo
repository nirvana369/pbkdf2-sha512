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
import Text "mo:base/Text";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Principal "mo:base/Principal";
import Utils "../src/utils";
import PBKDF2 "../src/lib";
import nacl "mo:tweetnacl";

actor class Test() = this {
    
    let principalId = Principal.fromActor(this);

    type TEST_ACTOR = actor {
        test1: () -> async ();
        test2: () -> async ();
        test3: () -> async ();
        run: (pwd : PBKDF2.PBKDFInput, salt : PBKDF2.PBKDFInput, iterations : Nat, keyLen : Nat) -> async (Text); 
    };

    let testActor: TEST_ACTOR = actor(Principal.toText(principalId));

    func hash(bytes : [Nat8]) : ([Nat8]) {
        nacl.hash(bytes);
    };

    public func run(pwd : PBKDF2.PBKDFInput, salt : PBKDF2.PBKDFInput, iterations : Nat, keyLen : Nat) : async (Text) {
        let r = PBKDF2.pbkdf2_sha512(pwd, salt, iterations, keyLen);
        let hex = Utils.bytesToHex(r);
        return hex;
    };

    // public func test1() : async () {
    //     suite("PBKDF2-SHA512-1", func() : ()  {

    //         let VECTORS = [
    //             {
    //                 password = #hex "00ffdeadbeefcafebabe";
    //                 salt = #hex "ff00bada55deadbeef";
    //                 iterations = 4096;
    //                 keyLen = 128;
    //                 output = "fa81cbc269d0656c1df2d3a592baa3b2cf74781b88e2419a84168f5deb60558788de54b1af59eeaa7047d2f03ce01aaa13130d933ee26889fa5dfdfa9681c8ac6977795abae0c593d23230480b241d49e93568cf4ddafa8048d21902edb54c24a50cc7c8690414afbd2278447e593c6b0a976fbe7c9a27940be7717703f3f5a4";
    //             },
    //             {
    //                 password = #hex "0a0b0c0d0e0f";
    //                 salt = #hex "f1f2f3f4f5";
    //                 iterations = 2048;
    //                 keyLen = 32;
    //                 output = "71b74f8b2e68c01b2e50ad500baec2ee0d59b16ccbec405100c86e1ab62a119f";
    //             }
    //         ];

    //         for (input in VECTORS.vals()) {
    //             test("PBKDF2_SHA512 simple test | " # input.output, func(): ()  {
    //                     let r = PBKDF2.pbkdf2_sha512(input.password, input.salt, input.iterations, input.keyLen);
    //                     let hex = Utils.bytesToHex(r);
    //                     Debug.print(hex);
    //                     assert(hex == input.output);
    //             });
    //         };
    //     });
    // };

    // public func test2() : async () {
    //     suite("PBKDF2-SHA512-2", func() : ()  {

    //         let VECTORS = [
    //             {
    //                 iterations = 1000;
    //                 password = #hex "deadbeef";
    //                 salt = #hex "cafebabe";
    //                 keyLen = 64;
    //                 output = "6d355c79c1120926801975555acd57e195a6d0fcaa642f15cc62c703f438df06d34b8f46eb7a82114d69727d5e819afd34dd8b71e3a84dc7d61020883da8f47b";
    //             },
    //             {
    //                 iterations = 8192;
    //                 password = #hex "00ff00ff00ff";
    //                 salt = #hex "112233445566";
    //                 keyLen = 64;
    //                 output = "f189d6192a3592fd3c5ad3be440d15f94f4b05bc5562a66d9969e5cc5b4982ae457efc6ca24f498127fb2d6afe19cd2017fffae27e8874fcd0a1ca9004a493f9";
    //             },
    //             {
    //                 iterations = 4096;
    //                 password = #hex "1337c0de";
    //                 salt = #hex "badc0ffee0ddf00d";
    //                 keyLen = 64;
    //                 output = "7833e58f6687851acd3dcce33fee307f4dbcec5cec1c9f87ea710e4cfff49b5c381f4f557fdb8f07e65f1b26aaa8f8f0e4ac49e5ce1aa6d0a358fccea85963bd";
    //             },
    //             {
    //                 iterations = 1024;
    //                 password = #hex "000102030405";
    //                 salt = #hex "0a0b0c0d0e0f";
    //                 keyLen = 32;
    //                 output = "ae2274fb46de2acfe8d7e062e7b3d2da9b65adc8279ac1169457ec2486d23bbb";
    //             }
    //         ];

    //         for (input in VECTORS.vals()) {
    //             test("PBKDF2_SHA512 simple test | " # input.output, func(): ()  {
    //                     let r = PBKDF2.pbkdf2(hash, input.password, input.salt, input.iterations, input.keyLen);
    //                     let hex = Utils.bytesToHex(r);
    //                     Debug.print(hex);
    //                     assert(hex == input.output);
    //             });
    //         };
    //     });
    // };

    // public func test3() : async () {
    //     suite("PBKDF2-SHA512-3", func() : ()  {

    //         let VECTORS = [
    //             {
    //                 password = #text "password";
    //                 salt = #text "salt";
    //                 iterations = 1;
    //                 keyLen = 64;
    //                 output = "867f70cf1ade02cff3752599a3a53dc4af34c7a669815ae5d513554e1c8cf252c02d470a285a0501bad999bfe943c08f050235d7d68b1da55e63f73b60a57fce";
    //             },
    //             {
    //                 password= #text "password";
    //                 salt= #text "salt";
    //                 iterations = 2;
    //                 keyLen = 64;
    //                 output = "e1d9c16aa681708a45f5c7c4e215ceb66e011a2e9f0040713f18aefdb866d53cf76cab2868a39b9f7840edce4fef5a82be67335c77a6068e04112754f27ccf4e";
    //             },
    //             {
    //                 password= #text "password";
    //                 salt= #text "salt";
    //                 iterations = 4096;
    //                 keyLen = 64;
    //                 output = "d197b1b33db0143e018b12f3d1d1479e6cdebdcc97c5c0f87f6902e072f457b5143f30602641b3d55cd335988cb36b84376060ecd532e039b742a239434af2d5";
    //             },
    //             {
    //                 password = #text "passwordPASSWORDpassword";
    //                 salt = #text "saltSALTsaltSALTsaltSALTsaltSALTsalt";
    //                 iterations = 4096;
    //                 keyLen = 64;
    //                 output = "8c0511f4c6e597c6ac6315d8f0362e225f3c501495ba23b868c005174dc4ee71115b59f9e60cd9532fa33e0f75aefe30225c583a186cd82bd4daea9724a3d3b8";
    //             }
    //         ];

    //         for (input in VECTORS.vals()) {
    //             test("PBKDF2_SHA512 simple test | " # input.output, func(): ()  {
    //                     let r = PBKDF2.pbkdf2_sha512(input.password, input.salt, input.iterations, input.keyLen);
    //                     let hex = Utils.bytesToHex(r);
    //                     Debug.print(hex);
    //                     assert(hex == input.output);
    //             });
    //         };
    //     });

    // };

    public func runTests() : async () {
        await suite("PBKDF2-SHA512", func() : async ()  {

            let VECTORS = [
                {
                    password = #text "password";
                    salt = #text "salt";
                    iterations = 1;
                    keyLen = 64;
                    output = "867f70cf1ade02cff3752599a3a53dc4af34c7a669815ae5d513554e1c8cf252c02d470a285a0501bad999bfe943c08f050235d7d68b1da55e63f73b60a57fce";
                },
                {
                    password= #text "password";
                    salt= #text "salt";
                    iterations = 2;
                    keyLen = 64;
                    output = "e1d9c16aa681708a45f5c7c4e215ceb66e011a2e9f0040713f18aefdb866d53cf76cab2868a39b9f7840edce4fef5a82be67335c77a6068e04112754f27ccf4e";
                },
                {
                    password= #text "password";
                    salt= #text "salt";
                    iterations = 4096;
                    keyLen = 64;
                    output = "d197b1b33db0143e018b12f3d1d1479e6cdebdcc97c5c0f87f6902e072f457b5143f30602641b3d55cd335988cb36b84376060ecd532e039b742a239434af2d5";
                },
                {
                    password = #text "passwordPASSWORDpassword";
                    salt = #text "saltSALTsaltSALTsaltSALTsaltSALTsalt";
                    iterations = 4096;
                    keyLen = 64;
                    output = "8c0511f4c6e597c6ac6315d8f0362e225f3c501495ba23b868c005174dc4ee71115b59f9e60cd9532fa33e0f75aefe30225c583a186cd82bd4daea9724a3d3b8";
                },
                {
                    iterations = 1000;
                    password = #hex "deadbeef";
                    salt = #hex "cafebabe";
                    keyLen = 64;
                    output = "6d355c79c1120926801975555acd57e195a6d0fcaa642f15cc62c703f438df06d34b8f46eb7a82114d69727d5e819afd34dd8b71e3a84dc7d61020883da8f47b";
                },
                {
                    iterations = 8192;
                    password = #hex "00ff00ff00ff";
                    salt = #hex "112233445566";
                    keyLen = 64;
                    output = "f189d6192a3592fd3c5ad3be440d15f94f4b05bc5562a66d9969e5cc5b4982ae457efc6ca24f498127fb2d6afe19cd2017fffae27e8874fcd0a1ca9004a493f9";
                },
                {
                    iterations = 4096;
                    password = #hex "1337c0de";
                    salt = #hex "badc0ffee0ddf00d";
                    keyLen = 64;
                    output = "7833e58f6687851acd3dcce33fee307f4dbcec5cec1c9f87ea710e4cfff49b5c381f4f557fdb8f07e65f1b26aaa8f8f0e4ac49e5ce1aa6d0a358fccea85963bd";
                },
                {
                    iterations = 1024;
                    password = #hex "000102030405";
                    salt = #hex "0a0b0c0d0e0f";
                    keyLen = 32;
                    output = "ae2274fb46de2acfe8d7e062e7b3d2da9b65adc8279ac1169457ec2486d23bbb";
                },
                {
                    password = #hex "00ffdeadbeefcafebabe";
                    salt = #hex "ff00bada55deadbeef";
                    iterations = 4096;
                    keyLen = 128;
                    output = "fa81cbc269d0656c1df2d3a592baa3b2cf74781b88e2419a84168f5deb60558788de54b1af59eeaa7047d2f03ce01aaa13130d933ee26889fa5dfdfa9681c8ac6977795abae0c593d23230480b241d49e93568cf4ddafa8048d21902edb54c24a50cc7c8690414afbd2278447e593c6b0a976fbe7c9a27940be7717703f3f5a4";
                },
                {
                    password = #hex "0a0b0c0d0e0f";
                    salt = #hex "f1f2f3f4f5";
                    iterations = 2048;
                    keyLen = 32;
                    output = "71b74f8b2e68c01b2e50ad500baec2ee0d59b16ccbec405100c86e1ab62a119f";
                },
            ];

            for (input in VECTORS.vals()) {
                await test("PBKDF2_SHA512 simple test | " # input.output, func(): async ()  {
                        let hex = await testActor.run(input.password, input.salt, input.iterations, input.keyLen);
                        assert(hex == input.output);
                });
            };
        });
    };
}