<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//계약조회 페이지
	
	String car_off_nm = request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
	String car_nm = request.getParameter("car_nm")==null?"":AddUtil.replace(request.getParameter("car_nm"),"&nbsp;","");
	String opt = request.getParameter("opt")==null?"":request.getParameter("opt");
	String colo = request.getParameter("colo")==null?"":request.getParameter("colo");
	String bus_nm 	= request.getParameter("bus_nm")==null?"":request.getParameter("bus_nm");
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String o_rent_l_cd 	= request.getParameter("o_rent_l_cd")==null?"":request.getParameter("o_rent_l_cd");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	
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
	
	function set_cont(rent_mng_id, rent_l_cd)
	
	{
		opener.document.form1.rent_mng_id.value 	= rent_mng_id;
		opener.document.form1.rent_l_cd.value 		= rent_l_cd;
		
		self.window.close();
		
	}
	
//-->
</script>
</head>
<body onload="javascript:document.form1.swd.focus();">
<p>
<form name='form1' action='search_cont.jsp' method='post'>
<input type="hidden" name="o_rent_l_cd" value="<%=o_rent_l_cd%>">
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
						<%=car_off_nm%>
						<input type="hidden" name="car_off_nm" value="<%=car_off_nm%>">
				  </td>
				</tr>
				<tr>
					<td width="13%" class='title'> 차명 </td>
					<td>&nbsp;
						<%=car_nm%>
						<input type="hidden" name="car_nm" value="<%=car_nm%>">
				  </td>
				</tr>				
				<tr>
					<td width="13%" class='title'> 선택사양 </td>
					<td>&nbsp;
						<input type='text' name='opt' size='100' class='text' value='<%=opt%>' style='IME-MODE: active' >
				  </td>
				</tr>				
				<tr>
					<td width="13%" class='title'> 색상 </td>
					<td>&nbsp;
						<input type='text' name='colo' size='100' class='text' value='<%=colo%>' style='IME-MODE: active' >
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
		Vector vt = cop_db.getSearchSucCont(o_rent_l_cd, car_off_nm, car_nm, opt, colo, bus_nm, firm_nm);
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
					Hashtable ht = (Hashtable)vt.elementAt(i);	%>
				<tr>
					  <td align='center'><%=i+1%></td>
					  <td align="center"><a href="javascript:set_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("RENT_L_CD")%></a></td>
					  <td align="center"><%=ht.get("RENT_DT")%></td>					
				    <td align="center"><%=ht.get("CAR_OFF_NM")%></td>
				    <td align="center"><%=ht.get("RPT_NO")%></td>
				    <td align="center"><%=ht.get("CAR_NM")%></td>
				    <td align="center"><%=ht.get("CAR_NAME")%> <%=ht.get("OPT")%></td>
				    <td align="center"><%=ht.get("COLO")%>/<%=ht.get("IN_COL")%>/<%=ht.get("GARNISH_COL")%></td>
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
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr>
        <td>※ 출고영업소, 차명, 선택사양, 색상이 동일한 계약만 검색할 수 있습니다.</td>
    </tr>	
</table>
</body>
</html>