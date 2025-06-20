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
import Iter "mo:base/Iter";
import {pbkdf2_sha512} "../src/lib";

module {

    public func init() : Bench.Bench {

        let test = {
                    password = #text "passwordPASSWORDpassword";
                    salt = #text "saltSALTsaltSALTsaltSALTsaltSALTsalt";
                    iterations = 4096;
                    keyLen = 64;
                };
        let bench = Bench.Bench();

        bench.name("PBKDF2-SHA512 Benchmark");
        bench.description("PBKDF2 module benchmark");

        bench.rows(["pbkdf2_sha512",
                    ]);
        bench.cols(["1", "10", "100", "500", "1000"]);

        bench.runner(func(row, col) {
            let ?n = Nat.fromText(col);

            switch (row) {
                // Engine V1
                case ("pbkdf2_sha512") {
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