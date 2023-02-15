from starkware.cairo.common.uint256 import ( Uint256, uint256_add )

// Modify both functions so that they increment
// supplied value and return it
func add_one(y: felt) -> (val: felt) {
    let z = y + 1;
    return (val=z);
}

func add_one_U256{range_check_ptr}(y: Uint256) -> (val: Uint256) {
    let x = Uint256(low=1,high=0);
    let z = uint256_add(y, x);
    return (val=z.res);
}
