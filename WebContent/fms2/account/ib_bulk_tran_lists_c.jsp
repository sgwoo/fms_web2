<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	

	String dt = request.getParameter("dt")==null?"3":request.getParameter("dt");
	String result_nm = request.getParameter("result_nm")==null?"":request.getParameter("result_nm");
	String bank_acc_nm = request.getParameter("bank_acc_nm")==null?"":request.getParameter("bank_acc_nm");
	String match_yn = request.getParameter("match_yn")==null?"":request.getParameter("match_yn");
	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
		
	int ip_size = 0;  
	Vector ips = in_db.getIbBulkTranLists(result_nm, bank_acc_nm, match_yn, dt, ref_dt1, ref_dt2);

	ip_size = ips.size();	
	
	long t_amt = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
   
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 출금관리 > <span class=style5>
						내역 리스트</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>     
   		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="6%" class=title>연번</td>         
            <td width="8%" class=title>송금일</td>
            <td width="10%" class=title>금액</td>
            <td width="20%" class=title>예금주조회결과</td>	
            <td width="20%" class=title>송금예금주</td>	          
            <td width="10%" class=title>항목</td>			
            <td width="26%" class=title>적요</td>									
          </tr>
          <%
		 	for(int i = 0 ; i < ip_size ; i++){
		 		Hashtable ht = (Hashtable)ips.elementAt(i);
		 		
		 		t_amt  += AddUtil.parseLong(String.valueOf(ht.get("AMT")));
		 		%>	  
          <tr>
            <td align="center"><%=i+1%></td>           												
            <td align="center"><%=ht.get("ACT_DT")%></td>			
            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>           
            <td align="center"><%=ht.get("RESULT_NM")%></td>
             <td align="center"><%=ht.get("BANK_ACC_NM")%></td>		
            <td align="center"><%=ht.get("GUBUN_NM")%></td>				
            <td align="center"><%=ht.get("P_CONT")%></td>						
          </tr>
	      <%}%>
	      <tr>
            <td align="center" colspan=2></td> 
            <td align="right"><%=AddUtil.parseDecimalLong(t_amt)%></td>
            <td colspan=4 align="center"></td>	
          				
          </tr>		
		</table>
	  </td>
	</tr> 	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
    <tr>
	    <td align='center'>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
  </table>
</form>
</body>
</html>


