<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%//@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1);
%>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");

	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "07");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rr 	= request.getParameter("rr")==null?"":request.getParameter("rr");
			
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	int incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit(request.getParameter("incom_amt"));
	
	String ip_method 		= request.getParameter("ip_method")==null?"1":request.getParameter("ip_method");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String vlaus = 	"?rr="+rr+"&s_cnt="+s_cnt+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&incom_dt="+incom_dt+"&incom_seq="+incom_seq+"&incom_amt="+incom_amt+
					"&ip_method="+ip_method+"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&from_page="+from_page+
				   	"&sh_height="+height+"";
%>

<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>
<frameset rows="<%=height%>, <%=AddUtil.parseInt(s_height)-height%>" border=1 name=ex>
  <frame src="./incom_reg_scd_step2_sh.jsp<%=vlaus%>" name="c_body" marginwidth=10 marginheight=10  noresize scrolling="no">
  <frame src="./incom_reg_scd_step2_sc.jsp<%=vlaus%>" name="c_foot" marginwidth=10 marginheight=10  noresize scrolling="yes">
</frameset>
</HTML>
