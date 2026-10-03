{
  # Port 8080 is already in use on this host.
  nixdefs.endpoints.strata.port = 8081;

  services.strata = {
    family = "qwen";
    model = "IQ2_XS";
    context = 64 * 1024;
    kv = "int8";
    draftVocab = "cjk";
    gpu = 0;
  };
}
