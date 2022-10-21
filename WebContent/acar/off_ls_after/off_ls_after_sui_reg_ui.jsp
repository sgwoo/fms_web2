<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.offls_sui.*, acar.car_register.*, acar.car_scrap.*, acar.user_mng.*, acar.coolmsg.*, acar.common.*, acar.cont.*, acar.insur.* , acar.car_sche.*"%>
<%@ page import="java.io.*,java.text.SimpleDateFormat,java.util.Calendar"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<%

	boolean flag2 = true;
	
	int flag = 0;
		
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun");
	
	//sms��
	String destphone = request.getParameter("m_tel");
	String dest_addr = request.getParameter("des_addr");
	String firm_nm = request.getParameter("firm_nm");
				
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	String mng_id = c_db.getOff_ls_after_sui_Mng_id(car_mng_id); //���� ���Կɼ� ��� ����� �������°� �߰� 20140312 ���漱
	String sendphone = "02-392-4243";
	
	String i_result = "";
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	

	SuiBean sui = olsD.getSui(car_mng_id);
	sui.setCar_mng_id(car_mng_id);
	sui.setSui_nm(request.getParameter("sui_nm"));
	sui.setSsn(request.getParameter("ssn1")+request.getParameter("ssn2"));
	sui.setRelation(request.getParameter("relation"));
	sui.setH_tel(request.getParameter("h_tel"));
	sui.setM_tel(request.getParameter("m_tel"));
	sui.setCont_dt(request.getParameter("cont_dt"));
	sui.setH_addr(request.getParameter("h_addr"));
	sui.setH_zip(request.getParameter("h_zip"));
	sui.setD_addr(request.getParameter("d_addr"));
	sui.setD_zip(request.getParameter("d_zip"));
	sui.setCar_nm(request.getParameter("car_nm"));
	sui.setCar_relation(request.getParameter("car_relation"));
	sui.setCar_addr(request.getParameter("car_addr"));
	sui.setCar_zip(request.getParameter("car_zip"));
	sui.setCar_ssn(request.getParameter("car_ssn1")+request.getParameter("car_ssn2"));
	sui.setCar_h_tel(request.getParameter("car_h_tel"));
	sui.setCar_m_tel(request.getParameter("car_m_tel"));
	sui.setEtc(request.getParameter("etc"));
	sui.setAss_st_dt(request.getParameter("ass_st_dt"));
	sui.setAss_ed_dt(request.getParameter("ass_ed_dt"));
	sui.setAss_st_km(AddUtil.parseDigit3(request.getParameter("ass_st_km")));
	sui.setAss_ed_km(AddUtil.parseDigit3(request.getParameter("ass_ed_km")));
	sui.setAss_wrt(request.getParameter("ass_wrt"));
	sui.setMm_pr(request.getParameter("mm_pr")==null?0:AddUtil.parseDigit(request.getParameter("mm_pr")));
	sui.setCont_pr(request.getParameter("cont_pr")==null?0:AddUtil.parseDigit(request.getParameter("cont_pr")));
	sui.setJan_pr(request.getParameter("jan_pr")==null?0:AddUtil.parseDigit(request.getParameter("jan_pr")));
	sui.setModify_id(user_id);
	sui.setCont_pr_dt(request.getParameter("cont_pr_dt")==null?"":request.getParameter("cont_pr_dt"));
	sui.setJan_pr_dt(request.getParameter("jan_pr_dt")==null?"":request.getParameter("jan_pr_dt"));
	if(sui.getMigr_dt().equals("")){
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy:MM:dd-hh:mm:ss");
		String datetime1 = sdf1.format(cal.getTime());
		sui.setUdt_dt(datetime1);
	}
	String o_migr_dt = sui.getMigr_dt();
	sui.setMigr_dt(request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt"));
	String n_migr_dt = sui.getMigr_dt();
	sui.setMigr_no(request.getParameter("migr_no")==null?"":request.getParameter("migr_no"));
	String enp_no1 = request.getParameter("enp_no1")==null?"":request.getParameter("enp_no1");
	String enp_no2 = request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2");
	String enp_no3 = request.getParameter("enp_no3")==null?"":request.getParameter("enp_no3");
	sui.setEnp_no(enp_no1+enp_no2+enp_no3);
	sui.setEmail(request.getParameter("email")==null?"":request.getParameter("email"));
	sui.setClient_id(request.getParameter("client_id")==null?"":request.getParameter("client_id"));
	sui.setSui_st("1");  // ���Կɼ�
	sui.setDes_addr(request.getParameter("des_addr"));
	sui.setDes_zip(request.getParameter("des_zip"));
	sui.setDes_nm(request.getParameter("des_nm"));
	sui.setDes_tel(request.getParameter("des_tel"));
	sui.setAccid_yn(request.getParameter("accid_yn")==null?"N":request.getParameter("accid_yn"));
	sui.setSh_car_amt(AddUtil.parseDigit(request.getParameter("sh_car_amt"))); //������� �Ű��� ��� 
	
	int result = 0;
	if(gubun.equals("u")){
		result = olsD.upSui(sui);
	}else if(gubun.equals("i")){
		result = olsD.inSui(sui);
	}else if(gubun.equals("p")){
		result = olsD.upSui(sui);
		
		//��Ʈ������ȣ ������ �ѱ��-------------------------------
		
		//��������
		cr_bean = crd.getCarRegBean(car_mng_id);
		
		if(cr_bean.getCar_use().equals("1")){//cr_bean.getCar_no().length() > 8 && 
			String car_ext = c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext());
			if(sc_db.getScrapCheck(cr_bean.getCar_no())==0){			
				int result2 = sc_db.car_scrap_i(cr_bean.getCar_no(), cr_bean.getCar_nm(), AddUtil.getDate(), car_ext);
			}
		}
	}
	
	
	
	if(gubun.equals("u") || gubun.equals("p")){
		if(o_migr_dt.equals("") && !n_migr_dt.equals("")){
			//���躯���û ���ν��� ȣ��
			//String  d_flag2 =  ec_db.call_sp_ins_cng_req("�Ű� ���������� ���", "", car_mng_id, "");
			
			/*//����������Ȳ�� �ٷε�� (20171010 ������ ��û ���� �ּ�ó��) - ����� : jhChoi
				String gubun2 = "����";
				
				String ins_st = ai_db.getInsSt(car_mng_id);
				
				
				String reg_code  = Long.toString(System.currentTimeMillis());
				
				Hashtable i_ht = ai_db.getInsClsMng(car_mng_id, ins_st);
				
				InsurExcelBean ins = new InsurExcelBean();
				
				ins.setReg_code		(reg_code);
				ins.setSeq				(1);
				ins.setReg_id			(ck_acar_id);
				ins.setGubun			(gubun2);
				ins.setCar_mng_id (car_mng_id);
				ins.setIns_st	    (ins_st);
				
				ins.setValue01		(String.valueOf(i_ht.get("CAR_NO")));
				ins.setValue02		(String.valueOf(i_ht.get("INS_CON_NO")));
				ins.setValue03		(String.valueOf(i_ht.get("CAR_NM")));
				ins.setValue04		(String.valueOf(i_ht.get("MIGR_DT")));
				ins.setValue05		("����");
				ins.setValue06		(String.valueOf(i_ht.get("CAU")));
				ins.setValue07		("");
				ins.setValue08		("");
				ins.setValue09		(String.valueOf(i_ht.get("INS_COM_ID")));
				
				
				if(ins.getValue01().equals("null") && ins.getValue02().equals("null") && ins.getValue03().equals("null") && ins.getValue04().equals("null")){
					i_result = "���賻���� ���������� �������� ���߽��ϴ�.";
				}else{
					//�ߺ�üũ
					int over_cnt = ic_db.getCheckOverInsExcelCom(gubun2, "", "", "", car_mng_id, ins_st);
					if(over_cnt > 0){
						i_result = "�̹� ��ϵǾ� �ֽ��ϴ�.";
					}else{
						if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							i_result = "��Ͽ����Դϴ�.";
						}else{
							i_result = "���� ��ϵǾ����ϴ�.";
						}
					}
				}
				*/
		}
	}
	
	if(gubun.equals("i") )  {
	
			// ���Կɼ� ���� �Է��� ȸ�����ڿ��� �޼��� ����------------------------------------------------------------------------------------------
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		String sub 		= "������� ���Կɼ� ȸ�� ó�� ���";
		String cont 	= "[������ȣ:"+cr_bean.getCar_no()+"] ���Կɼ� ȸ�� ó�� �ϼ���.";	
			
		String url 		= "/fms2/cls_cont/lc_cls_off_d_frame.jsp";	 
		
					
		String target_id =  nm_db.getWorkAuthUser("����������");  //���Կɼ� ȸ�� �����		000092->000114 -> 000093 -> 000116 -> 000058 -> 000144  -> 000131		
		
	   CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);
				   
	   if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id();    // ��ü�ٹ���
						   
				
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
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
		
		flag2 = cm_db.insertCoolMsg(msg);
			
		System.out.println("��޽���(���Կɼǰ���)"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());			
				
	}
		
	
	// ���� ������ ����ڿ��Ե� ���� �޼��� ���� 
	if(gubun.equals("h") || gubun.equals("i") ){
	
	
		/*���Կɼ� ����߼۰��� ����ڿ��� �޼��� ������*/
			
		UsersBean sender_bean2 	= umd.getUsersBean(user_id);
		
		String sub2 	= "���Կɼ� ���ü��� ����߼� ";
		String cont2	= "[������ȣ:"+cr_bean.getCar_no()+"] ���Կɼ� ���ü����� ����߼��� �� �����Դϴ�.";	
			
		String url2 		= "/fms2/cls_cont/lc_cls_off_d_frame.jsp";	 
		
		String target_id2 = mng_id;  	
				
		//����� ���� ��ȸ
		UsersBean target_bean2 	= umd.getUsersBean(target_id2);
		
		String xml_data2 = "";
		xml_data2 =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub2+"</SUB>"+
	  				"    <CONT>"+cont2+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url2+"</URL>";
		
		xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		
		xml_data2 += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg2 = new CdAlertBean();
		msg2.setFlddata(xml_data2);
		msg2.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg2);
			
		System.out.println("��޽���(���Կɼǿ������)"+cr_bean.getCar_no()+"---------------------"+target_bean2.getUser_nm());	
	
			//�����߼� sms - ��
	
		String cont3	= "[������ȣ:"+cr_bean.getCar_no()+"] ���Կɼ� ���ü�����   " + dest_addr  + "�� ����߼��� �� �����Դϴ�. ";	
		String rqdate = "+0.1";
		
			
		//����� ���� ��ȸ
		UsersBean target_bean3 	= umd.getUsersBean(mng_id);
		
		if(!destphone.equals("")){ //��					
			
			
		   at_db.sendMessage(1009, "0", cont3, destphone, sendphone, null, "",  "999999");	
						
		   System.out.println("����(���Կɼǿ������)"+cr_bean.getCar_no()+"---------------------"+target_bean3.getUser_nm());			
		}
				
	}
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result > 0){
	if(gubun.equals("i")){%>
		alert("��ϵǾ����ϴ�.");
		parent.location.href = "/acar/off_ls_after/off_ls_after_sui_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	<%}else if(gubun.equals("u")   ){%>
		alert("�����Ǿ����ϴ�.");
		<%if(!i_result.equals("")){%>
			alert("<%=i_result%>");
		<%}%>		
		parent.parent.location.href = "/acar/off_ls_after/off_ls_after_sui_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";	
	<%}else if(gubun.equals("p") || gubun.equals("h") ){%>
		alert("ó���Ǿ����ϴ�.");
		<%if(!i_result.equals("")){%>
			alert("<%=i_result%>");
		<%}%>		
		parent.parent.parent.location.href = "/acar/off_ls_after/off_ls_after_opt_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	<%}%>
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	location.href = "/acar/off_ls_after/off_ls_after_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}%>
//-->
</script>
</body>
</html>
