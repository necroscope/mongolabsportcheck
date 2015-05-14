Function Testit {
   #Necroscope
  [cmdletbinding()]
  param( 
    [string[]]$MongoLabUrl = 'ps047198.mongolab.com',
    [Int32[]]$Port = 47191,
    [Int32]$TimeOut = 6000
    )

   Process {
    ForEach ($Computer in $MongoLabUrl) {
      ForEach ($p in $port) {
        Write-Verbose ("Checking port {0} on {1}" -f $p, $computer)
        $tcpClient = New-Object System.Net.Sockets.TCPClient
        $async = $tcpClient.BeginConnect($Computer,$p,$null,$null) 
        $wait = $async.AsyncWaitHandle.WaitOne($TimeOut,$false)
        If (-Not $Wait) {
          [pscustomobject]@{
            Computername = $MongoLabUrl
            Port = $P
            State = 'Closed'
            Notes = 'Connection timed out'
          }
        } Else {
          Try {
            $tcpClient.EndConnect($async)
            [pscustomobject]@{
              Computername = $Computer
              Port = $P
              State = 'Open'
              Notes = $Null
            }
          } Catch {
            [pscustomobject]@{
              Computername = $Computer
              Port = $P
              State = 'Closed or Down'
              Notes = ("{0}" -f $_.Exception.Message)
            }                    
          }
        }
      }
    }
  }
  }
  Testit

