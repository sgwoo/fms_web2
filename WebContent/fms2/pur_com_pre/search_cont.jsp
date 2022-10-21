<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//계약조회 페이지
	
	String car_off_nm = request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
	String com_con_no = request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String bus_nm 	= request.getParameter("bus_nm")==null?"":request.getParameter("bus_nm");
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	user_bean 	= umd.getUsersBean(ck_acar_id);
	
	int count = 0;
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function set_cont(rent_l_cd)
	
	{
		var fm = document.form1;
		
		window.opener.form1.rent_l_cd.value 		= rent_l_cd;
		window.close();
	}
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') save();
	}	
//-->
</script>
</head>
<body onload="javascript:document.form1.swd.focus();">
<p>
<form name='form1' action='search_cont.jsp' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > <span class=style5>계약검색</span></span></td>
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
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="13%" class='title'> 출고영업소 </td>
					<td>&nbsp;
						<input type='text' name='car_off_nm' size='20' class='text' value='<%=car_off_nm%>' style='IME-MODE: active'>
						
				  </td>
				</tr>
				<tr>
					<td width="13%" class='title'> 계출번호 </td>
					<td>&nbsp;
						<input type='text' name='com_con_no' size='20' class='text' value='<%=com_con_no%>' style='IME-MODE: inactive'>
						
				  </td>
				</tr>					
				<tr>
					<td width="13%" class='title'> 차명 </td>
					<td>&nbsp;
						<input type='text' name='car_nm' size='50' class='text' value='<%=car_nm%>' style='IME-MODE: active'>
						
				  </td>
				</tr>				
				<tr>
					<td width="13%" class='title'> 최초영업자 </td>
					<td>&nbsp;
						<input type='text' name='bus_nm' size='20' class='text' value='<%=bus_nm%>' style='IME-MODE: active'>
						
				  </td>
				</tr>		
				<tr>
					<td width="13%" class='title'> 고객명 </td>
					<td>&nbsp;
						<input type='text' name='firm_nm' size='50' class='text' value='<%=firm_nm%>' style='IME-MODE: active'>
						
				  </td>
				</tr>													
			</table>
		</td>
	</tr>
	<tr>
		<td align='center'><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
	</tr>
<%	
		Vector vt = cop_db.getSearchCont(car_off_nm, com_con_no, car_nm, bus_nm, firm_nm);
		int size = vt.size();
		if(size > 0){			%>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					  <td class='title' width='5%'> 연번 </td>
					  <td width="13%" class='title'>계약번호</td>
					  <td width="7%" class='title'>계약일</td>
				    <td width="10%" class='title'>출고영업소</td>
				    <td width="10%" class='title'>계출번호</td>
				    <td width="10%" class='title'>차명</td>
				    <td width="14%" class='title'>사양</td>
				    <td width="10%" class='title'>색상</td>
				    <td width="6%" class='title'>최초계약자</td>
				    <td width="15%" class='title'>고객명</td>
				</tr>
<%			for(int i = 0 ; i < size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					//20220527 에이전트, 외근직은 1단계 이상 등록분만 연동한다.  
					//if(String.valueOf(ht.get("REG_STEP")).equals("1") && (!user_bean.getLoan_st().equals("") || acar_de.equals("1000"))){
					//	continue;
					//}
					
					count++;
%>
				<tr>
					  <td align='center'><%=count%></td>
					  <td align="center"><a href="javascript:set_cont('<%=ht.get("RENT_L_CD")%>')"><%=ht.get("RENT_L_CD")%></a></td>
					  <td align="center"><%=ht.get("RENT_DT")%></td>					
				    <td align="center"><%=ht.get("CAR_OFF_NM")%></td>
				    <td align="center"><%=ht.get("RPT_NO")%></td>
				    <td align="center"><%=ht.get("CAR_NM")%></td>
				    <td align="center"><%=ht.get("CAR_NAME")%> <%=ht.get("OPT")%></td>
				    <td align="center"><%=ht.get("COLO")%>/<%=ht.get("IN_COL")%></td>
				    <td align="center"><%=ht.get("USER_NM")%></td>
				    <td align="center"><%=ht.get("FIRM_NM")%></td>
				</tr>
<%			}
		}else{		%>
				<tr>
					<td colspan='10'> 검색된 결과가 없습니다 </td>
				</tr>
<%		}
					%>
		  </table>
		</td>
	</tr>
</table>
</body>
</html>