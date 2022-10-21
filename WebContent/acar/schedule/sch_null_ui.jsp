<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ page import="acar.schedule.*, acar.user_mng.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_st 	= request.getParameter("m_st")==null?"":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	ScheduleDatabase csd = ScheduleDatabase.getInstance();
	
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
	String sch_st = "B";
	
	
	
	
		
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
	
	//공휴일체크
	String dt_chk = "Y";
	String scd_dt = start_year+""+start_mon+""+start_day;
	String chk_dt = AddUtil.replace(af_db.getValidDt(scd_dt),"-","");
	
	out.println("scd_dt="+scd_dt);
	out.println("chk_dt="+chk_dt);

	if(!scd_dt.equals(chk_dt)){
		dt_chk = "N";
		
		out.println("dt_chk="+dt_chk);
	}
	
	

	if(user_id.equals("")){
		LoginBean login = LoginBean.getInstance();
		user_id = login.getCookieValue(request, "acar_id");
	}
	
	out.println("user_id="+user_id);
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
	//재택근무 파트너 등록확인
	int chk1 = 0;
	int chk2 = 0;
	if(sch_chk.equals("0")){
		//
		if(user_bean.getLoan_st().equals("")){
			chk1 = csd.getSchCheck(user_id, start_year, start_mon, start_day);
		}	
		//중복체크
		chk2 = csd.getSchRegCheck(user_id, start_year, start_mon, start_day);		
	}
	
	out.println("chk1="+chk1);
	out.println("chk2="+chk2);
	 
	
	
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
			//공휴일이 아니다
			if(dt_chk.equals("Y")){
				if(chk1 == 0 && chk2 == 0){
					count = csd.insertCarSche(cs_bean);
				}
			}	
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%	if(cmd.equals("u")){%>
<%		if(count==1){%>
			alert("정상적으로 수정되었습니다.");
<%		}%>

<%	}else if(cmd.equals("i")){%>
<%		if(dt_chk.equals("Y")){		%>
<%			if(chk1 == 0 && chk2 == 0){		%>
<%				if(count==1){%>
					alert("정상적으로 등록되었습니다.");
					<%if(go_url.equals("homework_sh.jsp")){%>
						parent.LoadSche();
					<%}else{%>
						<% if(m_st.equals("10") && m_st2.equals("02") && m_cd.equals("03")){%>
						parent.LoadSche2();	
						<% }else{%>
						parent.LoadSche();
						<%}%>
					<%}%>
				
<%				}%>
<%			}else{%>
<%				if(chk1 > 0 || chk2 > 0){		%>
					alert('중복입력이거나 재택근무 파트너가 이미 재택근무 등록이 되었습니다. 동일자에 등록이 안됩니다.');
<%				}%>
<%			}%>
<%		}else{%>
			alert('공휴일 혹은 주말입니다. 등록이 안됩니다.');	
<%		}%>
<%	}else if(cmd.equals("d")){%>
<%		if(count==1){%>
			alert("정상적으로 삭제되었습니다.");
			parent.LoadSche();
<%		}%>
<%	}%>

}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">

</body>
</html>