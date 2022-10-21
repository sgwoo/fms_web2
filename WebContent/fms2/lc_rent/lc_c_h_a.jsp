<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.secondhand.*, acar.client.*, acar.im_email.*, tax.*, acar.car_mst.*, acar.coolmsg.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
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
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String now_stat 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
%>


<%
	if(cng_item.equals("cont_check")){
		//대여기타정보-----------------------------------------------------------------------------------------------
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		(rent_st);
			//=====[fee_etc] insert=====
			flag2 = a_db.insertFeeEtc(fee_etc);
		}
		
		//=====[fee_etc] update=====
		flag1 = a_db.updateFeeEtcCheck(rent_mng_id, rent_l_cd, rent_st, user_id);
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('점검 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("cont_cng_check")){
		//대여기타정보-----------------------------------------------------------------------------------------------
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		(rent_st);
			//=====[fee_etc] insert=====
			flag2 = a_db.insertFeeEtc(fee_etc);
		}
		
		//=====[fee_etc] update=====
		flag1 = a_db.updateFeeEtcCngCheck(rent_mng_id, rent_l_cd, rent_st, user_id);
		
		
		//20191108 계약승계은 계약변경확인시  계약안내메일 발송 한다.
		if(now_stat.equals("승계계약")){  // || now_stat.equals("연장계약")
			
			//거래처정보
			ClientBean client = al_db.getClient(base.getClient_id());
			
   			//통합안내문 고객 메일발송
   			if(client.getCon_agnt_email().length() > 5 ){	
   		
				//	1. d-mail 등록-------------------------------
	
				DmailBean d_bean = new DmailBean();
				d_bean.setSubject			(client.getFirm_nm()+"님, (주)아마존카 서비스 통합 안내문입니다."); //장기대여 이용 안내문
				d_bean.setSql				("SSV:"+client.getCon_agnt_email().trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+client.getCon_agnt_email().trim()+">");
				d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(0);
				d_bean.setGubun				(rent_l_cd+"scd_fee");
				d_bean.setRname				("mail");
				d_bean.setMtype       		(0);
				d_bean.setU_idx       		(1);//admin계정
				d_bean.setG_idx				(1);//admin계정
				d_bean.setMsgflag     		(0);	
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&rent_st=1");
			
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+3")) flag += 1;
				
				String car_comp_id = "";
				//차량기본정보
				ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
				//자동차기본정보
				cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
				car_comp_id = cm_bean.getCar_comp_id();	
			
				//20140210 현대자동차 블루멤버스 안내메일 발송
				if(car_comp_id.equals("0001") && base.getCar_gu().equals("1")){
			
					d_bean.setSubject			(client.getFirm_nm()+"님, 현대자동차 블루멤버스제도 시행 안내문입니다. (주)아마존카");
					d_bean.setGubun				(rent_l_cd+"bluemem");
					d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/etc/bluemem.html");
					if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+3")) flag += 1;						
				}      			
		
   			}	
   			
   			
   			//20210714 계약승계담당자한테 메시지 발송 : 승계처리 완료메시지
   			
   			//차량등록정보
   			if(!base.getCar_mng_id().equals("")){
   				cr_bean = crd.getCarRegBean(base.getCar_mng_id());
   			}
   			
   			String sub2 		= "승계처리완료";
   			String cont2 		= client.getFirm_nm() + " "+cr_bean.getCar_no()+" 차량 계약승계 스케줄이관 및 처리 완료되었습니다.";
   			
   			UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
   			UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
   			
   			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
	  						"<ALERTMSG>"+
							"    <BACKIMG>4</BACKIMG>"+
	  						"    <MSGTYPE>104</MSGTYPE>"+
							"    <SUB>"+sub2+"</SUB>"+
	  						"    <CONT>"+cont2+"</CONT>"+
							"    <URL></URL>";
			xml_data2 += "   <TARGET>"+target_bean.getId()+"</TARGET>";
			
			xml_data2 += "   <SENDER>"+sender_bean.getId()+"</SENDER>"+
							"    <MSGICON>10</MSGICON>"+
	  						"    <MSGSAVE>1</MSGSAVE>"+
	 						"    <LEAVEDMSG>1</LEAVEDMSG>"+
  							"    <FLDTYPE>1</FLDTYPE>"+
	 						"  </ALERTMSG>"+
  							"</COOLMSG>";
		
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
					
			boolean m_flag2 = cm_db.insertCoolMsg(msg2);
   			
   			
		}
		
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('변경확인 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("cancel_cls")){
		
		//계약부활
		flag1 = a_db.rebirthCont(rent_mng_id, rent_l_cd, base.getCar_mng_id());
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약부활 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	String del_chk = "Y";
	
	//월렌트 차량예약 연동계약 취소하기
	if(cng_item.equals("lc_rm_delete")){
	
		String sh_res_seq = ec_db.getShResSeq(rent_mng_id, rent_l_cd);
		
		if(!sh_res_seq.equals("")){
			ShResBean shBn = shDb.getShRes(base.getCar_mng_id(), sh_res_seq);
			if(shBn.getUse_yn().equals("Y")){
				//취소처리
				String  d_flag1 =  shDb.call_sp_sh_res_dire_cancel(base.getCar_mng_id(), sh_res_seq);
				
				//call_sp_sh_res_dire_cancel에서 취소처리가 안되어 있다면 다음에서 처리
				if(base.getUse_yn().equals("Y")){
					//flag1 = a_db.deleteCont(rent_mng_id, rent_l_cd);
					base.setUse_yn("N");
					//=====[cont] update=====
					flag1 = a_db.updateContBaseNew(base);
					//보유차 살리기
					flag2 = a_db.rebirthUseCar(base.getCar_mng_id());
					//등록차량 상태값 초기화
					flag3 = a_db.updateCarStatCng(base.getCar_mng_id());	
					//스케줄정리
					flag3 = a_db.updateRmScdFeeCancel(rent_mng_id, rent_l_cd);
				}
			}else{
				//전자계약 전송건은 삭제하지 못함 (모바일을 제외)
				//int alink_count2 = ln_db.getALinkCnt("rm_rent_link",   rent_l_cd);
				//int alink_count3 = ln_db.getALinkCnt("rm_rent_link_m", rent_l_cd);
				//if(alink_count2 > 0){
				//	del_chk = "N";
				//}
				//if(del_chk.equals("Y")){
					//flag1 = a_db.deleteCont(rent_mng_id, rent_l_cd);
					base.setUse_yn("N");
					//=====[cont] update=====
					flag1 = a_db.updateContBaseNew(base);
					//보유차 살리기
					flag2 = a_db.rebirthUseCar(base.getCar_mng_id());
					//등록차량 상태값 초기화
					flag3 = a_db.updateCarStatCng(base.getCar_mng_id());
					//스케줄정리
					flag3 = a_db.updateRmScdFeeCancel(rent_mng_id, rent_l_cd);
				//}
			}
		}
		
		
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('월렌트 차량예약 연동계약 취소 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>



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
</form>
<script language='javascript'>

	var fm = document.form1;
	
	fm.action = 'lc_c_h.jsp';
	fm.target = 'c_body';
	<%if(cng_item.equals("lc_rm_delete")){%>
		
		<%if(del_chk.equals("N")){%>
			alert('전자계약 전송건은 삭제하지 못합니다. 해지 등록하십시오.');
		<%}%>
		
		fm.action = 'lc_rm_frame.jsp';
		fm.target = 'd_content';
	<%}%>
	fm.submit();
	
</script>
</body>
</html>