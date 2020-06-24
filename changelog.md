## [0.4.4] - 2020-06-24
### Changed
- Default behavior now for daily threshold error being encounterd is to throw a DailyThesholdMetError instead of waiting till midnight and trying again.
- Added optional options hash to ApiCaller
- Added daily\_threshold\_behavior to options Values are AlmaApi::Batch::ApiCaller::DAILY\_THRESHOLD\_BEHAVIOR\_WAIT for old behavior of waiting till midnight, or AlmaApi::Batch::ApiCaller::DAILY\_THRESHOLD\_BEHAVIOR\_ERROR to have an error thrown (default).
## [0.2.4] - 2020-06-05
### Added
- This Changelog! 
- MIT License
- Fixed up gemspec, should now be able to install from github now
