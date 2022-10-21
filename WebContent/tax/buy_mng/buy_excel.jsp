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
		
		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 				return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('엑셀파일이 아닙니다.');				return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
		
		
		if(fm.gubun1[0].checked == true){				fm.action = 'buy_excel_reg_type1.jsp';				}
		else if(fm.gubun1[1].checked == true){			fm.action = 'buy_excel_reg_type1.jsp';				}							
		else{											alert('구분을 선택하십시오.');		return;				}
		
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
<table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
        <td> <font color="red">[ 엑셀파일을 이용한 매입계산서 전표처리  ]</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="200" class='title'>파일</td>
                    <td>&nbsp;<input type="file" name="filename" size="50"></td>
                </tr>
                <!-- 
                <tr>
                    <td class='title'>회계일자</td>
                    <td>&nbsp;<input type="text" name="doc_dt" value="<%=AddUtil.getDate()%>" size="11" maxlength='10' class='default' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                 -->
                <tr>
                    <td class='title'>구분</td>
                    <td>		   
                        <input type="radio" name="gubun1" value="1" checked>
                        <b>롯데오토리스[대출금] 부가세대급금 차대변금액없음 </b>                                                
                    </td>
                </tr>		
                <tr>
                    <td class=line2></td>
                </tr>			              
                <tr tr id=tr_etc style='display:none'>
                    <td>			   
                        &nbsp;<br>	
                        <input type="radio" name="gubun1" value="2">
                        <b>집금 </b> 
                    </td>
                </tr>	
            </table>
        </td>
    </tr>        
    <tr>
        <td><font color=red>* 홈텍스에서 다운로드한 엑셀파일로 실입력데이터는 <b>7행</b>부터입니다. </font></td>
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
