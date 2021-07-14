class person{
    [string]$FirstName
    [string]$LastName
    [string]$CompleteName

    [string]GetName() {
        return "$($this.FirstName) $($this.LastName)"
    }
    [void]SetName([string]$Name){
        $this.FirstName = ($Name -split ' ')[0]
        $this.LastName = ($Name -split ' ')[-1]
        $this.CompleteName = $Name
    }
    [void]SetName([string]$FirstName,[string]$LastName) {
        $this.FirstName = $FirstName
        $this.LastName = $LastName
        $this.CompleteName = "$($FirstName) $($LastName)"
    }
}

class teacher : person {
    [int]hidden $EmployeeId
}

class student : person {
    [int]hidden $StudentId
    [string[]]$Classes = @()
    [int]static $MaxClassCount = 7
    
    [void]AddClass ([string]$Name) {
        if ($this.Classes.Count -lt [student]::MaxClassCount) {
            $this.Classes += $Name
        }
    }
}


$teacher = [teacher]::New()
$teacher.SetName("Rodrigo Cordeiro")
# $teacher

$student1 = [student]::new()
$student1.SetName("Rodrigo Cordeiro")
'PE','English','Math','History','Computer Science','French','Wood Working','Cooking' | ForEach-Object {
	$student1.AddClass($_)
}

$student1