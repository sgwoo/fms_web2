<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//기존차량 선택시 보유차 검색 페이지
	
	String taecha	=  request.getParameter("taecha")==null?"":request.getParameter("taecha");
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String car_st 	=  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd 	=  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String s_kd 	=  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(t_wd.equals("")) car_cd="";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select_car(rent_mng_id, rent_l_cd, car_comp_id, car_mng_id, car_no, off_ls, car_nm, car_name, deli_dt, rent_s_cd){		
		var fm = document.form1;
		if(off_ls != '0'){
			alert("매각 진행중인 차량입니다.\n\n오프리스에서 매각취소 하십시오.");
		}
		fm.action='search_res_car_a.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd+'&car_comp_id='+car_comp_id+'&car_mng_id='+car_mng_id+'&car_no='+car_no+'&car_nm='+car_nm+'&car_name='+car_name+'&deli_dt='+deli_dt+'&rent_s_cd='+rent_s_cd;
		fm.target='i_no';
		fm.submit();
	}	
	function search(){
		document.form1.mode.value = 'AFTER';
		document.form1.target = 'inner';
		document.form1.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
//-->
</script>
</head>
<body leftmargin="15" javascript="document.form1.t_wd.focus();">
<form name='form1' action='search_res_car_in.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<input type='hidden' name='taecha' value='<%=taecha%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan='2'>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>기존차량 리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td  colspan='2' class=h></td>
    </tr>
	<tr>
	    <td colspan='2'>
    		&nbsp;&nbsp;<select name='s_kd'>
    		  <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
    		  <option value='1' <%if(s_kd.equals("1") || s_kd.equals("")){%> selected <%}%>>차량번호</option>
    		  <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>차명</option>
    		  <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>보유차상태</option>			  			  
    		  <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>보유차상호</option>			  			  
    		</select>
		    <input type='text' name='t_wd' size='15' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>
		    <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
	    </td>
	</tr>
	<tr>
        <td colspan='2' class=h></td>
    </tr>
	<tr>
	    <td class='line' width='780'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <tr>
        			<td class='title' rowspan='2' width='50'>연번</td>
        			<td class='title' rowspan='2' width='100'>차량번호</td>
        			<td class='title' rowspan='2' width='270'>차명</td>
        			<td class='title' colspan='3'>보유차</td>
    		    </tr>
    		    <tr>
        			<td class='title' width='80'>상태</td>
        			<td class='title' width='150'>상호</td>
        			<td class='title' width='130' >배차일</td>															
    		    </tr>				
    		</table>
	    </td>
	    <td width='20'>&nbsp;</td>
	</tr>
	<tr>
	    <td colspan='2'>
		    <iframe src="./search_res_car_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&mode=<%=mode%>&car_st=<%=car_st%>&car_cd=<%=car_cd%>&client_id=<%=client_id%>" name="inner" width="780" height="430" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
	    </td>
	</tr>
	<tr>
	    <td colspan='2'>* 예약시스템에 지연대차로 등록된 차량만 검색됩니다. </td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>

