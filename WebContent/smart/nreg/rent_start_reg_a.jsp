<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.insur,* "%>
<%@ page import="acar.cont.*, acar.car_register.*, acar.im_email.*"%>
<jsp:useBean id="a_db" 		class="acar.cont.AddContDatabase" 			scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page" />
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase"		scope="page" />
<%@ include file="/smart/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	String cmd 			= request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String serv_id		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_dt 		= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String tot_dist 	= request.getParameter("tot_dist")==null?"":request.getParameter("tot_dist");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	int flag = 0;
	
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	fee.setRent_start_dt	(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
	fee.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
	fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
	fee.setFee_est_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
	fee.setFee_pay_start_dt	(request.getParameter("fee_pay_start_dt")==null?"":request.getParameter("fee_pay_start_dt"));
	fee.setFee_pay_end_dt	(request.getParameter("fee_pay_end_dt")	==null?"":request.getParameter("fee_pay_end_dt"));
	fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt"));
	fee.setFee_fst_amt		(request.getParameter("fee_fst_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
	
	//=====[fee] update=====
	flag1 = a_db.updateContFeeStart(fee);
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	base.setRent_start_dt(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
	base.setRent_end_dt	(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
	
	//=====[cont] update=====
	flag2 = a_db.updateContBaseStart(base);
	
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	cont_etc.setCar_deli_dt		(request.getParameter("car_deli_dt")	==null?"":request.getParameter("car_deli_dt"));
	
	//=====[cont_etc] update=====
	flag3 = a_db.updateContEtcStart(cont_etc);
	
	
	//������ ��������� ���� ���� �߼��Ѵ�. : 20100716
	
	
	//��� ����� ���� ���� ����
	Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
	
	Hashtable cont_view = a_db.getContViewCase(rent_mng_id, rent_l_cd);
	
	UsersBean target_bean 	= umd.getUsersBean(base.getBus_id2());
	
	if(!base.getBus_id2().equals("000026") && !base.getBus_id2().equals("000005") && !base.getBus_id2().equals("000144") && !base.getBus_id2().equals("000053") && !base.getBus_id2().equals("000052") && !base.getBus_id2().equals("000054")){//��������,��������,ä�Ǵ��,�λ�����������
		
		CarRegDatabase crd = CarRegDatabase.getInstance();
		if(!base.getCar_mng_id().equals("")){
			cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		}
		
		String s_destphone = "";
		s_destphone = String.valueOf(sms.get("TEL"));
		
		String s_destname = "";
		s_destname = String.valueOf(sms.get("NM"));
		
		String ins_name = "";
		ins_name = ai_db.getInsComNm(base.getCar_mng_id() );
			
		String ins_tel ="";
		if ( ins_name.equals("�Ｚȭ��") ) {
			    ins_tel = " 1588-5114 , ";
		} else if  ( ins_name.equals("����ȭ��") ) {
			    ins_tel = " 1588-0100 ,";
		}
		
		String cont_sms 	= cr_bean.getCar_no() + " �뿩�������� " + String.valueOf(cont_view.get("RENT_START_DT")) + ", ���� ����ڴ� " + target_bean.getUser_nm() + ", ����ó�� "+ target_bean.getUser_m_tel() + " �Դϴ�. (��)�Ƹ���ī"; 
		
		String cont_sms1 	= "������  "+ ins_name + "  "  + ins_tel + "   ����⵿�� ����Ÿ�ڵ��� 1588-6688, SK��Ʈ���� 1670-5494 �Դϴ�.  (��)�Ƹ���ī "; 
							
		if(!s_destphone.equals("")){
		
			//201411 �뿩������ +3�Ͽ� �����°����� �����Ѵ�.
			String msg_type 	= "5";
			String msg_subject 	= "�뿩���þȳ�";
			String req_time 	= AddUtil.getDate(4);
			String rqdate 		= "";
				
			req_time = rs_db.addDay(req_time, 3);
				
			req_time = AddUtil.replace(af_db.getValidDt(req_time),"-","")+"100000";	
						
			
			ImEmailDb.insertsendMail_V5_req_H("02-392-4242", "(��)�Ƹ���ī", s_destphone, s_destname, req_time, rqdate, msg_type, msg_subject, cont_sms, rent_l_cd, base.getClient_id(), ck_acar_id, "start");
			
			System.out.println("[�����뿩����-"+String.valueOf(cont_view.get("FIRM_NM"))+" "+String.valueOf(cont_view.get("CAR_NO"))+"]"+s_destname + ":" + s_destphone + ":" + cont_sms);
						
			msg_subject 	= "����� ����⵿�ȳ�";
			
			//������ ����⵿ ���ڸ޼��� 
			
			ImEmailDb.insertsendMail_V5_req_H( target_bean.getUser_m_tel(), "(��)�Ƹ���ī " + target_bean.getUser_nm(), s_destphone, s_destname, req_time, rqdate, msg_type, msg_subject, cont_sms1, rent_l_cd, base.getClient_id(), ck_acar_id, "start");
					
		}
	}
	
	
	//20120713 �����ٻ����� ���վȳ����Ϸ� ��ü�Ѵ�.
	
	
/*	
	
	String email 	= "";
	String gov_nm   = "";
	
	String car_info_mail		= request.getParameter("car_info_mail")==null?"N":request.getParameter("car_info_mail"); 
	
	gov_nm		 = String.valueOf(cont_view.get("FIRM_NM"));
	
	//mail_view :�����̿��� �Ǵ� �ŷ�ó ����� ����
	Hashtable mail_view = ImEmailDb.getContEmail(rent_mng_id, rent_l_cd);
	
	email = String.valueOf(mail_view.get("EMAIL"));
	
	//���뿩 �������� �ȳ����� ������ - �����ּ� ������---
	if(!email.equals("") && car_info_mail.equals("Y") ){
	
		//	1. d-mail ���-------------------------------
		
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject			(gov_nm+"��, (��)�Ƹ���ī ���������ȳ����Դϴ�. ");
		d_bean.setSql				("SSV:"+email);
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
		d_bean.setMailto			("\""+gov_nm+"\"<"+email+">");			
		d_bean.setReplyto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
		d_bean.setErrosto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(rent_l_cd+"car_info");
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin����
		d_bean.setG_idx				(1);//admin����
		d_bean.setMsgflag     		(0);
		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/car_adm/car_mng_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&rent_st=1");
		
		if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
		
		System.out.println("������������=" + email + ":" + gov_nm);
		
		
			int today_mail_chk = ImEmailDb.getFmsInfoMailTodayNotSendChkList(d_bean.getSubject(), email);
			
			if(today_mail_chk ==1){
				
				//����Ÿ�ڵ��� ����⵿ �ȳ�����
				d_bean.setSubject			(gov_nm+"��, (��)�Ƹ���ī ����Ÿ�ڵ��� ����⵿ �ȳ����Դϴ�.");
				d_bean.setGubun				(rent_l_cd+"car_sos");
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/sos.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&rent_st=1");
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
				
				//�̳��������·� ���� �ȳ�����
				d_bean.setSubject			(gov_nm+"��, (��)�Ƹ���ī �����ӵ���&������ �̳�����ᳳ�� �ȳ����Դϴ�.");
				d_bean.setGubun				(rent_l_cd+"cms_fine");
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/cms/cms_fine.html");
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
				
				if(fee.getRent_way().equals("1")){
					d_bean.setSubject			(gov_nm+"��, (��)�Ƹ���ī ���ǵ����Ʈ �������¾�ü �ȳ����Դϴ�.");
					//�Ϲݽ��� ��� ���ǵ����Ʈ �ȳ�����
					d_bean.setGubun				(rent_l_cd+"speedmate");
					d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/etc/notice_rep.html");
					if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
				}
			}
	}
	
*/
	
	//���⺻����
	ContBaseBean base2 = a_db.getCont(rent_mng_id, rent_l_cd);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<form action="rent_start_view.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='serv_id'		value='<%=serv_id%>'>		
</form>
<script>
<%	if(!base2.getRent_start_dt().equals("")){%>		
		document.form1.action = "rent_start_view.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else{%>
		alert("�����߻�!");
<%	}%>
</script>
</body>
</html>