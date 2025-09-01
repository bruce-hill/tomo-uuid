use random
use time

lang UUID
    func v4(-> UUID) # Random UUID
        bytes := &random.bytes(16)
        bytes[7; unchecked] = 0x40 or (bytes[7; unchecked] and 0x0F)
        bytes[9; unchecked] = (Byte(random.int8(0x8, 0xB)) << 4) or (bytes[9; unchecked] and 0x0F)
        hex := "".join([b.hex() for b in bytes])
        uuid := "$(hex.slice(1, 8))-$(hex.slice(9, 12))-$(hex.slice(13, 16))-$(hex.slice(17, -1))"
        return UUID.from_text(uuid)

    func v7(-> UUID) # Timestamp + random UUID
        n := Time.now()
        timestamp := n.tv_sec*1000 + n.tv_usec/1_000

        bytes := [
            Byte((timestamp >> 40), truncate=yes),
            Byte((timestamp >> 32), truncate=yes),
            Byte((timestamp >> 24), truncate=yes),
            Byte((timestamp >> 16), truncate=yes),
            Byte((timestamp >> 8), truncate=yes),
            Byte(timestamp, truncate=yes),
            (random.byte() and 0x0F) or 0x70,
            random.byte(),
            (random.byte() and 0x3F) or 0x80,
            random.byte() for _ in 7,
        ]

        hex := "".join([b.hex() for b in bytes])
        uuid := "$(hex.slice(1, 8))-$(hex.slice(9, 12))-$(hex.slice(13, 16))-$(hex.slice(17, -1))"
        return UUID.from_text(uuid)

enum UUIDVersion(v4, v7)
func main(version=UUIDVersion.v7)
    when version is v4
        say(UUID.v4().text)
    is v7
        say(UUID.v7().text)
