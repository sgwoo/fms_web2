<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.cont.*, acar.memo.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cd 		= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");	
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String brch_id 		= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String mng_br_id 	= request.getParameter("mng_br_id")==null?"":request.getParameter("mng_br_id");	
		
	String park 		= request.getParameter("park")==null?"":request.getParameter("park");
	String park_cont 	= request.getParameter("park_cont")==null?"":request.getParameter("park_cont");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int count = 1;
	int count2 = 0;
	
	//현위치 수정
	//count = rs_db.updateCarPark(c_id, park, park_cont);
	count = rs_db.updateCarPark2(c_id, park, park_cont, user_id);
	
	
	//주차장현황 - 입출고 데이터 삭제
	if(park.equals("1") || park.equals("3") || park.equals("7") || park.equals("8")|| park.equals("4") || park.equals("9") || park.equals("12") || park.equals("13") || park.equals("14") ){
		Hashtable ht2 = pk_db.getRentParkIOSearch2(c_id);
		count2 = pk_db.UpdateParkIO(String.valueOf(ht2.get("CAR_MNG_ID")));	
	}
	
		
	//실위치와 틀린 관리지점인 경우 관리지점  수정 - 2012-10-09 -  위치가 기타인 경우는 처리
	

	String n_mng_br_id = "";
	String n_user_id = "";	
			
	
	if(park.equals("1") || park.equals("5") || park.equals("10") || park.equals("15")){	
		n_mng_br_id = "S1";		
		n_user_id = nm_db.getWorkAuthUser("본사관리팀장");	
	//부산지점 park_in ('3', '7', '8' )	
	}else if(park.equals("3") || park.equals("7") || park.equals("8")){	
		n_mng_br_id = "B1";		
		n_user_id = nm_db.getWorkAuthUser("부산지점장");	
	//대전지점 park_in ('4', '9') 
	}else if(park.equals("4") || park.equals("9")){	
		n_mng_br_id = "D1";		
		n_user_id = nm_db.getWorkAuthUser("대전지점장");	
	}else if(park.equals("12") || park.equals("14")){	
		n_mng_br_id = "J1";		
		n_user_id = nm_db.getWorkAuthUser("광주지점장");	
	}else if(park.equals("13")){	
		n_mng_br_id = "G1";		
		n_user_id = nm_db.getWorkAuthUser("대구지점장");	
	}	
		
	Hashtable cont = a_db.getContViewUseYCarCase(c_id);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont.get("RENT_MNG_ID")), String.valueOf(cont.get("RENT_L_CD")));
	
	if(cont_etc.getRent_mng_id().equals("")){
	
		cont_etc.setMng_br_id		(n_mng_br_id);
	
		//=====[cont_etc] update=====
		cont_etc.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
		cont_etc.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
		boolean flag2 = a_db.insertContEtc(cont_etc);
	}else{
	
		String o_mng_br_id = cont_etc.getMng_br_id();
		
		if(!o_mng_br_id.equals(n_mng_br_id)){
			
			//관리지점 변경이력등록 & 관리지점 변경 적용
			LcRentCngHBean bean = new LcRentCngHBean();	
			bean.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
			bean.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
			bean.setCng_item	("mng_br_id");
			bean.setOld_value	(o_mng_br_id);
			bean.setNew_value	(n_mng_br_id);
			bean.setCng_cau		("보유차 현위치 변경");
			bean.setCng_id		(ck_acar_id);
			bean.setRent_st		(String.valueOf(cont.get("FEE_RENT_ST")));
			bean.setS_amt		(0);
			bean.setV_amt		(0);	
			boolean flag = a_db.updateLcRentCngH(bean);
			
			String cont_memo 		= "[보유차 현위치 변경] "+car_no+" 의 현위치가 변경되었습니다. 관리지점 및 관리담당자를 배정해주세요.";
								
			
		}		
	}
		
	
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
<%	if(count2 == 1){%>
		parent.window.close();
		parent.opener.location.reload();
<%	}%>
</script>
</body>
</html>
