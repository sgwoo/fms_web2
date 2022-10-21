<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	String dt	= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");
		
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");	
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String head_url = "/acar/off_ls_cmplt/off_ls_cmplt_sc_in_h.jsp";
	String body_url = "/acar/off_ls_jh/off_ls_jh_st_frame.jsp";
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"&s_au="+s_au+
				   	"&car_mng_id="+car_mng_id+"&seq="+seq+"&from_page="+from_page+"";					
	
%>
<HTML>
<HEAD>
<TITLE>오프리스 프레임</TITLE>
</HEAD>
<frameset rows="160,*,1" border=0 cols="*"> 
  <frame name="detail_head" src="<%=head_url%><%=vlaus%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="detail_body" src="<%=body_url%><%=vlaus%>" marginwidth=10 marginheight=10 scrolling="auto" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>