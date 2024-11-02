let
  hosts = {
    desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHdTbIP/5oz7zd6SUKU8k+q62FZRQy9YVWNaDcaD/y9";
    notebook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEvlbc4gUtPyB80wDz4WBuQb7sNAaVHrxHP9koLc3Y1";
  };
  identities = {
    matthias-yubikey = "age1yubikey1q2p57cqnfe3jah577pp6s3w3759wuvgxsssd8t5fsnqp4z550ryhq0rcv26";
  };
  allHosts = builtins.attrValues hosts;
  allIdentities = builtins.attrValues identities;
in
{
  "hashedPassword.age".publicKeys = [ hosts.notebook ] ++ allIdentities;
}
