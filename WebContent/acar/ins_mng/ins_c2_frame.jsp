<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%> 
<%@ page import="acar.insur.*"%>  
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 1; //검색 라인수
	int height = cnt*sh_line_height+20;
%>
<%
	String flag = request.getParameter("flag")==null?"":request.getParameter("flag");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"3":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"N":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String reg_code = request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");	
	String[] regCodeArray = null;
	String[] seqArray = null;
	if(flag.equals("ALL")) {
		regCodeArray = reg_code.split(",");
		seqArray = seq.split(",");
	}
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "03");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	if(flag.equals("ALL")) {
		for(int i=0; i<regCodeArray.length; i++) {
			boolean insExCh = ai_db.changeInsExcel(regCodeArray[i], seqArray[i], "Y");
		}
	} else {
		boolean insExCh = ai_db.changeInsExcel(reg_code, seq, "Y");
	}

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="80, *" border=0>
	<FRAME SRC="./ins_c2_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&dt=<%=dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&sh_height=<%=height%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&t_wd=<%=t_wd%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./ins_c2_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&dt=<%=dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&sh_height=<%=height%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&t_wd=<%=t_wd%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="no" noresize>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>