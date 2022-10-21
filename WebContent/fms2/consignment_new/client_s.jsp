<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cust_st 	= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_start_dt= request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "01");
	
	String h_con 	= request.getParameter("h_con")==null?"1":request.getParameter("h_con");
	String h_wd 	= request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	
	if(cust_st.equals("4")) h_con = "2";
//	if(rent_st.equals("1") && h_con.equals("")) 			h_con = "2";
//	else if(!rent_st.equals("1") && h_con.equals("")) 		h_con = "1";
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	function select(rent_l_cd, idx, age_scp, car_no){		
		window.opener.select(rent_l_cd, idx, age_scp, car_no);				
		self.close();			
	}
	
	function search(){
		var fm = document.form1;
		fm.h_con.value = fm.s_con.options[fm.s_con.selectedIndex].value;
		fm.h_wd.value =  fm.t_wd.value;
		fm.action='client_s_in.jsp';
		fm.target='inner';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
	//등록
	function save(){
		var fm = document.form1;
		fm.action='client_i_p.jsp';
		fm.target='CLIENT_SEARCH';
		fm.submit();
	}	
	
	//대여일수 구하기
	function getRentTimeChk(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  		// 1시간
		lm = 60*1000;  	 	 	// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}		
</script>
</head>

<body onLoad="javascript:document.form1.t_wd.focus();">
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<input type='hidden' name='cust_st' value='<%=cust_st%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > <span class=style5>고객검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td>			
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td align='left' width="80%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
                        <select name='s_con'>
                          <option value='1' <%if(h_con.equals("1")){%> selected <%}%>>상호 
                          </option>
                          <option value='2' <%if(h_con.equals("2")){%> selected <%}%>>성명</option>
                          <option value='3' <%if(h_con.equals("3")){%> selected <%}%>>생년월일/사업자번호</option>
                          <%if(!rent_st.equals("1")){%>
                          <option value='4' <%if(h_con.equals("4")){%> selected <%}%>>차량번호</option>
                          <%}%>
                        </select>
                        <input type='text' name='t_wd' size='15' class='text' value='<%=h_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                        <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
                    </td>
                    <td align='right' width="20%">
    			    <%if(rent_st.equals("1") || rent_st.equals("9")){%>
    				  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>			  
    			    <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>
    				  <%}%>
    			    <%}%>
    			    </td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
	    <td>
		    <iframe src="<%if(!h_wd.equals("")){%>client_s_in.jsp?rent_st=<%=rent_st%>&h_con=<%=h_con%>&h_wd=<%=h_wd%>&cust_st=<%=cust_st%><%}%>" name="inner" width="100%" height="600" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </td>
	</tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
