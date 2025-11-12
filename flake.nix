{
  description = "Terraform & Ansible flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    bsecret.url = "github:xsj3n/bsecret";
  };
  outputs = { self, nixpkgs, bsecret }: 
  let
    name = "IaC Shell";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    packages = with pkgs; [
      terraform
      terraform-ls
      ansible
      packer
      sops
      jq
      sshpass
      libuuid
      python312Packages.pywinrm
      gh
    ] ++ [ bsecret.packages.${system}.default ] ;
    shellHook = ''
      #terraform init
      #if [[ ! -d ./configuration/collections ]]; then
       # ansible-galaxy collection install -r ./configuration/requirements.yml -p ./configuration/collections
      #fi
    '';
  in
  {
    devShells."${system}".default = pkgs.mkShell
    {
      inherit name packages shellHook;
    };
  };
}

