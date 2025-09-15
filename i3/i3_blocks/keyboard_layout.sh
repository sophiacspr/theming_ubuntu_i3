#!/bin/bash


# get the current layout
current_layout=$(setxkbmap -query | awk '/layout/{print $2}')

# output pretty label: for most language/layouts
case "$current_layout" in
    de) echo "DE 🇩🇪" ;;   # German
    us) echo "US 🇺🇸" ;;   # English (US)
    uk|gb) echo "UK 🇬🇧" ;; # English (UK)
    fr) echo "FR 🇫🇷" ;;   # French
    it) echo "IT 🇮🇹" ;;   # Italian
    es) echo "ES 🇪🇸" ;;   # Spanish
    pt) echo "PT 🇵🇹" ;;   # Portuguese
    br) echo "BR 🇧🇷" ;;   # Portuguese (Brazil)
    ru) echo "RU 🇷🇺" ;;   # Russian
    ua|ukr) echo "UA 🇺🇦" ;; # Ukrainian
    pl) echo "PL 🇵🇱" ;;   # Polish
    cz|cs) echo "CZ 🇨🇿" ;; # Czech
    sk) echo "SK 🇸🇰" ;;   # Slovak
    se|sv) echo "SE 🇸🇪" ;; # Swedish
    no) echo "NO 🇳🇴" ;;   # Norwegian
    dk|da) echo "DK 🇩🇰" ;; # Danish
    fi) echo "FI 🇫🇮" ;;   # Finnish
    jp|ja) echo "JP 🇯🇵" ;; # Japanese
    cn|zh) echo "CN 🇨🇳" ;; # Chinese (Simplified)
    tw|zh_TW) echo "TW 🇹🇼" ;; # Chinese (Traditional, Taiwan)
    kr|ko) echo "KR 🇰🇷" ;; # Korean
    in|hi) echo "IN 🇮🇳" ;; # Hindi
    il|he) echo "IL 🇮🇱" ;; # Hebrew
    sa|ar) echo "AR 🇸🇦" ;; # Arabic
    tr) echo "TR 🇹🇷" ;;   # Turkish
    *)
        echo "$current_layout"
        ;;
esac
