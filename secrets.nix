let
  marwe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHv3NWrxHIj3GPLU/DaOR7KFFEAEmqGOMmHJtmwAmZOX";
  # users = [ user1 ];

  # system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  # system2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzxQgondgEYcLpcPdJLrTdNgZ2gznOHCAxMdaceTUT1";
  # systems = [ system1 system2 ];
in
{
  "ssh_config.age".publicKeys = [ marwe ];
  # "secret2.age".publicKeys = users ++ systems;
}
