<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%


	if(chk1.equals("")) chk1 = "";
	if(chk2.equals("")) chk2 = "";
	if(chk3.equals("")) chk3 = "";
	if(chk4.equals("")) chk4 = "";
	if(gubun1.equals("")) gubun1 = "1";
	if(gubun2.equals("")) gubun2 = "";
	if(gubun3.equals("")) gubun3 = "";
	if(gubun4.equals("")) gubun4 = user_id;
	if(gubun7.equals("")) gubun7 = "";
	if(gubun5.equals("")) gubun5 = "0";
	if(gubun6.equals("")) gubun6 = "0";
	if(cgs_ok.equals("")) cgs_ok = "";

	if(s_kd.equals("")) s_kd = "";
	if(sort.equals("")) sort = "";
	if(asc.equals("")) asc = "";
	if(!br_id.equals("S1"))	s_br = br_id;
	
	if(st_dt.equals("")) 	st_dt = AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-01";
	if(end_dt.equals("")) 	end_dt = AddUtil.getDate();
	
	//전표승인자 리스트 조회
	Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	int cdi_size = card_d_ids.size();
	for (int i = 0 ; i < cdi_size ; i++){
		Hashtable card_d_id = (Hashtable)card_d_ids.elementAt(i);
		if(user_id.equals(String.valueOf(card_d_id.get("USER_ID")))){
			st_dt = "";
			end_dt = "";
			gubun4 = "all";
			gubun6 = user_id;
			chk2 = "N";

		}
	}
	
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&cgs_ok="+cgs_ok+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	sh_height = sh_line_height*5;
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./doc_mng_sh2.jsp<%=hidden_value%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./doc_mng_sc2.jsp<%=hidden_value%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
