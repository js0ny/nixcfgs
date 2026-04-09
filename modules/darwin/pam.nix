{...}: {
  security.pam.services.sudo_local = {
    watchIdAuth = true;
    touchIdAuth = true;
  };
}
