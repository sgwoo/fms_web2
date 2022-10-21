<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	Vector CodeList = FineDocDb.getZipSido();
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="../../include/table_ts.css">
</head>

<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//시/구/군 조회
	function cng_sido(){
		var fm = document.form1;
		fm.action = "get_gugun.jsp";
		fm.target = "i_no";
		fm.submit();	
	}	
	//등록하기
	function fine_reg(){
		window.open("fine_gov_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>", "REG_FINE_GOV", "left=200, top=200, width=550, height=500, scrollbars=yes");
	}
	//검색하기	
	function search(){
		var fm = document.form1;
		fm.action = "fine_gov_sc.jsp";
		fm.target = "c_foot";
		fm.submit();	
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
//-->
</script>
<body>
<form name='form1' method='post'>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 과태료관리 > <span class=style5>청구기관관리</span></span></td>
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
                    <td width=27%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jy.gif align=absmiddle>&nbsp;
                      <select name="gubun1" onChange="javascript:cng_sido()">
        			    <option value="">광역시/도</option>
        			<%	if(CodeList.size() > 0){
        					for(int i = 0 ; i < CodeList.size() ; i++){
        						Hashtable ht = (Hashtable)CodeList.elementAt(i);	%>
        				<option value='<%= ht.get("SIDO") %>' <%if(gubun1.equals((String)ht.get("SIDO"))){%>selected<%}%>><%= ht.get("SIDO") %></option>			
        			<%		}
        				}%>
                      </select>
                      <select name="gubun2">
        			    <option value="">시/구/군</option>			  
                      </select>			  
                      </td>
                    <td width=30%><img src=/acar/images/center/arrow_cgggm.gif align=absmiddle>&nbsp;
                      <input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                    </td>
                    <td width=35%> <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a> 
                    </td>
                    <td align="right"><a href='javascript:fine_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
