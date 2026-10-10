// ======================================================================================
// Mod Name: Never Fade Away on Morro Rock Radio
// Author: Spuddeh
// Description: Adds the end-credits cover of Never Fade Away to Morro Rock Radio's playlist,
//              from the game's own audio.
// Mod Version: 1.0.2
// Credits: AudioXL by DigitalVixen.
// ======================================================================================

module NeverFadeAwayMorroRock

// RedLogger's signature ships once, inside the plugin, so callers cannot collide. Without
// RedLogger installed this compiles to nothing.
@if(ModuleExists("RedLogger"))
import RedLogger.*

import AudioXL.*

@if(ModuleExists("RedLogger"))
public func NeverFadeLog(msg: String) -> Void {
  RedLog.Append("NeverFadeAwayMorroRock", msg);
}

@if(!ModuleExists("RedLogger"))
public func NeverFadeLog(msg: String) -> Void {}

// A radio playlist is not TweakDB. The station record holds only its name, icon and index; the
// track list lives in two places:
//
//   the event table                  name -> Wwise id, and the duration the station schedules on;
//                                    AudioXL adds the row when the game reads eventsmetadata.json
//   cooked_metadata.audio_metadata   the audioRadioTrack rows and each station's track array,
//                                    patched here from Resource/Load as it loads
//
// The event itself comes from never_fade_away_att_rock.bnk, which AudioXL loads.
//
// Never write from a ResourceToken callback, or push into eventsmetadata.json: AudioXL 0.6.0 names
// both as a launch crash.

public class NeverFadeAwayMorroRock extends ScriptableService {

  // Matches the event built by tools/make_bank.py. Change one, change the other.
  private let m_trackEvent: CName = n"mus_radio_01_att_rock_never_fade_away_cover";

  // The source file runs 286071.4375 ms, of which 540 ms of silence at the head and 2100 ms at
  // the tail are trimmed away in the bank. The station uses this to know when to queue the next
  // track, so it must match the segment length there, not the file.
  private let m_duration: Float = 283.431;

  private let m_station: CName = n"radio_station_01_att_rock";

  // The title, shipped in this mod's archive. ArchiveXL registers an entry whose primaryKey is 0
  // under both FNV1a32 of the secondary key and FNV1a64 of it, so either resolves the string.
  // This uses the 32-bit one: every vanilla radio track's key fits in 32 bits, and anything
  // reading the key as the low half of a CName sees the whole value only at that width.
  private let m_locName: CName = n"Gameplay-Devices-Radio_tracks-att_rock_never_fade_away_cover";
  private let m_locKey: Uint64 = 865378895ul;

  private cb func OnLoad() {
    if AudioXLAPI.RegisterEventRow(this.m_trackEvent, false, this.m_duration, this.m_duration) {
      NeverFadeLog(s"event registered: \(this.m_trackEvent) \(this.m_duration)s");
    } else {
      NeverFadeLog(s"AudioXL did not take the event row \(this.m_trackEvent) - see its log for why");
    }

    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Load", this, n"OnCookedMetadata")
      .AddTarget(ResourceTarget.Path(r"base\\sound\\metadata\\cooked_metadata.audio_metadata"));
  }

  private cb func OnCookedMetadata(event: ref<ResourceEvent>) {
    this.PatchStation(event.GetResource() as audioCookedMetadataResource);
  }

  private func PatchStation(cooked: ref<audioCookedMetadataResource>) -> Void {
    if !IsDefined(cooked) { return; }

    let station: Bool = false;
    let tracks: Bool = false;

    for entry in cooked.entries {
      let stationData = entry as audioRadioStationMetadata;
      if IsDefined(stationData) && Equals(stationData.name, this.m_station) {
        if !ArrayContains(stationData.tracks, this.m_trackEvent) {
          ArrayPush(stationData.tracks, this.m_trackEvent);
          NeverFadeLog(s"\(this.m_station) now lists \(ArraySize(stationData.tracks)) tracks");
        }
        station = true;
      }

      let trackData = entry as audioRadioTracksMetadata;
      if IsDefined(trackData) {
        if !this.HasTrack(trackData) {
          let row: audioRadioTrack;
          row.trackEventName = this.m_trackEvent;
          row.localizationKey = this.m_locName;
          row.primaryLocKey = this.m_locKey;
          row.isStreamingFriendly = true;
          ArrayPush(trackData.radioTracks, row);
          NeverFadeLog(s"track row added, \(ArraySize(trackData.radioTracks)) rows total");
        }
        tracks = true;
      }

      if station && tracks { break; }
    }

    if !station {
      NeverFadeLog(s"\(this.m_station) not found in this metadata resource");
    }
  }

  private func HasTrack(trackData: ref<audioRadioTracksMetadata>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(trackData.radioTracks) {
      if Equals(trackData.radioTracks[i].trackEventName, this.m_trackEvent) { return true; }
      i += 1;
    }
    return false;
  }
}
