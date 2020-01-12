VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clDir"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'==================================================
'�w��f�B���N�g���Ƀt�H���_�����B
'�����̃t�H���_�����݂����ꍇ�A�t�H���_��������(#)��t���ăJ�E���g�A�b�v�B
'  [i]parentDir    �t�H���_�쐬��f�B���N�g���̃p�X
'  [i]name          �t�H���_��
'  [o]newDir   �쐬�����t���p�X�t�t�H���_��
'--------------------------------------------------
Public Function createFolder(ByVal parentDir As String, _
                                            ByVal name As String, _
                                            ByRef newDir As String _
                                            ) As Boolean
    If parentDir = "" Or name = "" Then
        createFolder = False
        Debug.Print "err ::: no input parentDir-> (" & parentDir & ")" & _
                            "/name -> (" & name & ") [func:createFolder()]" & Now
        Exit Function
    End If
                                            
    Dim orgName As String
    Dim tmpName As String
    Dim ret As String
    Dim num As Long
    Dim flg As Boolean
    
    '�t�H���_���̃t���p�X�𐶐�
    Dim FSO As Object
    Set FSO = CreateObject("Scripting.FileSystemObject")
    orgName = FSO.BuildPath(parentDir, name)
    Set FSO = Nothing

    '�t�H���_�̑��݂��`�F�b�N���ăt�H���_���𐶐�
    tmpName = orgName
    num = 1
    flg = True
    Do While flg
        ret = Dir(tmpName, vbDirectory)
        If ret = "" Then
            flg = False
        Else
            tmpName = orgName & " " & Format(num, "(#)")
            num = num + 1
        End If
    Loop

    '�t�H���_�쐬
    MkDir tmpName
    
    newDir = tmpName
    createFolder = True
End Function

