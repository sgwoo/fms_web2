<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.insur.*, acar.car_office.*, acar.res_search.*, acar.client.*,  acar.ext.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*, acar.im_email.*, tax.*, acar.doc_settle.*, acar.fee.*, acar.insur.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
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
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String reg_type 	= request.getParameter("reg_type")==null?"":request.getParameter("reg_type");	
	
	int t_con_mon 		=  request.getParameter("con_mon")==null?0:AddUtil.parseInt(request.getParameter("con_mon"));	
	int pere_r_mth 		=  request.getParameter("pere_r_mth")==null?0:AddUtil.parseInt(request.getParameter("pere_r_mth"));
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String fee_fst_dt1	= request.getParameter("fee_fst_dt1")==null?"":request.getParameter("fee_fst_dt1");
	String fee_fst_amt1	= request.getParameter("fee_fst_amt1")==null?"":request.getParameter("fee_fst_amt1");
	String fee_fst_dt3	= request.getParameter("fee_fst_dt3")==null?"":request.getParameter("fee_fst_dt3");
	String fee_fst_amt3	= request.getParameter("fee_fst_amt3")==null?"":request.getParameter("fee_fst_amt3");

	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int flag4 = 0;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	boolean flag12 = true;
	
	int flag = 0;
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();


	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(car_st.equals("")) car_st = base.getCar_st();
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);	
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	UsersBean target_bean = new UsersBean();
	
	UsersBean bus_bean 	= umd.getUsersBean(base.getBus_id());
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(fee.getPp_s_amt()==0 && !fee.getPp_chk().equals(""))  fee.setPp_chk("");
	

	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객관리
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
%>


<%
		if(!car_st.equals("2")){
		
			fee.setRent_start_dt			(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
			fee.setRent_end_dt			(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
			fee.setFee_pay_tm			(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
			
			if(reg_type.equals("1")){
				fee.setFee_est_day		(request.getParameter("fee_est_day1")		==null?"":request.getParameter("fee_est_day1"));
				fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt1")	==null?"":request.getParameter("fee_pay_start_dt1"));
				fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt1")	==null?"":request.getParameter("fee_pay_end_dt1"));
				fee.setFee_fst_dt		(request.getParameter("fee_fst_dt1")		==null?"":request.getParameter("fee_fst_dt1"));
				fee.setFee_fst_amt		(request.getParameter("fee_fst_amt1").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt1")));
			}else if(reg_type.equals("2")){
				fee.setFee_est_day		(request.getParameter("fee_est_day3")		==null?"":request.getParameter("fee_est_day3"));
				fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt3")	==null?"":request.getParameter("fee_pay_start_dt3"));
				fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt3")	==null?"":request.getParameter("fee_pay_end_dt3"));
				fee.setFee_fst_dt		(request.getParameter("fee_fst_dt3")		==null?"":request.getParameter("fee_fst_dt3"));
				fee.setFee_fst_amt		(request.getParameter("fee_fst_amt3").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt3")));
			}else if(reg_type.equals("3")){			
				fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")	==null?"":request.getParameter("fee_pay_start_dt"));
				fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")		==null?"":request.getParameter("fee_pay_end_dt"));
			}
			fee.setBr_id		("S1");
		
		
		
			base.setRent_start_dt		(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
			base.setRent_end_dt		(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
		

		
		
			//차량인도일
			cont_etc.setCar_deli_dt		(request.getParameter("car_deli_dt")		==null?"":request.getParameter("car_deli_dt"));
			if(cont_etc.getRent_mng_id().equals("")){
				//=====[cont_etc] update=====
				cont_etc.setRent_mng_id	(rent_mng_id);
				cont_etc.setRent_l_cd	(rent_l_cd);
				flag3 = a_db.insertContEtc(cont_etc);
			}else{
				//=====[cont_etc] update=====
				flag3 = a_db.updateContEtc(cont_etc);
			}
			
			
			//등록된 보험 찾기 
			//(보험배서2 > 재리스 대여차량인도 탁송의뢰 등록 은
			//		차량인도일자가 없으면 보이지 않게 되어 있는데  
			//		여기서 차량인도일자가 등록되면 보이게 된다.
			//		그런데 등록일은 탁송의뢰 등록시에 저장되었기에 탁송의뢰 등록시간으로 저장되어 있을거다.
			//		하지만 담당자가 탁송의뢰 시간이 아닌 차량인도일자에 등록된 시간으로 수정해 달라고 하여 
			//		여기서 ins_execl에 등록된 보험을 찾고 등록일(value05)을 수정 )
			
			//ins_excel 재리스 대여차량인도 탁송의뢰 등록 찾기
			int insExclCnt = ai_db.getInsExcelLeaseConsignmentCnt(rent_mng_id, rent_l_cd);
			if(insExclCnt > 0){
				SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMddHHmmss");
				Date time = new Date();
				String now = format1.format(time);
				boolean checkUpdate = ai_db.changeLeaseConsignmentRegDt(now, rent_mng_id, rent_l_cd);
			}
			
			
		
		
			//20141014 만기매칭대차의 경우 신차대여개시시 최초주행거리 입력한다.
		
			String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
			
			if(taecha_no.equals("")){
				taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
			}
					
			//출고지연대차
			ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
			
			taecha.setCar_rent_et	(base.getRent_start_dt());
			if(!a_db.updateTaecha(taecha)) flag += 1;
		
			ContFeeBean fee_add = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
			if(!AddUtil.replace(taecha.getCar_rent_et(),"-","").equals(fee_add.getRent_end_dt()) || !AddUtil.replace(taecha.getCar_rent_st(),"-","").equals(fee_add.getRent_start_dt())){
				fee_add.setRent_start_dt	(taecha.getCar_rent_st());
				fee_add.setRent_end_dt		(taecha.getCar_rent_et());
				boolean taecha_flag = a_db.updateContFeeAdd(fee_add);
			}
		


					
			//fee_etc
			ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
			if(base.getCar_gu().equals("1") && base.getRent_st().equals("3") && taecha.getCar_mng_id().equals(base.getCar_mng_id())){
				fee_etc.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));		
				//=====[fee_etc] update=====
				flag5 = a_db.updateFeeEtc(fee_etc);
			}
			
			
			//20150302 재리스인 경우 특별할인 초기화처리
			if(base.getCar_gu().equals("0") && !base.getCar_mng_id().equals("")){
				cr_bean = crd.getCarRegBean(base.getCar_mng_id());					
				cr_bean.setSpe_dc_st		("");				
				cr_bean.setSpe_dc_cau		("");			
				cr_bean.setSpe_dc_per		(0);		
				int result = crd.updateCarSpeDc(cr_bean);
				
			}
	
			
			
			
			//if(fee.getFee_s_amt()>0 && !fee.getFee_chk().equals("1") && !fee.getPp_chk().equals("0") ){
			
				//대여료스케줄생성 문서관리
	
				String sub 	= "신차개시 및 스케줄생성";
				String cont 	= "["+firm_nm+" "+rent_l_cd+"] 신차개시 및 스케줄생성을 요청하오니 확인바랍니다.";
	
				DocSettleBean doc = new DocSettleBean();
				doc.setDoc_st	("16");
				doc.setDoc_id	(rent_l_cd);
				doc.setSub	(sub);
				doc.setCont	(cont);
				doc.setEtc	(request.getParameter("etc")			==null?"":request.getParameter("etc"));
				
				if(fee.getFee_chk().equals("0")){
					doc.setEtc	("대여료일시완납");
				}
				if(fee.getPp_chk().equals("0") ){
					doc.setEtc	(doc.getEtc()+" 선납금 매월균등발행");
				}
				
				doc.setUser_nm1	("기안자");
				doc.setUser_nm2	("스케줄생성자");
				doc.setUser_nm3	("총무팀장");
				doc.setUser_id1	(user_id);
				doc.setUser_id2	(nm_db.getWorkAuthUser("스케줄생성자"));
				doc.setUser_id3	("XXXXXX");
				doc.setDoc_bit	("1");	
				doc.setDoc_step	("1");//기안
							
				doc.setVar01	(reg_type);
				doc.setSeq	(1);
				doc.setVar02	(request.getParameter("fee_est_day1")		==null?"":request.getParameter("fee_est_day1"));
				doc.setVar03	(request.getParameter("fee_pay_start_dt1")	==null?"":request.getParameter("fee_pay_start_dt1"));
				doc.setVar04	(request.getParameter("fee_pay_end_dt1")	==null?"":request.getParameter("fee_pay_end_dt1"));
				doc.setVar05	(request.getParameter("fee_fst_dt1")		==null?"":request.getParameter("fee_fst_dt1"));
				doc.setVar06	(request.getParameter("fee_fst_amt1")		==null?"":request.getParameter("fee_fst_amt1"));
				doc.setVar07	(request.getParameter("fee_lst_dt1")		==null?"":request.getParameter("fee_lst_dt1"));
				doc.setVar08	(request.getParameter("fee_lst_amt1")		==null?"":request.getParameter("fee_lst_amt1"));
				doc.setVar09	(request.getParameter("fee_est_day2")		==null?"":request.getParameter("fee_est_day2"));
				doc.setVar10	(request.getParameter("fee_pay_start_dt2")	==null?"":request.getParameter("fee_pay_start_dt2"));
				doc.setVar11	(request.getParameter("fee_pay_end_dt2")	==null?"":request.getParameter("fee_pay_end_dt2"));
				doc.setVar12	(request.getParameter("fee_fst_dt2")		==null?"":request.getParameter("fee_fst_dt2"));
				doc.setVar13	(request.getParameter("fee_fst_amt2")		==null?"":request.getParameter("fee_fst_amt2"));
				doc.setVar14	(request.getParameter("fee_lst_dt2")		==null?"":request.getParameter("fee_lst_dt2"));
				doc.setVar15	(request.getParameter("fee_lst_amt2")		==null?"":request.getParameter("fee_lst_amt2"));
				doc.setVar16	(request.getParameter("fee_est_day3")		==null?"":request.getParameter("fee_est_day3"));
				doc.setVar17	(request.getParameter("fee_pay_start_dt3")	==null?"":request.getParameter("fee_pay_start_dt3"));
				doc.setVar18	(request.getParameter("fee_pay_end_dt3")	==null?"":request.getParameter("fee_pay_end_dt3"));
				doc.setVar19	(request.getParameter("fee_fst_dt3")		==null?"":request.getParameter("fee_fst_dt3"));
				doc.setVar20	(request.getParameter("fee_fst_amt3")		==null?"":request.getParameter("fee_fst_amt3"));
				doc.setVar21	(request.getParameter("fee_lst_dt3")		==null?"":request.getParameter("fee_lst_dt3"));
				doc.setVar22	(request.getParameter("fee_lst_amt3")		==null?"":request.getParameter("fee_lst_amt3"));
				
				
				br_id = bus_bean.getBr_id();
				
				if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){
					
				}else{
					doc.setUser_id2	(nm_db.getWorkAuthUser("부산스케줄생성자"));
				}
			
				//스케줄담당자 휴가체크
				CarScheBean cs_bean = csd.getCarScheTodayBean(doc.getUser_id2());
				
				if(!cs_bean.getUser_id().equals("")){
					if(cs_bean.getWork_id().equals("")){
						if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){
							doc.setUser_id2	(nm_db.getWorkAuthUser("부산스케줄생성자"));						
						}else{
							doc.setUser_id2	(nm_db.getWorkAuthUser("스케줄생성자"));							
						}
					}else{
						
						if(!cs_bean.getUser_id().equals("")){
							if(cs_bean.getTitle().equals("오전반휴")){
								//등록시간이 오전(12시전)이라면 대체자
								if(AddUtil.getTimeAM().equals("오전")){
								  doc.setUser_id2	(cs_bean.getWork_id()); //업무대체자									
								}								
							}else if(cs_bean.getTitle().equals("오후반휴")){
								//등록시간이 오후(12시이후)라면 대체자
								if(AddUtil.getTimeAM().equals("오후")){				
								  doc.setUser_id2	(cs_bean.getWork_id()); //업무대체자									
								}
							}else{//연차
								doc.setUser_id2	(cs_bean.getWork_id()); //업무대체자 								
							}
						}	
																										
					}
				}				
			
			
			
				//=====[doc_settle] insert=====
				flag6 = d_db.insertDocSettle(doc);
			
			
				DocSettleBean o_doc = d_db.getDocSettleCommi("16", rent_l_cd);							
			
				doc.setDoc_no	(o_doc.getDoc_no());
			
				//=====[doc_settle_var] insert=====
				flag6 = d_db.insertDocSettleVar(doc);
			
			
			
				String url 		= "/fms2/lc_rent/lc_start_doc.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+o_doc.getDoc_no();
				String m_url = "/fms2/lc_rent/lc_start_frame.jsp";
			
				target_bean 	= umd.getUsersBean(doc.getUser_id2());
			
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
	
				flag6 = cm_db.insertCoolMsg(msg);
				
				
				//20150616 가스케줄 생성
				if(!reg_type.equals("3")){
				
					
			
					//기존대여스케줄 대여횟수 최대값
					int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);
					max_fee_tm = 0; //예비스케줄이라 필요없음.
					
					
					int fee_pay_tm = 0;
					
					if(pere_r_mth>0)		fee_pay_tm = t_con_mon - pere_r_mth;
					else 				fee_pay_tm = t_con_mon;					
					
		
					//1회차 금액
					int f_fee_amt		= AddUtil.parseInt(AddUtil.replace(doc.getVar06(),",",""));
					//1회차 시작일
					String f_use_s_dt 	= fee.getRent_start_dt();
					//1회차 실종료일
					String f_use_e_dt 	= doc.getVar05();
					//마지막회차 금액
					int l_fee_amt		= AddUtil.parseInt(AddUtil.replace(doc.getVar08(),",",""));
					//마지막회차 납입일
					String l_est_dt  	= doc.getVar07();
					//일자계산내역
					String f_etc = request.getParameter("fee_fst_amt1_etc")==null?"":request.getParameter("fee_fst_amt1_etc");
					String l_etc = request.getParameter("fee_lst_amt1_etc")==null?"":request.getParameter("fee_lst_amt1_etc");
					
					if(reg_type.equals("2")){
						f_use_e_dt 	= doc.getVar19();
						f_fee_amt	= AddUtil.parseInt(AddUtil.replace(doc.getVar20(),",",""));
						l_fee_amt	= AddUtil.parseInt(AddUtil.replace(doc.getVar22(),",",""));						
						l_est_dt 	= doc.getVar21();
						f_etc = request.getParameter("fee_fst_amt3_etc")==null?"":request.getParameter("fee_fst_amt3_etc");
						l_etc = request.getParameter("fee_lst_amt3_etc")==null?"":request.getParameter("fee_lst_amt3_etc");
					}
					
					//2회차 실시작일
					String t_use_s_dt 	= c_db.addDay(f_use_e_dt, 1);
					
					//스케줄합계					
					int r_t_fee_s_amt		= 0;
					int r_t_fee_v_amt		= 0;

					//총대여료
					int t_fee_amt			= (fee.getFee_s_amt()+fee.getFee_v_amt()) * fee_pay_tm;
					int t_fee_s_amt			= fee.getFee_s_amt() * fee_pay_tm;
					int t_fee_v_amt			= t_fee_amt - t_fee_s_amt;
					
					
					
					//최종 종료일
					String use_e_dt 	= c_db.addMonth(fee.getRent_start_dt(), fee_pay_tm);	
					
					String r_use_end_dt = "";
					String req_fst_dt = c_db.minusDay(f_use_e_dt, 15);
					int count1 = 0;
					
					
					
					//스케줄 생성----------------------------------------------------------------------
		
					for(int i = max_fee_tm ; i < fee_pay_tm+max_fee_tm ; i++){
						
						FeeScdBean fee_scd = new FeeScdBean();
						fee_scd.setRent_mng_id	(rent_mng_id);
						fee_scd.setRent_l_cd		(rent_l_cd);
						fee_scd.setFee_tm				(String.valueOf(i+1));			
						fee_scd.setRent_st			("1");
						fee_scd.setTm_st2				("0");					//0-일반대여료 (1-회차연장)							
						fee_scd.setRent_seq			("1");					//분할청구일련번호									
						fee_scd.setTm_st1				("0");					//0-월대여료 (1~잔액)						
						fee_scd.setUpdate_id		(user_id);
						
						//1회차---------------------------------------------------------------------------------------------
						if(i == max_fee_tm){			
							fee_scd.setUse_s_dt		(f_use_s_dt);				//1회차 사용기간 시작일
							fee_scd.setUse_e_dt		(f_use_e_dt);				//1회차 사용기간 종료일
							fee_scd.setFee_est_dt	(fee_scd.getUse_e_dt());		//1회차 납입일				
							fee_scd.setFee_s_amt	(af_db.getSupAmt(f_fee_amt));		//1회차 대여료							
							fee_scd.setFee_v_amt	(f_fee_amt-fee_scd.getFee_s_amt());	//1회차 대여료
							fee_scd.setEtc				(f_etc);
						}else{						
							//2회차 기간시작일은 전회차 다음날로 한다.
							fee_scd.setUse_s_dt		(c_db.addDay(r_use_end_dt, 1));
							fee_scd.setUse_e_dt		(c_db.addMonth(f_use_e_dt, count1));
							fee_scd.setFee_est_dt	(fee_scd.getUse_e_dt());		//납입일				
							fee_scd.setFee_s_amt	(fee.getFee_s_amt());			//대여료
							fee_scd.setFee_v_amt	(fee.getFee_v_amt());			//대여료
							
							String s_cng_dt 	= AddUtil.replace(fee_scd.getFee_est_dt(),"-",""); 
							int i_cng_yy 		= AddUtil.parseInt(s_cng_dt.substring(0,4));
							int i_cng_mm 		= AddUtil.parseInt(s_cng_dt.substring(4,6));
							int i_cng_dd 		= AddUtil.parseInt(s_cng_dt.substring(6,8));
							int i_max_dd 		= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
										
							if(fee.getFee_est_day().equals("99")){//말일
								fee_scd.setFee_est_dt			(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
							}else{
								if(AddUtil.parseInt(fee.getFee_est_day()) < i_cng_dd ){
									fee_scd.setFee_est_dt		(s_cng_dt.substring(0,6)+""+AddUtil.addZero(fee.getFee_est_day()));	
								}
							}
							
							//마지막회차이면
							if(i == (fee_pay_tm+max_fee_tm-1)){	
								fee_scd.setUse_e_dt	(use_e_dt);
								fee_scd.setFee_est_dt	(l_est_dt);			//납입일
								fee_scd.setFee_s_amt	(t_fee_s_amt-r_t_fee_s_amt);
								fee_scd.setFee_v_amt	(t_fee_v_amt-r_t_fee_v_amt);
								fee_scd.setEtc				(l_etc);
							}
						
						}
						
						
						fee_scd.setTax_out_dt					(fee_scd.getFee_est_dt());
						fee_scd.setR_fee_est_dt					(af_db.getValidDt(fee_scd.getFee_est_dt()));
						fee_scd.setReq_dt					(c_db.addMonth(req_fst_dt, count1));
						fee_scd.setR_req_dt					(af_db.getValidDt(fee_scd.getReq_dt()));
						
						r_t_fee_s_amt 		= r_t_fee_s_amt + fee_scd.getFee_s_amt();
						r_t_fee_v_amt 		= r_t_fee_v_amt + fee_scd.getFee_v_amt();						
						
						//일수
						int max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(fee_scd.getUse_s_dt(), fee_scd.getUse_e_dt()));
						
						
						//마지막회차이면
						if(i > max_fee_tm && i == (fee_pay_tm+max_fee_tm-1)){


			
					
							if(fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
								fee_scd.setFee_est_dt			(fee_scd.getUse_e_dt());
								fee_scd.setTax_out_dt			(fee_scd.getUse_e_dt());
								fee_scd.setR_fee_est_dt			(af_db.getValidDt(fee_scd.getFee_est_dt()));
							}
				
							//20121101 대여만료일(마지막사용기간종료일)보다 입금예정일이 더 작을수도 없다.   use_e_dt > fee_est_dt
							if(max_tm_add_l_use_days <= 40 ){
								if(fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
									fee_scd.setFee_est_dt		(fee_scd.getUse_e_dt());
									fee_scd.setTax_out_dt		(fee_scd.getUse_e_dt());
									fee_scd.setR_fee_est_dt		(af_db.getValidDt(fee_scd.getFee_est_dt()));
								}
							}
				
							//if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
								if(max_tm_add_l_use_days > 15 ){								
									fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -15));
								}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
									fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -10));
								}else{
									fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -5));
								}
								fee_scd.setR_req_dt			(fee_scd.getReq_dt());
							//}
				
				
						}
			
						//거래명세서 발행일자가 회차의 시작일보다 작을수 없다.
						if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_s_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
							fee_scd.setReq_dt		(fee_scd.getUse_s_dt());
							fee_scd.setR_req_dt	(fee_scd.getReq_dt());
						}
			
			
						if(!af_db.insertFeeScdEst(fee_scd, o_doc.getDoc_no())) flag4 += 1;						
						
						
						
						//마지막회차 사용기간이 1달이상일때 나누기
						if(i == (fee_pay_tm+max_fee_tm-1) && max_tm_add_l_use_days > 40 ){
																		
										
								FeeScdBean add_fee_scd = fee_scd;
																		
												
								int add_fee_s_amt = fee_scd.getFee_s_amt()-fee.getFee_s_amt();
								int add_fee_v_amt = fee_scd.getFee_v_amt()-fee.getFee_v_amt();
						
																
								//마지막회차스케줄 정보수정-----------------------------------------------------
						
								//기간시작일은 전회차 다음날로 한다.
								fee_scd.setUse_s_dt			(c_db.addDay(r_use_end_dt, 1));
								fee_scd.setUse_e_dt			(c_db.addMonth(f_use_e_dt, count1));
								fee_scd.setFee_est_dt			(fee_scd.getUse_e_dt());		//납입일				
								fee_scd.setFee_s_amt			(fee.getFee_s_amt());
								fee_scd.setFee_v_amt			(fee.getFee_v_amt());
								
								String s_cng_dt 	= AddUtil.replace(fee_scd.getFee_est_dt(),"-",""); 
								int i_cng_yy 		= AddUtil.parseInt(s_cng_dt.substring(0,4));
								int i_cng_mm 		= AddUtil.parseInt(s_cng_dt.substring(4,6));
								int i_cng_dd 		= AddUtil.parseInt(s_cng_dt.substring(6,8));							
								int i_max_dd 		= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
										
								if(fee.getFee_est_day().equals("99")){//말일						
									fee_scd.setFee_est_dt			(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
								}else{
									if(AddUtil.parseInt(fee.getFee_est_day()) < i_cng_dd ){
										fee_scd.setFee_est_dt		(s_cng_dt.substring(0,6)+""+AddUtil.addZero(fee.getFee_est_day()));	
									}
								}		
								fee_scd.setTax_out_dt			(fee_scd.getFee_est_dt());
								fee_scd.setR_fee_est_dt			(af_db.getValidDt(fee_scd.getFee_est_dt()));
								fee_scd.setReq_dt			(c_db.addMonth(req_fst_dt, count1));								
								fee_scd.setR_req_dt			(fee_scd.getReq_dt());
								
								//거래명세서 발행일자가 회차의 시작일보다 작을수 없다.
								if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_s_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
									fee_scd.setReq_dt		(fee_scd.getUse_s_dt());
									fee_scd.setR_req_dt	(fee_scd.getReq_dt());
								}
								fee_scd.setEtc				("");
								
						
								if(!af_db.updateFeeScdEst(fee_scd)) flag4 += 1;
						
																																
								//마지막회차 1달이상분 추가생성-----------------------------------------------------
						
								add_fee_scd.setFee_tm				(String.valueOf(i+2));
								add_fee_scd.setUse_s_dt			(c_db.addDay(fee_scd.getUse_e_dt(), 1));
								add_fee_scd.setUse_e_dt			(use_e_dt);
												
								add_fee_scd.setFee_est_dt		(add_fee_scd.getUse_e_dt());
								add_fee_scd.setTax_out_dt		(add_fee_scd.getFee_est_dt());
								add_fee_scd.setR_fee_est_dt	(af_db.getValidDt(add_fee_scd.getFee_est_dt()));
								add_fee_scd.setFee_s_amt		(add_fee_s_amt);
								add_fee_scd.setFee_v_amt		(add_fee_v_amt);
						
								add_fee_scd.setReq_dt				(c_db.addMonth(req_fst_dt, count1+1));
								add_fee_scd.setR_req_dt			(af_db.getValidDt(add_fee_scd.getReq_dt()));
								add_fee_scd.setEtc					(l_etc);
						
								max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(add_fee_scd.getUse_s_dt(), add_fee_scd.getUse_e_dt()));
								
								//if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(add_fee_scd.getReq_dt(),"-",""))){								
									if(max_tm_add_l_use_days > 15 ){								
										add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -15));
									}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
										add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -10));
									}else{
										add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -5));
									}									
									add_fee_scd.setR_req_dt		(add_fee_scd.getReq_dt());
								//}
						
								//거래명세서 발행일자가 회차의 시작일보다 작을수 없다.
								if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_s_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(add_fee_scd.getReq_dt(),"-",""))){
									add_fee_scd.setReq_dt		(add_fee_scd.getUse_s_dt());
									add_fee_scd.setR_req_dt	(add_fee_scd.getReq_dt());
								}

						
								if(!af_db.insertFeeScdEst(add_fee_scd, o_doc.getDoc_no())) flag4 += 1;
																															
				
						}
						
						
						r_use_end_dt 		= fee_scd.getUse_e_dt();
						count1++;
						
						
						//out.println((i+1)+"회차 스케줄생성---------------");						
						//out.println("fee_scd.getFee_s_amt()	= "+fee_scd.getFee_s_amt());
						//out.println("fee_scd.getFee_v_amt()	= "+fee_scd.getFee_v_amt());
						//out.println("fee_scd.getUse_s_dt()	= "+fee_scd.getUse_s_dt());
						//out.println("fee_scd.getUse_e_dt()	= "+fee_scd.getUse_e_dt());
						//out.println("fee_scd.getFee_est_dt()	= "+fee_scd.getFee_est_dt());
						//out.println("fee_scd.getReq_dt()	= "+fee_scd.getReq_dt());
						//out.println("fee_scd.getTax_out_dt()	= "+fee_scd.getTax_out_dt());
						//out.println("------------------------------------<br>");
																					
					}																								
				
				}
										
			
			//}
			
			//=====[fee] update=====
			flag1 = a_db.updateContFeeNew(fee);
			
			//=====[cont] update=====
			flag2 = a_db.updateContBaseNew(base);
			
			
			//재리스등록이거나 업무대여일때.. 법인 임직원 한전운전 관련 보험담당자 메시지 발송		
			if(base.getCar_gu().equals("0")){
				//보험변경요청 프로시저 호출
				String  d_flag2 =  ec_db.call_sp_ins_cng_req("재리스등록", rent_mng_id, rent_l_cd, "1");
			}
			
			//고객에게 영업담당자 배정 문자 발송한다. : 20100716
						
			//계약 담당자 변경 관련 문자
			Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
		
			Hashtable cont_view = a_db.getContViewCase(rent_mng_id, rent_l_cd);
		
			target_bean 	= umd.getUsersBean(base.getBus_id2());
		
			
			
				//지연대차 미반차 에이전트 업무지원자에게 메시지 발송		
							
				//예약시스템 지연대차 미반차건 확인
				Vector rs_conts = rs_db.getTarchaNoRegSearchList(base.getClient_id());
				int rs_cont_size = rs_conts.size();
				
				//예약시스템 지연대차 미반차건 확인 : 계약연동분
				Vector rs_conts2 = rs_db.getTarchaNoRetSearchList(base.getRent_l_cd());
				int rs_cont_size2 = rs_conts2.size();					
				
				if(rs_cont_size+rs_cont_size2>0){
				
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리"));
					UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리2"));
					//UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리3"));
					
					String sub2 	= "신차개시 및 스케줄생성 : 지연대차 미반차";
					String cont2 	= "["+firm_nm+" "+rent_l_cd+"] 신차개시 및 스케줄생성을 요청하였습니다. 지연대차 미반차가 있으니 확인하십시오.";
					
					if(base.getBus_st().equals("7")){
						cont2 	= "["+firm_nm+" "+rent_l_cd+"] 신차개시 및 스케줄생성을 요청하였습니다. 에이전트계약 지연대차 미반차가 있으니 확인하십시오.";
					}
					
					
					String xml_data2 = "";
					xml_data2 =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub2+"</SUB>"+
	  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
 							
					if(base.getBus_st().equals("7")){
						xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
						xml_data2 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
						//xml_data2 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";						
					}else{
						target_bean2 	= umd.getUsersBean(base.getBus_id());
						xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					}
						
					xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
					CdAlertBean msg2 = new CdAlertBean();
					msg2.setFlddata(xml_data2);
					msg2.setFldtype("1");
					flag3 = cm_db.insertCoolMsg(msg2);
					
				}
			
			
		}
			

	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag2){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag3){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>




<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 			value="">
  <input type="hidden" name="c_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;		
	fm.rent_st.value = '1';
	fm.c_st.value = 'fee';
	fm.action = '/fms2/lc_rent/lc_c_frame.jsp';	
	fm.target = 'd_content';
	fm.submit();
	

</script>
</body>
</html>