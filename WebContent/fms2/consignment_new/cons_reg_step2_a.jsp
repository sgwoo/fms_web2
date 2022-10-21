<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, java.text.SimpleDateFormat"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.car_office.*, acar.alink.*, acar.common.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cl_bean" class="acar.consignment.ConsignmentLinkBean" scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
 
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
	boolean flag7 = true; // 2018.03.13
	boolean flag8 = true; // 2018.03.26
	int result = 0;
	int    after_cnt	= 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	AlimTalkLogDatabase atl_db = AlimTalkLogDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<%!
	// 과거에 전송한 알림톡과 내용이 같은지 비교한다. 2018.03.14
	public boolean stringChacker(String cas, String fc, String cno, String cnm, String ad, String fp, String dn, String dmt){
		boolean result = false;
		String lines[] = cas.split("\\r?\\n");
		if(lines.length > 9){			
			if(lines[0].trim().equals((fc+"고객님 안녕하십니까.").trim()) &&
				lines[4].trim().equals(("★ "+cno+" ("+cnm+")").trim()) &&
				lines[5].trim().equals(("★ 예정일시 : "+ad).trim()) &&
				lines[6].trim().equals(("★ 약속장소 : "+fp).trim()) &&
				lines[7].trim().equals(("★ 탁송기사 : "+dn+" ("+dmt+")").trim())){
				result = true;
			}
		}
		return result;
	}
%>
<%
	String cons_no	 			= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String reg_code	 		= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String doc_no	 			= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 			= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String sms_msg	 		= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String off_msg	 			= request.getParameter("off_msg")==null?"N":request.getParameter("off_msg");
	String acar_driver_id		= "";
	
	int    cons_su	 			= request.getParameter("cons_su")==null?0:AddUtil.parseInt(request.getParameter("cons_su"));
	String cons_st	 			= request.getParameter("cons_st")==null?"":request.getParameter("cons_st");
	String off_id	 				= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm	 			= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String after_yn	 			= request.getParameter("after_yn")==null?"N":request.getParameter("after_yn");
	
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
	String from_st      		[] 		= request.getParameterValues("from_st");
	String from_place  	[] 		= request.getParameterValues("from_place");
	String from_comp     [] 		= request.getParameterValues("from_comp");
	String from_title  		[] 		= request.getParameterValues("from_title");
	String from_man     	[] 		= request.getParameterValues("from_man");
	String from_tel			[] 		= request.getParameterValues("from_tel");
	String from_m_tel   	[]		= request.getParameterValues("from_m_tel");
	String from_req_dt 	[] 		= request.getParameterValues("from_req_dt");
	String from_req_h  	[] 		= request.getParameterValues("from_req_h");
	String from_req_s  	[] 		= request.getParameterValues("from_req_s");
	String from_est_dt  	[] 		= request.getParameterValues("from_est_dt");
	String from_est_h  	[] 		= request.getParameterValues("from_est_h");
	String from_est_s  	[] 		= request.getParameterValues("from_est_s");
	String from_dt      		[] 		= request.getParameterValues("from_dt");
	String to_st				[] 		= request.getParameterValues("to_st");
	String to_place     		[] 		= request.getParameterValues("to_place");
	String to_comp      	[] 		= request.getParameterValues("to_comp");
	String to_title     		[] 		= request.getParameterValues("to_title");
	String to_man       	[] 		= request.getParameterValues("to_man");
	String to_tel	    		[]		= request.getParameterValues("to_tel");
	String to_m_tel     	[] 		= request.getParameterValues("to_m_tel");
	String to_req_dt  		[] 		= request.getParameterValues("to_req_dt");
	String to_req_h    		[] 		= request.getParameterValues("to_req_h");
	String to_req_s    		[] 		= request.getParameterValues("to_req_s");
	String to_est_dt    	[] 		= request.getParameterValues("to_est_dt");
	String to_est_h    		[] 		= request.getParameterValues("to_est_h");
	String to_est_s    		[] 		= request.getParameterValues("to_est_s");
	String to_dt        		[] 		= request.getParameterValues("to_dt");
	String driver_id    		[] 		= request.getParameterValues("driver_id");
	String driver_nm    	[] 		= request.getParameterValues("driver_nm");
	String driver_m_tel 	[] 		= request.getParameterValues("driver_m_tel");
	String wash_yn      	[] 		= request.getParameterValues("wash_yn");
	String oil_yn      		[] 		= request.getParameterValues("oil_yn");
	String oil_liter    		[]		= request.getParameterValues("oil_liter");
	String oil_est_amt  	[] 		= request.getParameterValues("oil_est_amt");
	String etc         			[] 		= request.getParameterValues("etc");
	String cons_amt     	[] 		= request.getParameterValues("cons_amt");
	String wash_amt     	[] 		= request.getParameterValues("wash_amt");
	String oil_amt     		[] 		= request.getParameterValues("oil_amt");
	String other        		[] 		= request.getParameterValues("other");
	String other_amt    	[] 		= request.getParameterValues("other_amt");
	String tot_amt      		[] 		= request.getParameterValues("tot_amt");
	String pay_dt       		[]		= request.getParameterValues("pay_dt");
	String cust_amt     	[] 		= request.getParameterValues("cust_amt");
	String hipass_yn    	[] 		= request.getParameterValues("hipass_yn");
	String sub_l_cd    [] 		= request.getParameterValues("sub_rent_l_cd");
	
	String cons_other_amt     	[] 		= request.getParameterValues("cons_other_amt");
	String etc1_amt     	[] 		= request.getParameterValues("etc1_amt");
	String etc2_amt     	[] 		= request.getParameterValues("etc2_amt");
	
	String target_id 	= "";
	String f_req_id 	= "";
	
	String consdrv_nm = "";
	String consdrv_tel = "";
	
	if(doc_bit.equals("")){
		
		//1. 탁송의뢰 수정/등록----------------------------------------------------------------------------------------	
		
		for(int i=0;i<cons_su;i++){
			
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no, AddUtil.parseInt(seq[i]));
			
			cons.setCons_su			(cons_su);
			cons.setCons_st			(cons_st);
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
			cons.setTo_st		  		(to_st		  		[i] ==null?"": to_st		  		[i]);
			cons.setTo_place     		(to_place     		[i] ==null?"": to_place     	[i]);
			cons.setTo_comp      	(to_comp      	[i] ==null?"": to_comp      	[i]);
			cons.setTo_title     		(to_title     		[i] ==null?"": to_title     		[i]);
			cons.setTo_man       		(to_man       		[i] ==null?"": to_man       	[i]);
			cons.setTo_tel	      		(to_tel	      		[i] ==null?"": to_tel	      		[i]);
			cons.setTo_m_tel     		(to_m_tel     		[i] ==null?"": to_m_tel     	[i]);
			cons.setTo_req_dt    		(to_req_dt[i]+to_req_h[i]+to_req_s[i]);
			cons.setWash_yn    		(wash_yn      	[i] ==null?"N": wash_yn     	[i]);
			cons.setOil_yn     			(oil_yn       		[i] ==null?"N": oil_yn       	[i]);
			cons.setOil_liter  			(oil_liter    		[i] ==null?0 : AddUtil.parseDigit(oil_liter    		[i]));
			cons.setOil_est_amt		(oil_est_amt  	[i] ==null?0 : AddUtil.parseDigit(oil_est_amt  	[i]));
			cons.setEtc					(etc          		[i] ==null?"": etc          		[i]);
			cons.setCust_amt			(cust_amt      	[i] ==null?0 : AddUtil.parseDigit(cust_amt     	[i]));
			cons.setHipass_yn		(hipass_yn    	[i] ==null?"": hipass_yn    	[i]);
			cons.setAfter_yn			(after_yn);
			cons.setSub_l_cd		(sub_l_cd    		[i] ==null?"": sub_l_cd    	[i]);
			
			//세차수수료 추가(20190509)	//시행초기라 디폴트값없이 직접입력하게. 추후도입예정.(VV도입시 정책에 맞게 수정해서 사용할것!)
			/* if(wash_yn[i].equals("M")||wash_yn[i].equals("Y")){		cons.setWash_fee(5000);			}	//기계세차 비용 5000원
			else if(wash_yn[i].equals("H")){			cons.setWash_fee(8000);			}	//손세차 비용 8000원  */
			
			if(cons.getAfter_yn().equals("Y")) after_cnt++;
			
			
			if(cons.getCons_no().equals("")){
				cons.setCons_no			(cons_no);
				cons.setSeq				(i+1);
				cons.setReg_code		(reg_code);
				cons.setOff_id			(off_id);
				cons.setOff_nm			(off_nm);
				cons.setCons_st			(cons_st);
				cons.setReg_id			(user_id);
				cons.setReg_dt			(AddUtil.getDate());
				//=====[consignment] insert=====
				cons_no = cs_db.insertConsignment(cons);
			}else{
				//=====[consignment] update=====
				flag1 = cs_db.updateConsignment(cons);
			}
		}
		
	}else if(doc_bit.equals("2")){
		
		//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
		
		String driver_cont = "[탁송배정]";
		String cons_num = "";
		for(int i=0;i<cons_su;i++){
					
			Hashtable ht_cons = cs_db.getConsignment_Links(cons_no, AddUtil.parseInt(seq[i]));
			
			String req_code  = Long.toString(System.currentTimeMillis());
	
			cl_bean.setCons_no		(cons_no+""+AddUtil.parseInt(seq[i]));
			cl_bean.setTmsg_seq	(req_code);
			cl_bean.setRent_l_cd	(String.valueOf(ht_cons.get("RENT_L_CD")));
			cl_bean.setDept_nm		(String.valueOf(ht_cons.get("DEPT_NM")));
			cl_bean.setCar_no		(String.valueOf(ht_cons.get("CAR_NO")));
			cl_bean.setCar_nm		(String.valueOf(ht_cons.get("CAR_NM")));
			cl_bean.setCons_cau	(String.valueOf(ht_cons.get("CONS_CAU")));
			cl_bean.setFirm_nm		(String.valueOf(ht_cons.get("FIRM_NM")));
			cl_bean.setFirm_ssn		(String.valueOf(ht_cons.get("FIRM_SSN")));
			cl_bean.setFirm_addr	(String.valueOf(ht_cons.get("FIRM_ADDR")));
			cl_bean.setFirm_tel		(String.valueOf(ht_cons.get("FIRM_TEL")));
			cl_bean.setFirm_m_tel	(String.valueOf(ht_cons.get("FIRM_M_TEL")));
			cl_bean.setFirm_email	(String.valueOf(ht_cons.get("CON_AGNT_EMAIL")));
			cl_bean.setAcar_mng	(String.valueOf(ht_cons.get("ACAR_MNG")));
			cl_bean.setAcar_tel		(String.valueOf(ht_cons.get("ACAR_TEL")));
			cl_bean.setOff_nm		(String.valueOf(ht_cons.get("OFF_NM")));
			cl_bean.setOff_drv		(driver_nm    	[i] ==null?"": driver_nm    	[i]);
			cl_bean.setOff_drv_tel	(driver_m_tel 	[i] ==null?"": driver_m_tel 	[i]);
			
			//채권양도통지서 및 확인서 데이터 조회 및 처리(20181127)
			Vector bond_trf_doc = cs_db.getBond_trf_doc(cons_no);
  			int bond_trf_doc_size = bond_trf_doc.size();
  			if(i==0 && bond_trf_doc_size==1){ 
	  			for(int j = 0 ; j < 1 ; j++){
	  				Hashtable btdoc = (Hashtable)bond_trf_doc.elementAt(j);
	  				cl_bean.setB_trf_yn					("Y");
	  				cl_bean.setIns_com_nm			(String.valueOf(btdoc.get("INS_COM_NM"))		);
	  				cl_bean.setFirm_zip					(String.valueOf(btdoc.get("ZIP"))						);
	  				cl_bean.setClient_nm				(String.valueOf(btdoc.get("CLIENT_NM"))			);
	  				cl_bean.setClient_st					(String.valueOf(btdoc.get("CLIENT_ST"))			);
	  				cl_bean.setClient_addr				(String.valueOf(btdoc.get("ADDR"))					);
	  				cl_bean.setIns_req_amt			(String.valueOf(btdoc.get("INS_REQ_AMT"))	);
	  				cl_bean.setIns_req_amt_han	(AddUtil.parseDecimalHan((String)btdoc.get("INS_REQ_AMT")));
	  				cl_bean.setAc_car_no				(String.valueOf(btdoc.get("CAR_NO"))				);
	  				cl_bean.setAc_car_nm				(String.valueOf(btdoc.get("CAR_NM"))				);
	  				cl_bean.setAccid_dt					(String.valueOf(btdoc.get("ACCID_DT"))			);
	  				cl_bean.setIns_use_st				(String.valueOf(btdoc.get("INS_USE_ST"))		);
	  				cl_bean.setIns_use_et				(String.valueOf(btdoc.get("INS_USE_ET"))		);
	  				if(String.valueOf(btdoc.get("CLIENT_ST")).equals("2")){
	  					cl_bean.setClient_ssn		(String.valueOf(btdoc.get("BIRTH"))		);
	  				}
	  			}
  			}
			
			cons_num = cs_db.insertConsignment_Link(cl_bean);
			
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no, AddUtil.parseInt(seq[i]));
			
			cons.setFrom_est_dt  	(from_est_dt[i]+from_est_h[i]+from_est_s[i]);
			cons.setTo_est_dt    	(to_est_dt[i]+to_est_h[i]+to_est_s[i]);
			cons.setDriver_nm			(driver_nm    	[i] ==null?"": driver_nm    	[i]);
			cons.setDriver_m_tel	(driver_m_tel 	[i] ==null?"": driver_m_tel 	[i]);
			
			if(cons.getAfter_yn().equals("Y")) after_cnt++;
			
			if(off_id.equals("003158")){
				String dv_id = driver_id[i] ==null?"":driver_id[i];
				String dv_nm = driver_nm[i] ==null?"":driver_nm[i];
				if(dv_id.equals("")){
					dv_id = umd.getUserID(dv_nm);
				}
				cons.setDriver_nm	(dv_id);
				acar_driver_id = dv_id;
			}
			
			driver_cont = driver_cont + cons.getCar_no() + ":" + cons.getDriver_nm() + " " + cons.getDriver_m_tel();
			consdrv_nm = cons.getDriver_nm();
			consdrv_tel = cons.getDriver_m_tel();
			if(i>0 && i+1<cons_su) driver_cont = driver_cont+" / ";
			
			//=====[consignment] update=====
			flag1 = cs_db.updateConsignment(cons);
	
			// ### acar0125 알림톡 발송 2018.03.13 ### start
			// 탁송사유(지연대차회수, 정비대차회수, 사고대차회수, 정비차량회수, 사고차량회수, 중도해지회수, 만기반납, 대여차량회수, 웰렌트차량회수)와 출발 구분이 고객인 경우 알림톡 발송
			//	지연대차회수:8, 정비대차회수:9, 사고대차회수:10, 정비차량회수:11, 사고차량회수:12, 중도해지회수:13, 만기반납:14, 대여차량회수:15, 웰렌트차량회수:22
			String cc_val = cons_cau[i];
			String customer_m_tel = "";
			String match1 = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
			String match2 =  "\\s{2,}";
			String arrival_date = "";
			String cons_no_seq = "";
			boolean send_switch = true;
			if(cc_val.equals("8")||cc_val.equals("9")||cc_val.equals("10")||cc_val.equals("11")||cc_val.equals("12")||cc_val.equals("13")||cc_val.equals("14")||cc_val.equals("15")||
					cc_val.equals("22")){
				if(from_st[i].equals("2")){// 출발 구분이 고객인 경우
					customer_m_tel = from_m_tel[i].replaceAll(match1, "");	// 고객 전화번호 특수문자 제거
					customer_m_tel = customer_m_tel.replaceAll(match2, "");	// 고객 전화번호 공백 제거
					arrival_date = from_req_dt[i];
					arrival_date += " ";
					arrival_date += from_req_h[i];
					arrival_date += ":";
					arrival_date += from_req_s[i];
					
					Date today = new Date();
					SimpleDateFormat date = new SimpleDateFormat("yyyyMM");
					int today_y_m = Integer.parseInt(date.format(today));//현재 연도 월 yyyyMM
					String check_y_m_str = "";
					int check_y_m = 0;
					
					String chk = "-";
					boolean check = from_req_dt[i].contains(chk);
					String[] spl_day;
					boolean chk_gubun = false;//요청일시가 과거인 경우
					// step1에서 알림톡을 전송한 경우 step2 결재과정에서 내용이 동일하면 알림톡을 전송하지 않는다.					
					if(check){
						spl_day = from_req_dt[i].split(chk);
						check_y_m_str = spl_day[0];
						check_y_m_str += spl_day[1];
						check_y_m = Integer.parseInt(check_y_m_str);						
						if(today_y_m > check_y_m){
							chk_gubun = true;
						}
					}
					String query_tran = "ATA_MMT_TRAN";
					String query_this_m = "ATA_MMT_LOG_";
					query_this_m += String.valueOf(today_y_m);
					//String chk_alim_str = cs_db.checkAlimTalk(query_tran, (cons_no+seq[i]), customer_m_tel);
					String chk_alim_str = atl_db.checkAlimTalk(query_tran, (cons_no+seq[i]), customer_m_tel);
					if(chk_alim_str.length() > 0 && stringChacker(chk_alim_str, from_comp[i], car_no[i], car_nm[i], arrival_date, from_place[i], driver_nm[i], driver_m_tel[i])){
						send_switch = false;
					}
					//chk_alim_str = cs_db.checkAlimTalk(query_this_m, (cons_no+seq[i]), customer_m_tel);
					chk_alim_str = atl_db.checkAlimTalk(query_this_m, (cons_no+seq[i]), customer_m_tel);
					if(chk_alim_str.length() > 0 && stringChacker(chk_alim_str, from_comp[i], car_no[i], car_nm[i], arrival_date, from_place[i], driver_nm[i], driver_m_tel[i])){
						send_switch = false;
					}
					int for_int;
					if(chk_gubun){
						for(int m=(today_y_m/100); m>(check_y_m/100-1); m--){
							for(int n=12; n>0; n--){
								for_int = m*100 + n;
								if(for_int < today_y_m && for_int > check_y_m-1 && for_int > 201709){
									query_this_m = "ATA_MMT_LOG_";
									//chk_alim_str = cs_db.checkAlimTalk((query_this_m += Integer.toString(for_int)), (cons_no+seq[i]), customer_m_tel);
									chk_alim_str = atl_db.checkAlimTalk((query_this_m += Integer.toString(for_int)), (cons_no+seq[i]), customer_m_tel);
									if(chk_alim_str.length() > 0 && stringChacker(chk_alim_str, from_comp[i], car_no[i], car_nm[i], arrival_date, from_place[i], driver_nm[i], driver_m_tel[i])){
										send_switch = false;
									}									
								}
							}
						}
					}					
					/*
						from_comp[i]:회사명, car_no[i]:차량번호, car_nm[i]:차명, arrival_date:도착 예정 일시, from_place[i]:약속장소, driver_nm[i]:탁송기사 성명, driver_m_tel[i]:탁송기사 연락처
						rent_l_cd[i]: 계약번호
					*/
					// 알림톡 테이블 etc_text_1 컬럼에 탁송 번호(cons_no와 seq를 함께 저장)를 저장한다.
					cons_no_seq = cons_no;
					cons_no_seq += cons.getSeq();
					if(customer_m_tel.length() > 9 && send_switch){
						List<String> fieldList = Arrays.asList(from_comp[i], car_no[i], car_nm[i], arrival_date, from_place[i], 
								driver_nm[i], driver_m_tel[i]);
						flag7 = at_db.sendMessageReserve("acar0125", fieldList, customer_m_tel, "02-392-4243", null, cons_no_seq, "999999");
					}
					
					//사고대차회수건이고 채권양도통지서 및 위임장 문서데이터 존재시 알림톡 발송(20190325)
					if(cc_val.equals("10")){
						if(customer_m_tel.length() > 9){
							Hashtable ht = cs_db.getBondTrfDocInfo(cons_no);
							if(String.valueOf(ht.get("B_TRF_YN")).equals("Y")){
								
								String firm_nm 			= String.valueOf(ht.get("FIRM_NM"));
								String rent_way 		= String.valueOf(ht.get("RENT_WAY"));
								String s_date 			= String.valueOf(ht.get("S_DATE"));
								String s_time 			= String.valueOf(ht.get("S_TIME"));
								String e_date 			= String.valueOf(ht.get("E_DATE"));
								String e_time 			= String.valueOf(ht.get("E_TIME"));
								String ac_car_nm	 	= String.valueOf(ht.get("CAR_NM"));
								String ac_car_no 		= String.valueOf(ht.get("CAR_NO"));
								String ins_req_amt 	= String.valueOf(ht.get("INS_REQ_AMT"));
								String today_date		= String.valueOf(ht.get("TODAY"));
								String acar_mng 		= String.valueOf(ht.get("ACAR_MNG"));
								String acar_tel 			= String.valueOf(ht.get("ACAR_TEL"));
								
								List<String> fieldList2 = Arrays.asList(firm_nm, rent_way, s_date, s_time, e_date, e_time, ac_car_nm, ac_car_no, ins_req_amt, today_date, acar_mng, acar_tel);
								
								flag4 = at_db.sendMessageReserve("acar0214", fieldList2, customer_m_tel, acar_tel, null, cons_no_seq, "999999");
							}
						}
					}
					
				}
			}
			// ### acar0125 알림톡 발송 2018.03.13 ### end
			
			//아마존카전자문서시스템
			String doc_code  = "CO"+req_code;
// 			String t_url = "https://fms5.amazoncar.co.kr/mailing/e_doc/index.jsp?doc_code="+doc_code;
			String t_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code;	
			//t_url = ShortenUrlGoogle.getShortenUrl(t_url);
// 			String doc_url = "http://211.174.180.200/edoc_fms/acar/e_doc/deli_taking.jsp?cons_no="+cons_no+"&seq="+cons.getSeq();
			String doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/deli_taking.jsp?doc_code="+doc_code;
			//doc_url = ShortenUrlGoogle.getShortenUrl(doc_url);
			//전자문서처리
			String receiver = cons.getDriver_m_tel().trim();
			String send_type = "driver";
			String doc_type = "2"; //인도인수증
			String sign_type = "2"; //자필서명					
			//유효기간 10일
			String term_dt = AddUtil.getDate(4);
			term_dt = af_db.getValidDt(c_db.addDay(term_dt, 10));
			//전자문서 전송데이터 처리		
			flag2 = ln_db.insertALinkEdoc(doc_code, doc_type, sign_type, send_type, "인도인수증", doc_url, request.getParameter("firm_nm"), receiver, cons.getReq_id(), term_dt, cons.getClient_id(), cons.getRent_mng_id(), cons.getRent_l_cd(), cons_no+String.valueOf(cons.getSeq()), "", "", "1", "0", "Y", "", doc_code);
			String edoc_msg = cons.getCar_no() +  " 탁송 인도인수증입니다. 전자문서를 발송합니다. \n\n" + t_url + " " ;		
			// 이승석 기사인 경우에만 인도인수증 알림톡 발송. 에스폼 문서 생성은 유지.
			if(cons.getDriver_nm().equals("이승석")){
				at_db.sendMessage(1009, "0", edoc_msg, cons.getDriver_m_tel(), "02-392-4243", null, cons_no, ck_acar_id);
			}
		}
		
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		DocSettleBean doc 		= d_db.getDocSettle(doc_no);
		
		String doc_step = "2";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);

		
		//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String sub 		= "[탁송번호:"+cons_no+"] 탁송의뢰 수신";
		String cont 	= driver_cont;
		String url 		= "/fms2/consignment_new/cons_reg_step3.jsp?cons_no="+cons_no;
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
		//System.out.println("1 --- ");//del
		//System.out.println("user_id : " + user_id);
		//System.out.println("doc.getUser_id1 : " + doc.getUser_id1());
		//System.out.println("after_cnt : " + after_cnt);
		if(!user_id.equals(doc.getUser_id1()) && after_cnt==0){
			flag3 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저(탁송의뢰수신)"+cons_no+"-----------------------"+target_bean.getUser_nm());
			
			//4. SMS 문자 발송------------------------------------------------------------
			//System.out.println("after_yn : " + after_yn + "   |target_bean.getUser_m_tel : " + target_bean.getUser_m_tel());//del
			if(after_yn.equals("N") && !target_bean.getUser_m_tel().equals("")){
				//System.out.println("2 --- ");//del
				String sendphone 	= sender_bean.getHot_tel();
				String sendname 	= "(주)아마존카";
				String destphone 	= target_bean.getUser_m_tel();
				String destname 	= target_bean.getUser_nm();
				
				//탁송의뢰 1번
				ConsignmentBean b_cons = cs_db.getConsignment(cons_no, 1);
				//에이전트 실의뢰자한테 요청
				if(target_bean.getDept_id().equals("1000") && !b_cons.getAgent_emp_id().equals("")){
					CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(b_cons.getAgent_emp_id());
					destname 	= a_coe_bean.getEmp_nm();
					destphone = a_coe_bean.getEmp_m_tel();
				}
				
				// 알림톡 사용 2018.03.26
				/* System.out.println("/fms/crs2a");
				System.out.println("sendphone : " + sendphone);
				System.out.println("sendname : " + sendname);
				System.out.println("destphone : " + destphone);
				System.out.println("destname : " + destname);
				System.out.println("cont : " + cont); */
				
				//List<String> fieldList_1 = Arrays.asList("시간", cons.getCar_no(), cons.getCar_nm(), "탁송 번호", "탁송일시", cons.getDriver_nm(), cons.getDriver_m_tel());
				
				//flag8 = at_db.sendMessageReserve("acar0135", fieldList_1, destphone, "02-392-4243", null, "탁송번호", "999999");
				System.out.println("##");
				
				// 기존 문자 보내기(ums_data 테이블)	2018.03.26
				IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont);	
			}
		}
	}else if(doc_bit.equals("sms")){
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		String driver_cont = "[탁송배정]";
		
		for(int i=0;i<cons_su;i++){
			
			//out.println(car_no[i]+"<br>");
			
			ConsignmentBean cons 		= cs_db.getConsignment(cons_no, AddUtil.parseInt(seq[i]));
			
			cons.setFrom_est_dt  	(from_est_dt[i]+from_est_h[i]+from_est_s[i]);
			cons.setTo_est_dt    	(to_est_dt[i]+to_est_h[i]+to_est_s[i]);
			cons.setDriver_nm			(driver_nm    	[i] ==null?"": driver_nm    	[i]);
			cons.setDriver_m_tel	(driver_m_tel 	[i] ==null?"": driver_m_tel 	[i]);
			
			driver_cont = driver_cont + cons.getCar_no() + ":" + cons.getDriver_nm() + " " + cons.getDriver_m_tel();
			
			if(i>0 && i+1<cons_su) driver_cont = driver_cont+" / ";
			
		}
		
		DocSettleBean doc 		= d_db.getDocSettle(doc_no);
		
		String sub 		= "[탁송번호:"+cons_no+"] 탁송의뢰 수신";
		String cont 	= driver_cont;
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id1());
		
		if(after_yn.equals("N") && !target_bean.getUser_m_tel().equals("")){
			String sendphone 	= sender_bean.getHot_tel();
			String sendname 	= "(주)아마존카";
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();

			//탁송의뢰 1번
			ConsignmentBean b_cons = cs_db.getConsignment(cons_no, 1);
			//에이전트 실의뢰자한테 요청
			if(target_bean.getDept_id().equals("1000") && !b_cons.getAgent_emp_id().equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(b_cons.getAgent_emp_id());
				destname 	= a_coe_bean.getEmp_nm();
				destphone = a_coe_bean.getEmp_m_tel();
			}
			/* System.out.println("/fms/crs2a");
			System.out.println("sendphone : " + sendphone);
			System.out.println("sendname : " + sendname);
			System.out.println("destphone : " + destphone);
			System.out.println("destname : " + destname);
			System.out.println("cont : " + cont); */
			IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont);
			
			
		}
		
	}else if(doc_bit.equals("sms_standby")){
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
				DocSettleBean doc 		= d_db.getDocSettle(doc_no);
				
				UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
				
				String standby_dt 	= from_req_dt[0];
				String standby_dt_h = from_req_h[0];
				String standby_st 	= "2";
				
				if(AddUtil.parseInt(standby_dt_h) > 12)	 standby_st = "3";
				
				
				Vector s_vt = cs_db.getConsStandbyList("", standby_dt, standby_st);
				int s_vt_size = s_vt.size();
				
				if(s_vt_size > 0)	{
					for(int i = 0 ; i < s_vt_size ; i++){
						Hashtable ht = (Hashtable)s_vt.elementAt(i);
						
						//4. SMS 문자 발송------------------------------------------------------------
						if(after_yn.equals("N") && !sender_bean.getUser_nm().equals(String.valueOf(ht.get("USER_NM"))) && !String.valueOf(ht.get("USER_M_TEL")).equals("")){
							String sendphone 	= sender_bean.getUser_m_tel();
							String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
							String destphone 	= String.valueOf(ht.get("USER_M_TEL"));
							String destname 	= String.valueOf(ht.get("USER_NM"));
							IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", sms_msg+"-"+sender_bean.getUser_nm());
						}
					}
				}
	}else if(doc_bit.equals("f_sms")){
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		DocSettleBean doc 		= d_db.getDocSettle(doc_no);
		
		String sub 		= "[탁송번호:"+cons_no+"] 탁송의뢰 수신";
		String cont 	= "[신차탁송-탁송등록한 차량이 준비완료 되었습니다.]";
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id1());

		if(after_yn.equals("N") && !target_bean.getUser_m_tel().equals("")){
			String sendphone 	= sender_bean.getHot_tel();
			String sendname 	= "(주)아마존카";
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont);
		}
		
	}else if(doc_bit.equals("d_sms")){
		
		String sub 		= "[신차탁송-탁송지정업체에 메세지 보내기]";
		String cont 	= sms_msg;	
		
		if(off_id.equals("002371")) target_id = "000094";//코리아탁송
		if(off_id.equals("002740")) target_id = "000095";//전국탁송
		if(off_id.equals("004107")) target_id = "000127";//코리아탁송부산
		if(off_id.equals("004171")||off_id.equals("007547")) target_id = "000139";//하이카콤대전
		if(off_id.equals("003158") && !acar_driver_id.equals(""))	target_id = acar_driver_id;//아마존카-지정된 운전자
		if(off_id.equals("008411")||off_id.equals("008468") ||off_id.equals("008516") ||off_id.equals("010921")||off_id.equals("010919") ||off_id.equals("010920") ) target_id = "000196";//일등전국탁송물류
		if(off_id.equals("009217")) target_id = "000223";//(주)아마존탁송
		if(off_id.equals("010255")) target_id = "000263";//스마일TS
		if(off_id.equals("011790")) target_id = "000328";//퍼스트드라이브
		
		UsersBean sender_bean 	= umd.getUsersBean(f_req_id);

		if(!target_id.equals("")){
		
			UsersBean target_bean 	= umd.getUsersBean(target_id);

			String url 		= "/fms2/consignment_new/cons_rec_frame.jsp";
			String m_url  = "/fms2/consignment_new/cons_rec_frame.jsp";
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
			
			if(!target_bean.getId().equals(sender_bean.getId())){
				
				flag2 = cm_db.insertCoolMsg(msg);
				System.out.println("쿨메신저(탁송의뢰)"+cons_no+"-----------------------"+target_bean.getUser_nm());
				
				if(off_id.equals("003158")){//003158
					cont = sms_msg+"-"+sender_bean.getUser_nm();
				}
				
		
				
				//4. SMS 문자 발송------------------------------------------------------------
				if(after_yn.equals("N") && !target_bean.getUser_m_tel().equals("")){
					String sendphone 	= sender_bean.getUser_m_tel();
					String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
					String destphone 	= target_bean.getUser_m_tel();
					String destname 	= target_bean.getUser_nm();
					
					if(off_id.equals("010255")) {
						destphone = target_bean.getHot_tel();
					}
					
					IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont);
				}
			}
		}else{
		
			//지정자가 없으면...대기자에게 문자보낸다.
			if(after_yn.equals("N") && off_id.equals("003158") && acar_driver_id.equals("")){//003158
				
				String standby_dt 	= from_req_dt[0];
				String standby_dt_h = from_req_h[0];
				String standby_st 	= "2";
				
				if(AddUtil.parseInt(standby_dt_h) > 12)	 standby_st = "3";
				
				Vector s_vt = cs_db.getConsStandbyList("", standby_dt, standby_st);
				int s_vt_size = s_vt.size();
				
				if(s_vt_size > 0)	{
					for(int i = 0 ; i < s_vt_size ; i++){
						Hashtable ht = (Hashtable)s_vt.elementAt(i);
						
						//4. SMS 문자 발송------------------------------------------------------------
						if(!sender_bean.getUser_nm().equals(String.valueOf(ht.get("USER_NM"))) && !String.valueOf(ht.get("USER_M_TEL")).equals("")){
							String sendphone 	= sender_bean.getUser_m_tel();
							String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
							String destphone 	= String.valueOf(ht.get("USER_M_TEL"));
							String destname 	= String.valueOf(ht.get("USER_NM"));
							IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", sms_msg+"-"+sender_bean.getUser_nm());
						}
					}
				}
			}
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('탁송 수정 에러입니다.\n\n확인하십시오');									<%		}	%>		
<%		if(!flag2){	%>	alert('문서품의서 등록 에러입니다.\n\n확인하십시오');							<%		}	%>		
<%		if(!flag3){	%>	alert('쿨메신저 등록 에러입니다.\n\n확인하십시오');								<%		}	%>
<%		if(!flag7){	%>	alert('고객에게 전송한 알림톡에 에러가 발생하였습니다.\n\n확인하십시오');	<%		}	%>
<%		if(!flag4){	%>	alert('고객에게 전송한 채권양도통지서 알림톡에 에러가 발생하였습니다.\n\n확인하십시오');	<%		}	%>
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
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">  
  <input type='hidden' name='cons_no' 	value='<%=cons_no%>'>    
</form>
<script language='javascript'>
	var fm = document.form1;	
	
	<%if(doc_bit.equals("")){%>
	fm.action = 'cons_reg_step2.jsp';
	<%}else{%>
	fm.action = 'cons_rec_frame.jsp';
	<%}%>
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>