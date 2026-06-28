{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.bullets-vim ];

    globals.bullets_enabled_file_types = [
      "markdown"
      "typst"
      "gitcommit"
    ];

    plugins = {
      snacks.settings.image = {
        img_dirs = [ "00_Meta/Assets" ];
      };
      obsidian = {
        enable = true;
        settings = {
          legacy_commands = false;
          footer.enabled = false;
          workspaces = [
            {
              name = "personal";
              path = "~/Obsidian";
            }
          ];
          completion = {
            nvim_cmp = false;
            blink = true;
            min_chars = 2;
          };
          ui.enable = false;
          daily_notes = {
            folder = "40_Journal";
            date_format = "%Y-%m-%d";
          };
          attachments = {
            folder = "00_Meta/Assets";
          };
          new_notes_location = "current_dir";
        };

        extraConfigLua = ''
          local function uuid()
            local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
            return string.gsub(template, '[xy]', function(c)
              local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
              return string.format('%x', v)
            end)
          end

          require('obsidian').setup({
            frontmatter = {
              func = function(note)
                local meta = note.metadata or {}
                local note_id = meta.uuid
                if note_id == nil then
                  note_id = uuid()
                end
                local aliases = meta.aliases or note.aliases or {}
                if type(aliases) ~= 'table' then
                  aliases = { aliases }
                end
                if note.title and note.id and note.title ~= note.id then
                  local is_duplicate = false
                  for _, v in pairs(aliases) do
                    if v == note.id then
                      is_duplicate = true
                      break
                    end
                  end
                  if not is_duplicate then
                    table.insert(aliases, note.id)
                  end
                end
                local out = {
                  uuid = note_id,
                  aliases = aliases,
                  tags = meta.tags or note.tags,
                  title = meta.title or note.id,
                }
                out = vim.tbl_extend('force', out, meta)
                out.modified = os.date('%Y-%m-%dT%H:%M:%S')
                if out.created == nil then
                  out.created = os.date('%Y-%m-%dT%H:%M:%S')
                end
                return out
              end,
            },
            attachments = {
              img_name_func = function()
                return string.format('%s-', os.time())
              end,
            },
            mappings = {
              ['<cr>'] = {
                action = function()
                  require('obsidian').util.smart_action()
                end,
                opts = { buffer = true, expr = true },
              },
            },
          })
        '';
      };

      render-markdown = {
        enable = true;
        settings = {
          file_types = [
            "markdown"
            "Avante"
          ];
          render_modes = [
            "n"
            "c"
            "t"
          ];
          latex = {
            enabled = false;
            converter = "latex2text";
            highlight = "RenderMarkdownMath";
            top_pad = 0;
            bottom_pad = 0;
          };
          link.custom = {
            python = {
              pattern = "%.py";
              icon = " ";
            };
            lua = {
              pattern = "%.lua";
              icon = " ";
            };
            markdown = {
              pattern = "%.md";
              icon = " ";
            };
          };
          bullet.icons = [
            "󰮯 "
            "●"
            "○"
            "◆"
            "◇"
          ];
          checkbox = {
            checked.scope_highlight = "@markup.strikethrough";
            unchecked.scope_highlight = "@comment.todo";
          };
          code = {
            position = "right";
            width = "block";
            right_pad = 10;
            disable = true;
          };
          callout = {
            note = {
              raw = "[!NOTE]";
              rendered = "󰋽 Note";
              highlight = "RenderMarkdownInfo";
            };
            tip = {
              raw = "[!TIP]";
              rendered = "󰌶 Tip";
              highlight = "RenderMarkdownSuccess";
            };
            important = {
              raw = "[!IMPORTANT]";
              rendered = "󰅾 Important";
              highlight = "RenderMarkdownHint";
            };
            warning = {
              raw = "[!WARNING]";
              rendered = "󰀪 Warning";
              highlight = "RenderMarkdownWarn";
            };
            caution = {
              raw = "[!CAUTION]";
              rendered = "󰳦 Caution";
              highlight = "RenderMarkdownError";
            };
            abstract = {
              raw = "[!ABSTRACT]";
              rendered = "󰨸 Abstract";
              highlight = "RenderMarkdownInfo";
            };
            summary = {
              raw = "[!SUMMARY]";
              rendered = "󰨸 Summary";
              highlight = "RenderMarkdownInfo";
            };
            tldr = {
              raw = "[!TLDR]";
              rendered = "󰨸 Tldr";
              highlight = "RenderMarkdownInfo";
            };
            info = {
              raw = "[!INFO]";
              rendered = "󰋽 Info";
              highlight = "RenderMarkdownInfo";
            };
            todo = {
              raw = "[!TODO]";
              rendered = "󰗡 Todo";
              highlight = "RenderMarkdownInfo";
            };
            hint = {
              raw = "[!HINT]";
              rendered = "󰌶 Hint";
              highlight = "RenderMarkdownSuccess";
            };
            success = {
              raw = "[!SUCCESS]";
              rendered = "󰄬 Success";
              highlight = "RenderMarkdownSuccess";
            };
            check = {
              raw = "[!CHECK]";
              rendered = "󰄬 Check";
              highlight = "RenderMarkdownSuccess";
            };
            done = {
              raw = "[!DONE]";
              rendered = "󰄬 Done";
              highlight = "RenderMarkdownSuccess";
            };
            question = {
              raw = "[!QUESTION]";
              rendered = "󰘥 Question";
              highlight = "RenderMarkdownWarn";
            };
            help = {
              raw = "[!HELP]";
              rendered = "󰘥 Help";
              highlight = "RenderMarkdownWarn";
            };
            faq = {
              raw = "[!FAQ]";
              rendered = "󰘥 Faq";
              highlight = "RenderMarkdownWarn";
            };
            attention = {
              raw = "[!ATTENTION]";
              rendered = "󰀪 Attention";
              highlight = "RenderMarkdownWarn";
            };
            failure = {
              raw = "[!FAILURE]";
              rendered = "󰅖 Failure";
              highlight = "RenderMarkdownError";
            };
            fail = {
              raw = "[!FAIL]";
              rendered = "󰅖 Fail";
              highlight = "RenderMarkdownError";
            };
            missing = {
              raw = "[!MISSING]";
              rendered = "󰅖 Missing";
              highlight = "RenderMarkdownError";
            };
            danger = {
              raw = "[!DANGER]";
              rendered = "󱐌 Danger";
              highlight = "RenderMarkdownError";
            };
            error = {
              raw = "[!ERROR]";
              rendered = "󱐌 Error";
              highlight = "RenderMarkdownError";
            };
            bug = {
              raw = "[!BUG]";
              rendered = "󰨰 Bug";
              highlight = "RenderMarkdownError";
            };
            example = {
              raw = "[!EXAMPLE]";
              rendered = "󰉹 Example";
              highlight = "RenderMarkdownHint";
            };
            quote = {
              raw = "[!QUOTE]";
              rendered = "󱆨 Quote";
              highlight = "RenderMarkdownQuote";
            };
            cite = {
              raw = "[!CITE]";
              rendered = "󱆨 Cite";
              highlight = "RenderMarkdownQuote";
            };
          };
        };
      };
    };

    keymaps = [
      {
        key = "<leader>fo";
        action = "<cmd>Obsidian quick_switch<CR>";
        options.desc = "Obsidian: Quick Switch";
      }
    ];
  };
}
