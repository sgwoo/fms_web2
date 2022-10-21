<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	int o_fee_amt		= request.getParameter("o_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("o_fee_amt"));
	String r_fee_est_dt = request.getParameter("r_fee_est_dt")==null?"":request.getParameter("r_fee_est_dt");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	String cng_st 	= request.getParameter("cng_st")	==null?"":request.getParameter("cng_st");
	String cng_dt 	= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_s_dt = request.getParameter("cng_s_dt")	==null?"":request.getParameter("cng_s_dt");
	String cng_e_dt = request.getParameter("cng_e_dt")	==null?"":request.getParameter("cng_e_dt");
	String cng_etc 	= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	
	
	//��������
	ins = ins_db.getInsCase(c_id, ins_st);
	
	
	String doc_no 		= "";
	String ch_before 	= "";
	String ch_after 	= "";
	String reg_code  	= Long.toString(System.currentTimeMillis());
	
	//ó������
	int flag = 0;
	boolean m_flag2 = true;
	
	
	String u_chk[] 					= request.getParameterValues("u_chk");	
	String age_scp_nm[] 				= request.getParameterValues("age_scp_nm");
	String vins_gcp_kd_nm[] 			= request.getParameterValues("vins_gcp_kd_nm");
	String vins_bacdt_kd_nm[] 			= request.getParameterValues("vins_bacdt_kd_nm");
	String vins_bacdt_kc2_nm[] 			= request.getParameterValues("vins_bacdt_kc2_nm");
	//String vins_canoisr_yn_nm[] 			= request.getParameterValues("vins_canoisr_yn_nm");
	String vins_cacdt_car_amt_nm[] 			= request.getParameterValues("vins_cacdt_car_amt_nm");
	String vins_cacdt_mebase_amt_nm[] 		= request.getParameterValues("vins_cacdt_mebase_amt_nm");
	String vins_cacdt_me_amt_nm[] 			= request.getParameterValues("vins_cacdt_me_amt_nm");
	String vins_cacdt_memin_amt_nm[] 		= request.getParameterValues("vins_cacdt_memin_amt_nm");
	//String vins_spe_yn_nm[] 			= request.getParameterValues("vins_spe_yn_nm");
	String vins_con_f_nm[] 				= request.getParameterValues("vins_con_f_nm");
	String com_emp_yn_nm[] 				= request.getParameterValues("com_emp_yn_nm");
	String blackbox_yn_nm[] 			= request.getParameterValues("blackbox_yn_nm");
	String hook_yn_nm[] 				= request.getParameterValues("hook_yn_nm");
	
	out.println("�����׸��="+u_chk.length+"<br><br>");
	
	
	InsurChangeBean d_bean = new InsurChangeBean();
	d_bean.setIns_doc_no			(reg_code);
	d_bean.setCar_mng_id			(c_id);
	d_bean.setIns_st			(ins_st);
	d_bean.setCh_dt				(cng_dt);
	d_bean.setCh_etc			(cng_etc);
	d_bean.setUpdate_id			(user_id);
	d_bean.setRent_mng_id			(rent_mng_id);
	d_bean.setRent_l_cd			(rent_l_cd);
	d_bean.setRent_st			(rent_st);
	d_bean.setO_fee_amt			(o_fee_amt);
	d_bean.setN_fee_amt			(0);
	d_bean.setD_fee_amt			(0);
	d_bean.setDoc_st			("1");
	d_bean.setCh_st				(cng_st);
	d_bean.setCh_s_dt			(cng_s_dt);
	d_bean.setCh_e_dt			(cng_e_dt);
	d_bean.setR_fee_est_dt		(r_fee_est_dt);
	if(!ins_db.insertInsChangeDoc(d_bean)) flag += 1;
	
	for(int i=0;i < u_chk.length;i++){
	
		ch_before 	= "";
		ch_after 	= "";
		
		out.println("�����׸�="+u_chk[i]+"<br><br>");
		
		InsurChangeBean bean = new InsurChangeBean();
		bean.setIns_doc_no		(reg_code);
		bean.setCar_mng_id		(c_id);
		bean.setIns_st			(ins_st);
		bean.setCh_tm			(String.valueOf(i));
		bean.setCh_dt			(cng_dt);
		bean.setCh_amt			(0);
		bean.setUpdate_id		(user_id);
		bean.setRent_mng_id		(rent_mng_id);
		bean.setRent_l_cd		(rent_l_cd);
		
		//���ɹ���
		if(u_chk[i].equals("1")){
			
			ch_before 	= age_scp_nm[0];
			ch_after 	= age_scp_nm[1];
			
			bean.setCh_item			("5");//���ɺ���
			
		//�빰���
		}else if(u_chk[i].equals("2")){
			
			ch_before 	= vins_gcp_kd_nm[0];
			ch_after 	= vins_gcp_kd_nm[1];
			
			bean.setCh_item			("1");//�빰���Աݾ�
			
		//�ڱ��ü���(1�δ���/����)
		}else if(u_chk[i].equals("3")){
			
			ch_before 	= vins_bacdt_kd_nm[0];
			ch_after 	= vins_bacdt_kd_nm[1];
			
			bean.setCh_item			("2");//�ڱ��ü����Աݾ�(1�δ���/����)
			
		//�ڱ��ü���(1�δ�λ�)
		}else if(u_chk[i].equals("4")){
						
			ch_before 	= vins_bacdt_kc2_nm[0];
			ch_after 	= vins_bacdt_kc2_nm[1];
			
			bean.setCh_item			("12");//�ڱ��ü����Աݾ�(1�δ�λ�)
			
		//������������
		//}else if(u_chk[i].equals("5")){						
		//	ch_before 	= vins_canoisr_yn_nm[0];
		//	ch_after 	= vins_canoisr_yn_nm[1];			
		//	bean.setCh_item			("3");//������������Ư��
			
		//�ڱ���������
		}else if(u_chk[i].equals("6")){

			ch_before 	= vins_cacdt_car_amt_nm[0];
			ch_after 	= vins_cacdt_car_amt_nm[1];
			
			bean.setCh_item			("4");//�ڱ��������ذ��Աݾ�
			
		//�ڱ��������� �ڱ�δ��
		}else if(u_chk[i].equals("7")){
			
			ch_before 	= vins_cacdt_mebase_amt_nm[0]+"/"+vins_cacdt_me_amt_nm[0]+"/"+vins_cacdt_memin_amt_nm[0];
			ch_after 	= vins_cacdt_mebase_amt_nm[1]+"/"+vins_cacdt_me_amt_nm[1]+"/"+vins_cacdt_memin_amt_nm[1];
			
			bean.setCh_item			("9");//�ڱ����������ڱ�δ��
			
		//����⵿ Ư��
		//}else if(u_chk[i].equals("8")){			
		//	ch_before 	= vins_spe_yn_nm[0];
		//	ch_after 	= vins_spe_yn_nm[1];			
		//	bean.setCh_item			("6");//�ִ�īƯ��
			
		//��������������Ư��
		}else if(u_chk[i].equals("9")){
					
			ch_before 	= com_emp_yn_nm[0];
			ch_after 	= com_emp_yn_nm[1];
			
			bean.setCh_item			("14");//��������������Ư��
			
		//�Ǻ����ں���
		}else if(u_chk[i].equals("10")){
			
			ch_before 	= vins_con_f_nm[0];
			ch_after 	= vins_con_f_nm[1];
			
			bean.setCh_item			("15");//�Ǻ����ں���
			
		//���谻��
		}else if(u_chk[i].equals("11")){
			String vins_renew 		= request.getParameter("vins_renew")==null?"":request.getParameter("vins_renew");
			
			ch_before 	= "";
			ch_after 	= vins_renew;
			
			bean.setCh_item			("16");//���谻��
			
		//��Ÿ
		}else if(u_chk[i].equals("12")){
			String vins_etc 		= request.getParameter("vins_etc")==null?"":request.getParameter("vins_etc");
			
			ch_before 	= "";
			ch_after 	= vins_etc;
			
			bean.setCh_item			("13");//��Ÿ

		//���ڽ�
		}else if(u_chk[i].equals("13")){
		
			ch_before 	= blackbox_yn_nm[0];
			ch_after 	= blackbox_yn_nm[1];
			
			bean.setCh_item			("17");//���ڽ�

		//���ΰ�
		}else if(u_chk[i].equals("14")){
			
			ch_before 	= hook_yn_nm[0];
			ch_after 	= hook_yn_nm[1];
			
			bean.setCh_item			("18");//���ΰ�

			
		}
		
		
		
		bean.setCh_before		(ch_before);
		bean.setCh_after		(ch_after);
		
		
		
		if(!ins_db.insertInsChangeDocList(bean)) flag += 1;
		
		
		
	}
	
	
	//���躯�渮��Ʈ
	Vector ins_cha = ins_db.getInsChangeDocList(reg_code);
	int ins_cha_size = ins_cha.size();
	
	if(ins_cha_size >0){
	
		int flag1 = 0;
		int flag2 = 0;
		int flag3 = 0;
		int flag4 = 0;
		boolean flag6 = true;
		boolean flag7 = true;
		int count1 = 0;
		int count2 = 0;
		int count3 = 0;
		
		
		//�����
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		
		//�������
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		
		String sub 	= "��������� �����û���� ǰ��";
		String cont 	= "["+firm_nm+"] ���躯�湮���� ����Ͽ����� ����ٶ��ϴ�.";
		
		String user_id3 = nm_db.getWorkAuthUser("�λ꺸����");
		String user_id2 = nm_db.getWorkAuthUser("���翵��������"); //20140415 �������� ���� ����
		
		String user_id4 = nm_db.getWorkAuthUser("���ݰ�꼭�����"); //20151112 �����ٴ���� �߰�
		
		
		
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(user_id4);
		
		if(!cs_bean2.getWork_id().equals("")) user_id2 = cs_bean2.getWork_id();
		if(!cs_bean3.getWork_id().equals("")) user_id3 = cs_bean3.getWork_id();
		if(!cs_bean4.getWork_id().equals("")) user_id4 = cs_bean4.getWork_id();
		
		//����,�λ꺸������ ��� �ް��϶�
		cs_bean3 = csd.getCarScheTodayBean(user_id3);
		if(!cs_bean3.getWork_id().equals("")) user_id3 = cs_bean3.getWork_id();
		
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st	("47");
		doc.setDoc_id	(reg_code);
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	(cng_etc);
		doc.setUser_nm1	("�����");
		doc.setUser_nm2	("��������");
		//doc.setUser_nm3("��������");
		doc.setUser_nm3	("��������");
		doc.setUser_nm4	("�����ٴ����");
		doc.setUser_nm5	("");
		doc.setUser_id1	(user_id);
		doc.setUser_id2	(user_id2);
		doc.setUser_id3	(user_id3);
		doc.setUser_id4	(user_id4);
		doc.setDoc_bit	("0");
		doc.setDoc_step	("0");//���
		
		if(cng_st.equals("2")){
			doc.setDoc_step	("3");//����
		}
		
		//=====[doc_settle] insert=====
		flag6 = d_db.insertDocSettle2(doc);
		
		doc = d_db.getDocSettleCommi("47", reg_code);
		
		doc_no = doc.getDoc_no();
		
		
		
		//�ݿ��� ��� �������ڿ��� �޽����� ������..
		if(cng_st.equals("1")){
		
			//��޽��� �˶� ���----------------------------------------------------------------------------------------
			
			
			String car_no		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
			sub 			= "��������� �����û���� ���";
			cont 			= "["+firm_nm+" "+car_no+"] ���躯�湮���� �ݿ����� ��ϵǾ����ϴ�. Ȯ���Ͽ��ֽʽÿ�.";
			String target_id 	= user_id2;
			String url 		= "/fms2/insure/ins_doc_frame.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|c_id="+c_id+"|ins_st="+ins_st+"|ins_doc_no="+reg_code;
			String m_url = "/fms2/insure/ins_doc_frame.jsp";
			
			
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
			
			//m_flag2 = cm_db.insertCoolMsg(msg);
			System.out.println("��޽���(���躯�湮������)"+car_no+"-----------------------"+target_bean.getUser_nm());
		
		}
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 				value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">   
  <input type='hidden' name="car_mng_id"		value="<%=c_id%>">
  <input type='hidden' name="c_id" 					value="<%=c_id%>">
  <input type='hidden' name="ins_st"				value="<%=ins_st%>">
  <input type="hidden" name="doc_no" 				value="<%=doc_no%>">     
  <input type="hidden" name="ins_doc_no" 		value="<%=reg_code%>">     
  <input type="hidden" name="from_page" 		value="/fms2/insure/ins_doc_reg_c_a.jsp">
    
</form>
<script language='javascript'>
<%	if(flag > 0){%>

		alert("������� �ʾҽ��ϴ�");
		
<%	}else{%>	


		<%if(cng_st.equals("2")){//����%>	
		alert("��ϵǾ����ϴ�");
		<%}else{//�ݿ�%>
		alert("��ϵǾ����ϴ�\n\n���躯���û���� ���躯�湮���������� �ش� ����� ������ �˾�â���� ���� �ֽ��ϴ�. ���� ������ �ѽ��� �߼��Ͻʽÿ�.\n\n���� �� �ΰ� ���ε� ���� �޾� ���� ��Ƚ� ��ĵ�Ͽ� ����Ͽ� �ּ���.");
		<%}%>
		
		var fm = document.form1;
		fm.target='d_content';
		fm.action='ins_doc_u.jsp';		
		fm.submit();	
		
<%	}%>
</script>
</body>
</html>