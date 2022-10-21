<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.car_mst.*, acar.insur.*, acar.car_office.*, acar.res_search.*, acar.client.*,  acar.ext.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*, acar.im_email.*, tax.*, acar.doc_settle.*, acar.fee.*, acar.kakao.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
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
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no 		= request.getParameter("doc_no")	==null?"":request.getParameter("doc_no");
	String doc_bit 		= request.getParameter("doc_bit")	==null?"":request.getParameter("doc_bit");	
	String scd_fee_move_yn 	= request.getParameter("scd_fee_move_yn")==null?"N":request.getParameter("scd_fee_move_yn");	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int flag4 = 0;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	boolean c_flag3 = true;
	
	int flag = 0;
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ai_db 	= InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	LoginBean login 	= LoginBean.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//�α��� ���������
	if (user_id.equals("")) {
		user_id = login.getCookieValue(request, "acar_id");
	}

	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
			
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);	
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);	
	
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�ŷ�ó����
	ClientBean client = al_db.getClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());	
	
	if(!base.getR_site().equals("") && site.getAgnt_email().length() > 5 ){		
		client.setCon_agnt_nm	(site.getAgnt_nm());
		client.setCon_agnt_email(site.getAgnt_email().trim());		
	}
	
	String car_comp_id = "";
	
	//�ڵ����⺻����
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	car_comp_id = cm_bean.getCar_comp_id();	
	
	
	//�������� ����Ʈ
	Vector fee_scd_est = af_db.getScdFeeEstList(rent_mng_id, rent_l_cd);
	int fee_scd_est_size = fee_scd_est.size();	
	
	
%>




<%
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	
	
	if(doc_bit.equals("u")){
	
		//��������
		DocSettleBean doc_var = d_db.getDocSettleVar(doc_no, 1);
		
		doc_var.setEtc		(request.getParameter("etc")			==null?"":request.getParameter("etc"));
		doc_var.setVar19	(request.getParameter("fee_fst_dt3")		==null?"":request.getParameter("fee_fst_dt3"));
		doc_var.setVar20	(request.getParameter("fee_fst_amt3")		==null?"":request.getParameter("fee_fst_amt3"));
		doc_var.setVar21	(request.getParameter("fee_lst_dt3")		==null?"":request.getParameter("fee_lst_dt3"));
		doc_var.setVar22	(request.getParameter("fee_lst_amt3")		==null?"":request.getParameter("fee_lst_amt3"));
		
		if(!d_db.updateDocSettleVarScdFeeDoc(doc_var)) flag += 1;		
	
	
	}
	
	
	//1. ����ó���� ����ó��-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	String doc_step = "2";
	
	//�ѹ����� �����̸� ���� ���� �Ϸ�
	if(doc_bit.equals("3")) doc_step = "3";
	
	//�ѹ����� �̰�� �̸� ���� ���� �Ϸ�
	if(doc_bit.equals("2") && doc.getUser_id3().equals("XXXXXX")) doc_step = "3";
	
	
	if(doc_bit.equals("2") || doc_bit.equals("3")){
	
		flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		
		
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
				
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String car_no	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
		String sub 	= "�������� �� �����ٻ���";
		String cont 	= "["+firm_nm+" "+car_no+"] �������� �� �����ٻ����� ��û�Ͽ��� Ȯ�ιٶ��ϴ�.";
		String target_id= "";
		String url 	= "/fms2/lc_rent/lc_start_doc.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
		String m_url ="/fms2/lc_rent/lc_start_frame.jsp";
		CarScheBean cs_bean = new CarScheBean();
		
		if(doc_bit.equals("2") && doc_step.equals("2")){
			target_id = doc.getUser_id3();
			cont 		= "["+firm_nm+" "+car_no+"] �������� �� �����ٻ��� �������� ������Դϴ�. ���縦 ��û�մϴ�.";
		}
			
		if(!target_id.equals("")){
			cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
		}
			
		//�������� ����Ϸ��� �����ٺ����ڿ��� �����û�Ѵ�.
		if(doc_bit.equals("3") && !doc.getUser_id3().equals("XXXXXX")){
			sub 		= "�������� �� �����ٻ���";
			cont 		= "["+firm_nm+" "+car_no+"] �������� �� �����ٻ����� ����Ǿ�����  �뿩�ὺ���� �����Ͻʽÿ�.";
			target_id 	= doc.getUser_id2();
				
			cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
			
		}
		
		
		if(!target_id.equals("")){
			
			//��޽��� �˶� ���----------------------------------------------------------------------------------------
			
			
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
  						"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
 						"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
			//�޴»��
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			//�������
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
			
			if(fee_scd_est_size == 0){
				flag2 = cm_db.insertCoolMsg(msg);
			}
			
		}
		
		
		//�������� �ǽ����ٷ� ����------------------------------------------------------------------------------------
		
		//�����뿩������ �뿩Ƚ�� �ִ밪
		int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);
		
		String cms_start_dt 	= "";
		String cms_end_dt 	= "";
		
		for (int j = 0; j < fee_scd_est_size; j++) {
   			Hashtable ht = (Hashtable)fee_scd_est.elementAt(j);       			
   			
   			
   			FeeScdBean fee_scd = af_db.getScdFeeEst( String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), String.valueOf(ht.get("RENT_ST")), String.valueOf(ht.get("RENT_SEQ")), String.valueOf(ht.get("FEE_TM")), String.valueOf(ht.get("TM_ST1")) );
   			
   			int fee_tm = AddUtil.parseInt(fee_scd.getFee_tm())+max_fee_tm;
      			
			fee_scd.setFee_tm		(String.valueOf(fee_tm));			
			fee_scd.setRc_yn		("0");					//0-�̼���
			
			if(scd_fee_move_yn.equals("Y")){
       			
				if(!af_db.insertFeeScd(fee_scd)) flag4 += 1;
      				
   			}
      			       			
			//1ȸ��---------------------------------------------------------------------------------------------
			if(j == 0){
				cms_start_dt 	= fee_scd.getFee_est_dt();
			}
			
			cms_end_dt 	= fee_scd.getFee_est_dt();			
       			
		}
       		
       		
   		if (fee_scd_est_size > 0) {
   		
   			//��������������
			if(max_fee_tm == 0){
				cms.setCms_start_dt	(cms_start_dt);				
				cms.setApp_dt		(AddUtil.getDate());
			}	
			cms.setCms_end_dt		(cms_end_dt);	
			cms.setCms_day			(fee.getFee_est_day());
			if(cms.getApp_dt().equals("")){
				cms.setCms_start_dt	(cms_start_dt);	
				cms.setApp_dt		(AddUtil.getDate());
			}		
			if(cms.getCms_day().equals("99")){			
				cms.setCms_day		("31");
			}		

			if(scd_fee_move_yn.equals("Y")){
				cms.setUpdate_id	(user_id);
				c_flag3 = a_db.updateContCmsMng(cms);
			    		
				//�����̷� ���------------------------------------------------------------------------
				FeeScdCngBean cng = new FeeScdCngBean();
				cng.setRent_mng_id	(rent_mng_id);
				cng.setRent_l_cd	(rent_l_cd);
				cng.setFee_tm		("1");
				cng.setAll_st		("");
				cng.setGubun		("�űԻ���");
				cng.setB_value		("");
				cng.setA_value		(fee_scd_est_size+"ȸ��");
				cng.setCng_id		(user_id);
				cng.setCng_cau		("�űԻ��� ���-�뿩���õ��");	
				if(!af_db.insertFeeScdCng(cng)) flag4 += 1;
			}
   		

   			//���վȳ��� �� ���Ϲ߼�
   			if (client.getCon_agnt_email().length() > 5 ) {
   		
				//	1. d-mail ���-------------------------------
			
				DmailBean d_bean = new DmailBean();
				d_bean.setSubject			(client.getFirm_nm()+"��, (��)�Ƹ���ī ���� ���� �ȳ����Դϴ�."); //���뿩 �̿� �ȳ���
				d_bean.setSql				("SSV:"+client.getCon_agnt_email().trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+client.getCon_agnt_email().trim()+">");
				d_bean.setReplyto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setErrosto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
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
				d_bean.setU_idx       		(1);//admin����
				d_bean.setG_idx				(1);//admin����
				d_bean.setMsgflag     		(0);	
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&rent_st=1");
				
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
			
			
				//20140210 �����ڵ��� ������� �ȳ����� �߼�
				if (car_comp_id.equals("0001") && base.getCar_gu().equals("1")) {
				
					d_bean.setSubject			(client.getFirm_nm()+"��, �����ڵ��� ����������� ���� �ȳ����Դϴ�. (��)�Ƹ���ī");
					d_bean.setGubun				(rent_l_cd+"bluemem");
					d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/etc/bluemem.html");
					if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
				}

   			}
   		
			UsersBean docuser_bean 	= umd.getUsersBean(doc.getUser_id1());
   		
    		//���վȳ��� ���ʿ����� ���Ϲ߼�
   			if(docuser_bean.getUser_email().length() > 5 ){	
   		
				//	1. d-mail ���-------------------------------
			
				DmailBean d_bean = new DmailBean();
				d_bean.setSubject			(client.getFirm_nm()+"��, (��)�Ƹ���ī ���� ���� �ȳ����Դϴ�."); //���뿩 �̿� �ȳ���
				d_bean.setSql				("SSV:"+docuser_bean.getUser_email().trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setMailto			("\""+docuser_bean.getUser_nm()+"\"<"+docuser_bean.getUser_email().trim()+">");
				d_bean.setReplyto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setErrosto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
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
				d_bean.setU_idx       		(1);//admin����
				d_bean.setG_idx				(1);//admin����
				d_bean.setMsgflag     		(0);	
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&rent_st=1");
				
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
		
   			}
    		    		
			
			UsersBean target_bean_1 = new UsersBean();
			UsersBean target_bean_2 = new UsersBean();
			target_bean_1 = umd.getUsersBean(base.getBus_id2());
			target_bean_2 = umd.getUsersBean(base.getBus_id());
			
			if (!base.getCar_mng_id().equals("")) {
				cr_bean = crd.getCarRegBean(base.getCar_mng_id());
			}
			
			Hashtable cont_view = a_db.getContViewCase(rent_mng_id, rent_l_cd);
			
			Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
			String s_destphone = String.valueOf(sms.get("TEL"))==null?"":String.valueOf(sms.get("TEL"));
			if (s_destphone.equals("")) {
				s_destphone = client.getM_tel();
			}
			
			
    		//�����ٻ���+3��
			String req_time = AddUtil.getDate(4);
			req_time = rs_db.addDay(req_time, 3);
			req_time = AddUtil.replace(af_db.getValidDt(req_time),"-","")+"100101";    		
			
			
			//���̸�
			String customer_name 	= String.valueOf(cont_view.get("FIRM_NM"));
			//������ȣ
			String car_num = cr_bean.getCar_no();
			//��� ������
			String contract_s_date = String.valueOf(cont_view.get("RENT_START_DT"));
			
			
			//����� �̸�
			String manager_name = target_bean_1.getUser_nm();
			//����� ��ȭ
			String manager_phone 	= target_bean_1.getUser_m_tel();
			
			//����� �̸�(����)
			String bus_manager_name = target_bean_2.getUser_nm();
			//����� ��ȭ(����)
			String bus_manager_phone = target_bean_2.getUser_m_tel();
			
			// �뿩�ὺ���� Ȯ�� URL
			String full_url = "http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id=" + rent_mng_id + "&l_cd=" + rent_l_cd + "&rent_st=";			
			String schedule_url = ShortenUrlGoogle.getShortenUrl(full_url);
    		
			String car_etc1 = rent_l_cd;
			String car_etc2 = user_id;			
			
			String ins_tel ="";
			String ins_name = "";
			
			ins_name = ai_db.getInsComNm(base.getCar_mng_id());
		
			if (ins_name.equals("�Ｚȭ��")) {
				ins_tel = " 1588-5114 ";
			} else if ( ins_name.equals("����ȭ��") || ins_name.equals("DB���غ���")) {
		    	ins_tel = " 1588-0100 ";
		    } else if ( ins_name.equals("����ī��������")) {
		    	ins_tel = " 1661-7977 ";
			}
			
			// ����� �̸�
			String insurance_name = ins_name + " (" + ins_tel + ")";
			// ����� ����ó
			String manager_phone2 = "("+ target_bean_1.getUser_m_tel() + ")";
			String callbackNum = target_bean_1.getUser_m_tel();
			
			//������ �ڵ��� ����ó
			String marster_car_num = "1588-6688";
			//sk��Ʈ���� ����ó
			String sk_net_num = "1670-5494";
			// ����⵿
			String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";
			
			String url_1 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
			String url_2 = "https://fms3.amazoncar.co.kr/fms2/attach/imgview_print_email.jsp?CONTENT_CODE=PROP_BBS&SEQ=9284563&S_GUBUN=94455";
			
			String sos_url = ShortenUrlGoogle.getShortenUrl(url_1);
			String service_url = ShortenUrlGoogle.getShortenUrl(url_2);
			
			
			//�˸��� acar0211 �뿩���þȳ�
			List<String> fieldList = Arrays.asList(customer_name, car_num, contract_s_date, bus_manager_name, bus_manager_phone, manager_name, manager_phone, schedule_url);
			at_db.sendMessageReserve("acar0211", fieldList, s_destphone, manager_phone, req_time, car_etc1, base.getBus_id2());
			
			//�˸��� acar0231 ����� ����⵿�ȳ�
			List<String> fieldList2 = Arrays.asList(customer_name, car_num, insurance_name, marster_car_num, sk_net_num, manager_name, manager_phone2, sos_url);
			at_db.sendMessageReserve("acar0231", fieldList2, s_destphone, manager_phone, null, car_etc1, base.getBus_id2());
			
			//��縵ũ �ȳ��� �˸��� �߼� (�����̰� �������鼭 ��縵ũ��뿡 Y�� üũ������) acar0164
			if (car_comp_id.equals("0001") && base.getCar_gu().equals("1")) {
				if (car.getBluelink_yn().equals("Y")) {
					List<String> fieldList3 = Arrays.asList("");
					at_db.sendMessageReserve("acar0164", fieldList3, s_destphone, manager_phone, null, car_etc1, base.getBus_id2());
				}
			}
			//��Ʈ��ķ ������ �˸��� �߼�(acar0257) 
			if(car.getTint_bn_yn().equals("Y") && car.getTint_bn_nm().equals("1")){ //���ڽ� ������ ���� (��Ʈ��ķ,������..)
				List<String> fieldList4 = Arrays.asList(customer_name,car_num, service_url );
				at_db.sendMessageReserve("acar0257", fieldList4, s_destphone, manager_phone, null, car_etc1, base.getBus_id2());
			}else{ //���û�翡 ��Ʈ��ķ�� �ִ� ���
				if(base.getCar_gu().equals("1") && (car.getOpt().contains("��Ʈ�� ķ")||car.getOpt().contains("��Ʈ��ķ"))){
					List<String> fieldList4 = Arrays.asList(customer_name,car_num, service_url );
					at_db.sendMessageReserve("acar0257", fieldList4, s_destphone, manager_phone, null, car_etc1, base.getBus_id2());
				}
			}
			
   		}
		
	}
	
	
	if(doc_bit.equals("d")){
		if(!d_db.deleteDocSettleLcStart(doc_no)) flag += 1;
	}				
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�뿩���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');			<%		}	%>		
<%		if(!flag2){	%>	alert('���⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
<%		if(!flag3){	%>	alert('����Ÿ���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
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
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value=''>     
  <input type='hidden' name='doc_no' 			value='<%=doc_no%>'>      
</form>
<script language='javascript'>

	var fm = document.form1;
	
	alert('��ϵǾ����ϴ�.');
				
	fm.action = '/fms2/lc_rent/lc_start_doc.jsp';
	
	<%if(doc_bit.equals("d")){%>
		fm.action = '/fms2/lc_rent/lc_start_frame.jsp';
	<%}%>
	fm.target = 'd_content';
	fm.submit();
	

</script>
</body>
</html>