<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<%@ page import="acar.car_mst.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	
	
	String vid[] = request.getParameterValues("ch_id");
	int vid_size = vid.length;
	out.println("* 선택건수="+vid_size+"<br><br>");
	
	String value[] = new String[10];
	String car_id	="";
	String car_seq	="";
	int count = 0;
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	for(int i=0; i < vid_size; i++){
		
		out.print("=============================================================");out.println("<br>");
		out.print(i+1+". ");
		
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		car_id 		= value[0];
		car_seq		= value[1];
		
		out.println("car_id:"+car_id);
		out.println("car_seq:"+car_seq);
		
		count = a_cmd.updateCarNmYn(car_id, car_seq);
		
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>일괄처리
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<input type='hidden' name='car_name' value='<%=car_name%>'>
<input type='hidden' name='view_dt' value='<%=view_dt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
	var fm = document.form1;
	fm.action = 'car_nm_yn_list.jsp';
	fm.submit();
	
//-->
</SCRIPT>
</BODY>
</HTML>