<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height+15;

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String gubun3 = request.getParameter("gubun3")==null?"11":request.getParameter("gubun3"); //신차/부서
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4"); //렌트/담당자 
	String gubun5 = request.getParameter("gubun5")==null?"1":request.getParameter("gubun5"); //일반식/기본식
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page"); //	
	
	String st_year = request.getParameter("st_year")==null?AddUtil.getDate(1):request.getParameter("st_year");//타입
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");//분기
		
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1"); //기간
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2"); //
	
	if (st_mon.equals("1")) {
	     if (ref_dt1.equals("")) ref_dt1 = st_year+"0101";
	     if (ref_dt2.equals(""))  ref_dt2 = st_year+"0331";   	
	} else if (st_mon.equals("2")) {
	    if (ref_dt1.equals("")) ref_dt1 = st_year+"0401";
	    if (ref_dt2.equals("")) ref_dt2 = st_year+"0630";   
	} else if (st_mon.equals("3")) {
	    if (ref_dt1.equals("")) ref_dt1 = st_year+"0701";
	    if (ref_dt2.equals("")) ref_dt2 = st_year+"0930";   
	} else if (st_mon.equals("4")) {
	    if (ref_dt1.equals("")) ref_dt1 = st_year+"1001";
	    if (ref_dt2.equals("")) ref_dt2 = st_year+"1231";   
	} else {
	    if (ref_dt1.equals("")) ref_dt1 = st_year+"0101";
	    if (ref_dt2.equals("")) ref_dt2 = st_year+"1231";   
	}    
	
%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./stat_oil_sh.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&st_year=<%=st_year%>&from_page=<%=from_page%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<%if(gubun4.equals("1")){%>
  	<FRAME SRC="/acar/menu/about_blank.jsp" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="no" noresize>  
  	<%}else{%>
  	<FRAME SRC="./stat_oil_sc.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&st_year=<%=st_year%>&from_page=<%=from_page%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
  	<%}%>
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
