param (
  [String] $TestCase = 'test.pats'
)
Set-StrictMode -Version 2.0
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
    

function RunTest() {
    param([string] $PS)
    
    # temporary files can only be created as .tmp, we must move it to end .ps1 or powershell refuse to run it
    $tmp = New-TemporaryFile
    $tmp.MoveTo("$($tmp.FullName).ps1")

    # exit with the status of the subcommand, not the powershell command itself
    "$($PS) ; exit `$lastExitCode" | Out-File -filepath $tmp.FullName
    $exitCode = 255
    try {
        # https://stackoverflow.com/a/8762068/3441106 
        $pinfo = New-Object System.Diagnostics.ProcessStartInfo
        $pinfo.FileName = "powershell.exe"
        $pinfo.RedirectStandardError = $true
        $pinfo.RedirectStandardOutput = $true
        $pinfo.UseShellExecute = $false
        $pinfo.Arguments = "-File $($tmp.FullName)"
        $p = New-Object System.Diagnostics.Process
        $p.StartInfo = $pinfo
        $p.Start() | Out-Null
        $p.WaitForExit()
        $stdout = $p.StandardOutput.ReadToEnd()
        $stderr = $p.StandardError.ReadToEnd()
        $exitCode = $p.ExitCode
        
        #write-host $stdout
        #write-host $stderr
        #write-host "test done: status $($exitCode)"
    } finally {
        Remove-Item $tmp.FullName -Force
    }
    return $exitCode
}


function RunTests() {
    param(
        [array] $Tests
    )

    $failedTests = 0
    foreach ($test in $Tests) {
        $status = RunTest $test[$testPSKey]
        if ($status -eq 0) {
            $emoji = "√"
            write-host " $($emoji) $($test[$testNameKey])"
        } else {
            $emoji = "X"
            $failedTests += 1
            write-error " $($emoji) $($test[$testNameKey])"
        }
        
        
    }

    write-host "$($tests.Count) test, $($failedTests) failure"
    return $failedTests
}



if ($TestCase -eq "") {
    write-error "Must specify Testcase File"
} else {
    if (Test-Path $TestCase) {
        write-host "processing tests in $($TestCase)"
        $tests = ParseTestcase $TestCase
        $status = RunTests $tests
        exit $status

    } else {
        Write-Error "Missing testcase file: $($TestCase)"
        exit 1
    }
}
