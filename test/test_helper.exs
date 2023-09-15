ExUnit.start()

Mox.defmock(ClusterEC2.HTTPClientMock, for: ClusterEC2.HTTPClient)
Mox.defmock(ClusterEC2Mock, for: ClusterEC2)
