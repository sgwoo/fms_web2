<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.out_car.*, acar.user_mng.*, acar.common.*, tax.*, acar.car_office.*, acar.bill_mng.* "%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");	
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String s_sort = request.getParameter("s_sort")==null?"":request.getParameter("s_sort");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	NeoErpUDatabase 	neoe_db = NeoErpUDatabase.getInstance();

	//입금표발행	
	String ch_cd[] 		= request.getParameterValues("ch_cd");
	
	int vid_size = ch_cd.length;
	
	String vid_num		= "";
	String ch_off_id	= "";
	String ch_incom_dt	= "";	
	int flag = 0;
	int flag3 = 0;
	
	String ebill_code = Long.toString(System.currentTimeMillis());
			
	//out.println(vid_size+"<br><br>");
	//out.println("ebill_code="+ebill_code+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		vid_num = ch_cd[i];
		ch_off_id		= vid_num.substring(0,5);
		ch_incom_dt 	= vid_num.substring(5);
		
		//out.println("ch_off_id="+ch_off_id+"<br>");
		//out.println("ch_incom_dt="+ch_incom_dt+"<br>");
		
		if(!oc_db.updateCarStatEbillcode(ch_off_id, ch_incom_dt, ebill_code)) flag += 1;
				
	}
	
	//user_id = "000131";
	
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	Hashtable br = c_db.getBranch("S1");  //무조건 본사
	
	Vector vt = vt = oc_db.getCarStatEbillcodeList(ebill_code);
	int vt_size = vt.size();	
	for (int i = 0 ; i < vt_size ; i++){
    	Hashtable ht = (Hashtable)vt.elementAt(i);
    	
    	//전자입금표일련번호
    	String SeqId = IssueDb.getSeqIdNext("PayEBill","PE");
    	
		SaleEBillBean sb_bean = new SaleEBillBean();
		
		sb_bean.setSeqID		(SeqId);
		sb_bean.setDocCode		("03");
		sb_bean.setDocKind		("03");
		sb_bean.setS_EbillKind	("1");//1:일반입금표 2:위수탁입금표
		sb_bean.setRefCoRegNo	("");
		sb_bean.setRefCoName	("");
		sb_bean.setTaxSNum1		("");
		sb_bean.setTaxSNum2		("");
		sb_bean.setTaxSNum3		("");
		sb_bean.setDocAttr		("N");
		sb_bean.setOrigin		("");
		sb_bean.setPubDate		(ht.get("INCOM_DT")+"");
		sb_bean.setSystemCode	("KF");
					
		//공급자------------------------------------------------------------------------------
		sb_bean.setMemID		("amazoncar11");
		sb_bean.setMemName		(user_bean.getUser_nm());
		sb_bean.setEmail		("tax@amazoncar.co.kr");				//계산서 담당 메일 주소
		sb_bean.setTel			(user_bean.getHot_tel());
	
		sb_bean.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
		sb_bean.setCoName		("(주)아마존카");
		sb_bean.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
		sb_bean.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
		sb_bean.setCoBizType	(String.valueOf(br.get("BR_STA")));
		sb_bean.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
		
		//공급받는자--------------------------------------------------------------------------
		
		//공급받는자-영업소
		CarOffBean co_bean = cod.getCarOffBean(ht.get("CAR_OFF_ID")+"");
		Hashtable ven = neoe_db.getTradeCase(co_bean.getVen_code());
		//세금계산서 수신자 - 지점장
		CarOffEmpBean coe_bean = cod.getCarOffEmpBean(co_bean.getCar_off_id(), co_bean.getManager());
	
		sb_bean.setRecMemID		("");
		sb_bean.setRecMemName	(coe_bean.getEmp_nm());
		sb_bean.setRecEMail		(co_bean.getAgnt_email());
		if(co_bean.getAgnt_email().equals("")){
			sb_bean.setRecEMail	(coe_bean.getEmp_email());
		}
		sb_bean.setRecTel		(coe_bean.getEmp_m_tel());
		sb_bean.setRemarks		(ht.get("B_MON")+"월 영업수당");
		sb_bean.setRecCoRegNo	(ven.get("S_IDNO")+"");		
		sb_bean.setRecCoName	(ven.get("CUST_NAME")+"");
		sb_bean.setRecCoCeo		(ven.get("DNAME")+"");
		sb_bean.setRecCoAddr	(ven.get("S_ADDRESS")+"");
		sb_bean.setRecCoBizType	(ven.get("TP_JOB")+"");
		sb_bean.setRecCoBizSub	(ven.get("CLS_JOB")+"");
		//내용-----------------------------------------------------------------------------------
		sb_bean.setSupPrice		(AddUtil.parseInt(String.valueOf(ht.get("INCOM_AMT"))));
		sb_bean.setTax			(0);
		sb_bean.setPubKind		("N");
		sb_bean.setLoadStatus	(0);
		sb_bean.setPubCode		("");
		sb_bean.setPubStatus	("");
		sb_bean.setItemName1	(ht.get("B_MON")+"월 영업수당");
		
		if(!IssueDb.insertPayEBill(sb_bean)){
			flag3 += 1;
		}
		
		if(!oc_db.updateCarStatSeqid(ht.get("CAR_OFF_ID")+"", ht.get("INCOM_DT")+"", SeqId)) flag += 1;
	}	

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'car_cash_back_payebill_sc.jsp';
		fm.target = "c_foot";
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='car_off_id' 	value='<%=car_off_id%>'>
<input type='hidden' name='s_dt' 	value='<%=s_dt%>'>
<input type='hidden' name='s_sort' 	value='<%=s_sort%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("처리되었습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
