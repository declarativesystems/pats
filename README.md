# PATS
PowerShell Acceptance Testing System

## What's this?
PATS is be a test framework analgous to the much-loved [BATS](https://github.com/bats-core/bats-core) for Unix-like OSs.

## Syntax?
Basically the same as BATS but with powershell. Here's an example:

```
@test "sets the timezone correctly" {
  cmd /C "tzutil /g | findstr /C:`"New Zealand Standard Time`" "
}
```

## Test results?

* `[*]` - Test passed
* `[X]` - Test failed

No emojii or even most extended ASCII characters allowed in our terminal 😂

Overall test status communicated by exit code:
* 0 - All tests passed
* Otherwise error

## Support?
If your interested in sponsoring development please email sales@declarativesystems.com to start the conversation.

## Helps?
If you'd like to help on this project, that would be awesome. Tickets, PRs, general feedback, etc. all gratefully received.
