<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//�α���ID&������ID
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "07", "03");
	
	if(gubun1.equals("")) 	gubun1 = AddUtil.getDate(1);
	if(gubun2.equals("")){
	  if(AddUtil.getDate(2).equals("01")) gubun2 = "1";
	  if(AddUtil.getDate(2).equals("02")) gubun2 = "1";
	  if(AddUtil.getDate(2).equals("03")) gubun2 = "1";
	  if(AddUtil.getDate(2).equals("04")) gubun2 = "2";
	  if(AddUtil.getDate(2).equals("05")) gubun2 = "2";
	  if(AddUtil.getDate(2).equals("06")) gubun2 = "2";
	  if(AddUtil.getDate(2).equals("07")) gubun2 = "3";
	  if(AddUtil.getDate(2).equals("08")) gubun2 = "3";
	  if(AddUtil.getDate(2).equals("09")) gubun2 = "3";
	  if(AddUtil.getDate(2).equals("10")) gubun2 = "4";
	  if(AddUtil.getDate(2).equals("11")) gubun2 = "4";
	  if(AddUtil.getDate(2).equals("12")) gubun2 = "4";
	}
	if(gubun3.equals("")) gubun3 = AddUtil.getDate(2);
	if(chk1.equals("")) 	chk1 = "0";
	if(chk2.equals("")) 	chk2 = "0";
	if(chk3.equals("")) 	chk3 = "0";
	if(chk4.equals("")) 	chk4 = "0";
	if(s_kd.equals("")) 	s_kd = "1";
	if(sort.equals("")) 	sort = "4";
	if(asc.equals("")) 		asc = "asc";
	if(!br_id.equals("S1"))	s_br = br_id;
	
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}
	
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	sh_height = sh_line_height*3+15;
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="tax_hap_sh.jsp<%=hidden_value%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="tax_hap_sc.jsp<%=hidden_value%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
