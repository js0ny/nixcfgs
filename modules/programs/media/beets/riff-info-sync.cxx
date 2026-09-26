//  riff-info-sync -- copy the ID3v2 properties TagLib understands into a WAV's
//  RIFF Info chunk (UTF-8), leaving the ID3v2 block itself untouched.
//
//  Build:
//    g++ -std=c++20 -O2 -Wall -Wextra riff-info-sync.cxx $(pkg-config --cflags
//    --libs taglib) -o riff-info-sync
#include <CLI/CLI.hpp>
#include <array>
#include <fstream>
#include <id3v2tag.h>
#include <infotag.h>
#include <iostream>
#include <sstream>
#include <string>
#include <string_view>
#include <tpropertymap.h>
#include <utility>
#include <vector>
#include <wavfile.h>
namespace {
// ---------------------------------------------------------------- command line
struct Options {
  bool dryRun = false;
  bool quiet = false;
  bool reportDropped = false;
  std::vector<std::string> paths;
};
// ------------------------------------------------------------------- file work
enum class Container { RiffWave, Foreign, Unreadable };
//  Cheap magic-number sniff, so we never hand a non-WAV to TagLib.
Container sniffContainer(const std::string &path) {
  std::ifstream input(path, std::ios::binary);
  if (!input)
    return Container::Unreadable;
  std::array<char, 12> header{};
  input.read(header.data(), header.size());
  if (input.gcount() != static_cast<std::streamsize>(header.size()))
    return Container::Foreign;
  const std::string_view magic(header.data(), header.size());
  return magic.substr(0, 4) == "RIFF" && magic.substr(8, 4) == "WAVE"
             ? Container::RiffWave
             : Container::Foreign;
}
using FieldListMap = TagLib::RIFF::Info::FieldListMap;
void reportUnrepresentable(const TagLib::PropertyMap &rejected,
                           const std::string &path, std::ostream &log) {
  if (rejected.isEmpty())
    return;
  log << "Not representable in INFO (retained in ID3):";
  for (const auto &entry : rejected)
    log << ' ' << entry.first;
  log << " [" << path << "]\n";
}
//  Info::Tag::setProperties() drops every INFO field whose property key is
//  absent from the incoming map, so a sync can quietly delete information (e.g.
//  an ISFT written by a recorder when the ID3 side has no ENCODING). Say so out
//  loud.
void reportDroppedInfoFields(const FieldListMap &before,
                             const FieldListMap &after, const std::string &path,
                             std::ostream &log) {
  bool reported = false;
  for (const auto &field : before) {
    if (after.contains(field.first))
      continue;
    if (!reported) {
      log << "Dropping INFO field(s) with no ID3 counterpart:";
      reported = true;
    }
    const TagLib::ByteVector &id = field.first; // INFO ids are four ASCII bytes
    log << ' ' << std::string(id.data(), id.size());
  }
  if (reported)
    log << " [" << path << "]\n";
}
enum class Outcome { Synced, WouldSync, Unchanged, Skipped, Failed };
Outcome syncFile(const std::string &path, const Options &options,
                 std::ostream &progress, std::ostream &log) {
  switch (sniffContainer(path)) {
  case Container::Unreadable:
    log << "Cannot read: " << path << '\n';
    return Outcome::Failed;
  case Container::Foreign:
    progress << "Skipped (not ordinary RIFF/WAVE): " << path << '\n';
    return Outcome::Skipped;
  case Container::RiffWave:
    break;
  }
  TagLib::RIFF::WAV::File file(path.c_str(), false);
  if (!file.isValid() || !file.hasID3v2Tag() || file.ID3v2Tag()->isEmpty()) {
    log << "Invalid WAV or missing/empty ID3: " << path << '\n';
    return Outcome::Failed;
  }
  auto *info = file.InfoTag();
  const FieldListMap before = info->fieldListMap();
  reportUnrepresentable(info->setProperties(file.ID3v2Tag()->properties()),
                        path, log);
  const FieldListMap after = info->fieldListMap();
  if (before == after) {
    progress << "Unchanged: " << path << '\n';
    return Outcome::Unchanged;
  }
  if (options.reportDropped)
    reportDroppedInfoFields(before, after, path, log);
  if (options.dryRun) {
    progress << "Would sync: " << path << '\n';
    return Outcome::WouldSync;
  }
  //  StripOthers is the default: ask for StripNone explicitly to keep the
  //  existing ID3v2 block (and every other chunk) byte for byte.
  if (!file.save(TagLib::RIFF::WAV::File::Info, TagLib::File::StripNone)) {
    log << "Save failed: " << path << '\n';
    return Outcome::Failed;
  }
  progress << "Synced: " << path << '\n';
  return Outcome::Synced;
}
struct Tally {
  unsigned processed = 0;
  unsigned synced = 0;
  unsigned wouldSync = 0;
  unsigned unchanged = 0;
  unsigned skipped = 0;
  unsigned failed = 0;
  void count(Outcome outcome) {
    ++processed;
    switch (outcome) {
    case Outcome::Synced:
      ++synced;
      break;
    case Outcome::WouldSync:
      ++wouldSync;
      break;
    case Outcome::Unchanged:
      ++unchanged;
      break;
    case Outcome::Skipped:
      ++skipped;
      break;
    case Outcome::Failed:
      ++failed;
      break;
    }
  }
};
void printSummary(const Tally &tally, std::ostream &out) {
  if (tally.processed < 2)
    return;
  const std::array<std::pair<unsigned, std::string_view>, 5> counters{{
      {tally.synced, "synced"},
      {tally.wouldSync, "would sync"},
      {tally.unchanged, "unchanged"},
      {tally.skipped, "skipped"},
      {tally.failed, "failed"},
  }};
  out << tally.processed << " files: ";
  bool first = true;
  for (const auto &[count, label] : counters) {
    if (count == 0)
      continue;
    if (!first)
      out << ", ";
    out << count << ' ' << label;
    first = false;
  }
  out << '\n';
}
} // namespace
int main(int argc, char *argv[]) {
  Options options;
  CLI::App app{"Copy the ID3v2 properties TagLib can express into a WAV's RIFF "
               "INFO chunk as UTF-8. The ID3v2 block and every other chunk are "
               "left untouched."};
  app.add_flag("-n,--dry-run", options.dryRun,
               "report what would change, write nothing");
  app.add_flag("-q,--quiet", options.quiet,
               "suppress progress output (warnings still print)");
  app.add_flag("--report-dropped", options.reportDropped,
               "list INFO fields the sync removes");
  app.add_option("files", options.paths, "RIFF/WAVE files to sync")
      ->required();
  try {
    app.parse(argc, argv);
  } catch (const CLI::CallForHelp &) {
    std::cout << app.help();
    return 0;
  } catch (const CLI::ParseError &e) {
    std::cerr << e.what() << "\nTry '--help'.\n";
    return 2;
  }
  std::ostringstream discard; // sink for --quiet
  std::ostream &progress = options.quiet ? discard : std::cout;
  Tally tally;
  for (const std::string &path : options.paths)
    tally.count(syncFile(path, options, progress, std::cerr));
  if (!options.quiet)
    printSummary(tally, std::cout);
  return tally.failed ? 1 : 0;
}
