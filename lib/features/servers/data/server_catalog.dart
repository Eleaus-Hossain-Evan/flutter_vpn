/// A VPN server. Country name and flag come from country_code_picker /
/// circle_flags via [iso].
typedef Server = ({
  String id,
  String iso,
  String city,
  int latencyMs,
  int bars,
});

/// The list on Figma "Choose server" (7:1427), in order.
const servers = <Server>[
  (id: 'us-ny', iso: 'US', city: 'New York', latencyMs: 28, bars: 3),
  (id: 'us-la', iso: 'US', city: 'Los Angeles', latencyMs: 48, bars: 3),
  (id: 'gb-lon', iso: 'GB', city: 'London', latencyMs: 60, bars: 3),
  (id: 'ca-tor', iso: 'CA', city: 'Toronto', latencyMs: 39, bars: 3),
  (id: 'de-fra', iso: 'DE', city: 'Frankfurt', latencyMs: 65, bars: 3),
  (id: 'nl-ams', iso: 'NL', city: 'Amsterdam', latencyMs: 72, bars: 3),
  (id: 'sg-sin', iso: 'SG', city: 'Singapore', latencyMs: 42, bars: 3),
  (id: 'jp-tyo', iso: 'JP', city: 'Tokyo', latencyMs: 47, bars: 3),
  (id: 'fr-par', iso: 'FR', city: 'Paris', latencyMs: 44, bars: 3),
  (id: 'in-bom', iso: 'IN', city: 'Mumbai', latencyMs: 92, bars: 2),
];

/// Further US cities that only Figma "Server details" (7:1631) lists, under
/// "Other Servers in United States".
const _moreServers = <Server>[
  (id: 'us-chi', iso: 'US', city: 'Chicago', latencyMs: 54, bars: 3),
  (id: 'us-dal', iso: 'US', city: 'Dallas', latencyMs: 58, bars: 3),
  (id: 'us-mia', iso: 'US', city: 'Miami', latencyMs: 62, bars: 3),
];

const _allServers = [...servers, ..._moreServers];

Server? serverById(String id) {
  for (final server in _allServers) {
    if (server.id == id) return server;
  }
  return null;
}

/// The other servers in [server]'s country.
List<Server> otherServersIn(Server server) => [
  for (final s in _allServers)
    if (s.iso == server.iso && s.id != server.id) s,
];
