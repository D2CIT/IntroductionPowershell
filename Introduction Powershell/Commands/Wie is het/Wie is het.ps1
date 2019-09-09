
#Naam         : Eric
#Haarkleur    : Blond
#Mond         : Groot
#Neus         : Klein
#Oogkleur     : Bruin
#Lengte_haar  : Kort
#Hoofddeksel  : Ja
#Gezichtshaar : Nee
#Rode_Wangen  : Nee
#Geslacht     : Man
#Bril         : Nee

Function Check-result {
    param([array]$object)
    If($object.count -lt 2){
        Write-host "Aantal personen over : 1"
        Write-host "Het is $($object.naam)" -for Green
    }Else{
        Write-host "Aantal personen over : $($object.count)"
    }
}


function start-wieishet{

    param(
        $Importfile = "wieishet.csv"
    )

    new-psdrive WieisHet -PSProvider FileSystem -Root "C:\Users\Markv\Documents\DATA\CloudStation\06_Cursus\Powershell\Powershell - Introduction to Powershell 3.0\2017_December\Commands\Wie is het" 
    cd wieishet:
    cls

    $script:wieishet = Import-csv  $Importfile -Delimiter ";"
    Check-result -object $wieishet

    


}




function get-question {

    param(
       [ValidateSet("geslacht", "bril", "Hoofddeksel","naam","Haarkleur","mond","neus","lengte_haar","gezichtshaar","rodewangen")]
       $question 
    
    )

    switch ($question)
    {
        'Bril' {
            read-host -Prompt "heeft hij/zij een bril?"
            $script:result = $result | where {$_.bril -eq "ja"}
            Check-result -object $result
        
        }
        'value3' {}
        Default {}
    }
    $result = $wieishet | where {$_.geslacht -eq "man"}
    Check-result -object $result
    read-host

}



$result = $wieishet | where {$_.geslacht -eq "man"}
Check-result -object $result
read-host

$result = $result | where {$_.bril -eq "ja"}
Check-result -object $result

$result = $result | where {$_.Hoofddeksel -eq "nee"}
Check-result -object $result

$result = $result | where {$_.Haarkleur -eq "wit"}
Check-result -object $result

$result = $result | where {$_.Lengte_haar -eq "kaal"}
Check-result -object $result
