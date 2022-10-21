<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_excel_park.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	
	
	//인천지점
	Hashtable br = c_db.getBranch("I1");
	
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<!--<link rel=stylesheet type="text/css" href="/include/table_t.css">-->
<body>
<% int col_cnt = 5;%>
<table border="0" cellspacing="0" cellpadding="0" width=500>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 12pt;" height="50">(주)아마존카 자동차 신규등록리스트 (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width=500>
	
		      <tr>   
		    	  <td align='center' style="font-size : 8pt;">연번</td>           
                  <td align='center' style="font-size : 8pt;">차명</td>
                  <td align='center' style="font-size : 8pt;">차량번호</td>	          
              </tr>
		     
		  		<%	for(int i=0;i < vid_size;i++){
						rent_l_cd = vid[i];
						Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
		  		 %>	
						
		        <tr>
        			<td align='center' style="font-size : 8pt;"><%=i+1%></td>
        		    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NM")%></td>        		 
        			<td align='center' style="font-size : 8pt;"><%=ht.get("EST_CAR_NO")%></td>	               		
		        </tr>
				<%	}%>

</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

