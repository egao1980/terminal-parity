;;;; terminal-parity input corpus. Notation: see src/notation.lisp.
;;;; Regenerate expected.sexp with (terminal-parity/generate:generate).
;;;; Wave 1 covers the VT core every TUI uses; fixtures needing more name
;;;; their :features.

;;; --- Text, C0 controls, wrapping --------------------------------------

(:name "plain-text" :cols 20 :rows 3 :feed "hello world")
(:name "crlf" :cols 10 :rows 3 :feed "ab{cr}{lf}cd")
(:name "lf-keeps-column" :cols 10 :rows 3 :feed "ab{lf}cd")
(:name "cr-overwrites" :cols 10 :rows 2 :feed "hello{cr}J")
(:name "backspace" :cols 10 :rows 2 :feed "abc{bs}{bs}X")
(:name "backspace-at-col0" :cols 10 :rows 2 :feed "{bs}{bs}a")
(:name "tab-stops" :cols 30 :rows 2 :feed "a{ht}b{ht}c")
(:name "tab-at-end" :cols 10 :rows 2 :feed "abcdefgh{ht}{ht}X")
(:name "bell-ignored-in-text" :cols 10 :rows 2 :feed "a{bel}b")
(:name "autowrap" :cols 5 :rows 3 :feed "abcdefgh")
(:name "pending-wrap-cr" :cols 5 :rows 3 :feed "abcde{cr}X")
(:name "pending-wrap-then-char" :cols 5 :rows 3 :feed "abcdeX")
(:name "autowrap-off" :cols 5 :rows 3 :feed "{csi}?7labcdefgh")
(:name "scroll-at-bottom" :cols 6 :rows 3 :feed "one{cr}{lf}two{cr}{lf}three{cr}{lf}four")
(:name "nul-ignored" :cols 10 :rows 2 :feed "a{nul}b")
(:name "can-aborts-sequence" :cols 10 :rows 2 :feed "{csi}1{can}mX")
(:name "unknown-csi-ignored" :cols 10 :rows 2 :feed "a{csi}99zb")

;;; --- Cursor movement -----------------------------------------------------

(:name "cup" :cols 10 :rows 5 :feed "{csi}3;4HX")
(:name "cup-default" :cols 10 :rows 5 :feed "abc{csi}HX")
(:name "cup-clamped" :cols 10 :rows 5 :feed "{csi}99;99HX")
(:name "hvp" :cols 10 :rows 5 :feed "{csi}2;2fX")
(:name "cuu-cud-cuf-cub" :cols 10 :rows 5 :feed "{csi}3;3H{csi}AU{csi}2BD{csi}3CF{csi}5DB")
(:name "cuu-clamped" :cols 10 :rows 5 :feed "{csi}2;2H{csi}9AX")
(:name "cnl-cpl" :cols 10 :rows 5 :feed "{csi}2;5Ha{csi}2Eb{csi}Fc")
(:name "cha-vpa" :cols 10 :rows 5 :feed "{csi}7Ga{csi}4db")
(:name "decsc-decrc" :cols 10 :rows 5 :feed "{csi}2;3H{esc}7{csi}5;5Hx{esc}8y")
(:name "decsc-restores-style" :cols 10 :rows 3 :feed "{csi}1m{esc}7{csi}0ma{esc}8b")
(:name "ind-ri" :cols 6 :rows 3 :feed "a{esc}Db{esc}Mc")
(:name "ri-at-top-scrolls" :cols 6 :rows 3 :feed "top{csi}H{esc}Mnew")
(:name "nel" :cols 10 :rows 3 :feed "abc{esc}Ed")

;;; --- Erase / edit ----------------------------------------------------

(:name "ed0" :cols 6 :rows 3 :feed "aaaaaa{cr}{lf}bbbbbb{cr}{lf}cccccc{csi}2;3H{csi}J")
(:name "ed1" :cols 6 :rows 3 :feed "aaaaaa{cr}{lf}bbbbbb{cr}{lf}cccccc{csi}2;3H{csi}1J")
(:name "ed2" :cols 6 :rows 3 :feed "aaaaaa{cr}{lf}bbbbbb{csi}2J")
(:name "el0" :cols 6 :rows 2 :feed "abcdef{csi}1;3H{csi}K")
(:name "el1" :cols 6 :rows 2 :feed "abcdef{csi}1;3H{csi}1K")
(:name "el2" :cols 6 :rows 2 :feed "abcdef{csi}1;3H{csi}2K")
(:name "erase-keeps-background" :cols 6 :rows 2 :feed "{csi}44m{csi}2K")
(:name "ech" :cols 8 :rows 2 :feed "abcdefgh{csi}1;2H{csi}3X")
(:name "ich" :cols 8 :rows 2 :feed "abcdef{csi}1;2H{csi}2@")
(:name "dch" :cols 8 :rows 2 :feed "abcdef{csi}1;2H{csi}2P")
(:name "il" :cols 4 :rows 4 :feed "aaaa{cr}{lf}bbbb{cr}{lf}cccc{csi}2;1H{csi}L")
(:name "dl" :cols 4 :rows 4 :feed "aaaa{cr}{lf}bbbb{cr}{lf}cccc{csi}1;1H{csi}M")
(:name "insert-mode" :cols 8 :rows 2 :feed "abcd{csi}1;2H{csi}4hXY")
(:name "rep" :cols 10 :rows 2 :feed "x{csi}4b")

;;; --- Scroll regions ---------------------------------------------------

(:name "decstbm-scroll" :cols 4 :rows 5
 :feed "1{cr}{lf}2{cr}{lf}3{cr}{lf}4{cr}{lf}5{csi}2;4r{csi}4;1H{lf}x")
(:name "decstbm-homes-cursor" :cols 4 :rows 5 :feed "{csi}3;3H{csi}2;4rX")
(:name "su-sd" :cols 4 :rows 4
 :feed "a{cr}{lf}b{cr}{lf}c{cr}{lf}d{csi}S{csi}1;1H{csi}2T")
(:name "il-in-region" :cols 4 :rows 5
 :feed "1{cr}{lf}2{cr}{lf}3{cr}{lf}4{cr}{lf}5{csi}2;4r{csi}3;1H{csi}L")
(:name "origin-mode" :cols 6 :rows 5 :feed "{csi}2;4r{csi}?6h{csi}1;1HX")

;;; --- SGR ----------------------------------------------------------------

(:name "sgr-bold-italic-underline" :cols 10 :rows 2 :feed "{csi}1mB{csi}3mI{csi}4mU{csi}0mn")
(:name "sgr-faint-blink-inverse" :cols 10 :rows 2 :feed "{csi}2ma{csi}5mb{csi}7mc{csi}m.")
(:name "sgr-invisible-strike-overline" :cols 10 :rows 2 :feed "{csi}8ma{csi}28;9mb{csi}29;53mc")
(:name "sgr-resets" :cols 10 :rows 2 :feed "{csi}1;3;4;5;7;9mA{csi}22;23;24;25;27;29mB")
(:name "sgr-underline-styles" :cols 10 :rows 2 :feed "{csi}4:1ma{csi}4:2mb{csi}4:3mc{csi}4:4md{csi}4:5me{csi}21mf")
(:name "sgr-fg-16" :cols 20 :rows 2 :feed "{csi}31mr{csi}32mg{csi}94mB{csi}39md")
(:name "sgr-bg-16" :cols 20 :rows 2 :feed "{csi}41mr{csi}102mg{csi}49md")
(:name "sgr-256" :cols 10 :rows 2 :feed "{csi}38;5;196ma{csi}48;5;21mb")
(:name "sgr-truecolor" :cols 10 :rows 2 :feed "{csi}38;2;10;20;30ma{csi}48;2;200;100;0mb")
(:name "sgr-truecolor-colon" :cols 10 :rows 2 :feed "{csi}38:2::1:2:3ma")
(:name "sgr-underline-color" :cols 10 :rows 2 :feed "{csi}4;58;2;255;0;0ma{csi}59mb")
(:name "sgr-bold-is-not-bright" :cols 10 :rows 2 :feed "{csi}1;31ma")

;;; --- Modes --------------------------------------------------------------

(:name "cursor-hidden" :cols 10 :rows 2 :feed "{csi}?25l")
(:name "cursor-keys-mode" :cols 10 :rows 2 :feed "{csi}?1h")
(:name "bracketed-paste-mode" :cols 10 :rows 2 :feed "{csi}?2004h")
(:name "mouse-modes" :cols 10 :rows 2 :feed "{csi}?1002h{csi}?1006h")
(:name "focus-mode" :cols 10 :rows 2 :feed "{csi}?1004h")
(:name "modes-reset" :cols 10 :rows 2 :feed "{csi}?1h{csi}?2004h{csi}?1l{csi}?2004l")
(:name "alt-screen-1049" :cols 10 :rows 3 :features (:alternate-screen)
 :feed "main{csi}?1049halt")
(:name "alt-screen-1049-restore" :cols 10 :rows 3 :features (:alternate-screen)
 :feed "main{csi}?1049halt{csi}?1049lX")
(:name "ris" :cols 10 :rows 3 :feed "{csi}1mabc{csi}?25l{esc}cZ")

;;; --- OSC / titles -------------------------------------------------------

(:name "osc-title-bel" :cols 10 :rows 2 :feed "{osc}2;hello{bel}x")
(:name "osc-title-st" :cols 10 :rows 2 :feed "{osc}0;both{st}x")
(:name "osc-pwd" :cols 10 :rows 2 :feed "{osc}7;file://host/tmp/dir{bel}")
(:name "osc-unknown-ignored" :cols 10 :rows 2 :feed "{osc}9999;zzz{bel}ok")

;;; --- Replies --------------------------------------------------------------

(:name "dsr-cpr" :cols 10 :rows 5 :feed "{csi}3;4H{csi}6n")
(:name "dsr-status" :cols 10 :rows 2 :feed "{csi}5n")
(:name "da1" :cols 10 :rows 2 :feed "{csi}c")
(:name "decrqm" :cols 10 :rows 2 :feed "{csi}?2004h{csi}?2004$p")

;;; --- Unicode ------------------------------------------------------------

(:name "utf8-two-three-four" :cols 10 :rows 2 :feed "é€😀")
(:name "wide-cjk" :cols 6 :rows 2 :feed "日本x")
(:name "wide-wraps" :cols 5 :rows 2 :feed "abcd日")
(:name "combining-mark" :cols 6 :rows 2 :feed "éx")
(:name "utf8-split-feed" :cols 6 :rows 2 :feed "{xe2}{x82}{xac}!")

;;; --- Input encoding ---------------------------------------------------

(:name "keys-basic" :cols 10 :rows 2
 :then ((:key :a :text "a") (:key :enter) (:key :tab) (:key :backspace)
        (:key :escape) (:key :space :text " ")))
(:name "keys-arrows" :cols 10 :rows 2
 :then ((:key :arrow-up) (:key :arrow-down) (:key :arrow-right) (:key :arrow-left)
        (:feed "{csi}?1h") (:key :arrow-up) (:key :arrow-left)))
(:name "keys-nav" :cols 10 :rows 2
 :then ((:key :home) (:key :end) (:key :page-up) (:key :page-down)
        (:key :insert) (:key :delete)))
(:name "keys-function" :cols 10 :rows 2
 :then ((:key :f1) (:key :f2) (:key :f4) (:key :f5) (:key :f10) (:key :f12)))
(:name "keys-modified" :cols 10 :rows 2
 :then ((:key :c :text "c" :modifiers (:ctrl)) (:key :x :text "x" :modifiers (:alt))
        (:key :arrow-up :modifiers (:ctrl)) (:key :arrow-right :modifiers (:shift))
        (:key :f5 :modifiers (:ctrl)) (:key :delete :modifiers (:alt))))
(:name "keys-release-is-silent" :cols 10 :rows 2
 :then ((:key :a :text "a" :action :release)))
(:name "mouse-off" :cols 10 :rows 5 :then ((:mouse :left :press 1 1)))
(:name "mouse-sgr" :cols 10 :rows 5
 :feed "{csi}?1000h{csi}?1006h"
 :then ((:mouse :left :press 2 3) (:mouse :left :release 2 3) (:mouse :right :press 0 0)
        (:mouse :wheel-up :press 4 4) (:mouse :wheel-down :press 4 4)))
(:name "mouse-x10-format" :cols 10 :rows 5
 :feed "{csi}?1000h"
 :then ((:mouse :left :press 2 3) (:mouse :left :release 2 3)))
(:name "mouse-motion-button-mode" :cols 10 :rows 5
 :feed "{csi}?1002h{csi}?1006h"
 :then ((:mouse nil :motion 1 1) (:mouse :left :press 1 1) (:mouse :left :motion 2 1)))
(:name "mouse-modifiers" :cols 10 :rows 5
 :feed "{csi}?1000h{csi}?1006h"
 :then ((:mouse :left :press 1 1 :modifiers (:shift)) (:mouse :left :press 1 1 :modifiers (:ctrl))))
(:name "focus-events" :cols 10 :rows 2
 :then ((:focus t) (:feed "{csi}?1004h") (:focus t) (:focus nil)))
(:name "paste" :cols 10 :rows 2
 :then ((:paste "ls -la") (:paste "two{lf}lines") (:feed "{csi}?2004h") (:paste "hi")
        (:paste "two{lf}lines")))

;;; --- Resize -------------------------------------------------------------

(:name "resize-grow" :cols 5 :rows 2 :feed "abc" :then ((:resize 8 3) (:feed "de")))
(:name "resize-shrink-rows" :cols 5 :rows 4
 :feed "1{cr}{lf}2{cr}{lf}3{cr}{lf}4" :then ((:resize 5 2)))
