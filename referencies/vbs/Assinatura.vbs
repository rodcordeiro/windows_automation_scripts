Const END_OF_STORY = 6
On Error Resume Next

Set objSysInfo = CreateObject("ADSystemInfo")
strUser = objSysInfo.UserName

Set objUser = GetObject("LDAP://" & strUser) 

strCompany = objUser.Company
strName = objUser.FullName
strFirstName = objuser.givenName
StrLastName = objuser.sn
strDepartment = objUser.Department
strPhone = objUser.telephoneNumber
strMobile = objUser.Mobile
strFax = objUser.facsimileTelephoneNumber
strMail = objuser.mail
strWeb = "www.fundacaodorina.org.br"
strDescr = "- imagem:Retângulo em cinza escuro onde se lê à esquerda - Série Encontros e abaixo, está escrito - acompanhe os encontros aos sábados no nosso canal do youtube. Precisamos de você para bater a meta de 75 mil reais. Doe em fdnc.org/75anos. Do lado direito, está escrito apoio UNIBES cultural e o selo comemorativo de 75 anos da Fundação, que é formado pelo texto 75 anos de inclusão e o smile de óculos escuros acima dele."
strNomeArq = "Assinatura " & strFirstName
strLogo = "\\fundacaodorina.org.br.local\NETLOGON\Assinatura\Assinatura_Logo.png"
strBanner = "\\fundacaodorina.org.br.local\NETLOGON\Assinatura\Assinatura_banner.png"
strBannerlink = "www.fundacaodorina.org.br"
Set objWord = CreateObject("Word.Application")
objWord.Visible = False

Set objDoc = objWord.Documents.Add()
Set objSelection = objWord.Selection
Set objRange = objDoc.Range()

Set objEmailOptions = objWord.EmailOptions
Set objSignatureObject = objEmailOptions.EmailSignature
Set objSignatureEntries = objSignatureObject.EmailSignatureEntries

'   Definicao das cores que podem ser usadas na assinatura
wdColorAqua = 13421619
wdColorAutomatic = -16777216
wdColorBlack = 0
wdColorBlue = 16711680
wdColorBlueGray = 10053222
wdColorBrightGreen = 65280
wdColorBrown = 13209
wdColorDarkBlue = 8388608
wdColorDarkGreen = 13056
wdColorDarkRed = 128
wdColorDarkTeal = 6697728
wdColorDarkYellow = 32896
wdColorGold = 52479
wdColorGray05 = 15987699
wdColorGray10 = 15132390
wdColorGray125 = 14737632
wdColorGray15 = 14277081
wdColorGray20 = 13421772
wdColorGray25 = 12632256
wdColorGray30 = 11776947
wdColorGray35 = 10921638
wdColorGray375 = 10526880
wdColorGray40 = 10066329
wdColorGray45 = 9211020
wdColorGray50 = 8421504
wdColorGray55 = 7566195
wdColorGray60 = 6710886
wdColorGray625 = 6316128
wdColorGray65 = 5855577
wdColorGray70 = 5000268
wdColorGray75 = 4210752
wdColorGray80 = 3355443
wdColorGray85 = 2500134
wdColorGray875 = 2105376
wdColorGray90 = 1644825
wdColorGray95 = 789516
wdColorGreen = 32768
wdColorIndigo = 10040115
wdColorLavender = 16751052
wdColorLightBlue = 16737843
wdColorLightGreen = 13434828
wdColorLightOrange = 39423
wdColorLightTurquoise = 16777164
wdColorLightYellow = 10092543
wdColorLime = 52377
wdColorOliveGreen = 13107
wdColorOrange = 26367
wdColorPaleBlue = 16764057
wdColorPink = 16711935
wdColorPlum = 6697881
wdColorRed = 255
wdColorRose = 13408767
wdColorSeaGreen = 6723891
wdColorSkyBlue = 16763904
wdColorTan = 10079487
wdColorTeal = 8421376
wdColorTurquoise = 16776960
wdColorViolet = 8388736
wdColorWhite = 16777215
wdColorYellow = 65535

'corpo da assinatura

objDoc.Tables.Add objRange, 1, 2
Set objTable = objDoc.Tables(1)
objTable.Columns(1).Width = objWord.InchesToPoints(0.85)
objTable.Columns(2).Width = objWord.InchesToPoints(3)

objTable.Cell(1, 1).Range.Text = objDoc.Hyperlinks.Add (objDoc.INLINEShapes.AddPicture(strLogo), "www.fundacaodorina.org.br")

objTable.Cell(1, 2).Select
objSelection.Font.Size = "13"
objSelection.Font.Name = "Calibri"
objSelection.Font.Bold = True
objSelection.Font.Color = wdColorBlack 
objSelection.TypeText strFirstName & " " & strLastName & Chr(11)
objSelection.Font.Size = "11"
objSelection.Font.Name = "Calibri"
objSelection.Font.Color = wdColorBlack 
objSelection.TypeText strDepartment
objSelection.Font.Bold = false
objSelection.TypeParagraph()
objSelection.Font.Color = wdColorGray45
objSelection.Font.Size = "11"
objSelection.Font.Name = "Calibri" 
objSelection.TypeText "" & "" & "" & strMail & Chr(11) & strPhone & Chr(11) & Chr(15) 
objSelection.TypeText "Rua Doutor Diogo de Faria, 558 São Paulo - SP" & "" & Chr(11) & Chr(15) 
objSelection.Font.Bold = True
objSelection.Font.Size = "9"
objSelection.Font.Name = "Calibri"
objSelection.Font.Color = wdColorGray45 
objSelection.TypeText "" & strWeb & Chr(12)
objSelection.Font.Bold = false
objSelection.Font.Size = "1"
objSelection.Font.Name = "Microsoft Uighur"
objSelection.Font.Color = wdColorWhite
objSelection.TypeText "" & strDescr & Chr(11)

objSelection.EndKey END_OF_STORY

' Adiciona o hyperlink do site e a imagem da SITE.
objSelection.Hyperlinks.Add objDoc.INLINEShapes.AddPicture(strBanner), "www.fundacaodorina.org.br"


objSignatureEntries.Add "Signature", objRange
objSignatureObject.NewMessageSignature = "Signature"
objSignatureObject.ReplyMessageSignature = "Signature"

objDoc.Saved = True
objWord.Quit
                                                                                                                             