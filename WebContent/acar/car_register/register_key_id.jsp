<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*" %>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	String white = "";
	
	CarKeyBn = CarMngDb.getCarKey(car_mng_id);
	
	if(cmd.equals("ud")) white = "white";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function CarKeyUp()
{
	var fm = document.form1;
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	fm.cmd.value = "u";
	fm.target = "nodisplay"
	fm.submit();
}

function cnt_display(st){
	var fm = document.form1;
	if(st == 'y'){
		tr_y1.style.display	= '';
		tr_y2.style.display	= '';	
		fm.key_kd1.value = '<%=CarKeyBn.getKey_kd1()%>';	
		fm.key_kd2.value = '<%=CarKeyBn.getKey_kd2()%>';	
		fm.key_kd3.value = '<%=CarKeyBn.getKey_kd3()%>';
		fm.key_kd4.value = '<%=CarKeyBn.getKey_kd4()%>';
		fm.key_kd5.value = '<%=CarKeyBn.getKey_kd5()%>';					
	}else{
		tr_y1.style.display	= 'none';
		tr_y2.style.display	= 'none';	
		fm.key_kd1.value = '0';	
		fm.key_kd2.value = '0';	
		fm.key_kd3.value = '0';
		fm.key_kd4.value = '0';
		fm.key_kd5.value = '0';									
	}
}
//-->
</script>
</head>
<body leftmargin="15">
<form action="./register_key_ui.jsp" name="form1" method="POST" >
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>예비키</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width=20% class=title>보유여부</td>
                    <td colspan="4" >&nbsp; 
        			  <input type="radio" name="key_yn" value="Y" onclick="javascript:cnt_display('y')" <%if(CarKeyBn.getKey_yn().equals("Y"))%>checked<%%>>
                      유 
                      <input type="radio" name="key_yn" value="N" onclick="javascript:cnt_display('n')" <%if(CarKeyBn.getKey_yn().equals("N"))%>checked<%%>>
                      무 </td>
                </tr>
                <tr id=tr_y1 style="display:<%if(CarKeyBn.getKey_yn().equals("Y")) {%>''<%} else{%>none<%}%>"> 
                    <td width=19% class=title>일반보조키</td>
                    <td width=19% class=title>카피보조키</td>
                    <td width=18% class=title>리모콘</td>
                    <td width=19% class=title>스마트키</td>
                    <td width=25% class=title>기타(
                      <input type="text" name="key_kd5_nm" value="<%=CarKeyBn.getKey_kd5_nm()%>" size="18" class=<%=white%>text>
                      )</td>
                </tr>
                <tr id=tr_y2 style="display:<%if(CarKeyBn.getKey_yn().equals("Y")) {%>''<% } else {%>none<%}%>"> 
                    <td align="center"><input type="text" name="key_kd1" value="<%=CarKeyBn.getKey_kd1()%>" size="5" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd2" value="<%=CarKeyBn.getKey_kd2()%>" size="5" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd3" value="<%=CarKeyBn.getKey_kd3()%>" size="5" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd4" value="<%=CarKeyBn.getKey_kd4()%>" size="5" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd5" value="<%=CarKeyBn.getKey_kd5()%>" size="5" class=<%=white%>num>
                      개</td>
                </tr>
            </table>
        </td>
    </tr>
	<%	if(cmd.equals("udp")){%>
    <tr>
    	<td align="right"><a href="javascript:CarKeyUp()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a></td>
    </tr>
 	<%	}%>
</table>
</form>
</body>
</html>