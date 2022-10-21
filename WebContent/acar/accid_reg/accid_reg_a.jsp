<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "01");
	String dept_id = login.getDept_id(user_id);
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String accid_id = "";
	
	AccidentBean accid = new AccidentBean();
	accid.setCar_mng_id(c_id);
	accid.setRent_mng_id(m_id);
	accid.setRent_l_cd(l_cd);
	accid.setAccid_id("");
	accid.setAccid_st(request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1"));
	accid.setReg_id	(user_id);//접수자
	accid.setUpdate_id(user_id);//접수자
	accid.setAcc_id	(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));//접수자
	accid.setAcc_dt	(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));//접수일자
	accid.setSub_etc(request.getParameter("sub_etc")==null?"":request.getParameter("sub_etc"));
	accid.setAccid_dt(request.getParameter("h_accid_dt")==null?"":request.getParameter("h_accid_dt"));//사고일자
	accid.setAccid_type(request.getParameter("accid_type")==null?"":request.getParameter("accid_type"));//사고유형
	if(car_st.equals("2")){//예비차
		accid.setRent_s_cd(request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd"));
		accid.setSub_rent_gu(request.getParameter("sub_rent_gu")==null?"":request.getParameter("sub_rent_gu"));
		accid.setSub_firm_nm(request.getParameter("sub_firm_nm")==null?"":request.getParameter("sub_firm_nm"));
		accid.setSub_rent_st(request.getParameter("sub_rent_st")==null?"":request.getParameter("sub_rent_st"));
		accid.setSub_rent_et(request.getParameter("sub_rent_et")==null?"":request.getParameter("sub_rent_et"));
		accid.setMemo(request.getParameter("memo")==null?"":request.getParameter("memo"));
	}
//	if(!accid.getAccid_st().equals("8")){//운행자차제외
		accid.setAccid_type_sub(request.getParameter("accid_type_sub")==null?"":request.getParameter("accid_type_sub"));//사고유형
		accid.setAccid_addr(request.getParameter("accid_addr")==null?"":request.getParameter("accid_addr"));//사고장소
		accid.setAccid_cont(request.getParameter("accid_cont")==null?"":request.getParameter("accid_cont"));//사고경위-왜
		accid.setAccid_cont2(request.getParameter("accid_cont2")==null?"":request.getParameter("accid_cont2"));//사고경위-어떻게
		accid.setImp_fault_st(request.getParameter("imp_fault_st")==null?"":request.getParameter("imp_fault_st"));//중대과실여부
		accid.setImp_fault_sub(request.getParameter("imp_fault_sub")==null?"":request.getParameter("imp_fault_sub"));//중대과실여부-상세내용
		accid.setOur_fault_per(request.getParameter("our_fault_per")==null?0:AddUtil.parseDigit(request.getParameter("our_fault_per")));//과실비율
//	}
	accid.setSettle_st("0");//처리상태-진행중
	accid.setDam_type1(request.getParameter("dam_type1")==null?"N":request.getParameter("dam_type1"));
	accid.setDam_type2(request.getParameter("dam_type2")==null?"N":request.getParameter("dam_type2"));
	accid.setDam_type3(request.getParameter("dam_type3")==null?"N":request.getParameter("dam_type3"));
	accid.setDam_type4(request.getParameter("dam_type4")==null?"N":request.getParameter("dam_type4"));
	accid.setSpeed(request.getParameter("speed")==null?"":request.getParameter("speed"));//속도
	accid.setRoad_stat(request.getParameter("road_stat")==null?"":request.getParameter("road_stat"));//도로면상태
	accid.setRoad_stat2(request.getParameter("road_stat2")==null?"":request.getParameter("road_stat2"));//도로면상태
	accid.setWeather(request.getParameter("weather")==null?"":request.getParameter("weather"));//날씨
	accid.setBus_id2(request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2"));//사고시점 담당자
	accid.setReg_ip	(request.getRemoteAddr());//등록자 아이피
			
	accid_id = as_db.insertAccident(accid);
	
	

	
	
%>

<script language='javascript'>
<%	if(accid_id == ""){	%>
		alert('사고기록 에러입니다.\n\n등록되지 않았습니다');
		location='about:blank';
<%	}else{	%>
		alert("등록되었습니다");
		
		
		<%if(go_url.equals("")){%>
		<%		if(dept_id.equals("8888")){//명진공업사%>
		parent.parent.location='../accid_mng/accid_gu.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&accid_st=<%=accid_st%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
		<%		}else{%>
		parent.parent.location='../accid_mng/accid_u_frame.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&accid_st=<%=accid_st%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
		<%		}%>
		<%}else{%>
		<%		if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
		parent.location.href = "/acar/res_search/sub_select_3_a.jsp?auth_rw=<%=auth_rw%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&go_url=<%=go_url%>";
		<%		}else{%>
		parent.parent.location='<%=go_url%>?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&c_id=<%=c_id%>&rent_st=<%=rent_st%>&car_no=<%=car_no%>&gubun=<%=gubun%>';		
		<%		}%>		
		<%}%>		
<%	}	%>
</script>
</body>
</html>
