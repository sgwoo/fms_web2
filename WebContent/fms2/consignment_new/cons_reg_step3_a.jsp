<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

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
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	String  t_cmp_app = "";  //전국탁송구간
 	int  t_cmp_amt = 0;    //전국탁송구간요금
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
%>


<%
	String cons_no	 		= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String reg_code	 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String doc_no	 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 		= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String step		 		= request.getParameter("step")==null?"":request.getParameter("step");
	
	int    cons_su	 		= request.getParameter("cons_su")==null?0:AddUtil.parseInt(request.getParameter("cons_su"));
	String cons_st	 		= request.getParameter("cons_st")==null?"":request.getParameter("cons_st");
	String off_id	 			= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm	 		= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
//	String req_id	 			= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	int    u_seq	 			= request.getParameter("u_seq")==null?0:AddUtil.parseInt(request.getParameter("u_seq"));
//	String cmp_app	 		= request.getParameter("cmp_app")==null?"":request.getParameter("cmp_app");
	String after_yn	 		= request.getParameter("after_yn")==null?"N":request.getParameter("after_yn");
	
	String f_req_id		 	= request.getParameter("cng_req_id")==null?"":request.getParameter("cng_req_id");
	
	String req_id				[]		= request.getParameterValues("req_id");
	String cmp_app			[]		= request.getParameterValues("cmp_app");
	
	String seq					[] 		= request.getParameterValues("seq");
	String car_mng_id		[] 		= request.getParameterValues("car_mng_id");
	String rent_mng_id	[] 		= request.getParameterValues("rent_mng_id");
	String rent_l_cd		[] 		= request.getParameterValues("rent_l_cd");
	String client_id			[] 		= request.getParameterValues("client_id");
	String car_no			[] 		= request.getParameterValues("car_no");
	String car_nm			[] 		= request.getParameterValues("car_nm");
	String cons_cau		[] 		= request.getParameterValues("cons_cau");
	String cons_cau_etc	[]		= request.getParameterValues("cons_cau_etc");
	String cost_st      		[] 		= request.getParameterValues("cost_st");
	String pay_st       		[] 		= request.getParameterValues("pay_st");
	String from_st     		[] 		= request.getParameterValues("from_st");
	String from_place  	[] 		= request.getParameterValues("from_place");
	String from_comp    	[] 		= request.getParameterValues("from_comp");
	String from_title   		[] 		= request.getParameterValues("from_title");
	String from_man     	[] 		= request.getParameterValues("from_man");
	String from_tel			[] 		= request.getParameterValues("from_tel");
	String from_m_tel   	[]		= request.getParameterValues("from_m_tel");
	String from_req_dt  	[] 		= request.getParameterValues("from_req_dt");
	String from_req_h  	[] 		= request.getParameterValues("from_req_h");
	String from_req_s  	[] 		= request.getParameterValues("from_req_s");
	String from_est_dt 	[] 		= request.getParameterValues("from_est_dt");
	String from_est_h  	[] 		= request.getParameterValues("from_est_h");
	String from_est_s  	[] 		= request.getParameterValues("from_est_s");
	String from_dt      		[] 		= request.getParameterValues("from_dt");
	String from_h  			[] 		= request.getParameterValues("from_h");
	String from_s  			[] 		= request.getParameterValues("from_s");
	String to_st				[] 		= request.getParameterValues("to_st");
	String to_place    		[] 		= request.getParameterValues("to_place");
	String to_comp     	[] 		= request.getParameterValues("to_comp");
	String to_title     		[] 		= request.getParameterValues("to_title");
	String to_man       	[] 		= request.getParameterValues("to_man");
	String to_tel	   			[]		= request.getParameterValues("to_tel");
	String to_m_tel     	[] 		= request.getParameterValues("to_m_tel");
	String to_req_dt   		[] 		= request.getParameterValues("to_req_dt");
	String to_req_h    		[] 		= request.getParameterValues("to_req_h");
	String to_req_s   	 	[] 		= request.getParameterValues("to_req_s");
	String to_est_dt   	 	[] 		= request.getParameterValues("to_est_dt");
	String to_est_h    		[] 		= request.getParameterValues("to_est_h");
	String to_est_s    		[] 		= request.getParameterValues("to_est_s");
	String to_dt        		[] 		= request.getParameterValues("to_dt");
	String to_h    			[] 		= request.getParameterValues("to_h");
	String to_s    			[] 		= request.getParameterValues("to_s");
	String driver_id    		[] 		= request.getParameterValues("driver_id");
	String driver_nm   	[] 		= request.getParameterValues("driver_nm");
	String driver_m_tel	[] 		= request.getParameterValues("driver_m_tel");
	String wash_yn     	[] 		= request.getParameterValues("wash_yn");
	String oil_yn       		[] 		= request.getParameterValues("oil_yn");
	String oil_liter    		[]		= request.getParameterValues("oil_liter");
	String oil_est_amt  	[] 		= request.getParameterValues("oil_est_amt");
	String etc         			[] 		= request.getParameterValues("etc");
	String cons_amt    	[] 		= request.getParameterValues("cons_amt");
	String cons_other_amt    	[] 		= request.getParameterValues("cons_other_amt");
	String wash_amt    	[] 		= request.getParameterValues("wash_amt");
	String oil_amt      		[] 		= request.getParameterValues("oil_amt");
	String other        		[] 		= request.getParameterValues("other");
	String other_amt    	[] 		= request.getParameterValues("other_amt");
	String tot_amt      		[] 		= request.getParameterValues("tot_amt");
	String pay_dt       		[]		= request.getParameterValues("pay_dt");
	String cust_amt     	[] 		= request.getParameterValues("cust_amt");
	String cust_pay_dt  	[]		= request.getParameterValues("cust_pay_dt");
	String tot_dist    		[] 		= request.getParameterValues("tot_dist");
	String hipass_yn    	[] 		= request.getParameterValues("hipass_yn");
	String hipass_amt  	[] 		= request.getParameterValues("hipass_amt");
	String wash_fee 	 	[] 		= request.getParameterValues("wash_fee");
	String etc1_amt    	[] 		= request.getParameterValues("etc1_amt");
	String etc2_amt    	[] 		= request.getParameterValues("etc2_amt");
	
	
	if(mode.equals("reqid_cng")){
		
//		f_req_id = req_id[0]==null?"":req_id[0];
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettleCng(doc_no, f_req_id);
		//out.println("문서처리전 결재<br>");
		
		//=====[consignment] update=====
		flag1 = cs_db.updateRegCng(cons_no, f_req_id);
	}
	
	if(mode.equals("offid_cng")){
		
		String off_user_id = "";
		
		if(off_id.equals("002371")) off_user_id = "000094";//코리아탁송
		if(off_id.equals("002740")) off_user_id = "000095";//전국탁송
		if(off_id.equals("004107")) off_user_id = "000127";//코리아탁송부산
		if(off_id.equals("004171")||off_id.equals("007547")) off_user_id = "000139";//하이카콤대전		
	//	if(off_id.equals("008411")||off_id.equals("008468")) off_user_id = "000196";//일등전국탁송물류
		if(off_id.equals("008411")||off_id.equals("008468")||off_id.equals("008516")||off_id.equals("010919")||off_id.equals("010920")||off_id.equals("010921")) off_user_id = "000196";//일등전국탁송물류
		if(off_id.equals("009217")) off_user_id = "000223";//(주)아마존탁송
		if(off_id.equals("010255")) off_user_id = "000263";//스마일TS
		if(off_id.equals("011790")) off_user_id = "000328";//퍼스트드라이브
		
		if(!off_user_id.equals("")){
			//=====[doc_settle] update=====
			flag2 = d_db.updateDocSettleOffCng(doc_no, off_user_id);
			//out.println("문서처리전 결재<br>");
			
			//=====[consignment] update=====
			flag1 = cs_db.updateRegOffCng(cons_no, off_id, off_nm);
		}
	}
	
	if(mode.equals("cust_pay")){
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		ConsignmentBean cons 		= cs_db.getConsignment(cons_no, u_seq+1);
		
		cons.setCust_amt		(cust_amt     	[u_seq] ==null?0 : AddUtil.parseDigit(cust_amt     	[u_seq]));
		cons.setCust_pay_dt		(cust_pay_dt    [u_seq] ==null?"": cust_pay_dt    	[u_seq]);
		
		//=====[consignment] update=====
		flag1 = cs_db.updateConsignment(cons);
		out.println(u_seq+"번 탁송의뢰 수정<br>");
	}
	
	
	if(mode.equals("driver_modify")){
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		
		ConsignmentBean cons 		= cs_db.getConsignment(cons_no, u_seq+1);
		
		cons.setDriver_nm		(driver_nm    	[u_seq] ==null?"": driver_nm    	[u_seq]);
		cons.setDriver_m_tel	(driver_m_tel 	[u_seq] ==null?"": driver_m_tel 	[u_seq]);
		
		if(cons.getOff_id().equals("003158")){
			cons.setDriver_nm	(driver_id    	[u_seq] ==null?"": driver_id   		[u_seq]);
		}
		
		//=====[consignment] update=====
		flag1 = cs_db.updateConsignment(cons);
		out.println(u_seq+"번 탁송의뢰 수정<br>");
		
		
	}
	
	if(mode.equals("modify")){
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		for(int i=0;i<cons_su;i++){
			//out.println(car_no[i]+"<br>");
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no, AddUtil.parseInt(seq[i]));
			
			if(from_est_dt[i].equals("")){
				from_est_h[i] = "";
				from_est_s[i] = "";
			}
			if(to_est_dt[i].equals("")){
				to_est_h[i] = "";
				to_est_s[i] = "";
			}
			
			cons.setCons_st			(cons_st);
			cons.setCons_su			(cons_su);
			cons.setCmp_app			(cmp_app   		[i] ==null?"": cmp_app   		[i]);
			cons.setReq_id				(req_id   			[i] ==null?"": req_id   			[i]);
			cons.setCar_mng_id		(car_mng_id   	[i] ==null?"": car_mng_id   	[i]);
			cons.setRent_mng_id	(rent_mng_id  	[i] ==null?"": rent_mng_id  	[i]);
			cons.setRent_l_cd			(rent_l_cd    		[i] ==null?"": rent_l_cd    	[i]);
			cons.setClient_id			(client_id    		[i] ==null?"": client_id    		[i]);
			cons.setCar_no				(car_no       		[i] ==null?"": car_no       	[i]);
			cons.setCar_nm			(car_nm       		[i] ==null?"": car_nm       	[i]);
			cons.setCons_cau			(cons_cau     	[i] ==null?"": cons_cau     	[i]);
			cons.setCons_cau_etc	(cons_cau_etc  	[i] ==null?"": cons_cau_etc [i]);
			cons.setCost_st				(cost_st      		[i] ==null?"": cost_st      		[i]);
			cons.setPay_st				(pay_st       		[i] ==null?"": pay_st       		[i]);
			cons.setFrom_st      		(from_st      		[i] ==null?"": from_st      	[i]);
			cons.setFrom_place   	(from_place   	[i] ==null?"": from_place   	[i]);
			cons.setFrom_comp    	(from_comp    	[i] ==null?"": from_comp    	[i]);
			cons.setFrom_title   		(from_title   		[i] ==null?"": from_title   	[i]);
			cons.setFrom_man     	(from_man     	[i] ==null?"": from_man     	[i]);
			cons.setFrom_tel	  		(from_tel	  		[i] ==null?"": from_tel	  		[i]);
			cons.setFrom_m_tel   	(from_m_tel   	[i] ==null?"": from_m_tel   	[i]);
			cons.setFrom_req_dt  	(from_req_dt[i]+from_req_h[i]+from_req_s[i]);
			cons.setFrom_est_dt  	(from_est_dt[i]+from_est_h[i]+from_est_s[i]);
//			cons.setFrom_dt      		(from_dt      		[i] ==null?"": from_dt     	 	[i]);
			cons.setTo_st		  		(to_st		  		[i] ==null?"": to_st		  		[i]);
			cons.setTo_place     		(to_place     		[i] ==null?"": to_place     	[i]);
			cons.setTo_comp      	(to_comp      	[i] ==null?"": to_comp      	[i]);
			cons.setTo_title     		(to_title     		[i] ==null?"": to_title     		[i]);
			cons.setTo_man       		(to_man       		[i] ==null?"": to_man       	[i]);
			cons.setTo_tel	      		(to_tel	      		[i] ==null?"": to_tel	      		[i]);
			cons.setTo_m_tel     		(to_m_tel     		[i] ==null?"": to_m_tel     	[i]);
			cons.setTo_req_dt    		(to_req_dt[i]+to_req_h[i]+to_req_s[i]);
			cons.setTo_est_dt    		(to_est_dt[i]+to_est_h[i]+to_est_s[i]);
//			cons.setTo_dt        		(to_dt        		[i] ==null?"": to_dt        		[i]);
			cons.setDriver_nm		(driver_nm    	[i] ==null?"": driver_nm    	[i]);
			cons.setDriver_m_tel	(driver_m_tel 	[i] ==null?"": driver_m_tel 	[i]);
			cons.setWash_yn    		(wash_yn      	[i] ==null?"N": wash_yn      [i]);
			cons.setOil_yn     			(oil_yn       		[i] ==null?"N": oil_yn       	[i]);
			cons.setOil_liter  			(oil_liter    		[i] ==null?0 : AddUtil.parseDigit(oil_liter    		[i]));
			cons.setOil_est_amt		(oil_est_amt  	[i] ==null?0 : AddUtil.parseDigit(oil_est_amt  	[i]));
			cons.setEtc					(etc          		[i] ==null?"": etc          		[i]);
			//cons.setCons_amt		(cons_amt     	[i] ==null?0 : AddUtil.parseDigit(cons_amt     	[i]));
			//cons.setOil_amt			(oil_amt     		[i] ==null?0 : AddUtil.parseDigit(oil_amt     		[i]));
			//cons.setWash_amt		(wash_amt      	[i] ==null?0 : AddUtil.parseDigit(wash_amt    	[i]));
			//cons.setOther			(other        		[i] ==null?"": other        		[i]);
			//cons.setOther_amt		(other_amt    	[i] ==null?0 : AddUtil.parseDigit(other_amt    	[i]));
			//cons.setTot_amt			(tot_amt      		[i] ==null?0 : AddUtil.parseDigit(tot_amt      	[i]));
//			cons.setPay_dt				(pay_dt       		[i] ==null?"": pay_dt       		[i]);
			cons.setCust_amt			(cust_amt      	[i] ==null?0 : AddUtil.parseDigit(cust_amt     	[i]));
			
			if(tot_dist.length>1){	//에러방지(20190523)
				cons.setTot_dist			(tot_dist      		[i] ==null?0 : AddUtil.parseDigit(tot_dist     		[i]));
				cons.setHipass_yn		(hipass_yn    	[i] ==null?"": hipass_yn    	[i]);
				cons.setAfter_yn			(after_yn);
			}
			
			if( off_id.equals("009217")   ){  // 아마존탁송 이면 선택된 구간의 탁송요금 setting
				t_cmp_app = cmp_app[i]	==null?"":cmp_app[i];  //탁송구간
				//왕복인경우 2번? 차량은 금액절반   cons_st :2 					
				if(!t_cmp_app.equals("")){
					t_cmp_amt = c_db.getCmp_app_amt(t_cmp_app);
				}
				
				if ( cons_st.equals("2") ) {
			 	   if(i==1) 		t_cmp_amt = t_cmp_amt /2 ;
			 	}
				cons.setCons_amt		(t_cmp_amt);		
			}
			
			
			if(cons.getCons_no().equals("")){
				cons.setCons_no			(cons_no);
				cons.setSeq				(i+1);
//				cons.setSeq				(AddUtil.parseInt(seq[i]));
				cons.setReg_code		(reg_code);
				cons.setOff_id			(off_id);
				cons.setOff_nm			(off_nm);
				cons.setCons_st			(cons_st);
				cons.setReg_id			(user_id);
				cons.setReg_dt			(AddUtil.getDate());
				
					//=====[consignment] insert=====
				cons_no = cs_db.insertConsignment(cons);
				//out.println(i+"번 탁송의뢰 등록<br>");
			}else{
				//=====[consignment] update=====
				flag1 = cs_db.updateConsignment(cons);   
				//out.println(i+"번 탁송의뢰 수정<br>");
			}
			
			
		// 탁송기사 재배정 SMS 문자 발송------------------------------------------------------------
			if(off_id.equals("009217")){ //아마존탁송 운전자 배정시 문자 보내기
				
				DocSettleBean doc 		= d_db.getDocSettle(doc_no);
				
				String consdrv_nm = "";
				String consdrv_tel = "";
				String driver_cont = "[탁송 재배정]";
				driver_cont = driver_cont + cons.getCar_no() + ":" + cons.getDriver_nm() + " " + cons.getDriver_m_tel();
				consdrv_nm = cons.getDriver_nm();
				consdrv_tel = cons.getDriver_m_tel();
				
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
				UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id1());
		
				
				String sendphone 	= sender_bean.getHot_tel();
				String sendname 	= "(주)아마존카";
				String destphone 	= target_bean.getUser_m_tel();
				String destname 	= target_bean.getUser_nm();
				
				String url1= "https://fms5.amazoncar.co.kr/off_web2/mobile/mobile.jsp?cons_no="+cons_no;
				
				String cont_plus = "["+driver_cont+"]  " +  ShortenUrlGoogle.getShortenUrl(url1) + "  ["+consdrv_nm + "-" + consdrv_tel+"]";
				
				
				//친구톡 	
				at_db.sendMessage(1009, "0", cont_plus, consdrv_tel, sendphone, null, "", ck_acar_id);
				
				System.out.println("[탁송운전자 재배정 문자메세지 fms2_1]"+url1);
							
				}
						
			
		}
		for(int i=cons_su;i<10;i++){
			flag1 = cs_db.deleteConsignment(cons_no, (i+1));
		}
		
		
	}	
	
	if(mode.equals("d_m")){
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		for(int i=0;i<cons_su;i++){
			
			//out.println(car_no[i]+"<br>");
			
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no, AddUtil.parseInt(seq[i]));
			
			if(from_est_dt[i].equals("")){
				from_est_h[i] = "";
				from_est_s[i] = "";
			}
			if(to_est_dt[i].equals("")){
				to_est_h[i] = "";
				to_est_s[i] = "";
			}
			
			cons.setCons_st			(cons_st);
			cons.setCons_su			(cons_su);
			cons.setCmp_app			(cmp_app   		[i] ==null?"": cmp_app   		[i]);
			cons.setReq_id				(req_id   			[i] ==null?"": req_id   			[i]);
			cons.setCar_mng_id		(car_mng_id   	[i] ==null?"": car_mng_id   	[i]);
			cons.setRent_mng_id	(rent_mng_id  	[i] ==null?"": rent_mng_id  	[i]);
			cons.setRent_l_cd			(rent_l_cd    		[i] ==null?"": rent_l_cd    	[i]);
			cons.setClient_id			(client_id    		[i] ==null?"": client_id    		[i]);
			cons.setCar_no				(car_no       		[i] ==null?"": car_no       	[i]);
			cons.setCar_nm			(car_nm       		[i] ==null?"": car_nm       	[i]);
			cons.setCons_cau			(cons_cau     	[i] ==null?"": cons_cau     	[i]);
			cons.setCons_cau_etc	(cons_cau_etc  	[i] ==null?"": cons_cau_etc [i]);
			cons.setCost_st				(cost_st      		[i] ==null?"": cost_st      		[i]);
			cons.setPay_st				(pay_st       		[i] ==null?"": pay_st       		[i]);
			cons.setFrom_st      		(from_st      		[i] ==null?"": from_st      	[i]);
			cons.setFrom_place   	(from_place   	[i] ==null?"": from_place   	[i]);
			cons.setFrom_comp    	(from_comp    	[i] ==null?"": from_comp    	[i]);
			cons.setFrom_title   		(from_title   		[i] ==null?"": from_title   	[i]);
			cons.setFrom_man     	(from_man     	[i] ==null?"": from_man     	[i]);
			cons.setFrom_tel	  		(from_tel	  		[i] ==null?"": from_tel	  		[i]);
			cons.setFrom_m_tel   	(from_m_tel   	[i] ==null?"": from_m_tel   	[i]);
			cons.setFrom_req_dt  	(from_req_dt[i]+from_req_h[i]+from_req_s[i]);
			cons.setFrom_est_dt  	(from_est_dt[i]+from_est_h[i]+from_est_s[i]);
			cons.setTo_st		  		(to_st		  		[i] ==null?"": to_st		  		[i]);
			cons.setTo_place     		(to_place     		[i] ==null?"": to_place     	[i]);
			cons.setTo_comp      	(to_comp      	[i] ==null?"": to_comp      	[i]);
			cons.setTo_title     		(to_title     		[i] ==null?"": to_title     		[i]);
			cons.setTo_man       		(to_man       		[i] ==null?"": to_man       	[i]);
			cons.setTo_tel	      		(to_tel	      		[i] ==null?"": to_tel	      		[i]);
			cons.setTo_m_tel     		(to_m_tel     		[i] ==null?"": to_m_tel     	[i]);
			cons.setTo_req_dt    		(to_req_dt[i]+to_req_h[i]+to_req_s[i]);
			cons.setTo_est_dt    		(to_est_dt[i]+to_est_h[i]+to_est_s[i]);
			cons.setDriver_nm		(driver_nm    	[i] ==null?"": driver_nm    	[i]);
			cons.setDriver_m_tel	(driver_m_tel 	[i] ==null?"": driver_m_tel 	[i]);
			cons.setWash_yn    		(wash_yn      	[i] ==null?"N": wash_yn      [i]);
			cons.setOil_yn     			(oil_yn       		[i] ==null?"N": oil_yn       	[i]);
			cons.setOil_liter  			(oil_liter    		[i] ==null?0 : AddUtil.parseDigit(oil_liter    		[i]));
			cons.setOil_est_amt		(oil_est_amt  	[i] ==null?0 : AddUtil.parseDigit(oil_est_amt  	[i]));
			cons.setEtc					(etc          		[i] ==null?"": etc          		[i]);
			cons.setCust_amt			(cust_amt      	[i] ==null?0 : AddUtil.parseDigit(cust_amt     	[i]));
			cons.setTot_dist			(tot_dist      		[i] ==null?0 : AddUtil.parseDigit(tot_dist     		[i]));
			cons.setHipass_yn		(hipass_yn    	[i] ==null?"": hipass_yn    	[i]);
			cons.setAfter_yn			(after_yn);
			
			
			//=====[consignment] update=====
			flag1 = cs_db.updateConsignment(cons);
			//out.println(i+"번 탁송의뢰 수정<br>");
		
			
			
		// 탁송기사 재배정 SMS 문자 발송------------------------------------------------------------
			if(off_id.equals("009217")){ //아마존탁송 운전자 배정시 문자 보내기
				
				DocSettleBean doc 		= d_db.getDocSettle(doc_no);
				
				String consdrv_nm = "";
				String consdrv_tel = "";
				String driver_cont = "[탁송 재배정]";
				driver_cont = driver_cont + cons.getCar_no() + ":" + cons.getDriver_nm() + " " + cons.getDriver_m_tel();
				consdrv_nm = cons.getDriver_nm();
				consdrv_tel = cons.getDriver_m_tel();
				
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
				UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id1());
		
				
				String sendphone 	= sender_bean.getHot_tel();
				String sendname 	= "(주)아마존카";
				String destphone 	= target_bean.getUser_m_tel();
				String destname 	= target_bean.getUser_nm();
				
				String url1= "https://fms5.amazoncar.co.kr/off_web2/mobile/mobile.jsp?cons_no="+cons_no;
				
				//String cont_plus = "["+driver_cont+"]  " +  ShortenUrlGoogle.getShortenUrl(url1) + "  ["+consdrv_nm + "-" + consdrv_tel+"]";
				String cont_plus = "["+driver_cont+"]  " +  url1 + "  ["+consdrv_nm + "-" + consdrv_tel+"]";
				
				
				//친구톡 	
				at_db.sendMessage(1009, "0", cont_plus, consdrv_tel, sendphone, null, "", ck_acar_id);
				
				System.out.println("[탁송운전자 재배정 문자메세지 fms2_2]"+url1);
				
				}
						
			
		}

		
	}	
	
	if(doc_bit.equals("u")){
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		for(int i=0;i<cons_su;i++){
			
			out.println(car_no[i]+"<br>");
				
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no, AddUtil.parseInt(seq[i]));
			
			cons.setFrom_dt  		(from_dt[i]+from_h[i]+from_s[i]);
			cons.setTo_dt    		(to_dt[i]+to_h[i]+to_s[i]);
			cons.setCons_amt  	(cons_amt  	[i] ==null?0 : AddUtil.parseDigit(cons_amt  [i]));
			
			cons.setWash_amt	(wash_amt  	[i] ==null?0 : AddUtil.parseDigit(wash_amt [i]));
			cons.setOil_amt  		(oil_amt   		[i] ==null?0 : AddUtil.parseDigit(oil_amt   	[i]));
			cons.setOther_amt	(other_amt  	[i] ==null?0 : AddUtil.parseDigit(other_amt [i]));
			cons.setTot_amt		(tot_amt  		[i] ==null?0 : AddUtil.parseDigit(tot_amt  	[i]));
			cons.setCons_other_amt  	(cons_other_amt  	[i] ==null?0 : AddUtil.parseDigit(cons_other_amt  [i]));
			cons.setEtc1_amt  	(etc1_amt  	[i] ==null?0 : AddUtil.parseDigit(etc1_amt  [i]));
			cons.setEtc2_amt  	(etc2_amt  	[i] ==null?0 : AddUtil.parseDigit(etc2_amt  [i]));
		//	cons.setOther			(other    		[i] ==null?"": other 	  [i]);
			cons.setCust_amt		(cust_amt  	[i] ==null?0 : AddUtil.parseDigit(cust_amt 	[i]));
			cons.setCust_pay_dt	(cust_pay_dt[i] ==null?"": cust_pay_dt[i]);
			cons.setTot_dist		(tot_dist  		[i] ==null?0 : AddUtil.parseDigit(tot_dist 		[i]));
		//	cons.setHipass_amt	(hipass_amt	[i] ==null?0 : AddUtil.parseDigit(hipass_amt[i]));
			cons.setWash_fee		(wash_fee		[i] ==null?0 : AddUtil.parseDigit(wash_fee	[i]));
			
			//=====[consignment] update=====
			flag1 = cs_db.updateConsignment(cons);
			//out.println(i+"번 탁송의뢰 수정<br>");
		}
	}
	
	if(doc_bit.equals("3")){
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		for(int i=0;i<cons_su;i++){
			
			out.println(car_no[i]+"<br>");
			
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no, AddUtil.parseInt(seq[i]));
			
			cons.setFrom_dt  		(from_dt[i]+from_h[i]+from_s[i]);
			cons.setTo_dt    		(to_dt[i]+to_h[i]+to_s[i]);
			cons.setCons_amt  	(cons_amt   	[i] ==null?0 : AddUtil.parseDigit(cons_amt  [i]));
			
			cons.setWash_amt	(wash_amt  	[i] ==null?0 : AddUtil.parseDigit(wash_amt [i]));
			cons.setOil_amt  		(oil_amt    	[i] ==null?0 : AddUtil.parseDigit(oil_amt   	[i]));
			cons.setOther_amt	(other_amt  	[i] ==null?0 : AddUtil.parseDigit(other_amt [i]));
			cons.setCons_other_amt  	(cons_other_amt  	[i] ==null?0 : AddUtil.parseDigit(cons_other_amt  [i]));
			cons.setEtc1_amt  	(etc1_amt  	[i] ==null?0 : AddUtil.parseDigit(etc1_amt  [i]));
			cons.setEtc2_amt  	(etc2_amt  	[i] ==null?0 : AddUtil.parseDigit(etc2_amt  [i]));
			cons.setTot_amt		(tot_amt  		[i] ==null?0 : AddUtil.parseDigit(tot_amt  	[i]));
		//	cons.setOther			(other    		[i] ==null?"": other 	  [i]);
			cons.setCust_amt		(cust_amt  	[i] ==null?0 : AddUtil.parseDigit(cust_amt 	[i]));
			cons.setCust_pay_dt	(cust_pay_dt	[i] ==null?"": cust_pay_dt[i]);
			cons.setTot_dist		(tot_dist  		[i] ==null?0 : AddUtil.parseDigit(tot_dist 		[i]));
	//		cons.setHipass_amt	(hipass_amt	[i] ==null?0 : AddUtil.parseDigit(hipass_amt[i]));
			cons.setWash_fee		(wash_fee		[i] ==null?0 : AddUtil.parseDigit(wash_fee  	[i]));
			
			//=====[consignment] update=====
			flag1 = cs_db.updateConsignment(cons);
			//out.println(i+"번 탁송의뢰 수정<br>");
		}
		
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		DocSettleBean doc 		= d_db.getDocSettle(doc_no);
		
		String doc_step = "2";
		
		if(off_id.equals("003158")){
			doc_step = "3";
		}
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		//out.println("문서처리전 결재<br>");
		
		
		
		
		//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String sub 		= "탁송의뢰 정산";
		String cont 	= "[탁송번호:"+cons_no+"] 탁송의뢰를 정산하였습니다. 정산확인 바랍니다.";
		String url 		= "/fms2/consignment_new/cons_reg_step4.jsp?cons_no="+cons_no;
		String m_url  = "/fms2/consignment_new/cons_rec_frame.jsp";
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id1());
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		//보낸사람
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
		
		//flag3 = cm_db.insertCoolMsg(msg);
//		out.println("쿨메신저 수정<br>");
		//System.out.println("쿨메신저(탁송의뢰정산)"+cons_no+"-----------------------"+target_bean.getUser_nm());
	}
	
	if(doc_bit.equals("5")){//확인
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		flag1 = cs_db.updateConsignmentConf(cons_no);
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
		
		String doc_step = "2";
		
		//=====[doc_settle] update=====
//		flag2 = d_db.updateDocSettle(doc.getDoc_no(), user_id, doc_bit, doc_step);
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), doc.getUser_id1(), doc_bit, doc_step);
		//out.println("문서처리전 결재<br>");
		
	}
	
	if(doc_bit.equals("6")){//팀장
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
		
		String doc_step = "3";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), user_id, doc_bit, doc_step);
		//out.println("문서처리전 결재<br>");
	}	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('탁송 수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
<%		if(!flag2){	%>	alert('문서품의서 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag3){	%>	alert('쿨메신저 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
  <input type='hidden' name='cons_no' 			value='<%=cons_no%>'>    
</form>
<script language='javascript'>
	var fm = document.form1;	
	<%if(doc_bit.equals("3")){%>
	fm.action = 'cons_settle_frame.jsp';
	<%}else if(doc_bit.equals("4")||doc_bit.equals("5")){%>
	fm.action = '<%=from_page%>';
	<%}else{
		if(step.equals("4") || mode.equals("reqid_cng")){%>
	fm.action = 'cons_reg_step4.jsp';
<%		}else if(mode.equals("offid_cng")){%>
	fm.action = 'cons_reg_step2.jsp';	
	<%	}else{%>
	fm.action = 'cons_reg_step3.jsp';	
	<%	}%>
	<%}%>	
	fm.target = 'd_content';
	fm.submit();
	
	<%if(mode.equals("reqid_cng")||mode.equals("offid_cng")){%>
	parent.window.close();
	<%}%>
</script>
</body>
</html>