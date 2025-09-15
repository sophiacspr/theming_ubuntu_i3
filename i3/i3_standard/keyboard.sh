#!/bin/bash

# Globales Standard-Layout für alle Keyboards
setxkbmap -layout us -variant alt-intl-unicode -option lv3:rwin_switch

# Externes RK84-Keyboard zusätzlich mit Alt/Win-Swap
setxkbmap \
  -device "$(xinput list --id-only 'keyboard:RK84RGB5.0  Keyboard')" \
  -layout us -variant alt-intl-unicode -option lv3:rwin_switch -option altwin:swap_alt_win

