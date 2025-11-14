#!/usr/bin/env -S nix-instantiate --eval --strict
# AI GENERATED TEST CASE

let
  optional = import ./optional.nix;
in
{
  # Test creating optional values
  testCreate = optional.create 42;  # Should be [42]
  
  # Test empty optional
  testEmpty = optional.empty;  # Should be []
  
  # Test hasValue
  testHasValueTrue = optional.hasValue (optional.create 42);  # Should be true
  testHasValueFalse = optional.hasValue optional.empty;  # Should be false
  
  # Test value extraction
  testValue = optional.value (optional.create "hello");  # Should be "hello"
  
  # Test getAttr (returns attrset, not compatible with list-based optional functions)
  testGetAttrPresent = optional.getAttr "foo" { foo = 123; bar = 456; };  # Should be { Value = 123; }
  testGetAttrMissing = optional.getAttr "baz" { foo = 123; };  # Should be {}
  
  # Test case (pattern matching)
  testCaseWithValue = optional.case "default" (x: "got: ${toString x}") ( optional.create 100 );  # Should be "got: 100"
  testCaseWithoutValue = optional.case "default" (x: "got: ${toString x}") optional.empty;  # Should be "default"
  
  # More complex test: using optional with real data (using list-based create)
  testExample = 
    let
      data = { name = "Alice"; age = 30; };
      maybeName = if builtins.hasAttr "name" data then optional.create data.name else optional.empty;
      maybeCity = if builtins.hasAttr "city" data then optional.create data.city else optional.empty;
    in
    {
      nameResult = optional.case "unknown" (x: x) maybeName;  # Should be "Alice"
      cityResult = optional.case "unknown" (x: x) maybeCity;  # Should be "unknown"
    };
  
  # Test head function
  testHeadNonEmpty = optional.head [1 2 3];  # Should be [1]
  testHeadEmpty = optional.head [];  # Should be []
  testHeadSingle = optional.head [42];  # Should be [42]
}

