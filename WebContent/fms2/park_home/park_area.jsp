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
	String park_nm = request.getParameter("park_nm")==null?"":request.getParameter("park_nm");
			
	//��������
	Hashtable ht =  pk_db.getParkAreaInfo(c_id);
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
$(document).ready(function(){
	parkAreaSetting();
});

//�����ϱ�
function save(){
	var fm = document.form1;
	//if(get_length(fm.car_key_cau.value) > 5){		
	//	alert("5�� ������ �Է��� �� �ֽ��ϴ�.");		return;		}
	if($("#area").val()==""){
		alert("������ �������ּ���.");
		return;
	}
	if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
	fm.action = 'park_area_a.jsp';
	fm.target = 'i_no';
	fm.submit();			
}
	
//��������
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

//������������ ������ ���� ����ȭ
function parkAreaSetting(){
	var park_nm = '<%=park_nm%>';
	var area_type1 = "";
	var area_type2 = "";
	area_type1 += '<option value=""selected>����</option>		<OPTION VALUE="A" >A����</option>' +
				  '<OPTION VALUE="B" >B����</option>			<OPTION VALUE="C" >C����</option>' +
				  '<OPTION VALUE="D" >D����</option>			<OPTION VALUE="E" >E����</option>' +
				  '<OPTION VALUE="F" >F����</option>			<OPTION VALUE="G" >G����</option>' +
				  '<OPTION VALUE="H" >H����</option>';
    area_type2 += '<option value=""selected>����</option>		<OPTION VALUE="3A" >3��A����</option>' +
  				  '<OPTION VALUE="3B" >3��B����</option>		<OPTION VALUE="3C" >3��C����</option>' +
	  			  '<OPTION VALUE="4A" >4��A����</option>		<OPTION VALUE="4B" >4��B����</option>' +
				  '<OPTION VALUE="4C" >4��C����</option>		<OPTION VALUE="5A" >5��A����</option>' +
				  '<OPTION VALUE="5B" >5��B����</option>		<OPTION VALUE="5C" >5��C����</option>' +
				  '<OPTION VALUE="F" >F����</option>			<OPTION VALUE="G" >G����</option>' +		
				  '<OPTION VALUE="H" >H����</option>';
				  
	if(park_nm=="����������"){		$("#area").html(area_type2);	}
	else{						$("#area").html(area_type1);	}
	var area = '<%=ht.get("AREA")%>';
	$("#area option[value='"+area+"']").prop("selected",true);
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%>  �������� ����</span>
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
					<td class=title width=25%>����</td>
					<td>&nbsp;<SELECT NAME="area" id="area">
										<option value="" <%if(String.valueOf(ht.get("AREA")).equals("")){%> selected <%}%>>����</option>
										<OPTION VALUE="A" <%if(String.valueOf(ht.get("AREA")).equals("A")){%> selected <%}%>>A</option>
										<OPTION VALUE="B" <%if(String.valueOf(ht.get("AREA")).equals("B")){%> selected <%}%>>B</option>
										<OPTION VALUE="C" <%if(String.valueOf(ht.get("AREA")).equals("C")){%> selected <%}%>>C</option>
										<OPTION VALUE="D" <%if(String.valueOf(ht.get("AREA")).equals("D")){%> selected <%}%>>D</option>
										<OPTION VALUE="E" <%if(String.valueOf(ht.get("AREA")).equals("E")){%> selected <%}%>>E</option>
										<OPTION VALUE="F" <%if(String.valueOf(ht.get("AREA")).equals("F")){%> selected <%}%>>F</option>
										<OPTION VALUE="G" <%if(String.valueOf(ht.get("AREA")).equals("G")){%> selected <%}%>>G</option>
										<OPTION VALUE="H" <%if(String.valueOf(ht.get("AREA")).equals("H")){%> selected <%}%>>H</option>
										<OPTION VALUE="I" <%if(String.valueOf(ht.get("AREA")).equals("I")){%> selected <%}%>>I</option>
										<OPTION VALUE="J" <%if(String.valueOf(ht.get("AREA")).equals("J")){%> selected <%}%>>J</option>
										<OPTION VALUE="K" <%if(String.valueOf(ht.get("AREA")).equals("K")){%> selected <%}%>>K</option>
										<OPTION VALUE="L" <%if(String.valueOf(ht.get("AREA")).equals("L")){%> selected <%}%>>L</option>
										<OPTION VALUE="M" <%if(String.valueOf(ht.get("AREA")).equals("M")){%> selected <%}%>>M</option>
										<OPTION VALUE="N" <%if(String.valueOf(ht.get("AREA")).equals("N")){%> selected <%}%>>N</option>
										
								</SELECT>&nbsp;&nbsp;&nbsp;
								
								</td>
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
