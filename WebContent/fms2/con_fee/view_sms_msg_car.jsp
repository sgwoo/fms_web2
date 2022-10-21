<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.car_mst.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="atp_db" scope="page" class="acar.kakao.AlimTemplateDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 		= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String msg_gubun = request.getParameter("msg_gubun")==null?"":request.getParameter("msg_gubun");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));		
		
	//[계약]보험정보 조회
	Hashtable insur = a_db.getInsurOfCont(l_cd, m_id);
	
	//cont_view
	Hashtable cont = a_db.getContViewCase(m_id, l_cd);
	String car_num = String.valueOf(cont.get("CAR_NO"));
	String car_name = String.valueOf(cont.get("CAR_NM"));
	
	//차량기본정보
   	ContCarBean f_fee_etc = a_db.getContFeeEtc(m_id, l_cd, "1");
   
 	//고객정보
	ClientBean client = al_db.getNewClient(insur.get("CLIENT_ID")+"");
   
  	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "");
	int mgr_size = car_mgrs.size();
	String f_person = "";
    String s_person = "";
    for(int i = 0 ; i < mgr_size ; i++){
		CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
       	if(mgr.getMgr_st().equals("추가이용자") || mgr.getMgr_st().equals("추가운전자")){
        	s_person =mgr.getMgr_nm();
       	}
   	} 
   
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
   
  	UsersBean user_bean = umd.getUsersBean(String.valueOf(insur.get("MNG_ID"))); 
  	UsersBean sener_user_bean = umd.getUsersBean(ck_acar_id);
  
  	String url1 = "http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+r_st+"";
  	String url2 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_accident.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
	
	String insur_mng_name = String.valueOf(insur.get("USER_NM"));						// 사고처리 담당자  
	String insur_mng_pos =String.valueOf(insur.get("USER_POS"));		// 사고처리 담당자 직급 
	String insur_mng_phone =String.valueOf(insur.get("USER_M_TEL"));		// 사고처리 담당자 전화 
	String insurance_name = String.valueOf(insur.get("INS_COM_NM"));		// 사고처리 보험사
	String insurance_phone = String.valueOf(insur.get("INS_TEL"));			// 사고처리 보험사 전화		
	String sos_service_info = "마스타자동차 (1588-6688)";								// 긴급출동	
	String marster_car_num = "1588-6688"; //마스터 자동차 연락처
	String sk_net_num = "1670-5494"; //sk네트웍스 연락처
	String sk_net_info = "sk네트웍스 (1670-5494)"; //sk네트웍스 연락처
	String car_service_info = "스피드메이트 (https://www.speedmate.com/shop_search/shop_search.do)";		// 정비업체
	//String insur_info_url = ShortenUrlGoogle.getShortenUrl(url1);
	//String accident_url = ShortenUrlGoogle.getShortenUrl(url2);
	String insur_info_url = url1;
	String accident_url = url2;
	
	insur_mng_pos =user_bean.getUser_pos();		// 사고처리 담당자 직급 
	
	String dist = AddUtil.parseDecimal(f_fee_etc.getAgree_dist());			// 주행거리
	String dist_fee = AddUtil.parseDecimal(f_fee_etc.getOver_run_amt());	// 주행거리 초과 비용
	String driver = String.valueOf(client.getClient_nm()) + " ";			// 운전자
	String driver2 = s_person + " 고객님 ";			// 운전자
	
	if(!s_person.equals("")){
		//driver += ", " + s_person + " 님";
	}else{
		driver2 = "없음";	
	}
	
	String visit_place = null;												// 반납장소
	String return_place = null;												// 약도
	String parking_map = "";													// 약도
	if ((insur.get("BR_ID")+"").equals("D1")) {
		visit_place = "현대카독크 2층 (042-824-1770)\n대전시 대덕구 벚꽃길 100";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";
		parking_map = "http://kko.to/5kTS9j74J";
	}
	else if ((insur.get("BR_ID")+"").equals("G1")) {
		visit_place = "성서현대정비센터 (053-582-2998)\n대구시 달서구 달서대로109길 58";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
		parking_map = "http://kko.to/9ZRdpTTmd";
	}
	else if ((insur.get("BR_ID")+"").equals("J1")) {
		visit_place = "상무1급자동차공업사 (062-385-0133)광주 서구 상무누리로 131-1";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
		parking_map = "http://kko.to/-VXvHD_ol";
	}
	else if ((insur.get("BR_ID")+"").equals("B1")) {
		visit_place = "부경자동차정비 (051-851-0606)\n부산 연제구 거제천로 270번길 5";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_bugyung.jpg";
		parking_map = "http://kko.to/0peONPKDI";
	}
	else {
		visit_place = "영남주차장 (02-6263-6378)\n서울시 영등포구 영등포로 34길 9";
		//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
		parking_map = "http://kko.to/M3C3ewyaQ";
	}
	if(!parking_map.equals("")){
		//return_place = "약도 바로 가기 "+ShortenUrlGoogle.getShortenUrl(parking_map); // 약도
		return_place = "약도 바로 가기 "+parking_map; // 약도
	}	
	
	String msg = "";
	
	if(msg_gubun.equals("mrent")){
		/*
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), driver, dist, dist_fee, insur_mng_name, insur_mng_phone,
						insurance_name, insurance_phone,  car_service_info, sos_service_info,  insur_mng_name,  insur_mng_phone, visit_place, return_place);	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0110");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
	    }
	    msg = content;
	    */
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), driver, driver2, dist, dist_fee, insur_mng_name, insur_mng_phone,
				insurance_name, insurance_phone);	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar_0262");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = content;	 
		List<String> fieldList2 = Arrays.asList(client.getFirm_nm(), car_service_info, sos_service_info, sk_net_info, insur_mng_name,  insur_mng_phone, visit_place, return_place, client.getFirm_nm());	
		AlimTemplateBean templateBean2 = atp_db.selectTemplate("acar_0264");
		String content2 = templateBean2.getContent();
		for (String field : fieldList2) {
			content2 = content2.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = msg + "\n\n\n"+ content2;
	}else if(msg_gubun.equals("mrent1")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), driver, driver2, dist, dist_fee, insur_mng_name, insur_mng_phone,
				insurance_name, insurance_phone);	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar_0262");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = content;
	}else if(msg_gubun.equals("mrent2")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), car_service_info, sos_service_info, sk_net_info, insur_mng_name,  insur_mng_phone, visit_place, return_place, client.getFirm_nm());	
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar_0264");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		msg = content;
	}else if (msg_gubun.equals("accid")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), cr_bean.getCar_no(), insurance_name, insurance_phone, marster_car_num, sk_net_num, insur_mng_name, insur_mng_phone, accident_url);
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0233");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
    	}
    	msg = content;
	}else if (msg_gubun.equals("accid_ins")){
		List<String> fieldList = Arrays.asList(insurance_name, insurance_name, insurance_phone, insur_mng_name, insur_mng_pos, insur_mng_phone, client.getFirm_nm(), cr_bean.getCar_no(), cm_bean.getCar_nm()+" "+cm_bean.getCar_name(), insur_info_url, sener_user_bean.getUser_nm(), sener_user_bean.getUser_pos(), sener_user_bean.getHot_tel());
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0089");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
    	}
    	msg = content;
	}else if (msg_gubun.equals("service")){
		List<String> fieldList = Arrays.asList(client.getFirm_nm(), car_service_info, insur_mng_name, insur_mng_phone);
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0204");
    	String content = templateBean.getContent();
	  	for (String field : fieldList) {
    		content = content.replaceFirst("\\#\\{.*?\\}", field);
    	}
    	msg = content;
	}
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function setSmsMsg(idx){
		var fm = document.form1;
		if(idx==1){
			opener.document.form1.txtMessage.value = fm.sms_msg2.value;
		}else if(idx==2 || idx==3 || idx==4 || idx==5 ){
			parent.document.form1.msg.value = fm.msg.value;
		}
		self.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='scd_size' value=''>
<input type='hidden' name='s_cnt' value='<%=s_cnt%>'>
<input type='hidden' name='h_fee_amt1' value=''>
<input type='hidden' name='h_dly_amt1' value=''>
<input type='hidden' name='h_fee_amt2' value=''>
<input type='hidden' name='h_dly_amt2' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>메시지<span class=style5> (<%if(msg_gubun.equals("accid")){%>사고처리<%}else if(msg_gubun.equals("park")){%>주차장<%}%>)</span></span></td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>        
    <% if(msg_gubun.equals("mrent")){%>
      <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>월렌트 안내 문자</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='5' cols='65' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(3);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("mrent1")){%>
      <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>월렌트 안내 문자1</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='5' cols='65' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(3);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("mrent2")){%>
      <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>월렌트 안내 문자2</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='5' cols='65' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(3);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("accid")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>사고처리(단순연락처) 안내</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='20' cols='72' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(2);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else if(msg_gubun.equals("accid_ins")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>보험접수 및 사고처리 안내</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='20' cols='72' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(5);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	    
    <%}else if (msg_gubun.equals("service")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>정비(일반식)안내</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='20' cols='72' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg(4);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	    
    <%}else if(msg_gubun.equals("park")){%>
    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	
                <tr> 
                    <td class='title' width='15%' rowspan="2">주차장</td>
                    <td align=''>
                    		 &nbsp;&nbsp;<select name='sms_msg2'  onchange="setSmsMsg('1')">
                        <option value="">================선택================</option>
						            <option value="주차장 위치: 영등포 영남주차장
서울시 영등포구 영등포로 34길 9
TEL: 02-6263-6378 
약도바로가기☞
http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg
 ">영등포주차장:영남주차장</option>
						            <option value="주차장 위치: 부산지점 하이트빌딩2층 
부산 연제구 반송로 69
TEL: 051-851-0606 
약도바로가기☞
http://fms1.amazoncar.co.kr/acar/images/center/hite.jpg 
 ">부산주차장:부산지점 하이트빌딩 3층</option>
						            <option value="주차장 위치: 현대카독크 2층 
대전시 대덕구 벚꽃길 100 현대카독크 2층
TEL: 042-824-1770 
약도바로가기☞
http://fms1.amazoncar.co.kr/acar/images/center/dyd.jpg 
">대전주차장:현대카독크 2층</option>
						            <option value="주차장 위치: 썬팅집 (3M아시아나상사) 
대구광역시 달서구 신당동321-86
TEL: 053-587-1550
약도바로가기☞
http://fms1.amazoncar.co.kr/acar/images/center/gyg.jpg 
">대구주차장:썬팅집 (3M아시아나상사)</option>
						            <option value="주차장 위치: 상무1급자동차공업사
광주광역시 서구 상무누리로 131
TEL: 062-371-3444 
약도바로가기☞
http://fms1.amazoncar.co.kr/acar/images/center/jyj_origin_com.jpg 
">광주주차장:상무1급자동차공업사</option>
                        </select>
        			 </td>
                </tr>
            </table>
        </td>
    </tr>	
   <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
<% if(msg_gubun.equals("park")){%>

<%}else if(msg_gubun.equals("accid")){%>
	parent.document.form1.msg_subject.value = '[아마존카 사고처리 안내]';	
	setSmsMsg(2);	
<%}else if(msg_gubun.equals("mrent")){%>
	parent.document.form1.msg_subject.value = '[아마존카 월렌트 안내]';
	setSmsMsg(3);	
<%}else if(msg_gubun.equals("mrent1")){%>
	parent.document.form1.msg_subject.value = '[아마존카 월렌트 안내1]';
	setSmsMsg(3);	
<%}else if(msg_gubun.equals("mrent2")){%>
	parent.document.form1.msg_subject.value = '[아마존카 월렌트 안내2]';
	setSmsMsg(3);	
<%}else if(msg_gubun.equals("service")){%>
	parent.document.form1.msg_subject.value = '[정비(일반식) 안내]';
	setSmsMsg(4);	
<%}else if(msg_gubun.equals("accid_ins")){%>
	parent.document.form1.msg_subject.value = '[아마존카 보험접수 및 사고처리 안내]';
	setSmsMsg(5);	
<%}%>

//-->
</script>
</body>
</html>