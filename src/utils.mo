/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : utils.mo
* Description       : Utilities
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 20/06/2025		nirvana369 		implement
******************************************************************/

import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Option "mo:base/Option";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";

module Utils {

    func hexCharMap() : HashMap.HashMap<Nat, Nat8> {
        let map = HashMap.HashMap<Nat, Nat8>(16, Nat.equal, Hash.hash);
        for (n in Iter.range(48, 57)) { map.put(n, Nat8.fromNat(n - 48)); };
        for (n in Iter.range(97, 102)) { map.put(n, Nat8.fromNat(n - 87)); };
        for (n in Iter.range(65, 70)) { map.put(n, Nat8.fromNat(n - 55)); };
        map
    };

    func hexes() : [Text] {
        let symbols = Iter.toArray("0123456789abcdef".chars());
        Array.tabulate<Text>(256, func i : Text {
            let u8 = Nat8.fromNat(i);
            let high = Nat8.toNat(u8 / 16);
            let low = Nat8.toNat(u8 % 16);
            Char.toText(symbols[high]) # Char.toText(symbols[low])
        })
    };

    public func int2Hex(x: Int): Text {
        if (x == 0) return "0";
        var result = Buffer.Buffer<Char>(0);
        var n = x;
        let chars = Iter.toArray("0123456789abcdef".chars());
        while (n > 0) {
            result.add(chars[Int.abs(n) % 16]);
            n /= 16;
        };
        Buffer.reverse(result);
        return Text.fromIter(result.vals());
    };

    public func bytesToHex(uint8a: [Nat8]): Text {
        let hex = hexes();
        Array.foldLeft<Nat8, Text>(uint8a, "", func(acc, b) = acc # hex[Nat8.toNat(b)]);
    };

    public func hexToBytes(hex: Text): [Nat8] {
        let hexMap = hexCharMap();
        let chars = Iter.toArray(Text.toIter(hex));
        assert (chars.size() % 2 == 0);
        Array.tabulate<Nat8>(chars.size() / 2, func(i) {
            let hi = Option.get<Nat8>(hexMap.get(Nat32.toNat(Char.toNat32(chars[i*2]))), 0);
            let lo = Option.get<Nat8>(hexMap.get(Nat32.toNat(Char.toNat32(chars[i*2 + 1]))), 0);
            16 * hi + lo
        });
    };

    public func hexCharToInt(c: Char): Int {
        let code = Nat32.toNat(Char.toNat32(c));
        if (code >= 48 and code <= 57) {
            code - 48;
        } else if (code >= 97 and code <= 102) {
            code - 87;
        } else if (code >= 65 and code <= 70) {
            code - 55;
        } else {
            0;
        }
    };

    public func hex2Int(hex: Text): Int {
        var result: Int = 0;
        for (c in hex.chars()) {
            result := result * 16 + hexCharToInt(c);
        };
        result
    };

    public func numberTo32BytesBE(num: Int): [Nat8] {
        let hex = int2Hex(num);
        let padSize = if (hex.size() < 64) 64 - hex.size() else 0;
        let padded = Text.join("", (Array.tabulate<Text>(padSize, func _ = "0")).vals()) # hex;
        hexToBytes(padded);
    };

    public func numberTo32BytesLE(num: Int): [Nat8] {
        Array.reverse(numberTo32BytesBE(num));
    };

    public func bytesToNumberLE(uint8a: [Nat8]): Int {
        hex2Int(bytesToHex(Array.reverse(uint8a)));
    };
};
