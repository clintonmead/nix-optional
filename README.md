# Optional Values for Nix

This module provides functions for working with optional values (similar to Maybe/Option types).

An optional value is represented as:
- `{}` - Empty (no value)
- `{ Value = blah }` - Has the value `blah`

## Usage

```nix
let
  optional = import ./optional.nix;
in
  # Create an optional with a value
  optional.create 42  # { Value = 42; }
  
  # Check if an optional has a value
  optional.hasValue { Value = 42; }  # true
  optional.hasValue {}  # false
  
  # Extract the value
  optional.value { Value = "hello" }  # "hello"
  
  # Pattern matching
  optional.case "default" (x: "got: ${toString x}") { Value = 100 }  # "got: 100"
  optional.case "default" (x: "got: ${toString x}") {}  # "default"
  
  # Get an attribute as an optional
  optional.getAttr "name" { name = "Alice"; age = 30; }  # { Value = "Alice"; }
  optional.getAttr "city" { name = "Alice"; }  # {}
```


