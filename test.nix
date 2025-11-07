#!/usr/bin/env -S nix-instantiate --eval --strict
# AI GENERATED TEST CASE

let
  optional = import ./optional.nix;
in
{
  # Test creating optional values
  testCreate = optional.create 42;  # Should be { Value = 42; }
  
  # Test empty optional
  testEmpty = optional.empty;  # Should be {}
  
  # Test hasValue
  testHasValueTrue = optional.hasValue { Value = 42; };  # Should be true
  testHasValueFalse = optional.hasValue {};  # Should be false
  
  # Test value extraction
  testValue = optional.value { Value = "hello"; };  # Should be "hello"
  
  # Test getAttr
  testGetAttrPresent = optional.getAttr "foo" { foo = 123; bar = 456; };  # Should be { Value = 123; }
  testGetAttrMissing = optional.getAttr "baz" { foo = 123; };  # Should be {}
  
  # Test case (pattern matching)
  testCaseWithValue = optional.case "default" (x: "got: ${toString x}") { Value = 100; };  # Should be "got: 100"
  testCaseWithoutValue = optional.case "default" (x: "got: ${toString x}") {};  # Should be "default"
  
  # More complex test: using optional with real data
  testExample = 
    let
      data = { name = "Alice"; age = 30; };
      maybeName = optional.getAttr "name" data;
      maybeCity = optional.getAttr "city" data;
    in
    {
      nameResult = optional.case "unknown" (x: x) maybeName;  # Should be "Alice"
      cityResult = optional.case "unknown" (x: x) maybeCity;  # Should be "unknown"
    };
}

