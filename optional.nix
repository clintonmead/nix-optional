rec {
  attrName = "Value";
  
  # Check if an optional value has a value
  hasValue = builtins.hasAttr attrName;
  
  # Extract the value from an optional (only valid if hasValue is true)
  value = builtins.getAttr attrName;
  
  # Create an optional with a value
  create = value: { Value = value; };
  
  # The empty optional value
  empty = {};
  
  # Get an attribute from an attrSet as an optional
  getAttr = key: attrSet:
    if builtins.hasAttr key attrSet then
      { Value = builtins.getAttr key attrSet; }
    else
      {};
  
  # Pattern matching on optional values
  case = default: f: x:
    if (hasValue x) then
      f (value x)
    else
      default;
}
