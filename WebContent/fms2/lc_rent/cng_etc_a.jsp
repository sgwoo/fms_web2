<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.cont.*, acar.estimate_mng.*, acar.car_register.*, acar.coolmsg.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
//	if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_no  	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm  	= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
%>

<%
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		//cont
		ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		base.setOthers			(request.getParameter("others")	==null?"":request.getParameter("others"));
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		
		
		//계약특이사항 보조번호판 발급 요청----------------------------------------------------------------------------
		
		//car_second_plate
		CarSecondPlateBean second_plate = a_db.getCarSecondPlate(rent_mng_id, rent_l_cd);
		second_plate.setSecond_plate_yn(request.getParameter("second_plate_yn")==null?"":request.getParameter("second_plate_yn"));		
		second_plate.setWarrant(request.getParameter("warrant")==null?"":request.getParameter("warrant"));
		second_plate.setBus_regist(request.getParameter("bus_regist")==null?"":request.getParameter("bus_regist"));
		second_plate.setCar_regist(request.getParameter("car_regist")==null?"":request.getParameter("car_regist"));
		second_plate.setCorp_regist(request.getParameter("corp_regist")==null?"":request.getParameter("corp_regist"));
		second_plate.setCorp_cert(request.getParameter("corp_cert")==null?"":request.getParameter("corp_cert"));		
		second_plate.setClient_nm(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
		second_plate.setClient_number(request.getParameter("client_number")==null?"":request.getParameter("client_number"));
		second_plate.setClient_zip(request.getParameter("client_zip")==null?"":request.getParameter("client_zip"));
		second_plate.setClient_addr(request.getParameter("client_addr")==null?"":request.getParameter("client_addr"));
		second_plate.setClient_detail_addr(request.getParameter("client_detail_addr")==null?"":request.getParameter("client_detail_addr"));		
		second_plate.setReg_id(user_id);
		
		if (second_plate.getRent_mng_id().equals("")) {
			//=====[car_second_plate] insert=====
			second_plate.setRent_mng_id(rent_mng_id);
			second_plate.setRent_l_cd(rent_l_cd);
			flag7 = a_db.insertCarSecondPlate(second_plate);
		} else {
			//=====[car_second_plate] update=====
			flag7 = a_db.updateCarSecondPlate(second_plate);
		}
		
		if (second_plate.getSecond_plate_yn().equals("Y")) {
			UsersBean sender_bean = umd.getUsersBean(user_id);
			
			String target_id = nm_db.getWorkAuthUser("차량번호관리자"); //류길선과장
			UsersBean target_bean = umd.getUsersBean(target_id);
			
			String sub = "보조번호판 발급 요청";
			String content = "[보조번호판 발급 요청] &lt;br&gt; &lt;br&gt; 계약번호 : " + second_plate.getRent_l_cd();
			
			if (!car_no.equals("")) {
				content += " &lt;br&gt; &lt;br&gt; "+"차량번호 : "+car_no;
			}
			if (!car_nm.equals("")) {
				content += " &lt;br&gt; &lt;br&gt; "+"차명 : "+car_nm;
			}
			
			//필요서류
			if (second_plate.getWarrant().equals("Y")) {
				content += " &lt;br&gt; &lt;br&gt; "+"위임장 : 필수";
			}
			if (second_plate.getBus_regist().equals("Y")) {
				content += " &lt;br&gt; &lt;br&gt; "+"사업자등록증 : 필요";
			}
			if (second_plate.getCar_regist().equals("1")) {
				content += " &lt;br&gt; &lt;br&gt; "+"챠량등록증 : 사본";
			} else if (second_plate.getCar_regist().equals("2")) {
				content += " &lt;br&gt; &lt;br&gt; "+"챠량등록증 : 원본(회수필수)";
			}
			if (second_plate.getCorp_regist().equals("Y")) {
				content += " &lt;br&gt; &lt;br&gt; "+"법인등기부등본 : 필요";
			}
			if (second_plate.getCorp_cert().equals("Y")) {
				content += " &lt;br&gt; &lt;br&gt; "+"법인임감증명서 : 필요";
			}
			
			//우편물 고객주소지
			content += " &lt;br&gt; &lt;br&gt; "+"우편물 수령자 : " + second_plate.getClient_nm();
			content += " &lt;br&gt; &lt;br&gt; "+"수령자 연락처 : " + second_plate.getClient_number();
			content += " &lt;br&gt; &lt;br&gt; "+"우편물 수령지 : " + second_plate.getClient_zip() + " " + second_plate.getClient_addr() + " " + second_plate.getClient_detail_addr();
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+content+"</CONT>"+
		 				"    <URL></URL>";			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";			
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
			flag8 = cm_db.insertCoolMsg(msg);
		}
		
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		cont_etc.setDec_etc		(request.getParameter("dec_etc")==null?"":request.getParameter("dec_etc"));
		cont_etc.setCls_etc	(request.getParameter("cls_etc")		==null?"":request.getParameter("cls_etc"));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] insert=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
		
		//차량기본정보-----------------------------------------------------------------------------------------------
		
		//car_etc
		ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		car.setRemark (request.getParameter("remark")==null?"":request.getParameter("remark"));
		//=====[car_etc] update=====
		flag3 = a_db.updateContCarNew(car);
		
		
		//대여정보-----------------------------------------------------------------------------------------------
		
		for(int i=1; i<=fee_size; i++){
			//fee
			ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
			fees.setFee_cdt			(request.getParameter("fee_cdt"+i)		==null?"":request.getParameter("fee_cdt"+i));
			//=====[fee] update=====
			flag4 = a_db.updateContFeeNew(fees);
			
			//fee_etc
			ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i));
			fee_etcs.setBc_etc			(request.getParameter("bc_etc"+i)			==null?"":request.getParameter("bc_etc"+i));
			
			if(nm_db.getWorkAuthUser("영업효율",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){
				if(fee_etcs.getRent_mng_id().equals("")){
					fee_etcs.setRent_mng_id	(rent_mng_id);
					fee_etcs.setRent_l_cd	(rent_l_cd);
					fee_etcs.setRent_st		(Integer.toString(i));
					//=====[fee_etc] insert=====
					flag5 = a_db.insertFeeEtc(fee_etcs);
				}else{
					//=====[fee_etc] update=====
					flag5 = a_db.updateFeeEtc(fee_etcs);
				}
			}
			
			if(fee_etcs.getRent_st().equals("1")){
			
				fee_etcs.setBus_cau	(request.getParameter("bus_cau")==null?"":request.getParameter("bus_cau"));
		
				if(fee_etcs.getBus_cau().equals("")){
					fee_etcs.setBus_yn	("N");
				}else{
					fee_etcs.setBus_yn	("Y");	
				}
		
				//=====[fee_etc] update=====
				flag6 = a_db.updateFeeEtcBus(fee_etcs);			
			}
		}
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag4){	%>	alert('대여기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag5){	%>	alert('대여기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag7){	%>	alert('대여기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>



<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;
	
	if('<%=from_page%>' == '/fms2/lc_rent/lc_bc_frame.jsp'){
		fm.rent_st.value = '<%=request.getParameter("rent_st")==null?"1":request.getParameter("rent_st")%>';
		fm.action = '/fms2/lc_rent/lc_bc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else{
		fm.action = '<%=from_page%>';	
		fm.target = 'c_foot';
		fm.submit();
	}
	parent.opener.parent.window.c_body.location.reload();
	parent.window.close();
//	window.close();

</script>
</body>
</html>