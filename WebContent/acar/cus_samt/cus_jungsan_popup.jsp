<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cus_samt.*, acar.util.*"%>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%//@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
	
	//정비정보
	s_bean = cs_db.getServiceId(car_mng_id,serv_id );	
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
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'cus_jungsan_popup_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.jung_st.focus()">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 정비비 현황 > <span class=style5><%=s_bean.getCar_no()%> 정산회차 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width="80">회차</td>
                    <td> 
                      <input type="text" name="jung_st" value="<%=s_bean.getJung_st_r()%>" size="10" class=text >
                    </td>
                </tr>
                <tr> 
                    <td class=title width="80">정산일</td>
                    <td> 
                      <input type="text" name="set_dt" value="<%=s_bean.getSet_dt()%>" size="10" class=text >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:save();"><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
        <a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
