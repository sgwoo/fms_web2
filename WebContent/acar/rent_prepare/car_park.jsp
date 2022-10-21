<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");

	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String mng_br_id = request.getParameter("mng_br_id")==null?"":request.getParameter("mng_br_id");

	CommonDataBase c_db = CommonDataBase.getInstance();

	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "04", "01");

	//차량정보
	Hashtable res = rs_db.getCarInfo(c_id);

	//주차장 정보
	CodeBean[] goods = c_db.getCodeAll("0027");
	int good_size = goods.length;
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
		if(fm.park.value == '6' && fm.park_cont.value == ''){ alert('상세내용을 입력하십시오.'); return; }
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'car_park_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}

	function search_cons_list(){
		var fm = document.form1;
		var SUBWIN="/acar/rent_diary/car_cons_list.jsp?c_id="+fm.c_id.value+"&auth_rw="+fm.auth_rw.value;
		window.open(SUBWIN, "CarCons", "left=150, top=150, width=850, height=600, scrollbars=yes, status=yes");
	}
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.park.focus()">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='mng_br_id' value='<%=mng_br_id%>'>

<table border=0 cellspacing=0 cellpadding=0 width=400>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> 차량위치</span>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:search_cons_list();" title='<%=car_no%> 탁송이력'>[탁송현황]</a>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="20%">현위치</td>
                    <td>
						<SELECT NAME="park" >
							<%
								for(int i = 0 ; i < good_size ; i++){
								CodeBean good = goods[i];
								if(good.getUse_yn().equals("Y")){ %>
									<option value='<%= good.getNm_cd()%>' <%if(String.valueOf(res.get("PARK")).equals(good.getNm_cd())){%> selected<%}%>><%= good.getNm()%></option>
								<%}%>
							<%}%>
        		        </SELECT>
        	        </td>
    		    </tr>
                <tr>
                    <td class=title>상세내용</td>
                    <td>
                        <textarea name="park_cont" cols="40" class="text" rows="5"><%=res.get("PARK_CONT")%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>* 현위치를 기타로 선택할 경우에는 상세내용에 내용을 입력하십시오.<br>&nbsp;&nbsp;(예를들어 고객명 등등)</td>
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
