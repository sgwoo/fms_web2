<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.parking.*, acar.util.*"%>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String cnt_su = request.getParameter("cnt_su")==null?"":request.getParameter("cnt_su");
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = 'vacation_cnt_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
//길이점검
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}	
</script>
</head>
<body leftmargin="15" >
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연차갯수 수정</span>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
                </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                   <td class=title width=25%>연차수</td>
					<td>&nbsp;<input type='text' name="cnt_su" size='20' class='num' value='' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:save();"><img src="/acar/images/center/button_in_reg.gif" align="absmiddle" border="0"></a> 
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_cancel.gif" align="absmiddle" border="0"></a></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
		<td><br/>- 000085(김태연) 2014-08-29일까지 연차갯수 7개, 그 후 매년 (전체연차수 -1) 개로 처리<br/>
- 무급휴가 2개월이상이면 퇴직시까지 연차개수 -1 개로 수정.<br/>
- 휴직시 연차계산식 = 전체연차수 * (1 - 휴직월수/12)  으로 계산하고 반올림 없음.</td>
	</tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
