<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");	
	String cust_tel 	= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");	
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	Hashtable sr_ht = cod.getSucRes(com_con_no, seq);
	
	
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
	function regReserveCar(gubun){
		fm = document.form1;
		
		if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
		
		fm.gubun.value = gubun;			
		if(!confirm("수정 하시겠습니까?"))	return;
		fm.action = "reserveCarM_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}

//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="com_con_no" value="<%=com_con_no%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="damdang_id" value="<%=damdang_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="cust_sms_y" value="">
<input type="hidden" name="situation" value="<%=situation%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량예약 메모수정</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td width="20%" class=title>진행상황</td>
                    <td width="80%">&nbsp;
                      <%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))		out.print("상담중");
        			            else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("계약확정");  
        			        %>
      		    </td>
                </tr>
                <tr> 
                    <td class=title>고객명</td>
                    <td >&nbsp;<input type="text" name="cust_nm" value="<%=sr_ht.get("CUST_NM")%>" size="30" class=text style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class=title>고객연락처</td>
                    <td >&nbsp;<input type="text" name="cust_tel" value="<%=sr_ht.get("CUST_TEL")%>" size="15" class=text style='IME-MODE: active'></td>
                </tr>                
                <tr> 
                    <td class=title>메모</td>
                    <td >&nbsp;<textarea name="memo" cols="48" rows="6" style="IME-MODE:ACTIVE"><%=sr_ht.get("MEMO")%></textarea></td>
                </tr>               
            </table>
        </td>
    </tr>
    <tr>  
        <td align="right">
	        <a href="javascript:regReserveCar('memo');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	        &nbsp;&nbsp;
		      <a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>	
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
