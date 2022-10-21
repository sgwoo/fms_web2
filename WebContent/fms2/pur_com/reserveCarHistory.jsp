<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	Vector sr = cod.getSucResHList(com_con_no);
	int sr_size = sr.size();	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>예약 이력</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="5%">연번</td>				
                    <td class="title" width="10%">담당자</td>
                    <td class="title" width="10%">진행상황</td>					
                    <td class="title" width="20%">예약기간</td>					
                    <td class="title" width="45%">메모</td>
                    <td class="title" width="10%">등록일</td>					
                </tr>
				<%	
					for(int i = 0 ; i < sr_size ; i++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(i);
						%>
                <tr> 
                    <td align="center"><%=i+1%></td>				
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("REG_ID")),"USER")%></td>
                    <td align="center"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("상담중");
        									else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))	out.print("계약확정");
        										else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))	out.print("계약연동");  %></td>
                    <td align="center">
					<%if(String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
					대기
					<%}else{%>
					<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
					<%}%>
					</td>
                    <td>&nbsp;<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%></td>
                    <td align="center">
					<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %>
					</td>					
                </tr>
				<%}%>
            </table>
	    </td>
    </tr>	

    <tr>  
        <td align="right" colspan=2><a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	    </td>	
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
