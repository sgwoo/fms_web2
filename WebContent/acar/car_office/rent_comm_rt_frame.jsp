<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+25;

%>
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  	==null?acar_br   :request.getParameter("br_id");

	String gubun1 	= request.getParameter("gubun1")	==null?"2":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"1":request.getParameter("gubun2");
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");
	
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun2="+gubun2+"&s_dt="+s_dt+"&e_dt="+e_dt+
				   	"&sh_height="+height+"";
	
%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./rent_comm_rt_sh.jsp<%=vlaus%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./rent_comm_rt_sc.jsp<%=vlaus%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="15" >
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
