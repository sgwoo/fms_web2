<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_app.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"firm_nm":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"asc":request.getParameter("sort");

	if(sort_gubun.equals(""))	sort_gubun 	= "firm_nm";
	if(sort.equals(""))		sort 		= "asc";
	
	if(t_wd.equals("")) return;
	
	CusApp_Database ca_db = CusApp_Database.getInstance();
	Vector cas = ca_db.getCus_AppList(t_wd,sort_gubun,sort);	
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function cus_app_reg(c_id){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "cus_app_reg.jsp?client_id="+c_id;
		fm.submit()
	}
-->
</script>
</head>
<body>

<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <% if(cas.size()>0){
					for(int i=0; i<cas.size(); i++){
						Hashtable ca = (Hashtable)cas.elementAt(i); %>
                <tr> 
                    <td width=5% align='center'><%= i+1 %></td>
                    <td width=25% align='left'>&nbsp;<span title="<%= ca.get("FIRM_NM") %>"><a href="javascript:cus_app_reg('<%= ca.get("CLIENT_ID") %>');"><%= AddUtil.subData((String)ca.get("FIRM_NM"),11) %></a></span></td>
                    <td width=10% align='left'>&nbsp;<span title="<%= ca.get("CLIENT_NM") %>"><%= AddUtil.subData((String)ca.get("CLIENT_NM"),6) %></span></td>
                    <td width=12% align='center'><%= AddUtil.ChangeDate2((String)ca.get("RENT_DT")) %></td>
                    <td width=10% align='right'><%= ca.get("CNT") %>건&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width=9% align='center'>
                      <% String caa = (String)ca.get("CAA");
        				  									if(caa.equals("1")) out.print("원활");
        													else if(caa.equals("2")) out.print("지체");
        													else if(caa.equals("3")) out.print("불량");
        													else if(caa.equals("4")) out.print("부도"); %>
                    </td>
                    <td width=9% align='center'>
                      <% String cbb = (String)ca.get("CBB");
        				  									if(cbb.equals("1")) out.print("매우양호");
        													else if(cbb.equals("2")) out.print("양호");
        													else if(cbb.equals("3")) out.print("보통");
        													else if(cbb.equals("4")) out.print("불분명");
        													else if(cbb.equals("5")) out.print("평가불가"); %>
                    </td>
                    <td width=10% align='center'>
                      <% String ccc = (String)ca.get("CCC");
        				  									if(ccc.equals("1")) out.print("매우양호");
        													else if(ccc.equals("2")) out.print("양호");
        													else if(ccc.equals("3")) out.print("보통");
        													else if(ccc.equals("4")) out.print("불분명");
        													else if(ccc.equals("5")) out.print("평가불가"); %>
                    </td>
                    <td width=10% align='center'>
                      <% String cdd = (String)ca.get("CDD");
        				  									if(cdd.equals("1")) out.print("최우수");
        													else if(cdd.equals("2")) out.print("우수");
        													else if(cdd.equals("3")) out.print("보통");
        													else if(cdd.equals("4")) out.print("침체");
        													else if(cdd.equals("5")) out.print("부실"); %>
                    </td>
                </tr>
          <% 	}
				}else{ %>
                <tr> 
                    <td colspan="9" align='center'>해당 거래처가 없습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
</table>
</form>  
</body>
</html>
