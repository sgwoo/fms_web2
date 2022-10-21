<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.settle_acc.*, acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.accid.*, acar.ext.*, acar.forfeit_mng.*, acar.con_ins_m.*, acar.res_search.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String page_st = request.getParameter("page_st")==null?"":request.getParameter("page_st");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	String bad_debt_cau	= request.getParameter("bad_debt_cau")==null?"":request.getParameter("bad_debt_cau");
	String bad_debt_st 	= request.getParameter("bad_debt_st")==null?"":request.getParameter("bad_debt_st");
	String reject_cau 	= request.getParameter("reject_cau")==null?"":request.getParameter("reject_cau");
	int    bad_amt		= request.getParameter("bad_amt")==null?0:AddUtil.parseInt(request.getParameter("bad_amt"));
	int    seq		= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	int count = 0;
	int res_count = 1;
	
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	RentContBean 	rc_bean 	= new RentContBean();
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	
	if(doc_no.equals("")){
	
		//계약기본정보
		ContBaseBean base = a_db.getCont(m_id, l_cd);
		
		//대손처리요청리스트
		Vector vt = a_db.getBadDebtReqList(m_id, l_cd);
		int vt_size = vt.size();
		
		seq = vt_size+1;
		
		//요청내용 및 처리구분 관리
		BadDebtReqBean bean = new BadDebtReqBean();
		
		bean.setRent_mng_id		(m_id);
		bean.setRent_l_cd		(l_cd);
		bean.setSeq			(seq);
		bean.setBad_debt_cau		(bad_debt_cau);	//요청사유
		bean.setBad_debt_st		("");			//처리구분
		bean.setOld_bus_id2		(base.getBus_id2());
		bean.setNew_bus_id2		(nm_db.getWorkAuthUser("채권관리자"));
		bean.setBus_id2_cng_yn		("");
		bean.setBad_debt_amt		(bad_amt);
		bean.setReg_id			(user_id);//수정자
		
		//예약시스템(월렌트)
		if(!s_cd.equals("")){
			//단기계약정보
			rc_bean = rs_db.getRentContCase(s_cd, c_id);
			bean.setOld_bus_id2		(rc_bean.getMng_id());
			
			if(base.getRent_l_cd().equals("")){
				String rm_rent_mng_id = c_id;
				String rm_rent_l_cd   = "RM00000"+s_cd;
				ContBaseBean im_base = a_db.getCont(rm_rent_mng_id, rm_rent_l_cd);
				if(im_base.getRent_mng_id().equals("")){
					//=====[cont] update=====
					im_base.setRent_mng_id		(rm_rent_mng_id);
					im_base.setRent_l_cd		(rm_rent_l_cd);
					im_base.setCar_st		("4");
					im_base.setCar_gu		("3");
					im_base.setUse_yn		("Y");
					im_base.setCar_mng_id		(c_id);
					im_base.setClient_id		(rc_bean.getCust_id());
					im_base.setBrch_id		(rc_bean.getBrch_id());
					im_base.setRent_dt		(rc_bean.getRent_dt());
					im_base.setBus_id		(rc_bean.getBus_id());
					im_base.setBus_id2		(rc_bean.getMng_id());
					im_base.setMng_id		(rc_bean.getMng_id());
					im_base = a_db.insertContBaseNew(im_base);
				}
			}
		}
	
		
		flag2 = a_db.insertBadDebtReq(bean);
		
		String vid1[] 		= request.getParameterValues("item_gubun");
		String vid2[] 		= request.getParameterValues("item_cd1");
		String vid3[] 		= request.getParameterValues("item_cd2");
		String vid4[] 		= request.getParameterValues("item_cd3");
		String vid5[] 		= request.getParameterValues("item_cd4");
		String vid6[] 		= request.getParameterValues("item_cd5");
		String vid7[] 		= request.getParameterValues("item_seq");
		String vid8[] 		= request.getParameterValues("est_dt");
		String vid9[] 		= request.getParameterValues("s_amt");
		String vid10[] 		= request.getParameterValues("v_amt");
		String vid11[] 		= request.getParameterValues("amt");
		String vid12[] 		= request.getParameterValues("etc");
		
		for(int j=0;j < vid1.length;j++){
			
			//요청내용 및 처리구분 관리
			BadDebtReqBean item_bean = new BadDebtReqBean();
			
			item_bean.setBad_debt_cd	(l_cd+""+String.valueOf(vt_size+1));
			item_bean.setSeq		(AddUtil.parseInt(vid7[j]));
			item_bean.setItem_gubun		(vid1[j]);
			item_bean.setItem_cd1		(vid2[j]);
			item_bean.setItem_cd2		(vid3[j]);
			item_bean.setItem_cd3		(vid4[j]);
			item_bean.setItem_cd4		(vid5[j]);
			item_bean.setItem_cd5		(vid6[j]);
			item_bean.setEst_dt		(vid8[j]);
			item_bean.setS_amt		(AddUtil.parseDigit(vid9[j]));
			item_bean.setV_amt		(AddUtil.parseDigit(vid10[j]));
			item_bean.setAmt		(AddUtil.parseDigit(vid11[j]));
			item_bean.setEtc		(vid12[j]);
			
			flag6 = a_db.insertBadDebtReqItem(item_bean);
		}
		
		
		String sub 	= "소액채권대손처리요청";
		String cont 	= sub;
		
		doc.setDoc_st	("46");
		doc.setDoc_id	(l_cd+""+String.valueOf(vt_size+1));
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	("");
		doc.setUser_nm1	("기안자");
		doc.setUser_nm2	("총무팀장");
		doc.setUser_nm3	("");
		doc.setUser_nm4	("");
		doc.setUser_id1	("");
		doc.setUser_id2	(nm_db.getWorkAuthUser("본사총무팀장"));
		doc.setUser_id3	("");
		doc.setDoc_bit	("1");//수신단계
		doc.setDoc_step	("1");//기안
		
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		DocSettleBean doc2 = d_db.getDocSettleCommi("46", l_cd+""+String.valueOf(vt_size+1));
		doc.setDoc_no(doc2.getDoc_no());
		
		doc_no = doc2.getDoc_no();
		
	}
	
	String doc_step = "2";
	
	if(doc_bit.equals("2")){
		doc_step = "3";
		
		
		//요청내용 및 처리구분 관리
		BadDebtReqBean bean = a_db.getBadDebtReq(m_id, l_cd, seq);
		
		bean.setBad_debt_cau		(bad_debt_cau);		//요청사유
		bean.setBad_debt_st		(bad_debt_st);		//처리구분
		bean.setReject_cau		(reject_cau);		//기각사유
		
		
		flag2 = a_db.updateBadDebtReq(bean);
		
		
		if(bad_debt_st.equals("1")){//채권추심 - 담당자변경
		
			if(!s_cd.equals("")){
			
				rc_bean = rs_db.getRentContCase(s_cd, c_id);
				rc_bean.setMng_id	(bean.getNew_bus_id2());
				res_count = rs_db.updateRentCont(rc_bean);
										
			}else{

				LcRentCngHBean cng = new LcRentCngHBean();
			
				cng.setRent_mng_id	(m_id);
				cng.setRent_l_cd	(l_cd);
				cng.setCng_item		("bus_id2");
				cng.setOld_value	(bean.getOld_bus_id2());
				cng.setNew_value	(bean.getNew_bus_id2());
				cng.setCng_cau		("채권대손처리요청");
				cng.setCng_id		(ck_acar_id);
				cng.setRent_st		("");
				cng.setS_amt		(0);
				cng.setV_amt		(0);
				
				flag3 = a_db.updateLcRentCngH(cng);
			
				bean.setBus_id2_cng_yn	("Y");				//변경여부
				bean.setCng_id			(ck_acar_id);		//변경자
			
				flag2 = a_db.updateBadDebtReqBusid2Cng(bean);
				
			}
			
			
		}else if(bad_debt_st.equals("2")){//대손처리
			
			String vid1[] 		= request.getParameterValues("item_gubun");
			String vid2[] 		= request.getParameterValues("item_cd1");
			String vid3[] 		= request.getParameterValues("item_cd2");
			String vid4[] 		= request.getParameterValues("item_cd3");
			String vid5[] 		= request.getParameterValues("item_cd4");
			String vid6[] 		= request.getParameterValues("item_cd5");
			String vid7[] 		= request.getParameterValues("amt");
			
			for(int j=0;j < vid1.length;j++){
				
				if(vid1[j].equals("보증금") || vid1[j].equals("선납금") || vid1[j].equals("개시대여료") || vid1[j].equals("승계수수료") || vid1[j].equals("해지정산금") || vid1[j].equals("면책금") || vid1[j].equals("대차료")){
					
					String e_rent_st 	= vid2[j];
					String e_ext_st 	= vid3[j];
					String e_ext_tm 	= vid4[j];
					String e_ext_id 	= vid5[j];
					
					flag4 = s_db.updateBadDebtExt(ck_acar_id, m_id, l_cd, e_rent_st, e_ext_st, e_ext_tm, e_ext_id);
					
					if(vid1[j].equals("대차료")){
						flag4 = s_db.updateBadDebtMyAccid(ck_acar_id, m_id, l_cd, c_id, e_ext_id);
					}
					
				}else if(vid1[j].equals("대여료")){
					
					String e_rent_st 	= vid2[j];
					String e_rent_seq 	= vid3[j];
					String e_fee_tm 	= vid4[j];
					String e_tm_st1 	= vid5[j];
					
					flag4 = s_db.updateBadDebtFee(ck_acar_id, m_id, l_cd, e_rent_st, e_rent_seq, e_fee_tm, e_tm_st1);

				}else if(vid1[j].equals("연체이자")){
					
					String e_rent_st 	= vid2[j];
					String e_rent_seq 	= vid3[j];
					String e_fee_tm 	= vid4[j];
					String e_tm_st1 	= vid5[j];
					
					flag4 = s_db.updateBadDebtDlyFee(ck_acar_id, m_id, l_cd, AddUtil.parseDigit(vid7[j]));

				}else if(vid1[j].equals("과태료")){
					
					String f_car_mng_id = vid2[j];
					String f_seq_no	 	= vid3[j];
					String f_m_id	 	= vid4[j];
					String f_l_cd	 	= vid5[j];
					
					flag4 = s_db.updateBadDebtFine(ck_acar_id, f_m_id, f_l_cd, f_car_mng_id, AddUtil.parseInt(f_seq_no));
					
				}else if(vid1[j].equals("월렌트정산금")){
					
					String e_rent_st 	= vid2[j];
					String e_ext_tm 	= vid3[j];
					
					flag4 = s_db.updateBadDebtRentCont(ck_acar_id, s_cd, e_rent_st, AddUtil.parseInt(e_ext_tm));
					
					RentMBean em_bean = new RentMBean();
					em_bean.setUser_id	(ck_acar_id);
					em_bean.setRent_s_cd	(s_cd);
					em_bean.setSub		("종료");
					em_bean.setNote		("채권 대손처리 요청 처리");	
					int em_count = rs_db.insertRentM(em_bean);
					
				}
			}
			
			//대손채권관련 메모에 넣기
			InsMemoBean memo = new InsMemoBean();
			memo.setRent_mng_id	(m_id);
			memo.setRent_l_cd	(l_cd);
			memo.setCar_mng_id	(c_id);
			memo.setTm_st		("9");
			memo.setAccid_id	("종료");
			memo.setServ_id		("");
			memo.setSeq		("");
			memo.setReg_id		(ck_acar_id);	// cookie세팅
			memo.setReg_dt		(AddUtil.getDate());
			memo.setContent		("채권 대손처리 요청 처리");
			memo.setSpeaker		("");
			
			flag5 = a_cad.insertInsMemo(memo);//tel_mm
			
			
			bean.setBus_id2_cng_yn	("Y");				//변경여부
			bean.setCng_id			(ck_acar_id);		//변경자
			
			flag2 = a_db.updateBadDebtReqBusid2Cng(bean);
		}
	}
	
	flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
	
	
	
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub 		= "채권대손처리요청 결재";
			String cont 	= "[ "+request.getParameter("firm_nm")+" "+request.getParameter("car_no")+" ] 채권대손처리요청합니다.";
			String url 		= "/fms2/settle_acc/bad_debt_doc.jsp?m_id="+m_id+"|l_cd="+l_cd+"|c_id="+c_id+"|s_cd="+s_cd+"|doc_no="+doc_no+"|seq="+seq+"|gubun1=1|s_kd=1|t_wd=";
			String target_id = doc.getUser_id2();
			String m_url = "/fms2/settle_acc/bad_debt_doc_frame.jsp";
			if(doc_bit.equals("2")){
				sub 		= "채권대손처리요청 결재완료";
				cont 		= "[ "+request.getParameter("firm_nm")+" "+request.getParameter("car_no")+" ] 채권대손처리요청 팀장 결재하였습니다.";
				url 		= "/fms2/settle_acc/bad_debt_doc_frame.jsp?m_id="+m_id+"|l_cd="+l_cd+"|c_id="+c_id+"|s_cd="+s_cd+"|doc_no="+doc_no+"|seq="+seq+"|gubun1=2|s_kd=1|t_wd="+request.getParameter("firm_nm");
				target_id 	= doc.getUser_id1();
				
				if(bad_debt_st.equals("3")){//기각
					sub 		= "채권대손처리요청 기각";
					cont 		= "[ "+request.getParameter("firm_nm")+" "+request.getParameter("car_no")+" ] 채권대손처리요청이 기각되었습니다. \n\n기각사유:"+reject_cau;
				}
			}
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
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
			
			flag4 = cm_db.insertCoolMsg(msg);
			
			
			if(doc_bit.equals("2")){
				if(bad_debt_st.equals("1")){//채권추심
					sub 		= "채권대손처리요청 결재완료";
					cont 		= "[ "+request.getParameter("firm_nm")+" "+request.getParameter("car_no")+" ] 채권대손처리요청 팀장 결재하였습니다. 담당자는 변경되었으니 채권추심 진행하십시오.";
					target_id 	= nm_db.getWorkAuthUser("채권관리자");
					
					UsersBean target_bean2 	= umd.getUsersBean(target_id);
					
					String xml_data2 = "";
					xml_data2 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
		  						"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
  								"    <SUB>"+sub+"</SUB>"+
				  				"    <CONT>"+cont+"</CONT>"+
 								"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
					xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		
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
					
					flag4 = cm_db.insertCoolMsg(msg2);
					
				}
			}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name="doc_no" 	value="<%=doc_no%>">		
<input type='hidden' name="seq" 	value="<%=seq%>">		
</form>
<script language='javascript'>
<%	if(flag1){	%>	

	alert('처리되었습니다.');
		
	var fm = document.form1;	
	fm.action = 'bad_debt_doc_frame.jsp';
	fm.target = 'd_content';
	fm.submit();
	
	parent.self.window.close();
	
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>