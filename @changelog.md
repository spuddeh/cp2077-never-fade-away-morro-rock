# Changelog

## [1.0.0] - Unreleased

### Added

- First build. `mus_radio_01_att_rock_never_fade_away_cover` (Wwise `1087448145`) on
  `radio_station_01_att_rock`, from `1067066079.wem` - the base game credits recording of the cover,
  played by `mus_finalboards_START`.
- Trims are 540 ms and 2100 ms. In 10 ms RMS windows the music starts at 550 ms and ends at
  283940 ms, and both edges hold at -70, -65 and -60 dB.
- Title `P.T. Adamczyk, Olga Jankowska - Never Fade Away (Samurai Cover)`, key
  `Gameplay-Devices-Radio_tracks-att_rock_never_fade_away_cover`, FNV1a32 `865378895`.

### Verified

- **Playing in game 2026-09-14.** Plays without issue in the Testing instance.
- **Restore Nebula needs its compatibility patch beside this mod**, even though the two add to
  different stations. Without the patch from Hardest to Be on Growl FM's page, Restore Nebula's
  track is lost; with it, it plays.
