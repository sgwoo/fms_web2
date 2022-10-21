<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* " %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");		
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String res_yn 		= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String jg_code 		= request.getParameter("jg_code")==null?"":request.getParameter("jg_code");
	
	String est_st 		= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
	
	//½ºÆó¼È°ßÀû ¿¬°á°ª
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String spe_seq 		= request.getParameter("spe_seq")==null?"":request.getParameter("spe_seq");
	String est_table 	= request.getParameter("est_table")==null?"":request.getParameter("est_table");
	
	String br_to_st 	= request.getParameter("br_to_st")==null?"":request.getParameter("br_to_st");

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="145,*,1" border=0 cols="*"> 
  <frame name="detail_head" src="secondhand_detail_h.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&jg_code=<%=jg_code%>&est_st=<%=est_st%>&fee_opt_amt=<%=fee_opt_amt%>&fee_rent_st=<%=fee_rent_st%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&brch_id=<%=brch_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&est_id=<%=est_id%>&spe_seq=<%=spe_seq%>&est_table=<%=est_table%>&from_page=<%=from_page%>&list_from_page=<%=list_from_page%>&br_to_st=<%=br_to_st%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="detail_body" src="secondhand_price_20090901.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&jg_code=<%=jg_code%>&est_st=<%=est_st%>&fee_opt_amt=<%=fee_opt_amt%>&fee_rent_st=<%=fee_rent_st%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&brch_id=<%=brch_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&est_id=<%=est_id%>&spe_seq=<%=spe_seq%>&est_table=<%=est_table%>&from_page=<%=from_page%>&list_from_page=<%=list_from_page%>&br_to_st=<%=br_to_st%>" marginwidth=10 marginheight=10 scrolling="auto" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>