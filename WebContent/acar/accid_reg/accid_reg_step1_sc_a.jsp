<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID

	AccidDatabase as_db = AccidDatabase.getInstance();

	boolean flag = true;

	String accid_id = "";
								
	// 리스트
	String car_mng_id[] = request.getParameterValues("car_mng_id");
	String rent_mng_id[] = request.getParameterValues("rent_mng_id");
	String rent_l_cd[]  = request.getParameterValues("rent_l_cd");
	
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
			
	//1. 사고 등록 - 자산양수차량 정비관련 사고 일괄등록건 ---------------------------------------------------------------------------	
		
	for(int i=0; i<size; i++){

			AccidentBean accid = new AccidentBean();
			
			accid.setCar_mng_id		(car_mng_id[i] ==null?"": car_mng_id[i]);
			accid.setRent_mng_id		(rent_mng_id[i] ==null?"": rent_mng_id[i]);
			accid.setRent_l_cd		(rent_l_cd[i] ==null?"": rent_l_cd[i]);					
			accid.setAccid_id("");
			accid.setAccid_st(request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1"));
			accid.setReg_id	(user_id);//접수자
			accid.setUpdate_id(user_id);//접수자
			accid.setAcc_id	(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));//접수자
			accid.setAcc_dt	(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));//접수일자
			accid.setSub_etc(request.getParameter("sub_etc")==null?"":request.getParameter("sub_etc"));
			accid.setAccid_dt(request.getParameter("h_accid_dt")==null?"":request.getParameter("h_accid_dt"));//사고일자
			accid.setAccid_type(request.getParameter("accid_type")==null?"":request.getParameter("accid_type"));//사고유형
		
			accid.setAccid_type_sub(request.getParameter("accid_type_sub")==null?"":request.getParameter("accid_type_sub"));//사고유형
			accid.setAccid_addr(request.getParameter("accid_addr")==null?"":request.getParameter("accid_addr"));//사고장소
			accid.setAccid_cont(request.getParameter("accid_cont")==null?"":request.getParameter("accid_cont"));//사고경위-왜
			accid.setAccid_cont2(request.getParameter("accid_cont2")==null?"":request.getParameter("accid_cont2"));//사고경위-어떻게
			accid.setImp_fault_st(request.getParameter("imp_fault_st")==null?"":request.getParameter("imp_fault_st"));//중대과실여부
			accid.setImp_fault_sub(request.getParameter("imp_fault_sub")==null?"":request.getParameter("imp_fault_sub"));//중대과실여부-상세내용
			accid.setOur_fault_per(request.getParameter("our_fault_per")==null?0:AddUtil.parseDigit(request.getParameter("our_fault_per")));//과실비율
	
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
			
			//사고중복등록여부 체크
			int accid_chk_cnt  =  as_db.getAccidRegChk(accid);
			
			if(accid_chk_cnt>1){
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>사고중복등록확인</SUB>"+
		  				"    <CONT>사고중복등록확인 "+rent_l_cd[i]+"</CONT>"+
		 				"    <URL></URL>";	
				xml_data += "    <TARGET>2006007</TARGET>";	
				xml_data += "    <SENDER>2006007</SENDER>"+
		  				"    <MSGICON>10</MSGICON>"+
		  				"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
		  				"</COOLMSG>";
			
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");	
				boolean flag2 = cm_db.insertCoolMsg(msg);	
			}							
	
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
</form>
<script>	

<%		if( !accid_id.equals("")){%>
			alert("정상적으로 처리되었습니다.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>


</script>
</body>
</html>

