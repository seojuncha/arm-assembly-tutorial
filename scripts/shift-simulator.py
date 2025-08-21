def logical_shift_right(val, n, bits=32):
    mask = (1 << bits) - 1
    return (val & mask) >> n

def arithmetic_shift_right(val, n, bits=32):
    if val & (1 << (bits - 1)):   # Negative
        return ((val >> n) | ((1 << n) - 1) << (bits - n)) & ((1 << bits) - 1)
    else:   # Positive
        return val >> n

def ror(val, n, bits=32):
    n %= bits
    return ((val >> n) | (val << (bits - n))) & ((1 << bits) - 1)

def rrx(val, carry_in, bits=32):
    lsb = val & 1
    result = (carry_in << (bits - 1)) | (val >> 1)
    carry_out = lsb
    return result, carry_out

nums = [26, -32]
for x in nums:
    print(f"\n=== {x} (0x{x & 0xffffffff:08X}) ===")
    lsr = logical_shift_right(x, 1)
    asr = arithmetic_shift_right(x, 1)
    print(f"LSR 1: {lsr} [{hex(lsr)}]")
    print(f"ASR 1: {asr} [{hex(asr)}]")

x = 0x68  # 0b01101000
rot = 4
print(f"\nROR #{rot}:", hex(ror(x, rot)))

res, cout = rrx(x, 1)
print(f"RRX (carry=1): result={hex(res)}, carry_out={cout}")