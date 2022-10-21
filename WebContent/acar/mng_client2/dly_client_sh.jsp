<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//관리현황
	Vector deb1s = ad_db.getStatDebtList("stat_rent_month");
	int deb1_size = deb1s.size();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchRentCond()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchRentCond();
}


//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>

<form action="./dly_client_sc.jsp" name="form1" method="POST" target="c_foot">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 영업관리 > <span class=style5>거래처연체현황</span></span></td>
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
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gggb.gif align=absmiddle>
                      &nbsp;<select name="gubun3">
                        <option value="">전체</option>
                        <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>1개월연체고객</option>
                        <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>2개월연체고객</option>
                        <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>3개월연체고객</option>				
                        </select>
			            &nbsp;&nbsp;&nbsp;마감일시:
			            <select name="gubun2">
			<%	if(deb1_size > 0){
				    for(int i = 0 ; i < deb1_size ; i++){
						StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>		
			<option value="<%=sd.getSave_dt()%>"><%=sd.getReg_dt()%></option>		
			<%		}
				}%>
		</select>
		                 &nbsp;&nbsp;&nbsp;검색어:
            			  <select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>업태/종목 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>영업담당자 </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차종 </option>
                        </select>
                        &nbsp;&nbsp;&nbsp;
            			<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            			
            			  &nbsp;<a href="javascript:SearchRentCond()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
    <input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
</body>
</html>