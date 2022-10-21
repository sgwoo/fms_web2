<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, tax.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String su 	= request.getParameter("su")==null?"":request.getParameter("su");
	String gubun 	= request.getParameter("s_destphone")==null?"":request.getParameter("s_destphone");
	String s_destphone_off	= request.getParameter("s_destphone_off")==null?"":request.getParameter("s_destphone_off");
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String msg 			= request.getParameter("msg")==null?"":request.getParameter("msg");
	String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String loc 			= request.getParameter("loc")==null?"":request.getParameter("loc");  //차량위치 - 친구톡으로 약도 보내기 ( 선택된 경우만 )
	
if(gubun.equals("시화") || s_destphone_off.equals("시화 경매장 탁송")){
	gubun = "시화-글로비스";
}else if(gubun.equals("분당") || s_destphone_off.equals("분당 글로비스 탁송")){
	gubun = "분당-글로비스";
}else if(gubun.equals("010-9026-1853") || s_destphone_off.equals("AJ경매장 탁송")){
	gubun = "에이제이셀카(주)";
}
	
	String vid1[] = request.getParameterValues("c_id");
	
	int vid_size = 0;
	vid_size = vid1.length;
	
	String car_mng_id = "";
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
		
	//알림톡
	String auction_name = gubun;										// 경매장 이름
	String car_num_name_arr = msg;									// 출품예정차량
	String car_num_name_arr_count = su;							// 출품예정차량 대수
	String auction_date = AddUtil.getDate();				// 출품일자
	String park = "";
	
		//2.   매각결정 탁송의뢰 등록-----------
	for(int i=0;i < vid_size;i++){		
			car_mng_id = vid1[i];	
		
			int cnt = c_db.updateCons_dt(car_mng_id);
    }
    

	if(!destphone.equals("") && destphone.length() > 9){
		
	//	List<String> fieldList = Arrays.asList(auction_name, car_num_name_arr, car_num_name_arr_count, auction_date, sendname, sendphone);
	//	at_db.sendMessageReserve("acar0107", fieldList, destphone,  sendphone, null , gubun,  ck_acar_id);
		
		//loc가 있다면 
		if ( !loc.equals("") ) {
			
			String url1="";
			if ( loc.equals("1") ){  //본사
				 url1= "https://fms5.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
			} else if ( loc.equals("2") ) {  //부산
				 url1= "https://fms5.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg";
			} else if ( loc.equals("3") ) { //대전
				 url1= "https://fms5.amazoncar.co.kr/acar/images/center/dyd.jpg";
			} else if ( loc.equals("4") ) { //대구
				 url1= "https://fms5.amazoncar.co.kr/acar/images/center/gyg.jpg";
			} else if ( loc.equals("5") ) { //광주
				 url1= "https://fms5.amazoncar.co.kr/acar/images/center/jyj_origin_com.jpg";
			}
						
			String cont_plus = "\n\n[주차장 약도]  " + ShortenUrlGoogle.getShortenUrl(url1) ;
			
			auction_date = auction_date +  cont_plus;			
			
			//친구톡으로 이미지만 발송 
		//	at_db.sendMessage(1009, "0", cont_plus, destphone, sendphone, null, "", ck_acar_id);			
		}
				
		List<String> fieldList = Arrays.asList(auction_name, car_num_name_arr, car_num_name_arr_count, auction_date, sendname, sendphone);
		at_db.sendMessageReserve("acar0107", fieldList, destphone,  sendphone, null , gubun,  ck_acar_id);
		
		
	}
%>
<script language='javascript'>
<!--
	alert('전송되었습니다.');
	parent.document.form1.msgs.value = '';
	parent.document.form1.msglen.value = '0';
//-->
</script>
</body>
</html>