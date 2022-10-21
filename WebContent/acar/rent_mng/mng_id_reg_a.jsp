<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*,acar.memo.*, acar.fee.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	String ment = request.getParameter("ment")==null?"":request.getParameter("ment");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String list_from_page = request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
	

		

	
	boolean flag3 = true;
	int count = 1;
	int count_cust = 0;
	int count2 = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�뿩����
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");
	

	//�������� ����
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	rc_bean.setMng_id(mng_id);	
	count = rs_db.updateRentCont(rc_bean);
		

	
	//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
		
		
	String memo_title 	= "";
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
	String c_cust_nm 	= request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm");
	
	
		
	memo_title = "����Ʈ ��������� ���� - "+car_no+" "+c_firm_nm+" "+c_cust_nm;// "+AddUtil.getTimeHMS()
	
			
	String sub 	= "����Ʈ ��������� ���� �뺸";
	String cont 	= memo_title;
	String target_id = mng_id;
		
				
	//����� ���� ��ȸ
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
 					"    <BACKIMG>4</BACKIMG>"+
 					"    <MSGTYPE>104</MSGTYPE>"+
 					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL></URL>";
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
		
	flag3 = cm_db.insertCoolMsg(msg);		
	System.out.println("��޽���("+memo_title+")-----------------------"+target_bean.getUser_nm());		
		
		
		
	//������ ����ں��� �ȳ����ڹ߼�
		
	String sms_reg 		= request.getParameter("sms_reg")==null?"":request.getParameter("sms_reg");
	
	String s_destphone 	= rm_bean4.getEtc();					
	String s_destname 	= rc_bean2.getCust_nm();
	
	//���� �޴�����ȣ�� ������ �߰������ڿ��� �߼�	
	if(s_destphone.equals("")){
		s_destphone = rm_bean1.getTel();
	}
	
	
			
	String cont_sms 	= "[����Ʈ] "+String.valueOf(reserv.get("CAR_NO")) + " ���������(���ó��,����,��࿬��,�ݳ� ���)�� " + target_bean.getUser_nm() + " ("+ target_bean.getUser_m_tel() + ") �Դϴ�. (��)�Ƹ���ī"; 
			
	int i_msglen = AddUtil.lengthb(cont_sms);
		
	String msg_type = "0";
		
	//80�̻��̸� �幮��
	if(i_msglen>80) msg_type = "5";
		
				
	if(!s_destphone.equals("") && !s_destphone.equals("null") ){
		if(sms_reg.equals("Y")){
							
			IssueDb.insertsendMail_V5_H("02-392-4242", "(��)�Ƹ���ī", s_destphone, s_destname, "", "", msg_type, "(��)�Ƹ���ī �����", cont_sms, "", "", ck_acar_id, "rm_user");
				
			
		}
	}				
			

%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('���������� ó���Ǿ����ϴ�');
		parent.self.close();
		<%if(from_page.equals("/acar/res_stat/res_rent_u.jsp")){%>
		parent.opener.location	='/acar/res_stat/res_rent_u.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "02", "01", "03")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&list_from_page=<%=list_from_page%>';
		<%}else{%>
		parent.opener.location	='/acar/rent_mng/res_rent_u.jsp?auth_rw=<%=rs_db.getAuthRw(user_id, "02", "01", "03")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&list_from_page=<%=list_from_page%>';
		<%}%>
		
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
</script>
</body>
</html>
