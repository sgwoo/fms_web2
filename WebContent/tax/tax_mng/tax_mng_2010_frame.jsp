<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//로그인ID&영업소ID
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "07", "01");
	
	if(gubun1.equals("")) 	gubun1 = "1";
	if(chk1.equals("")) 	chk1 = "0";
	if(chk2.equals("")) 	chk2 = "0";
	if(chk3.equals("")) 	chk3 = "0";
	if(chk4.equals("")) 	chk4 = "0";
	if(chk5.equals("")) 	chk5 = "0";
	if(chk6.equals("")) 	chk6 = "0";
	if(chk7.equals("")) 	chk7 = "0";
	if(s_kd.equals("")) 	s_kd = "1";
	if(sort.equals("")) 	sort = "4";
	if(asc.equals("")) 		asc = "desc";
	if(!br_id.equals("S1"))	s_br = br_id;
	
	gubun3 = String.valueOf(AddUtil.getDate2(1)-6);
	
	if(gubun2.equals("")) gubun2 = gubun3;
	
	
	sh_height = sh_line_height*3;
	
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&chk6="+chk6+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="tax_mng_2010_sh.jsp<%=hidden_value%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<%if(st_dt.equals("") && t_wd1.equals("")){%>
	<FRAME SRC="about:blank" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
	<%}else{%>
	<FRAME SRC="tax_mng_2010_sc.jsp<%=hidden_value%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
	<%}%>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
