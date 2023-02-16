%lang starknet
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin // don't know what this is used for
from starkware.cairo.common.math import unsigned_div_rem 

// Using binary operations return:
// - 1 when pattern of bits is 01010101 from LSB up to MSB 1, but accounts for trailing zeros
// - 0 otherwise

// 000000101010101 PASS
// 010101010101011 FAIL

func pattern{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(
    n: felt, idx: felt, exp: felt, broken_chain: felt
) -> (true: felt) {
    alloc_locals;

    // exp = next expected 
    // broken_chain = the chain to use next

    // If idx is greater than Cairo's 251-bit limit then it's time to stop
    if (idx == 252) {
        return(true=1);
    }

    // When doing bitwise operaions we go from RIGHT to LEFT

    // First bit is the basis
    if(idx == 0) {
        // Figure out if first bit is a 1 or a 0
        let (next_exp) = bitwise_xor(0x1, n);
        let (true) = pattern(n, idx + 1, next_exp, 0);
        return (true=true);
    }

    // Divide by 2 to shift bit down
    let div_result = unsigned_div_rem(n, 2);
    local quotient = div_result.q;
    local remainder = div_result.r;

    %{
    print(ids.quotient)
    %}

    // If the chain is broken... 
    if (broken_chain == 1) {
        // ...and it's not a 0 we're looking at then it's not a nice number
        if (remainder == 1) {
            return(true=0);
        }
        // ...but if everything is 0, then that means it's padded correctly!
        if (quotient == 0) {
            return(true=1);
        }
    }

    // Check to see if the expected value is the one that was given
    if (exp == remainder) {
        let (next_exp) = bitwise_xor(0x1, exp);
        let (true) = pattern(quotient, idx + 1, next_exp, 0);
        return(true=true);
    }

    // Uh oh! We didn't get the one we expected
    // If we got two 1s in a row, it's game over
    if (remainder == 1) {
        return(true=0);
    }

    // If we got two 0s in a row, it might not be over because of padding, but the chain IS broken
    let (true) = pattern(quotient, idx + 1, 0, 1);
    return(true=true);
}
