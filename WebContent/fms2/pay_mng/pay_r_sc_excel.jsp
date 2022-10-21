<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=pay_r_sc_excel.xls");
%>

<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	
	Vector vt =  pm_db.getPayRCheckList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<% int col_cnt = 12;%>
<table border="0" cellspacing="0" cellpadding="0" width='1010'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">출금송금결과 리스트 (<%=st_dt%>~<%=end_dt%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='1010'>
                <tr> 
                    <td width='100' class='title'>처리일</td>
                    <td width='100' class='title'>처리시간</td>
                    <td width='200' class='title'>출금계좌</td>
                    <td width='100' class='title'>입금은행</td>
                    <td width='60' class='title'>구분</td>        	    
                    <td width='200' class='title'>입금계좌</td>        	                        
        	    <td width="200" class='title'>고객관리성명</td>
                    <td width='200' class='title'>수취인성명</td>
                    <td width='100' class='title'>정상입금액</td>
        	    <td width='200' class='title'>출금통장표시</td>
        	    <td width='200' class='title'>출금항목</td>
        	    <td width='200' class='title'>적요</td>
        	</tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>                     
                    <td align='center'><%=ht.get("TR_DATE")%></td>                    
                    <td align='center'><%=ht.get("TR_TIME")%></td>
                    <td align='center'>&nbsp;<%=ht.get("TRAN_JI_ACCT_NB")%></td>        	            	    
                    <td align='center'><%=ht.get("BANK_NM")%></span></td>
                    <td align='center'>&nbsp;<%=ht.get("CONF_ST_NM")%></td>        	            	    
                    <td align='center'>&nbsp;<%=ht.get("TRAN_IP_ACCT_NB")%></td>        	            	    
                    <td align='center'><%=ht.get("TRAN_MEMO")%>
                    	<%if((	String.valueOf(ht.get("OFF_ST")).equals("client_id")||
                    			String.valueOf(ht.get("GUBUN_NM")).equals("CMS과출금")||
                    			String.valueOf(ht.get("GUBUN_NM")).equals("계약승계보증금환불")||
                    			String.valueOf(ht.get("GUBUN_NM")).equals("해지정산금환불")
                    		) && !String.valueOf(ht.get("CLIENT_NM")).equals("") && !String.valueOf(ht.get("CLIENT_NM")).equals(String.valueOf(ht.get("TRAN_MEMO")))){%>
                    		/<%=ht.get("CLIENT_NM")%>
                    	<%}%>
                    </td>
                    <td align='center'><%=ht.get("TRAN_REMITTEE_NM")%></td>
        	    <td align='right'><%=ht.get("TRAN_AMT")%></td>				
        	    <td align='center'><%=ht.get("TRAN_JI_NAEYONG")%></td>	        		           		    
        	    <td align='center'><%=ht.get("GUBUN_NM")%></td>				
        	    <td align='center'><%=ht.get("P_CONT")%></td>	        		           		    
                </tr>
<%		}	%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

