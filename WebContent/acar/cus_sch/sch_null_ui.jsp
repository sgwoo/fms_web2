<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ include file="/acar/cookies.jsp" %>

<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<%
	CarSchDatabase csd = CarSchDatabase.getInstance();
		
	String auth_rw = "";
	String cmd = "";
	int count = 0;
	String start_mon = "";
	String start_year = "";
	String start_day = "";
	String user_id = "";
	int seq = 0;
	String title = "";
	String content = "";
	String reg_dt = "";
	String sch_kd = "";
	String sch_chk = "";
	String sch_st = "M";
	
	if(request.getParameter("auth_rw")!=null) auth_rw=request.getParameter("auth_rw");
	if(request.getParameter("cmd")!=null) cmd=request.getParameter("cmd");
	if(request.getParameter("start_year")!=null) start_year=request.getParameter("start_year");
	if(request.getParameter("start_mon")!=null) start_mon=request.getParameter("start_mon");
	if(request.getParameter("start_day")!=null) start_day=request.getParameter("start_day");
	if(request.getParameter("acar_id")!=null) user_id=request.getParameter("acar_id");
	if(request.getParameter("seq")!=null) seq=Util.parseInt(request.getParameter("seq"));
	if(request.getParameter("title")!=null) title=request.getParameter("title");
	if(request.getParameter("content")!=null) content=request.getParameter("content");
	if(request.getParameter("reg_dt")!=null) reg_dt=request.getParameter("reg_dt");
	if(request.getParameter("sch_kd")!=null) sch_kd=request.getParameter("sch_kd");
	if(request.getParameter("sch_chk")!=null) sch_chk=request.getParameter("sch_chk");
	String work_id 	= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	
//System.out.println(user_id);
//System.out.println(start_year);
//System.out.println(start_mon);
//System.out.println(start_day);
	
	if(user_id.equals("")){
		LoginBean login = LoginBean.getInstance();
		user_id = login.getCookieValue(request, "acar_id");
	}
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		cs_bean.setStart_mon(start_mon);
		cs_bean.setStart_year(start_year);
		cs_bean.setStart_day(start_day);
		cs_bean.setUser_id(user_id);
		cs_bean.setSeq(seq);
		cs_bean.setTitle(title);
		cs_bean.setContent(content);
		cs_bean.setReg_dt(reg_dt);
		cs_bean.setSch_kd(sch_kd);
		cs_bean.setSch_st(sch_st);
		cs_bean.setSch_chk(sch_chk);
		cs_bean.setWork_id(work_id);
		
		if(cmd.equals("i"))
		{
			count = csd.insertCarSche(cs_bean);
		}else if(cmd.equals("u")){
			count = csd.updateCarSche(cs_bean);
			
		}
	}else if(cmd.equals("d")){
		cs_bean.setStart_mon(start_mon);
		cs_bean.setStart_year(start_year);
		cs_bean.setStart_day(start_day);
		cs_bean.setUser_id(user_id);
		cs_bean.setSeq(seq);
		
		count = csd.deleteCarSche(cs_bean);
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%	if(cmd.equals("u")){
		if(count==1){%>
	alert("정상적으로 수정되었습니다.");
	//parent.SearchVis();
	//window.location="about:blank";
<%		}
	}else if(cmd.equals("i")){
		if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	parent.LoadSche();
	//parent.SearchVis();
	//window.location="about:blank";
<%		}
	}else if(cmd.equals("d")){
		if(count==1){%>
	alert("정상적으로 삭제되었습니다.");
	parent.LoadSche();	
<%		}
	}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">

</body>
</html>