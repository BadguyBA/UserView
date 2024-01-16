<#
    BadguyBA - UserView. 
        User friendly, simple program to view all registered and unregistered users in reference to a list.

#>

#Imports
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#==Handler==
function SetMainForm(){

    function CreateButton{
        Param(
            [System.Windows.Forms.Form]$form,
            [string]$buttonType,
            [string]$buttonText,
            [int]$xSize,
            [int]$ySize,
            [int]$xPos,
            [int]$yPos
        )

        $MainButton = New-Object System.Windows.Forms.Button
        $MainButton.Location = New-Object System.Drawing.Point($xPos,$yPos)
        $MainButton.Size = New-Object System.Drawing.Size($xSize,$ySize)
        $MainButton.Text = $buttonText

        $form.Controls.Add($MainButton)
        if ($buttonType -eq "Accept") 
        {
            $form.AcceptButton = $MainButton
        } else {
            $form.CancelButton = $MainButton
        }

        return $MainButton
    }

    function CreateLabel{
        Param(
            [System.Windows.Forms.Form]$form,
            [string]$LabelType,
            [string]$LabelText,
            [int]$xSize,
            [int]$ySize,
            [int]$xPos,
            [int]$yPos
        )

        $label = New-Object System.Windows.Forms.Label
        $label.Location = New-Object System.Drawing.Point($xPos, $yPos)
        $label.Size = New-Object System.Drawing.Size($xSize,$ySize)
        $label.Text = $LabelText
        $form.Controls.Add($label)

        if ($LabelType -eq "Bold") 
        {
            $label.Font = New-Object System.Drawing.Font($label.Font.FontFamily, $label.Font.Size, [System.Drawing.FontStyle]::Bold)
        } elseif ($LabelType -eq "Italic")  {
            $label.Font = New-Object System.Drawing.Font($label.Font.FontFamily, $label.Font.Size, [System.Drawing.FontStyle]::Italic)
        } else {
            $label.Font = New-Object System.Drawing.Font($label.Font.FontFamily, $label.Font.Size, [System.Drawing.FontStyle]::Regular)
        }
    }

    $passForm = New-Object System.Windows.Forms.Form
    $passForm.Size = New-Object System.Drawing.Size(300,200)
    $passForm.StartPosition = 'CenterScreen'
    $passForm.Text = 'User Entry Form'
    $passForm.Opacity = 0.95
    
    $ConfrimButton = CreateButton $passForm "Accept" "CONFIRM" 75 23 75 120
    CreateButton $passForm "Deny" "CANCEL" 75 23 150 120
    CreateLabel $passForm "Regular" "Please enter the list of users below:" 280 20 10 20
    CreateLabel $passForm "Bold" "EXAMPLE: 'Adam, Tin, Nik, Kylie'" 280 20 10 40

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,75)
    $textBox.Size = New-Object System.Drawing.Size(260,90)
    $passForm.Controls.Add($textBox)
    
    $passForm.Topmost = $true
    $passForm.Add_Shown({$textBox.Select()})


    $ConfrimButton.Add_Click({ 
        $TextInput = $textBox.Text
        $enteredUsers = $TextInput -split ',\s*'
        $registeredUsers = Get-LocalUser | Select-Object -ExpandProperty Name
        $unregisteredUsers = $enteredUsers | Where-Object { $_ -notin $registeredUsers }
        $extraRegisteredUsers = $registeredUsers | Where-Object { $_ -notin $enteredUsers }

        $result = ''
        if ($unregisteredUsers) {
            $result = "The following users are not registered on this PC: $($unregisteredUsers -join ', ')"
        } else {
            $result = "All entered users are registered."
        }
        
        $result = ''
        if ($unregisteredUsers) {
            $result += "Unregistered users from the entered list: $($unregisteredUsers -join ', ')" + "`n`n"
        } else {
            $result += "All entered users are registered on the PC." + "`n`n"
        }
    
        if ($extraRegisteredUsers) {
            $result += "Registered users not in the entered list: $($extraRegisteredUsers -join ', ') `n"
        } else {
            $result += "There are no registered users missing from the entered list.`n`n"
        }
    
        [System.Windows.Forms.MessageBox]::Show($result, 'User Check Results')
    })

    $passForm.ShowDialog()

}

SetMainForm