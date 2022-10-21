<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int height = 90; // 검색 라인수(제목하고 데이터 사이에 보여주는 여백 간격)
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
		
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	
	if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")){
		brid = "1";
	}else if(br_id.equals("B1")){
		brid = "3";
	}else if(br_id.equals("D1")){
		brid = "4";
	}else if(br_id.equals("J1")){
		brid = "5";
	}else if(br_id.equals("G1")){
		brid = "6";
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height2 = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String values = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&brid="+brid+
						"&gubun1="+gubun1+"&gubun2="+gubun2+"&start_dt="+start_dt+"&end_dt="+end_dt+
						"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+
					   	"&sh_height="+height+"&height="+height2;	
	
%>
<HTML>
	<HEAD>
		<title>FMS</title>
	</HEAD>
	<FRAMESET rows="<%=height%>, *" >
		<FRAME SRC="./park_w_sh.jsp<%=values%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" >
		<FRAME SRC="./park_wd_sc.jsp<%=values%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=10  scrolling="auto" noresize>
	</FRAMESET>

	<NOFRAMES>
		<BODY>
			<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
		</body>
	</NOFRAMES>
</HTML>
