<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	//희망차량번호 수정 처리 페이지
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String est_car_no 	= request.getParameter("est_car_no")==null?"":request.getParameter("est_car_no");
	String est_car_num	= request.getParameter("est_car_num")==null?"":request.getParameter("est_car_num");
	String car_nm		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	//String process 		= request.getParameter("process")==null?"":request.getParameter("process");
	String tmp_drv_no = request.getParameter("tmp_drv_no")==null?"":request.getParameter("tmp_drv_no");		// 임시차량번호		2017.12.07
		
	String query1 = "";
	String query2 = "";
	String query3 = "";
	int flag1 = 0;
	int flag2 = 0;
	boolean flag3 = true;
	
	//car_pur 테이블에 업데이트(기존 소스)
	query1 = " UPDATE car_pur SET est_car_no =replace('"+est_car_no+"','-',''), car_num =replace('"+est_car_num+"','-','')   WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
	query2 = " UPDATE car_scrap SET rent_l_cd ='"+l_cd+"', car_nm = '"+car_nm+"',"+
			 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = 'N'"+
			 " WHERE car_no='"+est_car_no+"'";
	query3 = " UPDATE car_scrap SET rent_l_cd = null, car_nm = null,"+
			 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = 'N'"+
			 " WHERE rent_l_cd='"+l_cd+"'";
	
	if(!est_car_no.equals("")){
		//먼저, 해당 차량번호로 매핑된 계약이 이미 있는지 체크
		int resultCnt = sc_db.getCarNoMappingYn2(est_car_no, l_cd);		// 자기 자신의 계약 제외 기능 추가 2017.12.12
							
		if(resultCnt != 0){		//해당번호와 매핑된 계약이 이미 있으면 두건의 매핑정보를 바꾸기
			String rent_l_cd2 = sc_db.getCarNoMappingInfo(est_car_no);
			Vector lists1 = sc_db.getNewCarNumList("","","","1",l_cd,"");
			Vector lists2 = sc_db.getNewCarNumList("","","","1",rent_l_cd2,"");
			
			if(lists1 != null && lists2 != null && !lists1.isEmpty() && !lists2.isEmpty()){
				Hashtable list1 = (Hashtable)lists1.elementAt(0);
				Hashtable list2 = (Hashtable)lists2.elementAt(0);
				String car_no1 = (String)list1.get("CAR_NO");
				String car_no2 = (String)list2.get("CAR_NO");
				String car_nm1 = (String)list1.get("CAR_NM");
				String car_nm2 = (String)list2.get("CAR_NM");
%>
				<script language='javascript'>
					var car_no1 = '<%=car_no1%>';		//기존 
					var car_no2 = '<%=car_no2%>';		//변경
					var car_nm1 = '<%=car_nm1%>';		//기존
					var car_nm2 = '<%=car_nm2%>';		//변경
					var rent_l_cd1 = '<%=l_cd%>';		//기존
					var rent_l_cd2 = '<%=rent_l_cd2%>';	//변경		
					var alertText = car_no2 +"해당 자동차번호로 등록된 계약건이 이미 존재합니다.\n\n"+
					                "1 : "+rent_l_cd1+" : "+car_no1+"  --> "+rent_l_cd1+" : "+car_no2+"\n\n"+
					                "2 : "+rent_l_cd2+" : "+car_no2+"  --> "+rent_l_cd2+" : "+car_no1+"\n\n"+
					                "두 계약건의 차량번호를 서로 바꾸시겠습니까?";
					if(!confirm(alertText)){
						alert("취소되었습니다");
						location='about:blank';	
					}else{
						location.href='/fms2/car_pur/reg_estcarno_b.jsp?car_no1='+car_no1+'&car_no2='+car_no2+'&rent_l_cd1='+rent_l_cd1+'&rent_l_cd2='+rent_l_cd2+'&car_nm1='+car_nm1+'&car_nm2='+car_nm2;
					}
			</script>
<%				}else{ %>
			<script type="text/javascript">
					alert("변경할 차량 번호는 두 번호 모두\n\n신규자동차번호관리/대폐차관리 에 등록된 번호이어야 합니다.\n\n재확인(번호등록)후 다시 시도해주세요.");
					location='about:blank';
			</script>		
<%				}
		}else{	//매핑된 계약건이 없으면
			String rent_l_cd2 = sc_db.getCarNoMappingInfo(est_car_no);	//기존에 매핑된건이 있고 매핑안된번호로 기존매핑을 바꿔야되는 경우를 체크
			if(rent_l_cd2==null || rent_l_cd2.equals("")){//매핑된건이 있는데 신규번호(매핑안된)를 기존 매핑된 건의 계약번호와 새로 매칭시킬 경우
				//기존 매핑을 삭제토록 업데이트
				flag2 = sc_db.updateCarScrap(query3);	//1
				//새로운 번호로 매핑
				int s_flag1 = a_db.updateEstDt(query1);	
				int s_flag2 = sc_db.updateCarScrap(query2);	//2	(1,2 순서 바꾸면 안됨!!)
				if(s_flag1==1 && s_flag2==1){ flag1 = 1; }
			}else{	//매핑된 건이 없는 계약에 새번호를 매핑하는 경우
				flag1 = a_db.updateEstDt(query1);
				flag2 = sc_db.updateCarScrap(query2);
			}
		}
	}else{ 	// 희망차량번호가 빈값일때는 null로 다시 업데이트
		flag1 = a_db.updateEstDt(query1);
		flag2 = sc_db.updateCarScrap(query3);
	}
	
	// 임시차량번호 update		2017.12.07
	if(m_id.length() > 0 && l_cd.length() > 0){
		flag3 = a_db.updateTmpDrvNo(tmp_drv_no, m_id, l_cd);
	}
	
%>
<script language='javascript'>
<%	if(flag3 == false){%>
		alert("임시차량번호 저장에 실패하였습니다");
		parent.window.close();
		parent.opener.location.reload();
<%	}else if(flag1 == 0 && flag2 == 0){%>// or 조건을 and로 수정  2017.12.12
		alert("처리되지 않았습니다");
		//location='about:blank';
		parent.window.close();
		parent.opener.location.reload();
<%	}else{		%>		
		alert("처리되었습니다");
		<%if(mode.equals("board")){%>	
			parent.window.close();
			parent.opener.location.reload();
		<%}%>
<%	}			%>
</script>