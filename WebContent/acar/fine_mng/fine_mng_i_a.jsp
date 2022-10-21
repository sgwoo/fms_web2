<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.user_mng.*, acar.coolmsg.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");

	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String fault_st = request.getParameter("fault_st")==null?"":request.getParameter("fault_st");
	

	boolean flag6 = true;
	int seq = 0;
	int count = 0;
	String reg_code  = Long.toString(System.currentTimeMillis());
	int est_check1 = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	//과태료정보
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	if(!c_id.equals("") && !seq_no.equals("")){//값이 있을때 검색한다.			
		f_bean = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd, seq_no);
	}
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	//기초정보
	if(!c_id.equals("")){//값이 있을때 검색한다.
		rl_bean = fdb.getCarRent(c_id, m_id, l_cd);
	}
	
	if(cmd.equals("i")||cmd.equals("u")){
	
		
		f_bean.setReg_code		(reg_code);
		f_bean.setFine_st			(request.getParameter("fine_st")==null?"":request.getParameter("fine_st"));
		f_bean.setCall_nm			(request.getParameter("call_nm")==null?"":request.getParameter("call_nm"));
		f_bean.setTel					(request.getParameter("tel")==null?"":request.getParameter("tel"));
		f_bean.setFax					(request.getParameter("fax")==null?"":request.getParameter("fax"));
		f_bean.setVio_dt			(request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt"));
		f_bean.setVio_pla			(request.getParameter("vio_pla")==null?"":request.getParameter("vio_pla"));
		f_bean.setVio_cont		(request.getParameter("vio_cont")==null?"":request.getParameter("vio_cont"));
		f_bean.setPaid_st			(request.getParameter("paid_st")==null?"":request.getParameter("paid_st"));
		f_bean.setRec_dt			(request.getParameter("rec_dt")==null?"":request.getParameter("rec_dt"));
		f_bean.setPaid_end_dt	(request.getParameter("paid_end_dt")==null?"":request.getParameter("paid_end_dt"));
		f_bean.setPaid_amt		(request.getParameter("paid_amt")==null?0:AddUtil.parseDigit(request.getParameter("paid_amt")));
		f_bean.setPaid_amt2		(request.getParameter("paid_amt2")==null?0:AddUtil.parseDigit(request.getParameter("paid_amt2")));
		f_bean.setProxy_dt		(request.getParameter("proxy_dt")==null?"":request.getParameter("proxy_dt"));
		f_bean.setPol_sta			(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
		f_bean.setPaid_no			(request.getParameter("paid_no")==null?"":request.getParameter("paid_no"));
		f_bean.setFault_st		(request.getParameter("fault_st")==null?"":request.getParameter("fault_st"));
		f_bean.setFault_nm		(request.getParameter("fault_nm")==null?"":request.getParameter("fault_nm"));
		f_bean.setFault_amt		(request.getParameter("fault_amt")==null?0:AddUtil.parseDigit(request.getParameter("fault_amt")));
		f_bean.setDem_dt			(request.getParameter("dem_dt")==null?"":request.getParameter("dem_dt"));
		f_bean.setColl_dt			(request.getParameter("coll_dt")==null?"":request.getParameter("coll_dt"));
		f_bean.setRec_plan_dt	(request.getParameter("rec_plan_dt")==null?"":request.getParameter("rec_plan_dt"));
		f_bean.setNote				(request.getParameter("note")==null?"":request.getParameter("note"));
		f_bean.setNo_paid_yn	(request.getParameter("no_paid_yn")==null?"N":request.getParameter("no_paid_yn"));
		f_bean.setNo_paid_cau	(request.getParameter("no_paid_cau")==null?"":request.getParameter("no_paid_cau"));
		f_bean.setUpdate_id		(request.getParameter("user_id")==null?"":request.getParameter("user_id"));
		f_bean.setUpdate_dt		(AddUtil.getDate());
		f_bean.setObj_dt1			(request.getParameter("obj_dt1")==null?"":request.getParameter("obj_dt1"));
		f_bean.setObj_dt2			(request.getParameter("obj_dt2")==null?"":request.getParameter("obj_dt2"));
		f_bean.setObj_dt3			(request.getParameter("obj_dt3")==null?"":request.getParameter("obj_dt3"));
		f_bean.setBill_doc_yn	(request.getParameter("bill_doc_yn")==null?"":request.getParameter("bill_doc_yn"));
		f_bean.setBill_mon		(request.getParameter("bill_mon")==null?"":request.getParameter("bill_mon"));		
		f_bean.setVat_yn			(request.getParameter("vat_yn")==null?"":request.getParameter("vat_yn"));
		f_bean.setTax_yn			(request.getParameter("tax_yn")==null?"":request.getParameter("tax_yn"));
		f_bean.setF_dem_dt		(request.getParameter("f_dem_dt")==null?"":request.getParameter("f_dem_dt"));
		f_bean.setE_dem_dt		(request.getParameter("e_dem_dt")==null?"":request.getParameter("e_dem_dt"));
		f_bean.setBusi_st			(request.getParameter("busi_st")==null?"":request.getParameter("busi_st"));
		f_bean.setRent_s_cd		(request.getParameter("s_cd")==null?"":request.getParameter("s_cd"));		
		f_bean.setNotice_dt		(request.getParameter("notice_dt")==null?"":request.getParameter("notice_dt"));
		f_bean.setObj_end_dt	(request.getParameter("obj_end_dt")==null?"":request.getParameter("obj_end_dt"));
		f_bean.setMng_id			(request.getParameter("mng_id")==null?"":request.getParameter("mng_id"));
		f_bean.setFine_gb			(request.getParameter("fine_gb")==null?"":request.getParameter("fine_gb"));
		f_bean.setRent_st			(request.getParameter("rent_st")==null?"":request.getParameter("rent_st"));
		f_bean.setVio_st			(request.getParameter("vio_st")==null?"":request.getParameter("vio_st"));

		if(cmd.equals("i")){
		
			//중복체크
			Vector c_fines = a_fdb.getFineCheckList(c_id, f_bean.getVio_dt());
			int c_fine_size = c_fines.size();
			
			est_check1 = c_fine_size;
		
			if(est_check1==0){
			
				f_bean.setCar_mng_id	(c_id);
				f_bean.setRent_mng_id	(m_id);
				f_bean.setRent_l_cd		(l_cd);
				f_bean.setSeq_no			(request.getParameter("seq_no")==null?0:Util.parseInt(request.getParameter("seq_no")));

				//대여기간에 맞는 과태료 입력 확인
				String ch_rent_st = a_fdb.getFineSearchRentst(m_id, l_cd, AddUtil.replace(f_bean.getVio_dt(),"-",""));
				if(!ch_rent_st.equals(""))	f_bean.setRent_st(ch_rent_st);
			
				seq = a_fdb.insertForfeit(f_bean);
			
			
				if(fault_st.equals("2")){//업무상과실 과태료 등록시 담당자에게 쿨메신져로 알려줌.
					//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
					String paid_no = request.getParameter("paid_no")==null?"":request.getParameter("paid_no");
					String vio_dt = request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
					String sub 		= "업무상 과실 과태료 등록 안내";
					String cont 	= "업무상 과실 과태료가 등록 되었습니다.  &lt;br&gt; &lt;br&gt;  위반차량번호:"+rl_bean.getCar_no()+" 과태료번호: ["+paid_no+"] 위반일시:["+vio_dt+"]  &lt;br&gt; &lt;br&gt; 내용을 확인하여 납부하시고, 납부영수증을 총무팀 김현태사원에게 보내주시기 바랍니다.";			
					String url 		= "/acar/fine_mng/fine_mng_frame.jsp";
					//사용자 정보 조회
					String target_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
					UsersBean target_bean 	= umd.getUsersBean(target_id);
					UsersBean sender_bean 	= umd.getUsersBean(user_id);
					String xml_data = "";
					xml_data =  "<COOLMSG>"+
						"<ALERTMSG>"+
						"<BACKIMG>4</BACKIMG>"+
						"<MSGTYPE>104</MSGTYPE>"+
						"<SUB>"+sub+"</SUB>"+
						"<CONT>"+cont+"</CONT>"+
						"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
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
				}
			}else{
				for (int i = 0 ; i < 1 ; i++){
        	Hashtable c_fine = (Hashtable)c_fines.elementAt(i);
        	seq = AddUtil.parseInt(String.valueOf(c_fine.get("SEQ_NO")));
        	flag6 = a_fdb.updateForfeitReReg(c_id, seq, f_bean.getUpdate_id());	
        }
			}
		}else if(cmd.equals("u")){	
			count = a_fdb.updateForfeit(f_bean);
		}
	}else if(cmd.equals("d")){
		count = a_fdb.deleteForfeit(f_bean);
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function NullAction()
	{
		var fm = document.form1;
		
<%	if(cmd.equals("u")||cmd.equals("d")){
			if(count==1){
%>
				alert("정상적으로 수정되었습니다.");
				fm.seq_no.value = '<%=f_bean.getSeq_no()%>';
				fm.target = "d_content";
				if ( fm.from_page.value == "/fms2/forfeit_mng/forfeit_r_frame.jsp") {
					fm.action = "/fms2/forfeit_mng/forfeit_r_frame.jsp";
				} else {
					fm.action = "fine_mng_frame.jsp";
				}
				fm.submit();
<%		}else if(count==2){
%>
				alert("정상적으로 삭제되었습니다.");
				fm.seq_no.value = '';
				fm.target = "d_content";
				fm.action = "fine_mng_frame.jsp";
				fm.submit();
<%		}
		}else{
			if(est_check1==0){
				if(seq!=0){
%>
					alert("정상적으로 등록되었습니다.");
					fm.seq_no.value = '<%=seq%>';
					fm.target = "d_content";
					fm.action = "fine_mng_frame.jsp";
					fm.submit();
<%			}
			}else{
%>
				alert('입력한 차량번호와 위반일자로 기등록분이 있습니다. 과태료 중복등록 처리하였습니다.');
				fm.seq_no.value = '<%=seq%>';
				fm.target = "d_content";
				fm.action = "fine_mng_frame.jsp";
				fm.submit();
<%		}
		}
%>
	
	}

//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="" name="form1" method="post">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="seq_no" value="">
<input type="hidden" name="cmd" value="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
<input type='hidden' name='f_list' value='<%=f_list%>'>
</form>
</body>
</html>
