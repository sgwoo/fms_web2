<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"000071":request.getParameter("gubun1");

	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
	
%>
<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
				
//-->
</script>
</head><%@ include file="/acar/getNaviCookies.jsp" %>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>

<form name='form1' action='poll_a_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>콜등록현황</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                
                      <td width='200'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
						<select name="st_year">
							<%for(int i=2015; i<=year; i++){%>
							<option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
							<%}%>
						</select> 
						</td>
						
				    <td width='260'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
						<select name="gubun1">
                     <!--       <option value="0" <%if(gubun1.equals("0")){%>selected<%}%>>전체</option> -->
                            <option value="000071" <%if(gubun1.equals("000071")){%>selected<%}%>>콜센타(안숙영)</option>
                            <option value="000194" <%if(gubun1.equals("000194")){%>selected<%}%>>컬센타(허양숙)</option>	
                          </select>
                    </td>
              
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
										
					</td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
