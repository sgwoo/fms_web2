<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=pur_order_sc_in_excel.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.car_office.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	int count =0;
	
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
			
	Vector vt = umd.getPurComOrderList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
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
<% int col_cnt = 15;%>
<table border="0" cellspacing="0" cellpadding="0" width='1340'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 자동차납품 변경계약 리스트 (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='1340'>
                <tr> 
                    <td width='30' class='title'>연번</td>
                    <td width='30' class='title'>상태</td>
                    <td width='100' class='title'>특판계약번호</td>
                    <td width='100' class='title'>제조사</td>
                    <td width='100' class='title'>영업소</td> 
                    <td width='150' class='title'>차명</td>        	    
        	    <td width="100" class='title'>구분</td>
                    <td width='130' class='title'>고객확인</td>
                    <td width='130' class='title'>처리구분</td>
                    <td width="75" class='title'>배정구분</td>       		
                    <td width="75" class='title'>출고예정일</td>       		
                    <td width="75" class='title'>배정일자</td>
                    <td width="75" class='title'>출고일자</td>
        	    <td width='100' class='title'>계약자</td>
        	    <td width='70' class='title'>최초영업자</td>
        	</tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='30' align='center'><%=i+1%></td>                    
                    <td width='30' align='center'><%=ht.get("USE_YN_ST")%></td>                    
                    <td width='100' align='center'><%=ht.get("COM_CON_NO")%></td>
                    <td width='100' align='center'><%=ht.get("CAR_COMP_NM")%></td>
                    <td align='center'><%=ht.get("CAR_OFF_NM")%></td>
                    <td width='150' align='center'><%=ht.get("CAR_NM")%></td>        	            	    
                    <td width='100' align='center'>주문차</td>
                    <td width='130' align='center'><%=ht.get("ORDER_REQ_DT")%></td>
                    <td width='130' align='center'><%=ht.get("ORDER_CHK_DT")%><%if(String.valueOf(ht.get("ORDER_CHK_DT")).equals("")){%><font color=red>미확인</font><%}%></td>
                    <td width='75' align='center'><%=ht.get("DLV_ST_NM")%></td>
                    <td width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_EST_DT")))%></td>                
                    <td width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_CON_DT")))%></td>
                    <td width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
        	    <td width='100' align='center'><%=ht.get("PUR_COM_FIRM")%></td>				
        	    <td width='70' align='center'><%=ht.get("BUS_NM")%></td>	        		    
                </tr>
<%		}	%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

