<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.im_email.*, tax.*, acar.cont.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list 	= request.getParameter("f_list")==null?"scd":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_yn 	= request.getParameter("reg_yn")==null?"":request.getParameter("reg_yn");
	String gubun	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	String cls_chk 	= request.getParameter("cls_chk")==null?"N":request.getParameter("cls_chk");
	String mail_st 	= request.getParameter("mail_st")==null?"":request.getParameter("mail_st");
	
	String con_agnt_nm 	= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String firm_nm2		= request.getParameter("firm_nm2")==null?"":request.getParameter("firm_nm2");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String sendname = "(��)�Ƹ���ī";
	String sendphone = "02-392-4243";
	
	String rst = request.getParameter("rst")==null?"all":request.getParameter("rst");	// 2018.04.25
	String fee_count = request.getParameter("fee_count")==null?"1":request.getParameter("fee_count");		// 2018.04.25
	
	
	
	int flag = 0;
	
	
	//[5�ܰ�] �������Ϸ� �߼� : d-mail ����

	if(!con_agnt_email.equals("")){
	
		//	1. d-mail ���-------------------------------
		
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject			(firm_nm+"��, (��)�Ƹ���ī ���� ���� �ȳ����Դϴ�."); //���뿩 �̿� �ȳ���
		d_bean.setSql				("SSV:"+con_agnt_email.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
		d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
		d_bean.setReplyto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
		d_bean.setErrosto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(l_cd+"scd_fee");
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin����
		d_bean.setG_idx				(1);//admin����
		d_bean.setMsgflag     		(0);
//		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/rent/scd_fee.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st);
		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st);
		
		if(mail_st.equals("scd_fee_print")){
			d_bean.setSubject		(firm_nm+"��, (��)�Ƹ���ī ���뿩 ������ �ȳ����Դϴ�.");
			d_bean.setGubun			(l_cd+"scd_info");
			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&b_dt="+b_dt+"&mode="+mode+"&bill_yn="+bill_yn+"&cls_chk="+cls_chk+"&reg_id="+ck_acar_id+"&rst="+rst+"&fee_count="+fee_count);
//			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&b_dt="+b_dt+"&mode="+mode+"&bill_yn="+bill_yn+"&cls_chk="+cls_chk+"&reg_id="+ck_acar_id);
		}
		
		if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
		
		
		
		//20140210 �����ڵ��� ������� �ȳ����� �߼�
		if(!mail_st.equals("scd_fee_print") && car_comp_id.equals("0001")){
			
			d_bean.setSubject			(firm_nm+"��, �����ڵ��� ����������� ���� �ȳ����Դϴ�. (��)�Ƹ���ī");
			d_bean.setGubun				(l_cd+"bluemem");
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/etc/bluemem.html");
			if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
						
		}
		
		
		
		//��������� ���� ����� ��� ��FMS�ȳ��� ���� �߼�
		/*
		if(emp1.getEmp_id().equals("")){
			
			//	1. d-mail ���-------------------------------
			
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(firm_nm+"��, (��)�Ƹ���ī ���� ���� �ȳ����Դϴ�.");//��FMS �̿� �ȳ���
			d_bean.setSql				("SSV:"+con_agnt_email);
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
			d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email+">");
			d_bean.setReplyto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
			d_bean.setErrosto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				(l_cd+"fms_info");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin����
			d_bean.setG_idx				(1);//admin����
			d_bean.setMsgflag     		(0);
//			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/fms/fms_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st);
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st);
			if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
			
		}
		*/
	}
	
	/*
	if(!mail_st.equals("scd_fee_print")){
		
		//���뿩�̿�ȳ��� �߼��� 7�� ����ߴµ� ��FMS�ȳ����� ������ �߼۵��� ���� ��� �̸��� �߼��Ѵ�.->���ν���
		Vector m_vt =  ImEmailDb.getFmsInfoMailNotSendList();
		int m_vt_size = m_vt.size();
		
		if(m_vt_size > 0){
			
			//System.out.println("* ��FMS�ȳ��� �߼� : "+m_vt_size);
			
			
			for(int i = 0 ; i < m_vt_size ; i++){
				Hashtable ht = (Hashtable)m_vt.elementAt(i);
				
				
				//�ߺ�üũ�ؼ� �ѹ��� ������
				int mail_cnt_cnt  =  ImEmailDb.getFmsInfoMailNotSendChkList("fms_info", String.valueOf(ht.get("SUBJECT")), String.valueOf(ht.get("SQL")));
				
				if(mail_cnt_cnt>0) continue;
				
				
				//	1. d-mail ���-------------------------------
				
				DmailBean d_bean2 = new DmailBean();
				d_bean2.setSubject			(String.valueOf(ht.get("SUBJECT")));
				d_bean2.setSql				(String.valueOf(ht.get("SQL")));
				d_bean2.setReject_slist_idx	(0);
				d_bean2.setBlock_group_idx	(0);
				d_bean2.setMailfrom			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
				d_bean2.setMailto			("\""+String.valueOf(ht.get("FIRM_NM"))+"\"<"+String.valueOf(ht.get("MAIL"))+">");
				d_bean2.setReplyto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
				d_bean2.setErrosto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
				d_bean2.setHtml				(1);
				d_bean2.setEncoding			(0);
				d_bean2.setCharset			("euc-kr");
				d_bean2.setDuration_set		(1);
				d_bean2.setClick_set		(0);
				d_bean2.setSite_set			(0);
				d_bean2.setAtc_set			(0);
				d_bean2.setGubun			(String.valueOf(ht.get("GUBUN")));
				d_bean2.setRname			("mail");
				d_bean2.setMtype       		(0);
				d_bean2.setU_idx       		(1);//admin����
				d_bean2.setG_idx			(1);//admin����
				d_bean2.setMsgflag     		(0);
				d_bean2.setContent			("http://fms1.amazoncar.co.kr/mailing/fms/fms_info.jsp?m_id="+String.valueOf(ht.get("RENT_MNG_ID"))+"&l_cd="+String.valueOf(ht.get("RENT_L_CD"))+"&rent_st=1");
//				d_bean2.setContent			("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+String.valueOf(ht.get("RENT_MNG_ID"))+"&l_cd="+String.valueOf(ht.get("RENT_L_CD"))+"&rent_st=1");
				if(!ImEmailDb.insertDEmail(d_bean2, "4", "", "+7")) flag += 1;
			}
		}
	}
	*/
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='reg_yn' value='<%=reg_yn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
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
  
<a href="javascript:go_step()"></a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("�̸��� �߼� ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("�̸��ϸ� �߼��Ͽ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
