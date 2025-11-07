{
  description = "Optional values library for Nix";

  outputs = { self }: {
    lib = {
      optional = import ./optional.nix;
    };
  };
}

