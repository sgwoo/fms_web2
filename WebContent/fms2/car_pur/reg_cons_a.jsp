<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.consignment.*, acar.client.*, acar.car_office.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String rent_mng_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
			
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(base.getBus_id());
	
	
	//�������
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
%>


<%
	
	//������� car_pur--------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	String o_udt_st = pur.getUdt_st();
	
	String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
	String dlv_est_h 	= request.getParameter("dlv_est_h")==null?"":request.getParameter("dlv_est_h");
	
	pur.setRpt_no		(request.getParameter("rpt_no")		==null?"":request.getParameter("rpt_no"));
	pur.setDlv_est_dt	(dlv_est_dt+dlv_est_h);
	pur.setDlv_ext		(request.getParameter("dlv_ext")	==null?"":request.getParameter("dlv_ext"));
	pur.setUdt_st		(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
	pur.setCons_st		(request.getParameter("cons_st")	==null?"":request.getParameter("cons_st"));
	pur.setOff_id		(request.getParameter("off_id")		==null?"":request.getParameter("off_id"));
	pur.setOff_nm		(request.getParameter("off_nm")		==null?"":request.getParameter("off_nm"));
	pur.setCons_amt1	(request.getParameter("cons_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	
	
	String n_udt_st = pur.getUdt_st();
	
	String o_udt_st_nm = c_db.getNameByIdCode("0035", "", o_udt_st);
	String n_udt_st_nm = c_db.getNameByIdCode("0035", "", n_udt_st);
	
	//�����μ��� ����� ��ຯ��������� �޽��� �߼�
	if(!o_udt_st.equals("") && !o_udt_st.equals(n_udt_st)){
		if(base.getUse_yn().equals("Y")){
			
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			//String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub2 		= "����� �����μ��� ����";
			String cont2 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ]  &lt;br&gt; &lt;br&gt; ������� �����μ����� ("+o_udt_st_nm+" -> "+n_udt_st_nm+") �����Ͽ����ϴ�.  &lt;br&gt; &lt;br&gt; Ȯ�ιٶ��ϴ�.";
			String target_id2 = nm_db.getWorkAuthUser("��ຯ�����");//20130128 ����������->�߰������м��� ����  20131205 �߰������м���->��ຯ�����
			
			
			CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id2);
			if(!cs_bean7.getUser_id().equals("")){
				if(cs_bean7.getTitle().equals("��������")){
					//��Ͻð��� ����(12����)�̶�� ��ü��, �ƴϸ� ����
					target_id2 = nm_db.getWorkAuthUser("��������������");
				}else if(cs_bean7.getTitle().equals("���Ĺ���")){
					//��Ͻð��� ����(12������)��� ��ü��, �ƴϸ� ����
					target_id2 = nm_db.getWorkAuthUser("��������������");
				}else{//����
					target_id2 = nm_db.getWorkAuthUser("��������������");
				}
			}
			
			//����� ���� ��ȸ
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
		  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			flag5 = cm_db.insertCoolMsg(msg2);
			System.out.println("��޽���("+rent_l_cd+" "+request.getParameter("firm_nm")+" [������ݱ�ȵ��] ��� �����μ��� ����)-----------------------"+target_bean2.getUser_nm());
			
			
		}
	}	
	
	
	//���� ���Ź�� ����� �ִ��� Ȯ��
	ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
	

  		
	cons.setUdt_mng_id		(request.getParameter("udt_mng_id")	==null?"":request.getParameter("udt_mng_id"));
	cons.setUdt_mng_nm		(request.getParameter("udt_mng_nm")	==null?"":request.getParameter("udt_mng_nm"));
	cons.setUdt_mng_tel		(request.getParameter("udt_mng_tel")	==null?"":request.getParameter("udt_mng_tel"));
	cons.setUdt_firm			(request.getParameter("udt_firm")	==null?"":request.getParameter("udt_firm"));
	cons.setUdt_addr			(request.getParameter("udt_addr")	==null?"":request.getParameter("udt_addr"));
	
	

	if(pur.getOff_id().equals("009771")){
		cons.setDriver_nm	(request.getParameter("driver_nm")	==null?"":request.getParameter("driver_nm"));	
		cons.setDriver_m_tel	(request.getParameter("driver_m_tel")	==null?"":request.getParameter("driver_m_tel"));		
		cons.setDriver_ssn	(request.getParameter("driver_ssn")	==null?"":request.getParameter("driver_ssn"));		
	}
	
	if(!o_udt_st.equals(n_udt_st) && !o_udt_st_nm.equals(n_udt_st_nm)){
	
		CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, String.valueOf(pur_com.get("COM_CON_NO")));
		
		if(!cpd_bean.getCom_con_no().equals("")){// && !cpd_bean.getUdt_st().equals(n_udt_st)
		  String o_udt_firm = cpd_bean.getUdt_firm(); 
			cpd_bean.setUdt_st			(n_udt_st);	
			cpd_bean.setUdt_firm		(request.getParameter("udt_firm")	==null?"":request.getParameter("udt_firm"));	
			cpd_bean.setUdt_addr		(request.getParameter("udt_addr")	==null?"":request.getParameter("udt_addr"));		
			cpd_bean.setUdt_mng_id	(request.getParameter("udt_mng_id")	==null?"":request.getParameter("udt_mng_id"));	
			cpd_bean.setUdt_mng_nm	(request.getParameter("udt_mng_nm")	==null?"":request.getParameter("udt_mng_nm"));	
			cpd_bean.setUdt_mng_tel	(request.getParameter("udt_mng_tel")	==null?"":request.getParameter("udt_mng_tel"));	
			flag1 = cod.updateCarPurCom(cpd_bean);
			
			int cng_next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, cpd_bean.getCom_con_no());

			CarPurDocListBean cng_bean = new CarPurDocListBean();
			cng_bean.setRent_mng_id	(rent_mng_id);
			cng_bean.setRent_l_cd		(rent_l_cd);
			cng_bean.setCom_con_no	(cpd_bean.getCom_con_no());
			cng_bean.setSeq					(cng_next_seq);
			cng_bean.setCng_st			("1");	
			cng_bean.setCng_cont		("�����");	
			cng_bean.setBigo				(o_udt_st_nm+"->"+n_udt_st_nm);	
			cng_bean.setReg_id			(ck_acar_id);
			flag1 = cod.insertCarPurComCng(cng_bean);
		}
	}
				
	//�ű��Է��̸�
	if(cons.getRent_l_cd().equals("")){
	
	
		//Ź���Ƿڵ��
	
		String cons_no	 	= "";		
	
		cons.setRent_mng_id		(rent_mng_id);
		cons.setRent_l_cd		(rent_l_cd);
		cons.setReq_id			(base.getBus_id());
		cons.setReg_id			(ck_acar_id);
			
		
		//=====[consignment] insert=====
		cons_no = cs_db.insertConsignmentPur(cons);	
	
		if(cons_no.equals("")){
			result++;
		}	
		
		//�����Ǹ��� 03900 �� �ƴϸ� Ȯ�� �޽��� �߼� (Ź�۾�ü)
		if(!emp2.getCar_off_id().equals("03900")){
		
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			
			String sub2 	= "������-���Ź��Ȯ��";
			String cont2 	= "["+pur.getRpt_no()+"] ��������� ���Ź�� Ȯ���մϴ�.";
			String url2 	= "/fms2/cons_pur/consp_mng_frame.jsp";
			String m_url  = "/fms2/cons_pur/consp_mng_frame.jsp";
			
			
			//����� ���� ��ȸ
			UsersBean target_bean3 	=  new UsersBean();
			
			String target_id3 = "";
			
			if(pur.getOff_id().equals("007751")){
				target_id3 = "000187";
			}
			if(pur.getOff_id().equals("009026")){
				target_id3 = "000222";
			}
			if(pur.getOff_id().equals("009771")){
				target_id3 = "000240";
			}
			if(pur.getOff_id().equals("011372")){
				target_id3 = "000308";
			}
			
			if(!target_id3.equals("")){
			
				target_bean3 	= umd.getUsersBean(target_id3);
			
				String xml_data2 = "";
				xml_data2 =  "<COOLMSG>"+
  					"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub2+"</SUB>"+
  					"    <CONT>"+cont2+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url2+"&m_url="+m_url+"</URL>";
	
				xml_data2 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		
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
	
				flag2 = cm_db.insertCoolMsg(msg2);	
								
			}
			
			
			cons.setCons_no			(cons_no);
			cons.setSettle_id		(ck_acar_id);	
			boolean cons_flag = cs_db.updateConsignmentPurSettle(cons);
		
		}
		
		
	}else{
	
	

			
		//=====[CONS_PUR] update=====
		flag4 = cs_db.updateConsignmentPur(cons);
	
		
		//�����Ǹ��� 03900 �� �ƴϸ� Ȯ�� �޽��� �߼� (Ź�۾�ü)
		if(!emp2.getCar_off_id().equals("03900") && cons.getSettle_id().equals("")){
		
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			
			String sub2 	= "������-���Ź��Ȯ��";
			String cont2 	= "["+pur.getRpt_no()+"] ��������� ���Ź�� Ȯ���մϴ�.";
			String url2 	= "/fms2/cons_pur/consp_mng_frame.jsp";
			String m_url 	= "/fms2/cons_pur/consp_mng_frame.jsp";
			
			//����� ���� ��ȸ
			UsersBean target_bean3 	=  new UsersBean();
			
			String target_id3 = "";
			
			if(pur.getOff_id().equals("007751")){
				target_id3 = "000187";
			}
			if(pur.getOff_id().equals("009026")){
				target_id3 = "000222";
			}
			if(pur.getOff_id().equals("009771")){
				target_id3 = "000240";
			}
			if(pur.getOff_id().equals("011372")){
				target_id3 = "000308";
			}
			
			if(!target_id3.equals("")){
			
				target_bean3 	= umd.getUsersBean(target_id3);
			
				String xml_data2 = "";
				xml_data2 =  "<COOLMSG>"+
  					"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub2+"</SUB>"+
  					"    <CONT>"+cont2+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url2+"&m_url="+m_url+"</URL>";
	
				xml_data2 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		
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
	
				flag2 = cm_db.insertCoolMsg(msg2);	
								
			}
			
			cons.setSettle_id		(ck_acar_id);	
			
			boolean cons_flag = cs_db.updateConsignmentPurSettle(cons);
					
		}
		
		
		
		if(!o_udt_st.equals(n_udt_st)){		
			ConsignmentBean cng_bean = new ConsignmentBean();
		
			int next_seq = cs_db.getConsPurCngNextSeq(cons.getCons_no());
		
			cng_bean.setCons_no		(cons.getCons_no());
			cng_bean.setSeq			(next_seq);			
			cng_bean.setCng_st		("1");			
			cng_bean.setReg_id		(ck_acar_id);
			
			//=====[CONS_PUR_CNT] insert=====				
			flag1 = cs_db.insertConsignmentPurCng(cng_bean);
			
			
			if(!flag4){
				result++;			
			}				
			
			
		}	
	}	
	
		
%>
<script language='javascript'>


<%	if(result>0){%>
		alert("ó������ �ʾҽ��ϴ�");
		location='about:blank';		
<%	}else{		%>		
		alert("ó���Ǿ����ϴ�");
		parent.window.close();
		parent.opener.location.reload();
<%	}			%>
</script>