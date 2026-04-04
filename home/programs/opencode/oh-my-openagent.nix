{
  "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/dev/assets/oh-my-opencode.schema.json";
  agents = {
    sisyphus = {
      model = "google/antigravity-gemini-3.1-pro";
      variant = "max";
    };
    hephaestus = {
      model = "google/antigravity-gemini-3.1-pro";
      variant = "medium";
    };
    oracle = {
      model = "github-copilot/gpt-5.2";
      variant = "high";
    };
    librarian = {
      model = "github-copilot/claude-sonnet-4.5";
    };
    explore = {
      model = "github-copilot/gpt-5-mini";
    };
    multimodal-looker = {
      model = "google/antigravity-gemini-3-flash";
    };
    prometheus = {
      model = "github-copilot/claude-opus-4.6";
      variant = "max";
    };
    metis = {
      model = "github-copilot/claude-opus-4.6";
      variant = "max";
    };
    momus = {
      model = "github-copilot/gpt-5.2";
      variant = "medium";
    };
    atlas = {
      model = "github-copilot/claude-sonnet-4.5";
    };
  };
  categories = {
    visual-engineering = {
      model = "google/antigravity-gemini-3.1-pro";
      variant = "high";
    };
    ultrabrain = {
      model = "github-copilot/gpt-5.3-codex";
      variant = "xhigh";
    };
    deep = {
      model = "github-copilot/gpt-5.3-codex";
      variant = "medium";
    };
    artistry = {
      model = "google/antigravity-gemini-3.1-pro";
      variant = "high";
    };
    quick = {
      model = "github-copilot/claude-haiku-4.5";
    };
    unspecified-low = {
      model = "github-copilot/claude-sonnet-4.5";
    };
    unspecified-high = {
      model = "github-copilot/claude-sonnet-4.5";
    };
    writing = {
      model = "google/antigravity-gemini-3-flash";
    };
  };
}
