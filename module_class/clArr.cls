VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clArr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Option Base 1
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)



'---------------------------------------------
' ����������

'==================================================
'2�����z��(arr)�́A�c�������ւ���B�B
'  [i]arr       ���̔z��
'  [o]newArr       ���`��̔z��
'--------------------------------------------------
Public Function transposeArray(ByVal arr As Variant, _
                                ByRef dat As Variant _
                                ) As Boolean
                            
    '�l��ݒ肷��ׂ́A���ۂ̃��[�v���������擾
    Dim loopRow As Long
    Dim loopCol As Long
    loopRow = UBound(arr, 1)
    loopCol = UBound(arr, 2)
    
    
    '2�����z��𐮌`
    Dim retTmpBucket As Variant
    ReDim retTmpBucket(1 To loopCol, 1 To loopRow)
    Dim i As Long
    Dim j As Long
    For i = 1 To loopRow Step 1
        For j = 1 To loopCol Step 1
            retTmpBucket(j, i) = arr(i, j)
        Next j
    Next i

    dat = retTmpBucket
    transposeArray = True
End Function


'==================================================
'Collection�̒��g��2�����z��ɓ���Ȃ����B
'  [i]coll    Collection
'  [i]isRow �s�p����p true=�s(1,1)(1,2)�E�E�E
'                               false=��(1,1)(2,1)�E�E�E
'  [o]arr    �ϊ���̔z��
'--------------------------------------------------
Public Function cnvCollToArr(ByVal coll As Collection, _
                                            ByVal isRow As Boolean, _
                                            ByRef arr As Variant _
                                            ) As Boolean
    Dim retArr As Variant
    Dim i As Long
    
    If isRow = True Then
        ReDim retArr(1 To 1, 1 To coll.count)
        For i = 1 To coll.count Step 1
            retArr(1, i) = coll(i)
        Next i
    Else
        ReDim retArr(1 To coll.count, 1 To 1)
        For i = 1 To coll.count Step 1
            retArr(i, 1) = coll(i)
        Next i
    End If
    
    arr = retArr
    cnvCollToArr = True
End Function

'==================================================
'2�����z���1�s����Collection�ɓ���Ȃ����B
'  [i]arr      �Ώۂ̔z��
'  [o]coll    �ϊ����Collection
'--------------------------------------------------
Public Function cnvArrToColl(ByVal arr As Variant, _
                                            ByRef coll As Collection _
                                            ) As Boolean
    Dim bRet As Boolean
    Dim dimension As Long
    Dim orgRow As Long
    Dim orgCol As Long
    Dim retColl As New Collection
    Dim i As Long
    Dim j As Long
    
    '�z��̎��������擾 2�����z��łȂ��ꍇ�̓G���[
    bRet = getDimension(arr, dimension)
    If bRet = False Or dimension <> 2 Then
        Debug.Print "err ::: dimension ->" & dimension & " [func:cnvArrToColl()]" & Now
        cnvArrToColl = False
        Exit Function
    End If
    
    orgRow = UBound(arr, 1)
    orgCol = UBound(arr, 2)
    
    For i = 1 To orgRow Step 1
        For j = 1 To orgCol Step 1
            retColl.Add (arr(i, j))
        Next j
    Next i
    
    Set coll = retColl
    cnvArrToColl = True
End Function

'==================================================
'2�����z��̎w��s���擾����B
'  [i]arr      �Ώۂ̔z��
'  [i]row     �擾����s�̓Y����
'  [o]coll    �ϊ����Collection
'--------------------------------------------------
Public Function getOneLineFromArr(ByVal arr As Variant, _
                                    ByVal row As Long, _
                                    ByRef retArr As Variant _
                                    ) As Boolean
    Dim bRet As Boolean
    Dim dimension As Long
    Dim idx1_min As Long, idx2_min As Long
    Dim idx1_max As Long, idx2_max As Long
    Dim i As Long
    
    '�z��̎��������擾 2�����z��łȂ��ꍇ�̓G���[
    bRet = getDimension(arr, dimension)
    If bRet = False Or dimension <> 2 Then
        Debug.Print "err ::: dimension ->" & dimension & " [func:cnvArrToColl()]" & Now
        getOneLineFromArr = False
        Exit Function
    End If
    
    idx1_min = LBound(arr, 1) '��1�v�f�̓Y�����̍ŏ��l
    idx2_min = LBound(arr, 2) '��2�v�f�̓Y�����̍ŏ��l
    idx1_max = UBound(arr, 1) '��1�v�f�̓Y�����̍ő�l
    idx2_max = UBound(arr, 2) '��2�v�f�̓Y�����̍ő�l
    
    Dim ret As Variant
    ReDim ret(idx1_min To idx1_min, idx2_min To idx2_max)
    For i = idx2_min To idx2_max Step 1
        ret(idx1_min, i) = arr(row, i)
    Next i
    
    retArr = ret
    getOneLineFromArr = True
End Function


'==================================================
'2�����z��̒��ɁA�������R�[�h(�s)�����݂����ꍇ�A����c���đ��̃��R�[�h���폜���鏈����ǉ�����B
'  [i]arr           �Ώۂ̔z��
'  [o]newArr    �s�̏d���폜��̔z��
'  [i]ignoreCol ���R�[�h�̏d�����`�F�b�N���ۂɖ�������v�f(��)�̓Y����
'--------------------------------------------------
Public Function removeDuplication(ByVal arr As Variant, _
                                                    ByRef newArr As Variant, _
                                                    Optional ByVal ignoreCol As Long = 0 _
                                                    ) As Boolean
    Dim bRet As Boolean
    Dim dimension As Long
    Dim orgRow As Long
    Dim orgCol As Long
    Dim tmpArr As Variant
    Dim dic As Variant
    Dim i As Long
    Dim j As Long
    Dim tmpRow As Long
    Dim word As String
    Dim oneLine As String
                                                    
    '�z��̎��������擾 2�����z��łȂ��ꍇ�̓G���[
    bRet = getDimension(arr, dimension)
    If bRet = False Or dimension <> 2 Then
        Debug.Print "err ::: dimension ->" & dimension & " [func:removeDuplication()]" & Now
        removeDuplication = False
        Exit Function
    End If
    
    '�Ԃ�l�p�̔z��̗̈�𐶐�
    orgRow = UBound(arr, 1)
    orgCol = UBound(arr, 2)
    ReDim tmpArr(1 To orgRow, 1 To orgCol)
    
    '�d�����郌�R�[�h�𖳎����āA�V����Array���쐬����
    Set dic = CreateObject("Scripting.Dictionary")
    tmpRow = 1
    For i = 1 To orgRow Step 1
        'Empty�n��" "�ɕϊ����A���R�[�h���P������ɕϊ��B�v�f��"-"�łȂ�
        oneLine = ""
        For j = 1 To orgCol Step 1
            'ignoreCol�ƈ�v�����ꍇ�͖�������
            If ignoreCol <> j Then
                If IsEmpty(arr(i, j)) Then
                    word = " "
                Else
                    word = arr(i, j)
                End If
                oneLine = oneLine & "-" & word
            End If
        Next j
        
        'Dictionary�I�u�W�F�N�g���g���B�����l���Ȃ���ΕԂ�l�pArray�ɒǉ�
        If Not dic.exists(oneLine) Then
            dic.Add oneLine, oneLine
            For j = 1 To orgCol Step 1
                tmpArr(tmpRow, j) = arr(i, j)
            Next j
            tmpRow = tmpRow + 1
        End If
    Next i
    
    '�s�v�ȃ��R�[�h���폜
    bRet = formatArray(tmpArr, tmpRow - 1, orgCol, tmpArr)
    If bRet = False Then
        Debug.Print "err ::: cannot format the array. [func:removeDuplication()]" & Now
        removeDuplication = False
        Exit Function
    End If
    
    newArr = tmpArr
    removeDuplication = True
End Function

'==================================================
'2�����z��ŁA���郌�R�[�h(�s)�̂��ׂĂ̗v�f(��)��Emptly�̏ꍇ�A�폜����
'  [i]arr           �Ώۂ̔z��
'  [o]newArr         Empty���R�[�h�폜��̔z��
'--------------------
'���\�b�h���Ԃ��Ԃ��l�� bool -> integer �ɕύX 2017.2.15
' 0=�����G���[
' 1=��������
' 2=���
'--------------------------------------------------
Public Function removeEmptyRecord(ByVal arr As Variant, _
                                    ByRef newArr As Variant _
                                ) As Integer
    Dim bRet As Boolean
    Dim dimension As Long
    Dim tmpArr As Variant
    Dim orgRow As Long
    Dim orgCol As Long
    Dim emptyFlg As Boolean
    Dim i As Long
    Dim j As Long
    Dim tmpRow As Long
    Dim allEmptyFLg As Boolean
    allEmptyFLg = True
    
    
    '�z��̎��������擾 2�����z��łȂ��ꍇ�̓G���[
    bRet = getDimension(arr, dimension)
    If bRet = False Or dimension <> 2 Then
        Debug.Print "err ::: dimension ->" & dimension & " [func:removeEmptyRecord()]" & Now
        removeEmptyRecord = 0
        Exit Function
    End If
    
    '�Ԃ�l�p�̔z��̗̈�𐶐�
    orgRow = UBound(arr, 1)
    orgCol = UBound(arr, 2)
    ReDim tmpArr(1 To orgRow, 1 To orgCol)
    
    '�Ԃ�l�p�̔z��Ƀf�[�^��ݒ�
    tmpRow = 1
    For i = 1 To orgRow Step 1
        '�e�v�f�ɒl���ݒ肳��Ă��邩���`�F�b�N
        emptyFlg = True
        For j = 1 To orgCol Step 1
            If Not IsEmpty(arr(i, j)) Then
                emptyFlg = False
            End If
        Next j
        
        '�l����ł������Ă����ꍇ�͕Ԃ�l�p�̔z��ɃR�s�[
        If Not emptyFlg Then
            For j = 1 To orgCol Step 1
                tmpArr(tmpRow, j) = arr(i, j)
            Next j
            tmpRow = tmpRow + 1
            allEmptyFLg = False
        End If
    Next i
    
    If allEmptyFLg = False Then
        '�s�v�ȃ��R�[�h���폜
        bRet = formatArray(tmpArr, tmpRow - 1, orgCol, tmpArr)
        If bRet = False Then
            Debug.Print "err ::: cannot format the array. [func:removeEmptyRecord()]" & Now
            removeEmptyRecord = 0
            Exit Function
        End If
        
        newArr = tmpArr
        removeEmptyRecord = 1
        Exit Function
    Else
        '�S�Ẵ��R�[�h��Empty�̏ꍇ
        removeEmptyRecord = 2
        Exit Function
    End If

End Function

'==================================================
'2�����z��(arr)�̎w�����폜�B�������2�����z���1�񌸂�B
'  [i]arr           �폜���z��
'  [i]colIndex  �폜��̓Y����
'  [o]newArr   �폜��̔z��
'--------------------------------------------------
Public Function removeColFromArray(ByVal arr As Variant, _
                                                        ByVal colIndex As Long, _
                                                        ByRef newArr As Variant _
                                                        ) As Boolean
    Dim bRet As Boolean
    Dim dimension As Long
    Dim retArr As Variant
    Dim i As Long
    Dim j As Long

     '�z��̎��������擾 2�����z��łȂ��ꍇ�̓G���[
    bRet = getDimension(arr, dimension)
    If bRet = False Or dimension <> 2 Then
        Debug.Print "err ::: dimension ->" & dimension & " [func:removeColFromArray()]" & Now
        removeColFromArray = False
        Exit Function
    End If
    
    'arr�̗񐔂����폜��̎w��Y�������傫���ꍇ�G���[
    If colIndex > UBound(arr, 2) Then
        Debug.Print "err ::: colIndex(" & colIndex & ") is too big [func:removeColFromArray()] " & Now
        removeColFromArray = False
        Exit Function
    ElseIf colIndex < 1 Then
        Debug.Print "err ::: colIndex(" & colIndex & ") is not avairable [func:removeColFromArray()] " & Now
        removeColFromArray = False
        Exit Function
    End If
     
    '�Ԃ�l�p�̔z����쐬
    ReDim retArr(1 To UBound(arr, 1), 1 To UBound(arr, 2) - 1)
    
    '�Ԃ�l�p�̔z��Ƀf�[�^��ݒ�
    For i = 1 To UBound(arr, 1) Step 1
        For j = 1 To UBound(arr, 2) Step 1
            If j = colIndex Then
                '�Ȃɂ����Ȃ�
            ElseIf j < colIndex Then
                retArr(i, j) = arr(i, j)
            ElseIf j > colIndex Then
                retArr(i, j - 1) = arr(i, j)
            End If
        Next j
    Next i
    
    newArr = retArr
    removeColFromArray = True
End Function

'==================================================
'2�����z��(arr)�̎w���ɁA1��}�����l�𖄂߂�B�������2�����z���1�񑝂���B
'  [i]arr           ���ǉ�����z��
'  [i]colIndex  �}����̓Y����
'  [i]colVal    ��̒l
'  [o]newArr   �ǉ���̔z��
'--------------------------------------------------
Public Function insertColIntoArray(ByVal arr As Variant, _
                                                        ByVal colIndex As Long, _
                                                        ByVal colVal As String, _
                                                        ByRef newArr As Variant _
                                                        ) As Boolean
    Dim bRet As Boolean
    Dim dimension As Long
    Dim retArr As Variant
    Dim newRow As Long
    Dim newCol As Long

    '�z��̎��������擾 2�����z��łȂ��ꍇ�̓G���[
    bRet = getDimension(arr, dimension)
    If bRet = False Or dimension <> 2 Then
        Debug.Print "err ::: dimension ->" & dimension & " [func:insertColIntoArray()]" & Now
        insertColIntoArray = False
        Exit Function
    End If
    
     'arr�̗�+1�����}����̎w��Y�������傫���ꍇ�G���[
    If colIndex > UBound(arr, 2) + 1 Then
        Debug.Print "err ::: colIndex(" & colIndex & ") is too big [func:insertColIntoArray()] " & Now
        insertColIntoArray = False
        Exit Function
    End If
     
    '�Ԃ�l�p�̔z����쐬
    ReDim retArr(1 To UBound(arr, 1), 1 To UBound(arr, 2) + 1)
    
    '�Ԃ�l�p�̔z��Ƀf�[�^��ݒ�
    For newRow = 1 To UBound(arr, 1) Step 1
        For newCol = 1 To UBound(arr, 2) + 1 Step 1
            If newCol = colIndex Then
                retArr(newRow, newCol) = colVal
            ElseIf newCol > colIndex Then
                retArr(newRow, newCol) = arr(newRow, newCol - 1)
            Else
                retArr(newRow, newCol) = arr(newRow, newCol)
            End If
        Next newCol
    Next newRow
    
    newArr = retArr
    insertColIntoArray = True
End Function

'==================================================
'�z��(arr)�̎����������߂�
'  [i]arr           ���ǉ�����z��
'  [o]dimension         �ǉ���̔z��
'--------------------------------------------------
Private Function getDimension(ByVal arr As Variant, _
                                                    ByRef retDim As Long _
                                                    ) As Boolean
    Dim TempData As Variant
    Dim i As Long

    On Error Resume Next
    Do While ERR.Number = 0
        i = i + 1
        TempData = UBound(arr, i)
    Loop
    On Error GoTo 0
    
    retDim = i - 1
    getDimension = True
End Function

'==================================================
'2�����z��(arr)���A(newRow, newCol)��2�����z��ɐ��`���ĕԂ��B
'�l������Ȃ��v�f��Empty�ɂȂ�B
'  [i]arr       ���`����z��
'  [i]colIndex    ���`��̍s���i���R�[�h���j
'  [i]colVal    ���`��̗�i�t�B�[���h���j
'  [o]newArr       ���`��̔z��
'--------------------------------------------------
Public Function formatArray(ByVal arr As Variant, _
                            ByVal newRow As Long, _
                            ByVal newCol As Long, _
                            ByRef dat As Variant _
                            ) As Boolean
                            
    '�l��ݒ肷��ׂ́A���ۂ̃��[�v���������擾
    Dim loopRow As Long
    Dim loopCol As Long
    If UBound(arr, 1) > newRow Then
        loopRow = newRow
    Else
        loopRow = UBound(arr, 1)
    End If
    If UBound(arr, 2) > newCol Then
        loopCol = newCol
    Else
        loopCol = UBound(arr, 2)
    End If
    
    '2�����z��𐮌`
    Dim retTmpBucket As Variant
    ReDim retTmpBucket(1 To newRow, 1 To newCol)
    Dim i As Long
    Dim j As Long
    For i = 1 To loopRow Step 1
        For j = 1 To loopCol Step 1
            retTmpBucket(i, j) = arr(i, j)
        Next j
    Next i

    dat = retTmpBucket
    formatArray = True
End Function

'==================================================
'2�����z��(arr)���A2�����z��(dat)�ɒǉ����ĕԂ�
'indexRow�Ŏw�肳�ꂽ������arr�ŏ��̃��R�[�h�̓Y�����Ƃ���dat�ɒǉ�����B
'  [i]arr        �ǉ�����z��
'  [i]indexRow    �ǉ�����ۂ̐擪���R�[�h�̓Y����
'  [i/o]dat       �ǉ������e�z��
'  [o]row         �ǉ���̍ŏI���R�[�h�̓Y����
'--------------------------------------------------
Public Function addArray(ByVal arr As Variant, _
                            ByVal indexRow As Long, _
                            ByRef dat As Variant, _
                            ByRef row As Long) As Boolean
    Dim rowArr As Long
    Dim colArr As Long
    Dim rowDat As Long
    Dim colDat As Long
    
    rowArr = UBound(arr, 1)
    colArr = UBound(arr, 2)
    rowDat = UBound(dat, 1)
    colDat = UBound(dat, 2)
    
    'dat��arr�����Ă��I�[�o�[�t���[���Ȃ����`�F�b�N
    If rowDat < rowArr + indexRow - 1 Then
        Debug.Print "err ::: not enough ROW size. [func:combineArray()]" & Now
        addArray = False
        Exit Function
    End If
    If colDat < colArr Then
        Debug.Print "err ::: not enough COLUMN size. [func:combineArray()]" & Now
        addArray = False
        Exit Function
    End If
    
    'arr�̒��g��dat�ɓ����
    Dim i As Long
    Dim j As Long
    For i = 1 To rowArr Step 1
        For j = 1 To colArr
            dat(indexRow + i - 1, j) = arr(i, j)
        Next j
    Next i
    row = indexRow + rowArr - 1
    addArray = True
End Function



'==================================================
'2��2�����z����s(row)�����ɑ������킹��
'  [i]arr1        �z��1
'  [i]arr2        �z��2
'  [i/o]dat     ��������̔z��
'  [o]row        ��������̍ŏI���R�[�h�̓Y����
'--------------------------------------------------
Public Function add2Arrays(ByVal arr1 As Variant, _
                                            ByVal arr2 As Variant, _
                                            ByRef dat As Variant, _
                                            ByRef row As Long) As Boolean
    Dim rowArr1, colArr1, rowArr2, colArr2, newRow, newCol As Long
    Dim datTmp As Variant
    
    rowArr1 = UBound(arr1, 1)
    colArr1 = UBound(arr1, 2)
    rowArr2 = UBound(arr2, 1)
    colArr2 = UBound(arr2, 2)
    
    newRow = rowArr1 + rowArr2
    If colArr1 > colArr2 Then
      newCol = colArr1
    Else
      newCol = colArr2
    End If
    ReDim datTmp(1 To newRow, 1 To newCol)
    
    Dim i As Long
    Dim j As Long
    For i = 1 To rowArr1 Step 1
        For j = 1 To colArr1
            datTmp(i, j) = arr1(i, j)
        Next j
    Next i
    
    For i = 1 To rowArr2 Step 1
        For j = 1 To colArr2
            datTmp(rowArr1 + i, j) = arr2(i, j)
        Next j
    Next i
    
    dat = datTmp
    row = newRow
End Function

