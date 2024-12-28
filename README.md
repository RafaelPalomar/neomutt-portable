# Fast Email Client in a Distrobox Environment

This project encapsulates a terminal-based, fast email client leveraging NeoMutt, mbsync, and msmtp with OAuth2 support. The setup is designed to run within a Distrobox container for portability and flexibility.

## Features

- OAuth2 support for modern email providers (e.g., MS365, Gmail).
- NeoMutt-based terminal email client with advanced customization.
- Integration with `pass` for secure password management.
- Configurable to expose the email client to the host system.

## Getting Started

### Prerequisites

- A working installation of [Distrobox](https://github.com/89luca89/distrobox).
- Access to `pass` for secure password management.

### Exporting NeoMutt to the Host

To expose the NeoMutt application to the host system:

1. Ensure that Distrobox is installed and configured.
2. Run the container interactively:

   ```bash
   distrobox-enter <container-name>
   ```

3. Export NeoMutt to the host system:

   ```bash
   distrobox-export --app neomutt
   ```

This command makes NeoMutt accessible as a command on the host system.

### Configuration Files

#### mbsync Configuration

Below is an example `~/.mbsyncrc` configuration:

```plaintext
IMAPStore example-remote
Host imap.example.com
Port 993
User user@example.com
PassCmd "pass email/example"
AuthMechs LOGIN
SSLType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt

MaildirStore example-local
Subfolders Verbatim
Path ~/.local/share/mail/example/
Inbox ~/.local/share/mail/example/INBOX

Channel example
Expunge Both
Master :example-remote:
Slave :example-local:
Patterns *
Create Both
SyncState *
```

#### msmtp Configuration

Below is an example `~/.msmtprc` configuration:

```plaintext
account example
host smtp.example.com
port 587
from user@example.com
user user@example.com
passwordeval "pass email/example"
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.config/msmtp/msmtp.log
```

### Initializing `pass` and Configuring Accounts

1. Initialize `pass`:

   ```bash
   pass init "<your-gpg-key-id>"
   ```

2. Add credentials for your accounts:

   ```bash
   pass insert email/example
   ```

   Enter the email password when prompted.

3. For OAuth2 configurations, use the `mutt_oauth2.py` script to handle token retrieval and storage.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a pull request to improve this project.
