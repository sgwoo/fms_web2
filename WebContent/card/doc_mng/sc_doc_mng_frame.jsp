<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	if(t_wd1.equals("") && t_wd2.equals("") && st_dt.equals("") && gubun1.equals("") && gubun4.equals("")){
		
		if(chk1.equals("")) chk1 = "";
		if(chk2.equals("")) chk2 = "3";
		if(chk3.equals("")) chk3 = "";
		if(chk4.equals("")) chk4 = "";
		if(gubun1.equals("")) gubun1 = "1";
		if(gubun2.equals("")) gubun2 = "";
		if(gubun3.equals("")) gubun3 = "";
		if(gubun4.equals("")) gubun4 = user_id;
		if(gubun5.equals("")) gubun5 = "0";
		if(gubun6.equals("")) gubun6 = "0";
		if(gubun7.equals("")) gubun7 = "";
		if(cgs_ok.equals("")) cgs_ok = "";
		
		if(s_kd.equals("")) s_kd = "1";
		if(sort.equals("")) sort = "";
		if(asc.equals("")) asc = "";
		if(br_id.equals(""))	s_br = "";
		
		if(st_dt.equals("")) 	st_dt =""; 
		if(end_dt.equals("")) 	end_dt ="";
		
	}
	
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&cgs_ok="+cgs_ok+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	sh_height = sh_line_height*6;
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./sc_doc_mng_sh.jsp<%=hidden_value%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./sc_doc_mng_sc.jsp<%=hidden_value%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
