<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_br 	= request.getParameter("s_br")==null?"":request.getParameter("s_br");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트
	int brch_size 	= branches.size();	
	
%>

<html> 
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//검색
	function Search()
	{
		var fm = document.form1;
		
		if(fm.s_yy.value == '' && fm.s_mm.value != '') fm.s_yy.value = '';
		
		fm.target = "c_foot";		
		fm.action = 'rent_stat1_sc.jsp';	
		fm.submit();
	}
	
	function save()
	{
		var fm = document.form1;
		
		if(fm.s_yy.value == '' && fm.s_mm.value != '') fm.s_yy.value = '';
			
		fm.target = '_blank';		
		fm.action = 'rent_stat1_sc.jsp';								
		fm.submit();
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin=15>
<form name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class="style1">예약시스템 > 영업지원 > <span class="style5">일일영업현황</span></span></td>
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
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<!--기간-->
                    	<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
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
            		&nbsp;&nbsp;
            		<!--영업소코드-->
            		<img src=/acar/images/center/arrow_yuscd.gif align=absmiddle>&nbsp;
            		<select name='s_br'>
              		<option value=''>전체</option>
                        <%if(brch_size > 0){
    				for (int i = 0 ; i < brch_size ; i++){
    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
    		        }%>	
            		</select>
            		&nbsp;&nbsp;
            		<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>