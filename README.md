# Optional Values for Nix

This module provides functions for working with optional values (similar to Maybe/Option types in functional programming languages). An optional value can either contain a value or be empty, allowing you to represent nullable values in a type-safe way. The module provides functions for:

- Creating optional values
- Checking if an optional has a value
- Extracting values from optionals
- Pattern matching on optional values
- Converting other types (attributes, lists) to optionals

## Usage

```nix
let
  optional = import ./optional.nix;
in
  # Create an optional with a value
  optional.create 42
  
  # Check if an optional has a value
  optional.hasValue (optional.create 42)  # true
  optional.hasValue optional.empty  # false
  
  # Extract the value
  optional.value (optional.create "hello")  # "hello"
  
  # Pattern matching
  optional.case "default" (x: "got: ${toString x}") (optional.create 100)  # "got: 100"
  optional.case "default" (x: "got: ${toString x}") optional.empty  # "default"
  
  # Get an attribute as an optional
  optional.getAttr "name" { name = "Alice"; age = 30; }
  optional.getAttr "city" { name = "Alice"; }
```


## API Reference

### `hasValue`

Check if an optional value has a value.

**Parameters:**

- `value`: An optional value

**Returns:** true if the optional contains a value, false if it's empty

**Throws:** If the value passed is not in the standard optional format


### `value`

Extract the value from an optional. The optional must have a value (i.e., hasValue must return true), otherwise this function will throw an error.

**Parameters:**

- `l`: An optional value that contains a value

**Returns:** The value contained in the optional

**Throws:** If the optional is empty or is in an invalid format


### `create`

Create an optional with a value. Wraps a value to represent an optional that has a value. The implementation uses a list containing the single value.

**Parameters:**

- `value`: The value to wrap in an optional

**Returns:** An optional containing the value


### `empty`

The empty optional value. Represents an optional that has no value. The implementation uses an empty list.

**Returns:** An optional without a value


### `getAttr`

Get an attribute from an attribute set as an optional. If the attribute exists in the set, returns an optional containing its value. If the attribute does not exist, returns an empty optional.

**Parameters:**

- `key`: The attribute name to look up
- `attrSet`: The attribute set to search in

**Returns:** An optional containing the attribute value if it exists, otherwise an empty optional


### `head`

Get the first element of a list as an optional. If the list is non-empty, returns an optional containing the first element. If the list is empty, returns an empty optional.

**Parameters:**

- `l`: The list to get the first element from

**Returns:** An optional containing the first element if the list is non-empty, otherwise an empty optional


### `case`

Pattern matching on optional values. Applies a function to the value if the optional has a value, otherwise returns a default value. This is similar to pattern matching on Maybe/Option types.

**Parameters:**

- `default`: The value to return if the optional is empty
- `f`: A function to apply to the value if the optional has a value
- `x`: The optional value to pattern match on

**Returns:** The result of applying f to the value if x has a value, otherwise default

