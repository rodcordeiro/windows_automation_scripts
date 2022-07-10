# https://github.com/adbertram/PSYouTube
$headers = @{ "Authorization" = "Bearer 106201267274007155212" }
$Body = @{
    "q"      = @("Hello World");
    "target" = "pt-br"
}
Invoke-WebRequest `
    -Method POST `
    -Headers $headers `
    -ContentType: "application/json; charset=utf-8" `
    -Body $($Body | ConvertTo-JSON) `
    -inFile 'C:\Users\Rodrigo Cordeiro\Downloads\cordeiro-177115-0de5dcf62042.json' `
    -Uri "https://translation.googleapis.com/language/translate/v2?key=$env:GOOGLE_TOKEN" | Select-Object -Expand Content