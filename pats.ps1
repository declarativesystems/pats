Set-StrictMode -Version 2.0
param (
  [String] $TestCase = 'c:\vagrant\test.pats'
)

$testNameKey = "testName"
$testPSKey   = "testPS"


function ParseTestcase() {
    param(
        [string] $TestCase
    )

    # read the file as one long string
    [String]$raw = Get-Content $TestCase -raw
    $testRe = '@test "([^"]+)"\s*{\s*(.*)\s*}'

    $matches = [regex]::Matches($raw, $testRe)
    $tests = @()
    foreach ($match in $matches) {
        $testName = $match.captures.groups[1]
        $testPS = $match.captures.groups[2]

        $test = @{
            $testNameKey=$testName;
            $testPSKey = $testPS
        }
        $tests += $test
    }
    return $tests
}
    
  #  if ($matches.success) {
  #      write-host "its seuccess"
  #      $i = 1
#
 #       foreach ($match in [regex]::Matches($raw, $testRe, $i)) {
 #           write-host "lOL"
#
 #           write-host $matches.captures.groups[1]
  #          $i += 1
  #      }
   # }


   #write-host $matches.captures.groups.Count


#    foreach ($line in $raw) {
#        ($url.ToCharArray() | Where-Object {$_ -eq ''} | Measure-Object).Count


#        if ($insideTest -and $insidePS) {
#            # scan for the `}` indicating end of and powershell
#            if ($line -match $endTestRe
#        if ($line -match $testNameRe) {
#            $insideTest = $true
#            
#            $testName = [regex]::Match($line, $testNameRe).captures.groups[1]
#            $tests[$testName] = ""
#        } else {
#            # append to current testcase
#            $tests[$testName] += $line
#        }
#    }


  #  write-host "parsed tests OK"
  #  foreach ($test in $tests.Keys) {
  #      Write-Host "${test}: $($tests.Item($test))"
  #  }

function RunTest() {
    param([string] $PS)


    return 0
}


function RunTests() {
    param(
        [array] $Tests
    )

    $failedTests = 0
    foreach ($test in $Tests) {
        $status = RunTest $test[$testPSKey]
        if ($status -eq 0) {
            $emoji = "✓"
        } else {
            $emoji = "✗"
            $failedTests += 1
        }
        
        write-host " $($emoji) $($test[$testNameKey])"
    }

    write-host "$($tests.Count) test, $($failedTests) failure"
}



if ($TestCase -eq "") {
    write-error "Must specify Testcase File"
} else {
    if (Test-Path $TestCase) {
        write-host "processing tests in $($TestCase)"
        $tests = ParseTestcase $TestCase
        RunTests $tests
    } else {
        Write-Error "Missing testcase file: $($TestCase)"
    }
}