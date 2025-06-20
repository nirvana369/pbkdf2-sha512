/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : pbkdf2.bench.mo
* Description       : Benchmark pbkdf2.
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 20/06/2025		nirvana369 		Add benchmarks.
******************************************************************/

import Bench "mo:bench";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Nat32 "mo:base/Nat32";
import Utils "../src/utils";
import {pbkdf2_sha512; async_pbkdf2; pbkdf2} "../src/lib";
import Sha512 "../test/sha512";
import Cycles "mo:base/ExperimentalCycles";

module {

    public func init() : Bench.Bench {

        // Cycles.add(4_000_000_000_000);
        // let sha512 = await Sha512.Sha512();
        let test = {
                    password = #text "passwordPASSWORDpassword";
                    salt = #text "saltSALTsaltSALTsaltSALTsaltSALTsalt";
                    iterations = 4096;
                    keyLen = 64;
                };
        let bench = Bench.Bench();

        bench.name("Benchmark");
        bench.description("module benchmark");

        bench.rows(["pbkdf2",
                    ]);
        bench.cols(["1", "10", "100", "500", "1000"]);

        bench.runner(func(row, col) {
            let ?n = Nat.fromText(col);

            switch (row) {
                // Engine V1
                case ("old") {
                    for (i in Iter.range(1, n)) {
                        ignore pbkdf2_sha512(test.password, test.salt, test.iterations, test.keyLen);
                    };
                };
                case _ {};
            };
        });

        bench;
  };
};