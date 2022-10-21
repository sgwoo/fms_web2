<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.car_service.*, acar.user_mng.*, acar.coolmsg.*,  acar.car_sche.*"%>

<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");//사고관리번호
	String cust_req_dt =  request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"); //청구일자
	
	int cust_s_amt 	=  request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt")); //청구 공급가
	int cust_v_amt 	=  request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt")); //청구 부가세
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
		
	AccidentBean accid = as_db.getAccidentBean(c_id, accid_id);
	
	int flag = 0;	
	int count = 0;
	boolean flag2 = true;
	boolean flag6 = true;
	
	String from_page 	= "";

	String no_dft_yn = request.getParameter("no_dft_yn")==null?"":request.getParameter("no_dft_yn"); //면제여부

	String 	sac_yn =  request.getParameter("sac_yn")==null?"":request.getParameter("sac_yn"); //확정여부	
	
	String 	bill_doc_yn =  request.getParameter("bill_doc_yn")==null?"":request.getParameter("bill_doc_yn"); //계산서 발행여부
		
	int c_amt = AddUtil.parseDigit(request.getParameter("cust_amt"));
	
	ServiceBean s_bean = a_csd.getService(c_id, accid_id, serv_id);
	
	int old_amt = s_bean.getCust_amt();
	
	s_bean.setCust_amt(request.getParameter("cust_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_amt")));
	s_bean.setCust_req_dt(request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"));
	s_bean.setCust_plan_dt(request.getParameter("cust_plan_dt")==null?"":request.getParameter("cust_plan_dt"));
	s_bean.setCust_pay_dt(request.getParameter("cust_pay_dt")==null?"":request.getParameter("cust_pay_dt"));  //해지정산후 입금된경우 입금일만 수정될 수 있음.
	s_bean.setNo_dft_yn(no_dft_yn);//면제여부
	s_bean.setNo_dft_cau(request.getParameter("no_dft_cau")==null?"":request.getParameter("no_dft_cau"));//면제사유
	s_bean.setBill_doc_yn(bill_doc_yn);  //세금계산서 발행여부 0:미발행 1:개별발행
	s_bean.setBill_mon(request.getParameter("bill_mon")==null?"":request.getParameter("bill_mon"));		
	s_bean.setUpdate_id(user_id);//수정자
	s_bean.setUpdate_dt(AddUtil.getDate());//수정일자
	s_bean.setExt_amt(request.getParameter("ext_amt")==null?0:AddUtil.parseDigit(request.getParameter("ext_amt"))); //고객입금액
	s_bean.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_s_amt"))); //해지정산시 포함금액
	s_bean.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_v_amt"))); //해지정산시 포함금액
	s_bean.setCls_amt(request.getParameter("cls_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_amt"))); //해지정산시 포함금액
	s_bean.setCust_s_amt(request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt"))); //청구 공급가액
	s_bean.setCust_v_amt(request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt"))); //청구 부가세액
	s_bean.setExt_cau(request.getParameter("ext_cau")==null?"":request.getParameter("ext_cau"));//고객입금내역
		
		// 면책금 담당자 확정처리
	if(!a_csd.updateServiceSac(c_id, serv_id))	flag += 1;			

	int cnt = 0;
	//면책금 스케쥴 작성 여부
	cnt = a_csd.getServiceScdExt(s_bean);
	if ( cnt < 1) {
	   if( !serv_id.equals("")  ){	
		   count = a_csd.insertServiceScdExt(s_bean);
	   }
	}					
		//금액 수정될 경우 - 입금이 안된 건
	if(!serv_id.equals("") && c_amt != old_amt && s_bean.getCust_pay_dt().equals("")){
//	if(!serv_id.equals("") && c_amt > 0){
		count = a_csd.getServiceScdExtAmt(s_bean);
	}		
	//면제로 수정된 경우
	if (no_dft_yn.equals("Y")) {
		count = a_csd.updateServiceScdExt(s_bean);
	}

//면책금이 0으로 수정된 경우 bill_yn = 'N' , 면책금 스케쥴 생성 안된경우 제외 (고객입금분 등) -????
//	if(!serv_id.equals("") && c_amt == 0 && no_dft_yn.equals("")){
	if(!serv_id.equals("") && c_amt == 0 ){
		count = a_csd.updateServiceScdExt(s_bean);
	}
	
	// 두바이카 정보제공 수수료 선청구는 제외
	if (  c_id.equals("005938") && accid_id.equals("014279") ) {
		
	} else {
		
		if (bill_doc_yn.equals("1")) {				
			//세금계산서 발행의뢰 메세지 전송  ->계산서 발행여부 			
		   //계약조회 - 사고관련 
			Hashtable ht_c = as_db.getRentCase(m_id, l_cd);
						
				
		  //담당자에게 메세지 전송------------------------------------------------------------------------------------------							
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
					
			String sub 	= "면책금계산서발행요청";
			String cont 	= "▣ 면책금계산서발행요청  &lt;br&gt; &lt;br&gt;  "+ String.valueOf(ht_c.get("FIRM_NM"))+ " &lt;br&gt; &lt;br&gt;  " + String.valueOf(ht_c.get("CAR_NO")) + " &lt;br&gt; &lt;br&gt; 사고일시:" + accid.getAccid_dt() + ", 청구일자:" + cust_req_dt + "공급가:"+ cust_s_amt + ", 부가:"+cust_v_amt ;  	
										
			String url 	= "";		 
			
			url 		= "/tax/issue_3/issue_3_sc4.jsp";		 
				
			String target_id = nm_db.getWorkAuthUser("세금계산서담당자");  //면책금 계산서 담당자
			
			//휴가인 경우			
			CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);  		
	
			if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id(); //대체근무자
				
					
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
		
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		//	xml_data += "    <TARGET>2006007</TARGET>";
			
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		  				"    <MSGICON>10</MSGICON>"+
		  				"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
		  				"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			flag2 = cm_db.insertCoolMsg(msg);
				
			System.out.println("쿨메신저(면책금계산서발행의뢰)"+ String.valueOf(ht_c.get("CAR_NO"))+"---------------------"+target_bean.getUser_nm());	
		
		}							
	}
			
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>

<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="serv_id" value='<%=serv_id%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//면책금 확정 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//면책금 확정 성공.. %>
	
    alert('처리되었습니다');
    fm.action = "accid_u_frame.jsp";		
	fm.target = "d_content";
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
