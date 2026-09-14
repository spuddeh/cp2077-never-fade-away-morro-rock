# Features

## Implemented

- The credits cover of *Never Fade Away* plays on Morro Rock Radio in full, streamed from the game's
  own audio. The mod ships no music.
- Trimmed of the silence at both ends, so the station opens on the song and queues the next track
  on time.
- The station shows `P.T. Adamczyk, Olga Jankowska - Never Fade Away (Samurai Cover)`, in all
  nineteen languages.
- The segment carries Morro Rock Radio's broadcast sends, bus and dry Volume, so it plays at the
  station's level.
- Coexists with Restore Nebula with no patch. The mod never starts the metadata load from
  `OnLoad`: it listens for the load, and takes a depot token only for a resource
  `AudioXLNative.IsResourceRequested` reports as already requested.
- AudioXL 0.4.3 or newer is a hard compile dependency.

## Planned

- In-game check: comes up in rotation, plays in full, sits at the station's level.
- Better Vehicle Radio row `865378895` in the combined patch.
