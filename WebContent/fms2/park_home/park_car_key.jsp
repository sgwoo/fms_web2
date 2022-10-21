<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.parking.*, acar.util.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	
		
	//차량정보
	Hashtable ht =  pk_db.getParkCarKeyInfo(c_id);
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		//if(get_length(fm.car_key_cau.value) > 5){		
		//	alert("5자 까지만 입력할 수 있습니다.");		return;		}
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'park_car_key_a.jsp';
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
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%>  Key 정보</span>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="25%">유무</td>
                    <td>
			<input type='radio' name='car_key' value="O"  <%if(String.valueOf(ht.get("CAR_KEY")).equals("O")){%>checked <%}%>>유
			<input type='radio' name='car_key' value="X" <%if(String.valueOf(ht.get("CAR_KEY")).equals("X")){%>checked onfocus="car_key_cau"<%}%>>무
        	        </td>
    		    </tr>		
                <tr> 
                   <td class=title width=25%>사유</td>
		<td>&nbsp;<input type='text' name="car_key_cau" size='70' class='text' value='<%=String.valueOf(ht.get("CAR_KEY_CAU"))%>' ></td>
                </tr>
            </table>
        </td>
    </tr>
  
    <tr> 
        <td align="right">
		<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		<a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
		<%}%>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
