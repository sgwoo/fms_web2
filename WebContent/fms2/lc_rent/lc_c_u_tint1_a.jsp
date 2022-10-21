<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, tax.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.user_mng.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%

	
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
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 	= request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	
	int flag = 0;
		
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);

	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));

	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
		
	//용품	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	

	String tint_yn 	= request.getParameter("tint_yn")==null?"":request.getParameter("tint_yn");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String etc 	= request.getParameter("etc")==null?"":request.getParameter("etc");
	
		
	String film_st[]  	= request.getParameterValues("film_st");
	String film_st_etc[]  	= request.getParameterValues("film_st_etc");
	String sun_per[]  	= request.getParameterValues("sun_per");
	String cost_st[]  	= request.getParameterValues("cost_st");
	String est_st[]  	= request.getParameterValues("est_st");
	String est_m_amt[]  	= request.getParameterValues("est_m_amt");
	String sup_est_dt[]  	= request.getParameterValues("sup_est_dt");
	String sup_est_h[]  	= request.getParameterValues("sup_est_h");
	
	String o_sup_est_dt = "";
	String n_sup_est_dt = "";
	
	
	
	//측후면
	if(tint_yn.equals("1") || tint_yn.equals("3")){

		o_sup_est_dt = tint1.getSup_est_dt();
		
		tint1.setTint_st		("1");		
		tint1.setTint_yn		("Y");		
	
		//현재자료	
		tint1.setClient_id		(base.getClient_id());
		tint1.setCar_mng_id		(base.getCar_mng_id());
		tint1.setCar_nm			(cm_bean.getCar_nm());		
		tint1.setCar_num		(cr_bean.getCar_num());
		tint1.setCar_no			(cr_bean.getCar_no());
		if(tint1.getCar_num().equals("") && pur.getCar_num().equals("")) 	tint1.setCar_num		(pur.getCar_num());		


		if(off_id.length()>6){
			tint1.setOff_id			(off_id.substring(0,6));
			tint1.setOff_nm			(off_id.substring(6));
		}else if(off_id.length()==0){
			tint1.setOff_id			("");
			tint1.setOff_nm			("");		
		}
		
		tint1.setFilm_st		(film_st[0]  ==null?"":film_st[0]);		
		
		if(tint1.getFilm_st().equals("4"))	tint1.setFilm_st		(film_st_etc[0]  ==null?"":film_st_etc[0]);
		
		tint1.setSun_per		(sun_per[0]	==null? 0:AddUtil.parseDigit(sun_per[0]));
		tint1.setCost_st		(cost_st[0]  	==null?"":cost_st[0]);
		tint1.setEst_st			(est_st[0]  	==null?"":est_st[0]);
		tint1.setEst_m_amt		(est_m_amt[0]	==null? 0:AddUtil.parseDigit(est_m_amt[0]));		
		tint1.setSup_est_dt		(sup_est_dt[0]+sup_est_h[0]);
		tint1.setTint_su		(1);		
		
		tint1.setEtc		(etc);			
		
		n_sup_est_dt = tint1.getSup_est_dt();
		
		
		if(tint1.getSup_dt().equals("") && tint1.getReq_dt().equals("") && tint1.getConf_dt().equals("") && tint1.getPay_dt().equals("")){
		
			//기등록분이 있으면 수정
			if(!tint1.getTint_no().equals("")){
		
				//=====[tint] update=====
				flag2 = t_db.updateCarTint(tint1);
			
				String tint_no = tint1.getTint_no();
				
				//수신후 작업마감요청일 변경 안내문자 발송								
				if(!tint1.getDoc_code().equals("") && tint1.getOff_id().equals("002849") && tint1.getTint_yn().equals("Y") && !AddUtil.replace(n_sup_est_dt,"-","").equals(AddUtil.replace(o_sup_est_dt,"-",""))){
					
					UsersBean target_bean2 	= umd.getUsersBean("000103");						
		
					String sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", 썬팅 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
				
					if(tint1.getTint_st().equals("3")){
						sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", 블랙박스 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
					}
					if(tint1.getTint_st().equals("4")){
						sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", 내비게이션 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
					}
					if(tint1.getTint_st().equals("5")){
						sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", "+tint1.getCom_nm()+" 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
					}

					
					int i_msglen = AddUtil.lengthb(sms_content);
		
					String msg_type = "0";
		
					//80이상이면 장문자
					if(i_msglen>80) msg_type = "5";
						
					String send_phone = sender_bean.getUser_m_tel();
				
					if(!sender_bean.getHot_tel().equals("")){
						send_phone = sender_bean.getHot_tel();
					}
								
					IssueDb.insertsendMail_V5_H(send_phone, sender_bean.getUser_nm(), target_bean2.getUser_m_tel(), target_bean2.getUser_nm(), "", "", msg_type, "[작업요청일 변경안내]", sms_content, "", "", ck_acar_id, "tint_est");				
						
				}
				
			//등록	
			}else{
				tint1.setRent_mng_id		(rent_mng_id);
				tint1.setRent_l_cd		(rent_l_cd);		
				tint1.setReg_id			(user_id);		
			
				//=====[tint] insert=====
				String tint_no = t_db.insertCarTint(tint1);
			}
		}
		
	}
	
	//전면
	if(tint_yn.equals("2") || tint_yn.equals("3")){
	
		o_sup_est_dt = tint1.getSup_est_dt();
		
		tint2.setTint_st		("2");		
		tint2.setTint_yn		("Y");		
	
		//현재자료	
		tint2.setClient_id		(base.getClient_id());
		tint2.setCar_mng_id		(base.getCar_mng_id());
		tint2.setCar_nm			(cm_bean.getCar_nm());		
		tint2.setCar_num		(cr_bean.getCar_num());				
		tint2.setCar_no			(cr_bean.getCar_no());
		if(tint2.getCar_num().equals("") && pur.getCar_num().equals("")) 	tint2.setCar_num		(pur.getCar_num());


		if(off_id.length()>6){
			tint2.setOff_id			(off_id.substring(0,6));
			tint2.setOff_nm			(off_id.substring(6));
		}else if(off_id.length()==0){
			tint2.setOff_id			("");
			tint2.setOff_nm			("");		
		}
		
		tint2.setFilm_st		(film_st[1]  ==null?"":film_st[1]);		
		
		if(tint2.getFilm_st().equals("4"))	tint2.setFilm_st		(film_st_etc[1]  ==null?"":film_st_etc[1]);
		
		tint2.setSun_per		(sun_per[1]	==null? 0:AddUtil.parseDigit(sun_per[1]));
		tint2.setCost_st		(cost_st[1]  	==null?"":cost_st[1]);
		tint2.setEst_st			(est_st[1]  	==null?"":est_st[1]);
		tint2.setEst_m_amt		(est_m_amt[1]	==null? 0:AddUtil.parseDigit(est_m_amt[1]));		
		tint2.setSup_est_dt		(sup_est_dt[1]+sup_est_h[1]);
		tint2.setTint_su		(1);
		
		tint2.setEtc		(etc);			
		
		//20161025 전면썬팅 50000 디폴트 셋팅
		if(tint2.getTint_amt() == 0 && tint2.getOff_id().equals("002849")){
			tint2.setTint_amt(50000);
		}
		
		if(tint2.getTint_no().equals("") && car.getTint_ps_yn().equals("Y") && car.getTint_ps_amt() >0) tint2.setTint_amt(car.getTint_ps_amt());
		
		n_sup_est_dt = tint1.getSup_est_dt();
		
		
		if(tint2.getSup_dt().equals("") && tint2.getReq_dt().equals("") && tint2.getConf_dt().equals("") && tint2.getPay_dt().equals("")){
		
			//기등록분이 있으면 수정
			if(!tint2.getTint_no().equals("")){
		
				//=====[tint] update=====
				flag2 = t_db.updateCarTint(tint2);
			
				String tint_no = tint2.getTint_no();
				
				
				//수신후 작업마감요청일 변경 안내문자 발송								
				if(!tint2.getDoc_code().equals("") && tint2.getOff_id().equals("002849") && tint2.getTint_yn().equals("Y") && !AddUtil.replace(n_sup_est_dt,"-","").equals(AddUtil.replace(o_sup_est_dt,"-",""))){
					
					UsersBean target_bean2 	= umd.getUsersBean("000103");						
		
					String sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", 썬팅 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
				
					if(tint2.getTint_st().equals("3")){
						sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", 블랙박스 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
					}
					if(tint2.getTint_st().equals("4")){
						sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", 내비게이션 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
					}
					if(tint2.getTint_st().equals("5")){
						sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+client.getFirm_nm()+", 차명:"+cm_bean.getCar_nm()+", "+tint2.getCom_nm()+" 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
					}

					
					int i_msglen = AddUtil.lengthb(sms_content);
		
					String msg_type = "0";
		
					//80이상이면 장문자
					if(i_msglen>80) msg_type = "5";
						
					String send_phone = sender_bean.getUser_m_tel();
				
					if(!sender_bean.getHot_tel().equals("")){
						send_phone = sender_bean.getHot_tel();
					}
								
					IssueDb.insertsendMail_V5_H(send_phone, sender_bean.getUser_nm(), target_bean2.getUser_m_tel(), target_bean2.getUser_nm(), "", "", msg_type, "[작업요청일 변경안내]", sms_content, "", "", ck_acar_id, "tint_est");				
						
				}
								
			//등록	
			}else{
				tint2.setRent_mng_id		(rent_mng_id);
				tint2.setRent_l_cd		(rent_l_cd);		
				tint2.setReg_id			(user_id);		
			
				//=====[tint] insert=====
				String tint_no = t_db.insertCarTint(tint2);
			}
		}
			
	}
	
	

	
	//측후면 초기화
	if(tint_yn.equals("2") || tint_yn.equals("N")){
		
		TintBean tint = new TintBean();
			
		tint.setRent_mng_id	(tint1.getRent_mng_id());
		tint.setRent_l_cd	(tint1.getRent_l_cd());
		tint.setTint_st		("1");		
		tint.setTint_yn		("N");		
		tint.setTint_no		(tint1.getTint_no());				

		//기등록분이 있으면 초기화?
		if(!tint1.getTint_no().equals("")){			
			//=====[tint] update=====
			flag2 = t_db.updateCarTint(tint);	
			
		}else{
			tint.setReg_id			(user_id);
			//=====[tint] insert=====
			String tint_no = t_db.insertCarTint(tint);		
			
		}
		
	}
	
	//전면 초기화
	if(tint_yn.equals("1") || tint_yn.equals("N")){
		TintBean tint = new TintBean();
			
		tint.setRent_mng_id	(tint2.getRent_mng_id());
		tint.setRent_l_cd	(tint2.getRent_l_cd());
		tint.setTint_st		("2");		
		tint.setTint_yn		("N");	
		tint.setTint_no		(tint2.getTint_no());					

		//기등록분이 있으면 초기화?
		if(!tint2.getTint_no().equals("")){					
			//=====[tint] update=====
			flag2 = t_db.updateCarTint(tint);			
		}else{
			tint.setReg_id			(user_id);
			//=====[tint] insert=====
			String tint_no = t_db.insertCarTint(tint);				
		}
		
	}
	

%>


<%

		
		
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>



<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 		value="1">
</form>

<script language='javascript'>

	var fm = document.form1;
	
	if('<%=from_page2%>' == 'pur_doc_i.jsp'){
		alert('용품이 등록되었습니다. 새로고침을 하면 차량대금지급기안 내용이 없어지기 때문에 안합니다. 나머지 입력후 기안등록하세요.');				
	}else{
		if('<%=from_page%>' == '/fms2/car_pur/pur_doc_u.jsp' || '<%=from_page%>' == '/fms2/car_pur/pur_doc_frame.jsp'){
			fm.rent_st.value = '1';
			fm.action = '/fms2/car_pur/pur_doc_u.jsp';	
			fm.target = 'd_content';
			fm.submit();		
		}else{
			fm.action = '<%=from_page%>';			
			fm.target = 'c_foot';
			fm.submit();
		}
	}
	
	parent.window.close();

</script>
</body>
</html>