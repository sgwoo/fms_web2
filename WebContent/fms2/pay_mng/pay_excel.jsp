<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;
		
		if(fm.filename.value == ''){				alert('파일을 선택하십시오.'); 				return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('엑셀파일이 아닙니다.');				return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){		alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
		
		
		if(fm.gubun1[0].checked == true){			fm.action = 'pay_excel_reg_step1.jsp';				}
		else if(fm.gubun1[1].checked == true){			fm.action = 'pay_excel_reg_bank_step1.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>';			}						
	
		else{							alert('구분을 선택하십시오.');		return;			}
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;

		fm.submit();
		
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td> <font color="red">[ 엑셀파일을 이용한 집금/출금 처리  ]</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="40" class='title'>파일</td>
                    <td>&nbsp;<input type="file" name="filename" size="50"></td>
                </tr>
                <tr>
                    <td rowspan="23" class='title'>구분</td>
                    <td>	
                        &nbsp;<br>		   
                        <input type="radio" name="gubun1" value="1">
                        <b>출금 </b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!--<td style="font-size : 8pt;" class="title">①증권번호</td>
                                <td style="font-size : 8pt;" class="title">②차량번호</td>
                                <td style="font-size : 8pt;" class="title">③대인배상Ⅰ</td>
                                <td style="font-size : 8pt;" class="title">④대인배상Ⅱ</td>
                                <td style="font-size : 8pt;" class="title">⑤대물배상</td>
                                <td style="font-size : 8pt;" class="title">⑥자기신체사고</td>
                                <td style="font-size : 8pt;" class="title">⑦무보험차상해</td>
                                <td style="font-size : 8pt;" class="title">⑧분담금할증한정</td>
                                <td style="font-size : 8pt;" class="title">⑨자기차량손해</td>
                                <td style="font-size : 8pt;" class="title">⑩애니카</td>-->
                               
                            </tr>
                        </table>
                        <br>&nbsp;
                    </td>
                </tr>		
                <tr>
                    <td class=line2></td>
                </tr>			
              
                <tr>
                    <td>			   
                        &nbsp;<br>	
                        <input type="radio" name="gubun1" value="2">
                        <b>집금 </b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①상태</td>
                                <td style="font-size : 8pt;" class="title">②실행여부</td>
                                <td style="font-size : 8pt;" class="title">③집금일자</td>
                                <td style="font-size : 8pt;" class="title">④집금시간</td>
                                <td style="font-size : 8pt;" class="title">⑤집금구분</td>
                                <td style="font-size : 8pt;" class="title">⑥집금단계</td>
                                <td style="font-size : 8pt;" class="title">⑦자계좌은행</td>
                                <td style="font-size : 8pt;" class="title">⑧자계좌번호</td>
                                <td style="font-size : 8pt;" class="title">⑨무계좌은행</td>
                                <td style="font-size : 8pt;" class="title">⑩무계좌번호</td>
                                <td style="font-size : 8pt;" class="title">집금유형</td>
                                <td style="font-size : 8pt;" class="title">⑫집금의뢰액</td>
                                <td style="font-size : 8pt;" class="title">⑬집금액</td>
                                <td style="font-size : 8pt;" class="title">⑭수수료</td>
                                <td style="font-size : 8pt;" class="title">⑮지불가능잔액(이체전)</td>
                                <td style="font-size : 8pt;" class="title">⑮실행결과메세지</td>
                         
                            </tr>
                        </table>
                        <br>&nbsp;
                    </td>
                </tr>	
              
    <tr>
        <td align="right">
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
	</td>
    </tr>
</table>
</form>
</center>
</body>
</html>
