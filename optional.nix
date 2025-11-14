/**
 * Optional Values for Nix
 *
 * This module provides functions for working with optional values (similar to Maybe/Option types
 * in functional programming languages). An optional value can either contain a value or be empty,
 * allowing you to represent nullable values in a type-safe way.
 *
 * The module provides functions for:
 * - Creating optional values
 * - Checking if an optional has a value
 * - Extracting values from optionals
 * - Pattern matching on optional values
 * - Converting other types (attributes, lists) to optionals
 */
rec {
  /**
   * Check if an optional value has a value.
   *
   * @param value An optional value
   * @return true if the optional contains a value, false if it's empty
   * @throws If the value passed is not in the standard optional format
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
  
  /**
   * Extract the value from an optional.
   *
   * The optional must have a value (i.e., hasValue must return true),
   * otherwise this function will throw an error.
   *
   * @param l An optional value that contains a value
   * @return The value contained in the optional
   * @throws If the optional is empty or is in an invalid format
   */
  value = l:
    if hasValue l then
      builtins.head l
    else
      builtins.throw "Expected non-empty optional, got an empty optional";
  
  /**
   * Create an optional with a value.
   *
   * Wraps a value to represent an optional that has a value.
   * The implementation uses a list containing the single value.
   *
   * @param value The value to wrap in an optional
   * @return An optional containing the value
   */
  create = value: [value];
  
  /**
   * The empty optional value.
   *
   * Represents an optional that has no value.
   * The implementation uses an empty list.
   *
   * @return An optional without a value
   */
  empty = [];
  
  /**
   * Get an attribute from an attribute set as an optional.
   *
   * If the attribute exists in the set, returns an optional containing its value.
   * If the attribute does not exist, returns an empty optional.
   *
   * @param key The attribute name to look up
   * @param attrSet The attribute set to search in
   * @return An optional containing the attribute value if it exists, otherwise an empty optional
   */
  getAttr = key: attrSet:
    if builtins.hasAttr key attrSet then
      create (builtins.getAttr key attrSet)
    else
      empty;

  /**
   * Get the first element of a list as an optional.
   *
   * If the list is non-empty, returns an optional containing the first element.
   * If the list is empty, returns an empty optional.
   *
   * @param l The list to get the first element from
   * @return An optional containing the first element if the list is non-empty, otherwise an empty optional
   */
  head = l:
    if builtins.length l == 0 then
      empty
    else
      create (builtins.head l);
  
  /**
   * Pattern matching on optional values.
   *
   * Applies a function to the value if the optional has a value, otherwise
   * returns a default value. This is similar to pattern matching on Maybe/Option types.
   *
   * @param default The value to return if the optional is empty
   * @param f A function to apply to the value if the optional has a value
   * @param x The optional value to pattern match on
   * @return The result of applying f to the value if x has a value, otherwise default
   */
  case = default: f: x:
    if (hasValue x) then
      f (value x)
    else
      default;
}
