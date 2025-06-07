{
  description = "Terraform & Ansible flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs }: 
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
      jq
      sshpass
      libuuid
      python312Packages.pywinrm
    ];
    shellHook = ''
      shopt -s nullglob
      bash_src="$BASH_SOURCE[0]"
      script_dir="$(pwd)/bin"
      alias git="$script_dir/git_wrapper.sh"
      
      terraform init
      
      if [[ ! -d ./configuration/collections ]]; then
        ansible-galaxy install -r configuration/requirements.yml
      fi

      trap "./bin/encrypt.sh" EXIT 
      ./bin/decrypt.sh
    '';
  in
  {
    devShells."${system}".default = pkgs.mkShell
    {
      inherit name packages shellHook;
    };
  };
}

