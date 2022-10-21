<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.ext.*, acar.user_mng.*, acar.car_office.*, acar.coolmsg.*, acar.car_sche.*, acar.client.*, acar.car_mst.*, acar.estimate_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	String o_rent_mng_id= request.getParameter("o_rent_mng_id")==null?"":request.getParameter("o_rent_mng_id");
	String o_rent_l_cd 	= request.getParameter("o_rent_l_cd")==null?"":request.getParameter("o_rent_l_cd");	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cng_size 	= request.getParameter("cng_size")==null?"":request.getParameter("cng_size");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	int count = 0;
	int result = 0;
	
	String msg_yn = "N"; 
	String target2_yn = "N"; 
		
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();	
	
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
			
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	//��������
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");	
	
	
	
	
	UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
	UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("��������"));
	UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("���������"));

	
	
	//��������		
	CarPurDocListBean cpd_bean = cod.getCarPurCom(o_rent_mng_id, o_rent_l_cd, com_con_no);
	

%>


<%

	//Ư�ǰ���ȣ �ߺ�üũ
	count = cod.checkComConNo(com_con_no);	
	
	if(count == 0){

		cpd_bean.setRent_mng_id	(rent_mng_id);
		cpd_bean.setRent_l_cd		(rent_l_cd);
		cpd_bean.setReg_id			(user_id);
		cpd_bean.setUse_yn			("Y");
		cpd_bean.setOrder_req_id("");
		cpd_bean.setOrder_chk_id("");
		
		flag1 = cod.insertCarPurCom2(cpd_bean);
		

		if(cpd_bean.getCar_comp_id().equals("0001") && client.getClient_st().equals("1") && !pur.getPur_com_firm().equals(client.getFirm_nm())){
			pur.setPur_com_firm(client.getFirm_nm());	
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}		
		
		CarPurDocListBean o_cpd_bean = cod.getCarPurCom(o_rent_mng_id, o_rent_l_cd, com_con_no);
		o_cpd_bean.setSuc_yn		("Y");
		flag2 = cod.updateCarPurCom(o_cpd_bean);
		
		//������
		Vector vt = cod.getCarPurComCngs(o_rent_mng_id, o_rent_l_cd, com_con_no);
		int vt_size = vt.size();
		int cng_seq = 0;
		
		for(int i = 0 ; i < vt_size ; i++){
    		Hashtable ht = (Hashtable)vt.elementAt(i);
    		if(String.valueOf(ht.get("CNG_ST")).equals("2")){
    			if(String.valueOf(ht.get("CNG_DT")).equals("")){
    				//���������Ȳ���ΰ��� ������Ϻ� �ݿ�ó��
					CarPurDocListBean cng_bean2 = cod.getCarPurComCng(o_rent_mng_id, o_rent_l_cd, com_con_no, String.valueOf(ht.get("SEQ")));
					cng_bean2.setCng_id		(user_id);
					flag1 = cod.updateCarPurComCngAct(cng_bean2);	
    			}
    		}else{
    			//�����൵ �ѱ��(������ ������ ��� �����)
    			cng_seq++;
    			CarPurDocListBean cng_bean2 = new CarPurDocListBean();
    			cng_bean2.setRent_mng_id	(rent_mng_id);
    			cng_bean2.setRent_l_cd		(rent_l_cd);
    			cng_bean2.setCom_con_no		(com_con_no);
    			cng_bean2.setSeq			(cng_seq);
    			cng_bean2.setCng_st			(String.valueOf(ht.get("CNG_ST")));	
    			cng_bean2.setCng_cont		(String.valueOf(ht.get("CNG_CONT")));	
    			cng_bean2.setCar_nm			(String.valueOf(ht.get("CAR_NM")));	
    			cng_bean2.setOpt			(String.valueOf(ht.get("OPT")));	
    			cng_bean2.setColo			(String.valueOf(ht.get("COLO")));	
    			cng_bean2.setPurc_gu		(String.valueOf(ht.get("PURC_GU")));	
    			cng_bean2.setAuto			(String.valueOf(ht.get("AUTO")));		
    			cng_bean2.setCar_c_amt		(AddUtil.parseDigit(String.valueOf(ht.get("CAR_C_AMT"))));	
    			cng_bean2.setCar_f_amt		(AddUtil.parseDigit(String.valueOf(ht.get("CAR_F_AMT"))));
    			cng_bean2.setDc_amt			(AddUtil.parseDigit(String.valueOf(ht.get("DC_AMT"))));
    			cng_bean2.setAdd_dc_amt		(AddUtil.parseDigit(String.valueOf(ht.get("ADD_DC_AMT"))));
    			cng_bean2.setCar_d_amt		(AddUtil.parseDigit(String.valueOf(ht.get("CAR_D_AMT"))));
    			cng_bean2.setCar_g_amt		(AddUtil.parseDigit(String.valueOf(ht.get("CAR_G_AMT"))));		
    			cng_bean2.setReg_id			(String.valueOf(ht.get("REG_ID")));
    			cng_bean2.setReg_dt			(String.valueOf(ht.get("REG_DT2")));
    			cng_bean2.setCng_id			(String.valueOf(ht.get("CNG_ID")));
    			cng_bean2.setCng_dt			(String.valueOf(ht.get("CNG_DT2")));
    			cng_bean2.setCng_yn			(String.valueOf(ht.get("CNG_YN")));
    			cng_bean2.setReq_dt			(String.valueOf(ht.get("PUR_REQ_DT")));
    			cng_bean2.setBigo			(String.valueOf(ht.get("BIGO")));
    			flag1 = cod.insertCarPurComCng2(cng_bean2);	
    		}
    	}		
		
		CarPurDocListBean cng_bean = new CarPurDocListBean();
		
		int next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, com_con_no);
		
		cng_bean.setRent_mng_id	(rent_mng_id);
		cng_bean.setRent_l_cd		(rent_l_cd);
		cng_bean.setCom_con_no	(com_con_no);
		cng_bean.setSeq					(next_seq);
		cng_bean.setCng_st			("5");	
		cng_bean.setCng_cont		("��� ����");	
		cng_bean.setReg_id			(user_id);
									
		flag3 = cod.insertCarPurComCng(cng_bean);		
		
		result = shDb.sucRes_3cng(com_con_no, seq);
		
		
		//��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
		String sub 	= "������� ����ȣ���";
		String cont 	= "[ "+rent_l_cd+" "+client.getFirm_nm()+" ] ���������Ȳ���� ��࿬���Ǿ� ������� ����ȣ("+cpd_bean.getCom_con_no()+")�� ��ϵǾ����ϴ�.";
		String url 	= "/fms2/pur_com/lc_rent_c.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|com_con_no="+cpd_bean.getCom_con_no();
		String m_url = "/fms2/pur_com/lc_rent_frame.jsp'";
		
		if(cpd_bean.getDlv_st().equals("2")){
			sub 	= "������� ����ȣ��� & �ڵ�����ǰ ������";
			cont 	= "���������Ȳ���� ��࿬�� [ "+rent_l_cd+" "+client.getFirm_nm()+" ] ("+cpd_bean.getCom_con_no()+") ������ ("+cpd_bean.getDlv_con_dt()+") ";
		}else{
			if(cpd_bean.getDlv_st().equals("1") && !cpd_bean.getDlv_est_dt().equals("")){
				sub 	= "������� ����ȣ��� & �ڵ�����ǰ �����";
				cont 	= "���������Ȳ���� ��࿬�� [ "+rent_l_cd+" "+client.getFirm_nm()+" ] ("+cpd_bean.getCom_con_no()+") ����� ("+cpd_bean.getDlv_est_dt()+") ";
			}
		}
						
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
				"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	  				
		
		if(!user_id.equals(target_bean.getUser_id())){
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		}
		
		//���� �������� ���������ô����(������)���� �޽��� �߼�
		if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
			xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		}		
		//���� �������� ���������ô����(������)���� �޽��� �߼�
		if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
			xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		}		
		
		xml_data += "    <SENDER></SENDER>"+
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
		System.out.println("��޽���(�������)"+cont+"-----------------------"+target_bean.getUser_nm());
		
		
		//������ڿ��� ���ڹ߼�
		if(!user_id.equals(target_bean.getUser_id())){
		
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			String sendphone 	= sender_bean.getUser_m_tel();
			String sendname 	= "(��)�Ƹ���ī "+sender_bean.getUser_nm();
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			String msg_cont		= cont;
			
			//������Ʈ ���Ƿ������� ��û
			if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
				destname 	= a_coe_bean.getEmp_nm();
				destphone = a_coe_bean.getEmp_m_tel();
			}
			
			
			at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
		}
		
		//�ֹ���Ȯ�θ޽��� �߼�
		if(!user_id.equals(target_bean.getUser_id()) && cpd_bean.getOrder_car().equals("Y")){
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			String sendphone 	= sender_bean.getUser_m_tel();
			String sendname 	= "(��)�Ƹ���ī "+sender_bean.getUser_nm();
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			String msg_cont		= "";
			
			msg_cont 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] ("+cpd_bean.getCom_con_no()+") �ֹ����Դϴ�. �ٽ� �� �� Ȯ�ο�û �ٶ��ϴ�. Ȯ���� ���¾�ü����-��ü������-������Ȳ �������������� [��Ȯ��ó��]�� Ŭ���Ͻʽÿ�.";
			
			//������Ʈ ���Ƿ������� ��û
			if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
				destname 	= a_coe_bean.getEmp_nm();
				destphone = a_coe_bean.getEmp_m_tel();
			}
			
			
			at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
		}
				
	}	


%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('������� ó�� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%}%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
  <input type='hidden' name='rent_mng_id'  value='<%=rent_mng_id%>'>  
  <input type='hidden' name='rent_l_cd'	   value='<%=rent_l_cd%>'> 
  <input type='hidden' name="com_con_no"   value="<%=com_con_no%>">  
</form>
<script language='javascript'>
	<%if(flag1){%>
	alert('ó���Ǿ����ϴ�.');
	<%}%>
	<%if(cng_item.equals("cng_act") || cng_item.equals("cls_act") || cng_item.equals("re_act")){%>
	<%}else{%>
	parent.self.close();
	<%}%>	
	var fm = document.form1;	
	fm.action = 'lc_rent_c.jsp';
	fm.target = 'd_content';
	fm.submit();
	
</script>
</body>
</html>