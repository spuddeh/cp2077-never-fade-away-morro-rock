# Never Fade Away on Morro Rock Radio

Adds the end-credits cover of *Never Fade Away* by P.T. Adamczyk and Olga Jankowska to 107.3 Morro
Rock Radio, so it comes up in rotation beside Samurai's original.

**The mod ships no audio.** The song is already in the game, and the mod points at that copy.

## Requirements

- [AudioXL](https://www.nexusmods.com/cyberpunk2077/mods/33442) - loads the soundbank
- [ArchiveXL](https://www.nexusmods.com/cyberpunk2077/mods/4198) - the track title
- [Codeware](https://www.nexusmods.com/cyberpunk2077/mods/7780)
- [redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511)

[RedLogger](https://www.nexusmods.com/cyberpunk2077/mods/31920) is optional. With it installed the
mod writes what it registered to `r6/logs/mods/`; without it the logging compiles away.

## How it works

A radio station's track list is not a TweakDB record, so no tweak can reach it. It lives in the
game's cooked audio metadata, which this mod patches as it loads - nothing on disk is overwritten.

The soundbank adds the four Wwise objects a radio track needs and points them at the song's
existing audio file. The segment is parented to Morro Rock Radio's own playlist and carries that
playlist's broadcast sends, bus and dry Volume, so the track plays at the station's level.

The same shape as [Hardest to Be on Growl FM](https://github.com/spuddeh/cp2077-hardest-to-be-growl-fm),
whose `docs/how-it-works.md` is the full write-up.

## Building the soundbank

```
python tools/make_bank.py <radio.bnk> <cp_music.bnk> \
    red4ext/plugins/AudioXL/sounds/NeverFadeAwayMorroRock/never_fade_away_att_rock.bnk
```

Both inputs are vanilla banks from `base\sound\soundbanks\`. The generator asserts every field it
reads, so a game patch that moves anything fails the build rather than producing a bank that loads
and misbehaves. Pass trailing `<name> <source_wem> <begin_trim_ms> <end_trim_ms>` groups to wrap
other sources, each optionally followed by a parent playlist id.

The records are cloned from a Growl FM track and reparented to Morro Rock's playlist `845273388`.
The two stations' segments share one layout and differ only in ids and lengths.

## The source and its trims

`1067066079.wem` is the base game's credits recording, played by `mus_finalboards_START`: 286.071 s.
The music starts at 0.55 s and its fade reaches the -79 dB noise floor at 283.94 s. The bank trims
540 ms from the head and 2100 ms from the tail, leaving 283.431 s.

## The track title

`archive/pc/mod/NeverFadeAwayMorroRock.archive` carries one onscreens entry, and the `.xl` beside it
maps every language to that file. The entry is authored in `tools/onscreens.json`. Its `primaryKey`
is `0`, which is what makes ArchiveXL register it under the hash of the secondary key.
