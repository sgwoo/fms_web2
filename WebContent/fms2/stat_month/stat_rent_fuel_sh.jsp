<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript">
<!--
	//검색
	function Search()
	{
		var fm = document.form1;
		
		if(fm.s_yy.value == '' && fm.s_mm.value != '') fm.s_yy.value = '';
		
		fm.target = "c_foot";		
		fm.action = 'stat_rent_fuel_sc_d.jsp';
		
		if(fm.s_yy.value == '' && fm.s_mm.value == '') fm.action = 'stat_rent_fuel_sc_y.jsp';
		if(fm.s_yy.value != '' && fm.s_mm.value == '') fm.action = 'stat_rent_fuel_sc_m.jsp';		

		fm.submit();
	}
	
	function save()
	{
		var fm = document.form1;	
		
		if(fm.s_yy.value == '' && fm.s_mm.value != '') fm.s_yy.value = '';
		
		fm.target = '_blank';
		
		fm.action = 'stat_rent_fuel_sc_d_prn.jsp';
		
		if(fm.s_yy.value == '' && fm.s_mm.value == '') fm.action = 'stat_rent_fuel_sc_y_prn.jsp';
		
		if(fm.s_yy.value != '' && fm.s_mm.value == '') fm.action = 'stat_rent_fuel_sc_m_prn.jsp';		
		
		fm.submit();
	}
	
$(document).ready(function(){
	$("#test_btn").on("click", function(){
		
	});
	
});	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin=15>
<form name="form1" method="POST">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='user_id'	value='<%=user_id%>'>
		
	<div class="navigation" style="margin-bottom:0px !important">
		<span class="style1">경영정보> 영업관리> </span><span class="style5"></span>
	</div>
	<div class="search-area" style="padding-bottom: 100px;">
		<label><i class="fa fa-check-circle"></i>&nbsp;기준일자</label>
		<select name="s_yy" class="select">
			<option value="" <%if(s_yy.equals("")){%>selected<%}%>>전체</option>						
				<%for(int i=2000; i<=AddUtil.getDate2(1); i++){%>
			<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
				<%}%>
		</select>	
		<select name="s_mm" class="select">
			<option value="" <%if(s_mm.equals("")){%>selected<%}%>>전체</option>												
				<%for(int i=1; i<=12; i++){%>
			<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
				<%}%>
		</select>	 
		 <input type="button" class="button btn-default" value="검색" onclick="javascript:Search();">
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 <input type="button" class="button btn-submit" value="Excel" onclick="javascript:save();">
	</div>
	

<!-- 기존의 검색기능 바 폼-->
<%-- <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 영업현황 > <span class=style5>차종별계약현황</span></span></td>
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
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						<select name="s_yy">
							<option value="" <%if(s_yy.equals("")){%>selected<%}%>>전체</option>						
			  			<%for(int i=2000; i<=AddUtil.getDate2(1); i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
	        			<select name="s_mm">
							<option value="" <%if(s_mm.equals("")){%>selected<%}%>>전체</option>												
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          			<%}%>
	        			</select>             			  
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
						  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:save()" id="test_btn"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>                        
        </td>
    </tr>
</table> --%>
</form>
</body>
</html>