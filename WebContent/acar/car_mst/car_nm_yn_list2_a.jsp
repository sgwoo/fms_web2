<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<%@ page import="acar.car_mst.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String size = request.getParameter("size")==null?"":request.getParameter("size");
	
	String end_hp_yn 	= request.getParameter("end_hp_yn")==null?"":request.getParameter("end_hp_yn");
	
	
	String vid1[] = request.getParameterValues("car_id");
	String vid2[] = request.getParameterValues("car_seq");
	String vid3[] = request.getParameterValues("use_yn");
	String vid4[] = request.getParameterValues("est_yn");
	String vid5[] = request.getParameterValues("hp_yn");
	String vid6[] = request.getParameterValues("end_dt");
	String vid7[] = request.getParameterValues("jg_tuix_st");
	
	String car_id	="";
	String car_seq	="";
	String use_yn	="";
	String est_yn	="";
	String hp_yn	="";
	String end_dt	="";
	String jg_tuix_st	="";
	int count = 0;
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	for(int i=0; i < AddUtil.parseInt(size); i++){
		
		out.print("=============================================================");out.println("<br>");
		out.print(i+1+". ");
		
		car_id 		= vid1[i];
		car_seq		= vid2[i];
		use_yn 		= vid3[i]==null?"N":vid3[i];
		est_yn 		= vid4[i]==null?"N":vid4[i];
		hp_yn 		= vid5[i]==null?"N":vid5[i];
		end_dt 		= vid6[i]==null?"":vid6[i];
		jg_tuix_st= vid7[i]==null?"":vid7[i];
		
		
		if(end_hp_yn.equals("Y") && end_dt.equals("N") && hp_yn.equals("Y")){
			hp_yn = "N";
		}
		
		//out.print(car_id+", "+car_seq+", "+use_yn+", "+est_yn+", "+hp_yn+", "+end_dt+"<br>");
		
		count = a_cmd.updateCarNmYn(car_id, car_seq, use_yn, est_yn, hp_yn, end_dt, jg_tuix_st);
		
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>ÀÏ°ýÃ³¸®
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
	fm.action = 'car_nm_yn_list2.jsp';
	fm.submit();
	
//-->
</SCRIPT>
</BODY>
</HTML>