<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//로그인ID&영업소ID
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "10", "07");
	
	if(t_wd1.equals("") && t_wd2.equals("") && st_dt.equals("") && gubun1.equals("") && gubun4.equals("")){	
	
	  if(chk1.equals("")) chk1 = "";
	  if(chk2.equals("")) chk2 = "";
	  if(chk3.equals("")) chk3 = "";
	  if(chk4.equals("")) chk4 = "";
	  if(gubun1.equals("")) gubun1 = "2";
	  if(gubun2.equals("")) gubun2 = "";
	  if(gubun3.equals("")) gubun3 = "";
	  if(gubun4.equals("")) gubun4 = "";
	  if(gubun5.equals("")) gubun5 = "0";
	  if(gubun6.equals("")) gubun6 = "0";
	  
	  if(s_kd.equals("")) 		s_kd = "1";
	  if(sort.equals("")) 		sort = "";
	  if(asc.equals("")) 		asc = "";
	  
	  //전표승인자 리스트 조회
	  Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	  int cdi_size = card_d_ids.size();
	  for (int i = 0 ; i < cdi_size ; i++){
		  Hashtable card_d_id = (Hashtable)card_d_ids.elementAt(i);
		  if(user_id.equals(String.valueOf(card_d_id.get("USER_ID")))){
			  gubun6 = user_id;
		  }
	  }
  }
  
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	sh_height = sh_line_height*5;
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./doc_app_sh.jsp<%=hidden_value%>" name="cd_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./doc_app_sc.jsp<%=hidden_value%>" name="cd_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
