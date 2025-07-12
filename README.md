# Thunderbird Waybar Email Module

A simple and accurate Thunderbird email unread count module for Waybar.

## Features

- ✅ **Accurate unread counts** - Parses Thunderbird's MSF files properly instead of relying on file sizes
- ✅ **Multi-account support** - Works with IMAP, POP3, and smart mailboxes
- ✅ **Clean design** - Shows unread envelope icon with count when there are unread emails
- ✅ **Theme-aware** - Uses CSS that works with most themes
- ✅ **No dependencies** - Uses only standard Unix tools

## Installation

### Manual Installation

1. Download the script:
```bash
wget https://raw.githubusercontent.com/yourusername/thunderbird-waybar-email/main/email-count.sh
chmod +x email-count.sh
```

2. Move to your waybar scripts directory:
```bash
mkdir -p ~/.config/waybar/scripts
mv email-count.sh ~/.config/waybar/scripts/
```

3. Add the CSS to your waybar style.css:
```css
#custom-email.unread {
  background: rgba(255, 255, 255, 0.2);
  color: inherit;
  border-radius: 4px;
  padding: 0 6px;
  font-weight: bold;
  border: 1px solid currentColor;
}

#custom-email.read {
  opacity: 0.7;
}
```

4. Add the module to your waybar config:
```json
"custom/email": {
  "format": "{}",
  "exec": "~/.config/waybar/scripts/email-count.sh",
  "return-type": "json",
  "interval": 60,
  "tooltip": false,
  "on-click": "thunderbird"
}
```

5. Add it to your modules list:
```json
"modules-right": [
  "custom/email",
  // ... other modules
]
```

## How it works

The script:
1. Finds your Thunderbird profile directory
2. Locates all inbox MSF files (IMAP, POP3, smart mailboxes)
3. Parses the A2 field in each MSF file to get accurate unread counts
4. Sums up all unread emails across accounts
5. Outputs JSON for waybar with appropriate icons and CSS classes

## Icons

- 📧 `󰇯` - When all emails are read
- 📧 `󰇮` - When there are unread emails (with count)

## Requirements

- Bash
- Thunderbird
- Waybar
- Nerd Fonts (for icons)

## Troubleshooting

**No emails showing?**
- Make sure Thunderbird has been opened at least once
- Check that your Thunderbird profile exists in `~/.thunderbird/`

**Wrong counts?**
- The script updates every 60 seconds by default
- You can change the interval in your waybar config

**Icons not showing?**
- Install a Nerd Font like "SauceCodePro Nerd Font Mono"

## License

MIT License - feel free to use and modify!
