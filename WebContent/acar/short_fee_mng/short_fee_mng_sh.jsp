<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*" %>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	Vector vt = sfm_db.getSectionRegDtList();
	int vt_size = vt.size();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.target = "c_foot";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="short_fee_mng_sc.jsp" name="form1" method="post">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 차종관리 > <span class=style5>단기대여요금관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
	<tr>
        <td>			
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>					
                    <td width="300"><img src=../images/center/arrow_gjgji.gif align=absmiddle>
                        <select name="gubun1">
        			  	<%if(vt_size > 0){
							for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);%>
        				  <option value="<%=ht.get("REG_DT")%>" <%if(gubun1.equals(String.valueOf(ht.get("REG_DT"))))%>selected<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></option>
        			  	<%	}%>				
        			  	<%}%>										
                      	</select>
					  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      	<a href="javascript:Search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>	
</table>
</form>
</body>
</html>