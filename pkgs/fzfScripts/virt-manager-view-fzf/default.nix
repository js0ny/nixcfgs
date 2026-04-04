{pkgs, ...}:
pkgs.writeShellApplication {
  name = "virt-manager-view-fzf";

  runtimeInputs = with pkgs; [
    libvirt
    virt-manager
    fzf
    gnused
  ];

  text = ''
    VM=$(virsh --connect qemu:///system list --name --state-running | sed '/^$/d' | fzf --height=20% --border --prompt="Select VM > ")

    if [ -n "$VM" ]; then
        echo "Opening console for $VM..."
        virt-manager --connect qemu:///system --show-domain-console "$VM" >/dev/null 2>&1 &
    else
        echo "No VM selected."
    fi
  '';
}
