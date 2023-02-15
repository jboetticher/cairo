from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

// Implement a function that sums even numbers from the provided array
func sum_even{bitwise_ptr: BitwiseBuiltin*}(arr_len: felt, arr: felt*, run: felt, idx: felt) -> (
    sum: felt
) {
    if (idx == arr_len) {
        return (sum=run);
    }

    let v = arr[idx];
    let (is_odd) = bitwise_and(v, 0x1);
    if (is_odd == 0x1) {
        let (sum) = sum_even(arr_len, arr, run, idx + 1);
        return (sum=sum);
    }

    let (sum) = sum_even(arr_len, arr, run, idx + 1);
    return (sum=sum+v);
}
