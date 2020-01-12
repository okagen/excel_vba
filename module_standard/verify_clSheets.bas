Attribute VB_Name = "verify_clSheets"
Option Explicit
Option Base 1

'==================================================
Sub verify_clSheets_deleteUnSpecifiedSheets()

    Dim shs As New clSheets
    Dim remainSheets As Variant
    Dim bRet As Boolean
    Dim wb As Workbook
    Set wb = ThisWorkbook
    
    '=======================
    remainSheets = Array("R02中結果_国語", "H29小結果_国語A", "$領域観点_R02中_国語", "$領域観点_H29小_国語A")

    '=======================
    
    'check existance of the module.
    bRet = shs.deleteUnSpecifiedSheets(wb, remainSheets)
    
    If bRet Then
        Debug.Print "result ::: exist-->" & CStr(bRet) & " |" & Now
    Else
        Debug.Print "result ::: N/A-->" & CStr(bRet) & " |" & Now
    End If
    
End Sub
