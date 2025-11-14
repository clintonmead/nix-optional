rec {
  # Check if an optional value has a value
  hasValue = value:
    if ! builtins.isList value then
      builtins.throw "Expected a list, got ${builtins.typeOf value}"
    else if builtins.length value == 1 then
      true
    else if builtins.length value == 0 then
      false
    else
      builtins.throw "Expected a list with 0 or 1 elements, got ${toString (builtins.length value)}";
  
  # Extract the value from an optional (only valid if hasValue is true)
  value = l:
    if hasValue l then
      builtins.head l
    else
      builtins.throw "Expected non-empty optional, got an empty optional";
  
  # Create an optional with a value
  create = value: [value];
  
  # The empty optional value
  empty = [];
  
  # Get an attribute from an attrSet as an optional
  getAttr = key: attrSet:
    if builtins.hasAttr key attrSet then
      create (builtins.getAttr key attrSet)
    else
      empty;

  head = l:
    if builtins.length l == 0 then
      empty
    else
      create (builtins.head l);
  
  # Pattern matching on optional values
  case = default: f: x:
    if (hasValue x) then
      f (value x)
    else
      default;
}
