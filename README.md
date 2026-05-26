# Homebrew Tap For HADES System

Install HADES system from the public tap:

```bash
brew tap cbip-solutions/tap
brew install hades
```

The formula builds from the signed `v1.0.0` public source tag at
`cbip-solutions/hades-system`. It depends on Homebrew's `go` build toolchain
and the `hermes-agent` runtime package.

## Verification

```bash
brew audit --strict cbip-solutions/tap/hades
brew test cbip-solutions/tap/hades
```

For source-level verification, clone the release repository and run:

```bash
make build
make verify-license-compliance
```
