$dt = ([datetime]"2023-12-31T12:40:00.9999990Z").ToUniversalTime()
foreach ($i in 0..9) {
    New-Item "filetime_test_$i.txt" -Force | % {$_.LastWriteTime = $dt}
    $dt += 1  # Increase $dt by 1 tick (= 100 ns = 0.1 μs)
}
