<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.consignment.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	int result = 0;
	
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
%>


<%
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	System.out.println("��޽���(������ݱ�� ���)-----------------------"+doc_no+"____"+user_id);
	
	//=====[doc_settle] insert=====
	flag6 = d_db.deleteDocSettle(doc.getDoc_st(), doc.getDoc_id());
	
	
	//�������-���޿�û�� ����
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	pur.setCon_est_dt	("");
	pur.setDlv_est_dt	("");
	pur.setPur_pay_dt	("");
	pur.setPur_est_dt	("");
	pur.setTrf_pay_dt1	("");
	//���� ���޿� ������ �ʱ�ȭ
	if(!pur.getTrf_st2().equals("1")){
		pur.setTrf_pay_dt2	("");
	}
	if(!pur.getTrf_st3().equals("1")){
		pur.setTrf_pay_dt3	("");
	}	
	if(!pur.getTrf_st4().equals("1")){
		pur.setTrf_pay_dt4	("");
	}	
	if(!pur.getTrf_st5().equals("1")){
		pur.setTrf_pay_dt5	("");
	}	
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	
	
	//��ǰ������ ���--------------------------------------------------
	TintBean tint 	= t_db.getTint(rent_mng_id, rent_l_cd);
	flag1 = t_db.deleteTint(tint.getTint_no());
	
	
	//���� ���Ź�� ����� �ִ��� Ȯ��
	ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
			
	if(!cons.getRent_l_cd().equals("") && cons.getDlv_dt().equals("")){	
			
		//���Ź�����
		flag1 = cs_db.updateConsignmentPurCancel(rent_mng_id, rent_l_cd, ck_acar_id);
			
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			
		String sub2 		= "���Ź�� �Ƿ����";
		String cont2 		= "[ "+rent_l_cd+" "+pur.getRpt_no()+" ] ���Ź�� �Ƿ�����մϴ�. Ȯ�ιٶ��ϴ�.";
		String target_id2 	= "";
			
			
		if(pur.getOff_id().equals("007751")){
			target_id2 = "000187";
		}
		if(pur.getOff_id().equals("009026")){
			target_id2 = "000222";
		}
		if(pur.getOff_id().equals("009771")){
			target_id2 = "000240";
		}
		if(pur.getOff_id().equals("011372")){
			target_id2 = "000308";
		}
			
			
		if(!target_id2.equals("")){
			
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
			System.out.println("��޽���("+rent_l_cd+" "+pur.getRpt_no()+" [�����������ó��] ���Ź�� �Ƿ����)-----------------------"+target_bean2.getUser_nm());
		}	
	}	
	
	%>
<script language='javascript'>
<%		if(!flag6){	%>	alert('����ǰ�Ǽ� ���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');			<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>  
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>           
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'pur_doc_frame.jsp';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>