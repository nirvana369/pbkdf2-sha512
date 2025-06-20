[![mops](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/mops/pbkdf2-sha512)](https://mops.one/pbkdf2-sha512) [![documentation](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/documentation/pbkdf2-sha512)](https://mops.one/pbkdf2-sha512/docs)
# pbkdf2-sha512

A pure Motoko implementation of the PBKDF2 (Password-Based Key Derivation Function 2) using HMAC-SHA512.  

---

## ✨ Features

- Pure Motoko implementation of PBKDF2-HMAC-SHA512
- Uses `nacl.hash` ([TweetNaCl](https://github.com/nirvana369/tweetnacl)) by default
- Supports custom synchronous and asynchronous hash functions

---

## 📦 Installation

Install with mops

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops add pbkdf2-sha512
```

---

## 🔐 Example Usage

### Default using `nacl.hash`:

```motoko
import PBKDF2 "mo:pbkdf2-sha512";

let input = {
                password = #text "passwordPASSWORDpassword";
                salt = #text "saltSALTsaltSALTsaltSALTsaltSALTsalt";
                iterations = 4096;
                keyLen = 64;
            };
            
let derivedKey = PBKDF2.pbkdf2_sha512(input.password, input.salt, input.iterations, input.keyLen);
```

### Using a custom sync hash function:

```motoko
import PBKDF2 "mo:pbkdf2-sha512";

func myHashFunc(bytes : [Nat8]) : ([Nat8]) {
    // call your hash function
    let h : [Nat8] = sha512(bytes);
    return h;
};
let input = {
                password = #text "nirvana369";
                salt = #hex "badc0ffee0ddf00d";
                iterations = 4096;
                keyLen = 64;
            };

let derivedKey = PBKDF2.pbkdf2(myHashFunc, input.password, input.salt, input.iterations, input.keyLen);
```
- Uses a user-supplied synchronous SHA-512 hash function.
### Using a custom async hash function:

```motoko
import PBKDF2 "mo:pbkdf2-sha512";

func myAsyncHashFunc(bytes : [Nat8]) : async ([Nat8]) {
    // call your async hash function
    let h : [Nat8] = await sha512(bytes);
    return h;
};
let input = {
                password = #bytes ([111, 222, 3, 6, 9]);
                salt = #blob (Blob.fromArray([110, 105, 114, 118, 97, 110, 97, 51, 54, 57]));
                iterations = 4096;
                keyLen = 64;
            };

let derivedKey = await PBKDF2.async_pbkdf2(myAsyncHashFunc, input.password, input.salt, input.iterations, input.keyLen);
```
- Uses a user-supplied asynchronous SHA-512 hash function (e.g., for inter-canister use).

---
### Testing

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops test
```
---
### Benchmarks

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops bench
```

[Module benchmarks](https://mops.one/pbkdf2-sha512/benchmarks)

---
## 📜 License

[MIT License](https://github.com/nirvana369/pbkdf2-sha512/blob/main/LICENSE)
