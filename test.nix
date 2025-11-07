#!/usr/bin/env -S nix eval -f

let
  optional = import ./default.nix;
in
{
  # Test creating optional values
  testCreate = assert optional.create 42 == optional.create 42; true;
  
  # Test empty optional
  testEmpty = assert optional.empty == optional.empty; true;
  
  # Test hasValue
  testHasValueTrue = assert optional.hasValue (optional.create 42) == true; true;
  testHasValueFalse = assert optional.hasValue optional.empty == false; true;
  
  # Test value extraction
  testValue = assert optional.value (optional.create "hello") == "hello"; true;
  
  # Test getAttr
  testGetAttrPresent = assert optional.getAttr "foo" { foo = 123; bar = 456; } == optional.create 123; true;
  testGetAttrMissing = assert optional.getAttr "baz" { foo = 123; } == optional.empty; true;
  
  # Test case (pattern matching)
  testCaseWithValue = assert optional.case "default" (x: "got: ${toString x}") (optional.create 100) == "got: 100"; true;
  testCaseWithoutValue = assert optional.case "default" (x: "got: ${toString x}") optional.empty == "default"; true;
  
  # More complex test: using optional with real data (using list-based create)
  testExample = 
    let
      data = { name = "Alice"; age = 30; };
      maybeName = if builtins.hasAttr "name" data then optional.create data.name else optional.empty;
      maybeCity = if builtins.hasAttr "city" data then optional.create data.city else optional.empty;
      nameResult = optional.case "unknown" (x: x) maybeName;
      cityResult = optional.case "unknown" (x: x) maybeCity;
    in
    assert nameResult == "Alice";
    assert cityResult == "unknown";
    {
      nameResult = nameResult;
      cityResult = cityResult;
    };
  
  # Test head function
  testHeadNonEmpty = assert optional.head [1 2 3] == optional.create 1; true;
  testHeadEmpty = assert optional.head [] == optional.empty; true;
  testHeadSingle = assert optional.head [42] == optional.create 42; true;
  
  # Test makeAttrSet function (note: it's makeAttrSet in default.nix, not makeAttr)
  testMakeAttrWithValue = assert optional.makeAttrSet "foo" (optional.create 42) == { foo = 42; }; true;
  testMakeAttrEmpty = assert optional.makeAttrSet "bar" optional.empty == {}; true;
  testMakeAttrString = assert optional.makeAttrSet "name" (optional.create "Alice") == { name = "Alice"; }; true;
  
  # Test makeAttrSet in a practical scenario: conditionally adding attributes
  testMakeAttrUsage = 
    let
      base = { name = "Bob"; };
      maybeAge = optional.create 30;
      maybeCity = optional.empty;
      result = base // (optional.makeAttrSet "age" maybeAge) // (optional.makeAttrSet "city" maybeCity);
    in
    assert result == { name = "Bob"; age = 30; };
    true;
  
  # Test map function
  testMapWithValue = assert optional.map (x: x * 2) (optional.create 5) == optional.create 10; true;
  testMapEmpty = assert optional.map (x: x * 2) optional.empty == optional.empty; true;
  testMapString = assert optional.map (x: "value: ${toString x}") (optional.create 42) == optional.create "value: 42"; true;
  testMapNested = assert optional.map (x: x + 1) (optional.map (x: x * 2) (optional.create 3)) == optional.create 7; true;
  
  # Test bind function
  testBindWithValue = 
    let
      safeDivide = a: b: if b == 0 then optional.empty else optional.create (a / b);
    in
    assert optional.bind (safeDivide 10) (optional.create 2) == optional.create 5;
    true;
  
  testBindEmpty = 
    let
      safeDivide = a: b: if b == 0 then optional.empty else optional.create (a / b);
    in
    assert optional.bind (safeDivide 10) optional.empty == optional.empty;
    true;
  
  testBindReturnsEmpty = 
    let
      safeDivide = a: b: if b == 0 then optional.empty else optional.create (a / b);
    in
    assert optional.bind (safeDivide 10) (optional.create 0) == optional.empty;
    true;
  
  testBindChaining = 
    let
      safeDivide = a: b: if b == 0 then optional.empty else optional.create (a / b);
      maybeResult = optional.bind (safeDivide 20) (optional.create 4);
      finalResult = optional.bind (safeDivide 5) maybeResult;
    in
    assert finalResult == optional.create 1;
    true;
  
  testBindComplex = 
    let
      getAttr = key: attrSet: optional.getAttr key attrSet;
      maybeName = getAttr "name" { name = "Alice"; age = 30; };
      maybeLength = optional.bind (x: optional.create (builtins.stringLength x)) maybeName;
    in
    assert maybeLength == optional.create 5;
    true;
}

