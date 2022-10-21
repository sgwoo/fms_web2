<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.cont.*, acar.consignment.*, acar.user_mng.*, acar.doc_settle.*, acar.tint.*, acar.car_office.*, acar.coolmsg.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
	
	String vid[] = request.getParameterValues("ch_cd");
	String rent_mng_id = "";
	String rent_l_cd = "";
	int vt_size = vid.length;
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag5 = true;
	
	for(int i=0;i < vt_size;i++){
		
		rent_l_cd 	= vid[i];
		
		Hashtable ht 	= d_db.getCarPurPayDocCase(rent_l_cd);

		rent_mng_id 	= String.valueOf(ht.get("RENT_MNG_ID"));		

		
		//1. ������� ����-------------------------------------------------------------------------------------------
		
		//car_pur
		ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		pur.setReq_code		("");
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
		flag1 = a_db.updateContPur(pur);
		

		
		//2. ��������� ù��Ȼ��·�-------------------------------------------------------------------------------------------
		
		DocSettleBean doc = d_db.getDocSettleCommi("4", rent_l_cd);
		flag2 = d_db.updateDocSettleBitCancel(doc.getDoc_no(), "1", "1");
		
		
		
		//Ư�ǰ�� Ȯ�����		
		flag1 = cod.updateCarPurComSettleCancel(rent_mng_id, rent_l_cd);	

		
		
		//���� ���Ź�� ����� �ִ��� Ȯ��
		ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
			
		if(!cons.getRent_l_cd().equals("") && cons.getDlv_dt().equals("")){	
			
			//���Ź�����
			flag1 = cs_db.updateConsignmentPurCancel(rent_mng_id, rent_l_cd, ck_acar_id);
			
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			
			String sub2 		= "���Ź�� �Ƿ����";
			String cont2 		= "[ "+rent_l_cd+" "+pur.getRpt_no()+" ] ���Ź�� �Ƿ�����մϴ�. Ȯ�ιٶ��ϴ�.";
			String target_id2 	= "";
			
			//����Ư��
			if(pur.getOff_id().equals("007751")){
				target_id2 = "000187";
			}
			//��������
			if(pur.getOff_id().equals("009026")){
				target_id2 = "000222";
			}
			//����ī��
			if(pur.getOff_id().equals("009771")){
				target_id2 = "000240";
			}			
			//�������
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
		
	}
%>

<script language='javascript'>
<%		if(!flag1){	%>	alert('��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');					<%		}	%>		
<%		if(!flag2){	%>	alert('��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
</form>  
<script language='javascript'>
<!--
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
//-->
</script>
</body>
</html>
