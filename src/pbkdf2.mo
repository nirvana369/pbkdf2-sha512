/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : pbkdf2.mo
* Description       : Password-Based Key Derivation Function 2 using HMAC-SHA512
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 20/06/2025		nirvana369 		implement
******************************************************************/

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Nat8 "mo:base/Nat8";
import Nat "mo:base/Nat";
import nacl "mo:tweetnacl";
import Utils "./utils";

module {

    class Hmac() {
        public var ipad1 = Buffer.Buffer<Nat8>(0);
        public var ipad2 = Buffer.Buffer<Nat8>(0);
        var opad = Buffer.Buffer<Nat8>(0);
        var alg = "sha512";
        let blocksize = 128;
        let size = 64;

        public func init(key: [Nat8], saltLen: Nat) {
            
            var k = Buffer.fromArray<Nat8>(key);
            if (k.size() > blocksize) {
                k := Buffer.fromArray(nacl.hash(key));
            };
            
            while (k.size() < blocksize) {
                k.add(0);
            };

            var ipadTmp = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(blocksize + size, func i = 0));
            var opadTmp = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(blocksize + size, func i = 0));
            for (i in Iter.range(0, blocksize - 1)) {
                ipadTmp.put(i, k.get(i) ^ 0x36);
                opadTmp.put(i, k.get(i) ^ 0x5c);
            };


            var ipad1Tmp = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(blocksize + saltLen + 4, func i = 0));
            copy(ipadTmp, ipad1Tmp, 0, 0, blocksize);

            ipad1 := ipad1Tmp;
            ipad2 := ipadTmp;
            opad := opadTmp;
        };

        public func run(data: Buffer.Buffer<Nat8>, ipad: Buffer.Buffer<Nat8>) : [Nat8] {
            copy(data, ipad, blocksize, 0, data.size());
            var h = Buffer.fromArray<Nat8>(nacl.hash(Buffer.toArray(ipad)));
            copy(h, opad, blocksize, 0, h.size());
            return nacl.hash(Buffer.toArray<Nat8>(opad));
        };

        public func hrun(hash: ([Nat8]) -> ([Nat8]), data: Buffer.Buffer<Nat8>, ipad: Buffer.Buffer<Nat8>) : [Nat8] {
            copy(data, ipad, blocksize, 0, data.size());
            var h = Buffer.fromArray<Nat8>(hash(Buffer.toArray(ipad)));
            copy(h, opad, blocksize, 0, h.size());
            return hash(Buffer.toArray<Nat8>(opad));
        };

        public func async_run(hash: shared ([Nat8]) -> async ([Nat8]),data: Buffer.Buffer<Nat8>, ipad: Buffer.Buffer<Nat8>) : async [Nat8] {
            copy(data, ipad, blocksize, 0, data.size());
            var h = Buffer.fromArray<Nat8>(await hash(Buffer.toArray(ipad)));
            copy(h, opad, blocksize, 0, h.size());
            return await hash(Buffer.toArray<Nat8>(opad));
        };
    };

    func copy(source : Buffer.Buffer<Nat8>, dest : Buffer.Buffer<Nat8>, destPos : Nat, sourcePos : Nat, sourceEnd : Nat) {
        var end = destPos + (sourceEnd - sourcePos);
        if (end > dest.size()) {
            end := dest.size();
        };
        var iDest = destPos;
        var iSource = sourcePos;
        while (iDest < end) {
            dest.put(iDest, source.get(iSource));
            iDest += 1;
            iSource += 1;
        };
    };

    public func pbkdf2_sha512(password: [Nat8], salt: [Nat8], iterations: Nat, keylen: Nat) : [Nat8] {
        var hmac = Hmac();
        
        hmac.init(password, salt.size());

        var DK = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(keylen, func i = 0));
        var block1 = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(salt.size() + 4, func i = 0));
        copy(Buffer.fromArray(salt), block1, 0, 0, salt.size());

        var destPos = 0;
        var hashLen = 64;
        var l = Int.abs(Float.toInt(Float.ceil(Float.div(Float.fromInt(keylen), Float.fromInt(hashLen)))));
        
        for (i in Iter.range(1, l)) {
            let bytes = Buffer.fromArray<Nat8>(Utils.numberTo32BytesBE(i));
            
            copy(bytes, block1, salt.size(), bytes.size() - 4, bytes.size());

            var T = Buffer.fromArray<Nat8>(hmac.run(block1, hmac.ipad1));
            var U = T;
            
            for (j in Iter.range(1, iterations - 1)) {
                U := Buffer.fromArray<Nat8>(hmac.run(U, hmac.ipad2));

                for (k in Iter.range(0, hashLen - 1)) {
                    T.put(k, T.get(k) ^ U.get(k));
                };
            };

            copy(T, DK, destPos, 0, T.size());

            destPos += hashLen;
        };
        return Buffer.toArray(DK);
    };

    public func pbkdf2(hash: ([Nat8]) -> ([Nat8]), password: [Nat8], salt: [Nat8], iterations: Nat, keylen: Nat) : [Nat8] {
        var hmac = Hmac();
        
        hmac.init(password, salt.size());

        var DK = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(keylen, func i = 0));
        var block1 = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(salt.size() + 4, func i = 0));
        copy(Buffer.fromArray(salt), block1, 0, 0, salt.size());

        var destPos = 0;
        var hashLen = 64;
        var l = Int.abs(Float.toInt(Float.ceil(Float.div(Float.fromInt(keylen), Float.fromInt(hashLen)))));
        
        for (i in Iter.range(1, l)) {
            let bytes = Buffer.fromArray<Nat8>(Utils.numberTo32BytesBE(i));
            
            copy(bytes, block1, salt.size(), bytes.size() - 4, bytes.size());

            var T = Buffer.fromArray<Nat8>(hmac.hrun(hash, block1, hmac.ipad1));
            var U = T;
            
            for (j in Iter.range(1, iterations - 1)) {
                U := Buffer.fromArray<Nat8>(hmac.hrun(hash, U, hmac.ipad2));

                for (k in Iter.range(0, hashLen - 1)) {
                    T.put(k, T.get(k) ^ U.get(k));
                };
            };

            copy(T, DK, destPos, 0, T.size());

            destPos += hashLen;
        };
        return Buffer.toArray(DK);
    };

    public func async_pbkdf2(hash: shared ([Nat8]) -> async ([Nat8]), password: [Nat8], salt: [Nat8], iterations: Nat, keylen: Nat) : async [Nat8] {
        var hmac = Hmac();
        
        hmac.init(password, salt.size());

        var DK = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(keylen, func i = 0));
        var block1 = Buffer.fromArray<Nat8>(Array.tabulate<Nat8>(salt.size() + 4, func i = 0));
        copy(Buffer.fromArray(salt), block1, 0, 0, salt.size());

        var destPos = 0;
        var hashLen = 64;
        var l = Int.abs(Float.toInt(Float.ceil(Float.div(Float.fromInt(keylen), Float.fromInt(hashLen)))));
        
        for (i in Iter.range(1, l)) {
            let bytes = Buffer.fromArray<Nat8>(Utils.numberTo32BytesBE(i));
            
            copy(bytes, block1, salt.size(), bytes.size() - 4, bytes.size());

            var T = Buffer.fromArray<Nat8>(await hmac.async_run(hash, block1, hmac.ipad1));
            var U = T;
            
            for (j in Iter.range(1, iterations - 1)) {
                U := Buffer.fromArray<Nat8>(await hmac.async_run(hash, U, hmac.ipad2));

                for (k in Iter.range(0, hashLen - 1)) T.put(k, T.get(k) ^ U.get(k));
            };

            copy(T, DK, destPos, 0, T.size());

            destPos += hashLen;
        };
        return Buffer.toArray(DK);
    };
}