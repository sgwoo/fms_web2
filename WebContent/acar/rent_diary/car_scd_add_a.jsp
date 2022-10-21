<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");
	String start_dt = request.getParameter("start_dt")==null?"":AddUtil.replace(request.getParameter("start_dt"),"-","");
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.replace(request.getParameter("end_dt"),"-","");
	int count = 1;
	
	//삭제
	if(mode.equals("d")){
		//삭제
		count = rs_db.deleteScdCar2(s_cd, c_id, dt);
	}

	//생성
	else if(mode.equals("i")){
		//단기대여관리 수정 : 기간연장으로 인한 반차예정일자 수정
		RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
		rc_bean.setRet_plan_dt2(end_dt+"0000");
		rc_bean.setRet_plan_dt(end_dt+"0000");
		rc_bean.setReg_id(user_id);
		count = rs_db.updateRentCont(rc_bean);
		
		String use_max_dt = rs_db.getMaxData(s_cd, c_id, "dt");
		int use_days = 0;
		
		//운행일수
		use_days = AddUtil.parseInt(rs_db.getDay(start_dt, end_dt));
		//마지막회차
		int max_tm = AddUtil.parseInt(rs_db.getMaxData(s_cd, c_id, "tm"));
		for(int i=0; i<use_days; i++){
			ScdCarBean sc_bean = new ScdCarBean();
			sc_bean.setCar_mng_id(c_id);
			sc_bean.setRent_s_cd(s_cd);
			sc_bean.setTm(max_tm+i+1);
			sc_bean.setDt(rs_db.addDay(start_dt, i));
			if(i > 0 && i==use_days-1){//대여종료 예정일
				sc_bean.setTime("00");
				sc_bean.setUse_st("2");
			}else{//대여기간
				sc_bean.setTime("");
				sc_bean.setUse_st("1");
			}
			sc_bean.setReg_id(user_id);
			count = rs_db.insertScdCar(sc_bean);
		}
	}
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.location='car_scd_add.jsp?c_id=<%=c_id%>&s_cd=<%=s_cd%>';
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
