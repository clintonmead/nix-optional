/* Optional Values for Nix

This module provides functions for working with optional values (similar to Maybe/Option types
in functional programming languages). An optional value can either contain a value or be empty,
allowing you to represent nullable values in a type-safe way.

The module provides functions for:
- Creating optional values
- Checking if an optional has a value
- Extracting values from optionals
- Pattern matching on optional values
- Converting other types (attributes, lists) to optionals
*/
rec {
  /* Check if an optional value has a value.

  **Parameters:**
  - `value` - An optional value

  **Returns:** `true` if the optional contains a value, `false` if it's empty

  **Throws:** If the value passed is not in the standard optional format
  */
  hasValue = value:
    if ! builtins.isList value then
      builtins.throw "Expected a list, got ${builtins.typeOf value}"
    else if builtins.length value == 1 then
      true
    else if builtins.length value == 0 then
      false
    else
      builtins.throw "Expected a list with 0 or 1 elements, got ${toString (builtins.length value)}";
  
  /* Extract the value from an optional.

  The optional must have a value (i.e., hasValue must return true),
  otherwise this function will throw an error.

  **Parameters:**
  - `l` - An optional value that contains a value

  **Returns:** The value contained in the optional

  **Throws:** If the optional is empty or is in an invalid format
  */
  value = l:
    if hasValue l then
      builtins.head l
    else
      builtins.throw "Expected non-empty optional, got an empty optional";
  
  /* Create an optional with a value.

  Wraps a value to represent an optional that has a value.
  The implementation uses a list containing the single value.

  **Parameters:**
  - `value` - The value to wrap in an optional

  **Returns:** An optional containing the value
  */
  create = value: [value];
  
  /* The empty optional value.

  Represents an optional that has no value.
  The implementation uses an empty list.

  **Returns:** An optional without a value
  */
  empty = [];

  /* Get an attribute from an attribute set as an optional.

  If the attribute exists in the set, returns an optional containing its value.
  If the attribute does not exist, returns an empty optional.

  **Parameters:**
  - `key` - The attribute name to look up
  - `attrSet` - The attribute set to search in

  **Returns:** An optional containing the attribute value if it exists, otherwise an empty optional
  */
  getAttr = key: attrSet:
    if builtins.hasAttr key attrSet then
      create (builtins.getAttr key attrSet)
    else
      empty;

  /* Get the first element of a list as an optional.

  If the list is non-empty, returns an optional containing the first element.
  If the list is empty, returns an empty optional.

  **Parameters:**
  - `l` - The list to get the first element from

  **Returns:** An optional containing the first element if the list is non-empty, otherwise an empty optional
  */
  head = l:
    if builtins.length l == 0 then
      empty
    else
      create (builtins.head l);
  
  /* Pattern matching on optional values.

  Applies a function to the value if the optional has a value, otherwise
  returns a default value. This is similar to pattern matching on Maybe/Option types.

  **Parameters:**
  - `default` - The value to return if the optional is empty
  - `f` - A function to apply to the value if the optional has a value
  - `x` - The optional value to pattern match on

  **Returns:** The result of applying `f` to the value if `x` has a value, otherwise `default`
  */
  case = default: f: x:
    if (hasValue x) then
      f (value x)
    else
      default;

  /* Monadic bind operation for optional values.

  Applies a function that returns an optional to the value contained in an optional.
  If the optional is empty, returns an empty optional. This allows chaining operations
  that may fail (return empty optionals).

  **Parameters:**
  - `f` - A function that takes a value and returns an optional value
  - `x` - An optional value to bind over

  **Returns:** The result of applying `f` to the value in `x` if `x` has a value, otherwise an empty optional

  **Example:**
  ```nix
  let
    divide = a: b: if b == 0 then optional.empty else optional.create (a / b);
    maybeResult = optional.bind (divide 10) (optional.create 2);
  in
  maybeResult  # Returns [5]
  ```
  */
  bind = f: case empty (x: f x);

  /* Functor map operation for optional values.

  Applies a function to the value contained in an optional, if it exists.
  If the optional is empty, returns an empty optional. This allows transforming
  the value inside an optional without unwrapping it.

  **Parameters:**
  - `f` - A function to apply to the value if the optional has a value
  - `x` - An optional value to map over

  **Returns:** An optional containing the result of applying `f` to the value in `x` if `x` has a value, otherwise an empty optional

  **Example:**
  ```nix
  let
    maybeNumber = optional.create 5;
    maybeString = optional.map (x: toString x) maybeNumber;
  in
  maybeString  # Returns ["5"]
  ```
  */
  map = f: bind (x: create (f x));

  /* Create an attribute set from an optional value.
  
  If the optional has a value, returns an attribute set with a single key-value pair.
  If the optional is empty, returns an empty attribute set.
  
  This is useful for conditionally adding attributes to attribute sets, for example:
  
  ```nix
  {
    name = "Alice";
  } // (makeAttrSet "age" maybeAge)
  ```
  
  **Parameters:**
  - `key` - The attribute name to use if the optional has a value
  - `optional` - An optional value
  
  **Returns:** An attribute set with `{ key = value }` if the optional has a value, otherwise `{}`
  */
  makeAttrSet = key: case {} (value: { ${key} = value; });
}
