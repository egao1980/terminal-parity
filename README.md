# terminal-parity

Golden corpus for [`terminal-protocol`](https://github.com/egao1980/terminal-protocol) backends. [libghostty-vt 1.0](https://mitchellh.com/writing/libghostty-1-0) (through [`terminal-backend-ghostty`](https://github.com/egao1980/terminal-backend-ghostty)) is the oracle. Any backend replays the corpus and must match it exactly.

| File | |
|------|---|
| `corpus/inputs.sexp` | Hand-written fixtures: bytes to feed, then steps (`:key` `:mouse` `:focus` `:paste` `:feed` `:resize`) |
| `corpus/expected.sexp` | **Generated** by the oracle: replies, encoded input bytes, and a canonical snapshot per fixture |
| `corpus/palette.sexp` | **Generated**: the oracle's default foreground, background and 256-colour palette |

98 fixtures cover C0 controls, wrapping and pending wrap, cursor motion, DECSC/DECRC, erase/edit (ED EL ECH ICH DCH IL DL IRM REP), scroll regions and SU/SD, SGR (16/256/truecolor, colon forms, underline styles and colour), modes, the 1049 alternate screen, RIS, OSC 0/2/7, DSR/DA/DECRQM replies, UTF-8, wide and combining characters, keys (plain, arrows in both cursor modes, nav, F-keys, modifiers), mouse (X10 and SGR, motion, wheel, modifiers), focus, bracketed paste, and resize.

## Notation

A fixture string is UTF-8 text plus brace escapes: `{esc} {csi} {osc} {st} {bel} {bs} {ht} {lf} {cr} {nul} {can} {sub} {del}`, `{xHH}` for any byte, `{{` for a literal brace.

## Use it from a backend's tests

```lisp
(defsystem "my-backend/tests"
  :depends-on ("my-backend" "terminal-parity/rove" "rove") …)

(terminal-parity/rove:define-parity-tests my-backend
  (make-instance 'my-backend:my-backend))
```

That defines one Rove test per fixture. Each fixture runs twice: fed whole, and fed one byte at a time (sequences must resume across reads). A fixture whose `:features` the backend doesn't claim through `backend-supports-p` is skipped. Mismatches print the expected and actual values.

## Regenerate

Edit `inputs.sexp`, then:

```lisp
(asdf:load-system "terminal-parity/generate")
(terminal-parity/generate:generate)
```

Review the diff of `expected.sexp` before committing: it's the contract. `terminal-parity/tests` replays the corpus against the oracle itself, which catches a stale file or a libghostty-vt behaviour change.

## License

MIT
