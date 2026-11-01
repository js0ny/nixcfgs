use notify_rust::{Notification, NotificationResponse};
use std::ffi::{OsStr, OsString};
use std::process::Command;
use std::{collections::BTreeMap, io};
use systemd::journal::OpenOptions;

// MESSAGE_ID: see `systemd-coredump(8)`: The relevant messages have MESSAGE_ID=fc2e22bc6ee647b6b90729ab34a250b1
const COREDUMP_MESSAGE_ID: &str = "fc2e22bc6ee647b6b90729ab34a250b1";

#[derive(Debug)]
struct Config {
    xdg_terminal_exec: OsString,
}

impl Config {
    fn parse() -> io::Result<Self> {
        Self::parse_from(std::env::args_os().skip(1))
    }

    fn parse_from(args: impl IntoIterator<Item = OsString>) -> io::Result<Self> {
        let mut args = args.into_iter();
        let mut xdg_terminal_exec = OsString::from("xdg-terminal-exec");

        while let Some(arg) = args.next() {
            if arg == "--xdg-terminal-exec" {
                xdg_terminal_exec = args.next().ok_or_else(|| {
                    io::Error::new(
                        io::ErrorKind::InvalidInput,
                        "--xdg-terminal-exec requires a path",
                    )
                })?;
            } else {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidInput,
                    format!("unknown argument: {}", arg.to_string_lossy()),
                ));
            }
        }

        Ok(Self { xdg_terminal_exec })
    }
}

#[derive(Debug)]
struct CoredumpEvent {
    exe: String,
    signal: String,
    pid: String,
}

impl From<&BTreeMap<String, String>> for CoredumpEvent {
    fn from(record: &BTreeMap<String, String>) -> Self {
        let exe = record
            .get("COREDUMP_EXE")
            .cloned()
            .unwrap_or_else(|| "unknown".to_owned());

        let signal = record
            .get("COREDUMP_SIGNAL_NAME")
            .or_else(|| record.get("COREDUMP_SIGNAL"))
            .cloned()
            .unwrap_or_else(|| "unknown".to_owned());

        let pid = record
            .get("COREDUMP_PID")
            .cloned()
            .unwrap_or_else(|| "?".to_owned());

        Self { exe, signal, pid }
    }
}

#[derive(Debug)]
enum CoredumpctlArg {
    Info,
    Debug,
}

fn init_tracing() {
    tracing_subscriber::fmt::init();
}

fn run_coredumpctl(
    action: CoredumpctlArg,
    event: &CoredumpEvent,
    xdg_terminal_exec: &OsStr,
) -> io::Result<()> {
    let action_arg = match action {
        CoredumpctlArg::Info => "info",
        CoredumpctlArg::Debug => "debug",
    };
    let status = Command::new("systemd-run")
        .arg("--user")
        .arg("--collect")
        .arg("--service-type=exec")
        .arg("--")
        .arg(xdg_terminal_exec)
        .arg("--app-id=coredumpctl")
        .arg("--hold")
        .arg("coredumpctl")
        .arg(action_arg)
        .arg(&event.pid)
        .status()?;

    if status.success() {
        Ok(())
    } else {
        Err(io::Error::other(format!(
            "systemd-run exited with {status}"
        )))
    }
}

fn notify_handle(
    event: CoredumpEvent,
    xdg_terminal_exec: &OsStr,
) -> Result<(), Box<dyn std::error::Error>> {
    let body = format!("{} · PID {} · {}", event.signal, event.pid, event.exe);
    let summary = format!("Coredump: {}", event.exe);

    let handle = Notification::new()
        .appname("coredump-notify")
        .summary(summary.as_str())
        .body(body.as_str())
        .action("view", "View")
        .action("debug", "Debug")
        .action("dismiss", "Dismiss")
        .show()?;

    let mut action_result = Ok(());
    handle.wait_for_response(|response: &NotificationResponse| {
        action_result = match response {
            NotificationResponse::Action(action) if action == "view" => {
                run_coredumpctl(CoredumpctlArg::Info, &event, xdg_terminal_exec)
            }
            NotificationResponse::Action(action) if action == "debug" => {
                run_coredumpctl(CoredumpctlArg::Debug, &event, xdg_terminal_exec)
            }
            NotificationResponse::Action(_)
            | NotificationResponse::Default
            | NotificationResponse::Closed(_)
            | NotificationResponse::Reply(_) => Ok(()),
        };
    })?;
    action_result?;

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::parse()?;
    let mut journal = OpenOptions::default().open()?;
    init_tracing();
    journal.match_add("MESSAGE_ID", COREDUMP_MESSAGE_ID)?;
    journal.seek_tail()?;
    journal.previous()?;

    loop {
        match journal.next_entry()? {
            Some(record) => {
                let event = CoredumpEvent::from(&record);
                let xdg_terminal_exec = config.xdg_terminal_exec.clone();
                tracing::info!(?event);
                std::thread::spawn(move || {
                    if let Err(error) = notify_handle(event, &xdg_terminal_exec) {
                        tracing::error!(%error, "failed to handle coredump notification");
                    }
                });
            }
            None => {
                journal.wait(None)?;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::Config;
    use std::ffi::OsString;

    #[test]
    fn defaults_to_path_lookup() {
        let config = Config::parse_from([]).unwrap();

        assert_eq!(config.xdg_terminal_exec, "xdg-terminal-exec");
    }

    #[test]
    fn accepts_xdg_terminal_exec_path() {
        let config = Config::parse_from([
            OsString::from("--xdg-terminal-exec"),
            OsString::from("/nix/store/example/bin/xdg-terminal-exec"),
        ])
        .unwrap();

        assert_eq!(
            config.xdg_terminal_exec,
            "/nix/store/example/bin/xdg-terminal-exec"
        );
    }

    #[test]
    fn rejects_missing_xdg_terminal_exec_path() {
        let error = Config::parse_from([OsString::from("--xdg-terminal-exec")]).unwrap_err();

        assert_eq!(error.kind(), std::io::ErrorKind::InvalidInput);
    }
}
