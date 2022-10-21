<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>

<%
	String action = request.getParameter("action")==null?"":request.getParameter("action");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String t_fst_pay_amt = request.getParameter("t_fst_pay_amt")==null?"":request.getParameter("t_fst_pay_amt");
	
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
		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 						return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('엑셀파일이 아닙니다.');						return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
		if(fm.action == ''){							alert('작업이 명확하지 않습니다.');					return; 	}
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='<%=action%>' method='post' enctype="multipart/form-data">
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='t_fst_pay_amt' value='<%=t_fst_pay_amt%>'>
    <table border="0" cellspacing="0" cellpadding="0" width=570>
        <tr> 
            <td> <font color="red">[ 엑셀파일을 이용한 일괄 처리  ] : <%if(action.equals("scd_alt.jsp")){%>할부금상환스케줄 재등록<%}else if(action.equals("scd_alt_int.jsp")){%>할부금상환스케줄 이자 재등록<%}else{%>자동차세환급 처리<%}%></font></td>
        </tr>
        <tR>
            <td class=line2></td>
        </tr>
        <tr>
            <td align="right" class="line">
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                    <tr>
                        <td width="15%" class='title'>파일</td>
                        <td>&nbsp;
        			        <input type="file" name="filename" size="50">
                        </td>
                    </tr>
                </table>
		    </td>
        </tr>
        <tr>
            <td align="center">* 파일확장자 <b>*.xls</b> 인 파일만 가능합니다.</td>
        </tr>
        <tr>
            <td align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		    <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
        </tr>
    </table>
</form>
</center>
</body>
</html>
