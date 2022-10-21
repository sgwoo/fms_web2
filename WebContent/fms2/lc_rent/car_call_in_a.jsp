<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cont.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
	<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body>
<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	String in_st 		= request.getParameter("in_st")==null?"":request.getParameter("in_st");
	String in_dt 		= request.getParameter("in_dt")==null?"":request.getParameter("in_dt");
	String in_cau 		= request.getParameter("in_cau")==null?"":request.getParameter("in_cau");
	String out_dt 		= request.getParameter("out_dt")==null?"":request.getParameter("out_dt");
	
	int flag1 = 0;
	boolean flag12 = true;
	
	//�����ӽ�ȸ������Ʈ
	Vector vt = a_db.getCarCallInList(m_id, l_cd);
	int vt_size = vt.size();


	//����ȸ������ ���/���� ----------------------------------------------------------------------
	
	FeeScdStopBean fee_scd = af_db.getCarCallInFeeStop(m_id, l_cd, seq);
	
	fee_scd.setRent_mng_id(m_id);
	fee_scd.setRent_l_cd	(l_cd);
	fee_scd.setStop_st		(in_st);			//��������
	fee_scd.setStop_s_dt	(in_dt);			//�����Ⱓ
	fee_scd.setStop_cau		(in_cau);			//��������
	fee_scd.setCancel_dt	(out_dt);			//����������
	
	if(!fee_scd.getCancel_dt().equals("") && fee_scd.getCancel_id().equals(""))		fee_scd.setCancel_id(ck_acar_id);
	
	if(fee_scd.getSeq().equals("")){
		fee_scd.setReg_id(ck_acar_id);
		fee_scd.setSeq(String.valueOf(vt_size+1));
		if(!af_db.insertCarCallInFeeScdStop(fee_scd)) flag1 += 1;
		
		//������ ��������� ��� �������ڿ��� �޽����� ������.
		if(in_st.equals("4")){

				//��޽��� �޼��� ����------------------------------------------------------------------------------------------
				String sub 		= "������ ��������";
				String cont 	= "[ "+l_cd+" ] ������� ";
				String target_id 	= nm_db.getWorkAuthUser("�λ꺸����");
				
				//�뿩�᰹����ȸ(���忩��)
				int fee_size 	= af_db.getMaxRentSt(m_id, l_cd);
				
				cont = cont + ec_db.getContCngInsCngMsg(m_id, l_cd, String.valueOf(fee_size));
				
				//���躯���û ���ν��� ȣ��
				String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, m_id, l_cd, String.valueOf(fee_size));
				
				CarSchDatabase csd = CarSchDatabase.getInstance();
				CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getUser_id().equals("")){
					target_id = nm_db.getWorkAuthUser("���纸����");
					//�������� ��� �ް��϶�
					cs_bean = csd.getCarScheTodayBean(target_id);
					if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
				}
			
				//����� ���� ��ȸ
				UsersBean target_bean = umd.getUsersBean(target_id);
				
				//����� ���� ��ȸ
				UsersBean sender_bean = umd.getUsersBean(ck_acar_id);
				
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
						
				//flag12 = cm_db.insertCoolMsg(msg);
			
		}
	}else{
		if(!af_db.updateCarCallInFeeScdStop(fee_scd)) flag1 += 1;
	}
	
	seq = fee_scd.getSeq();
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
</form>
<script language='javascript'>
<%	if(flag1 > 0){%>
		alert("��ϵ��� �ʾҽ��ϴ�");
//		location='about:blank';
		
<%	}else{		%>		
		alert("��ϵǾ����ϴ�");
		var fm = document.form1;
		fm.target='CAR_CALLIN';
		fm.action='./car_call_in_list.jsp';
		fm.submit();	
<%	}			%>
</script>