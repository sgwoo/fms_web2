<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID

	AccidDatabase as_db = AccidDatabase.getInstance();

	boolean flag = true;

	String accid_id = "";
								
	// ����Ʈ
	String car_mng_id[] = request.getParameterValues("car_mng_id");
	String rent_mng_id[] = request.getParameterValues("rent_mng_id");
	String rent_l_cd[]  = request.getParameterValues("rent_l_cd");
	
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
			
	//1. ��� ��� - �ڻ������� ������� ��� �ϰ���ϰ� ---------------------------------------------------------------------------	
		
	for(int i=0; i<size; i++){

			AccidentBean accid = new AccidentBean();
			
			accid.setCar_mng_id		(car_mng_id[i] ==null?"": car_mng_id[i]);
			accid.setRent_mng_id		(rent_mng_id[i] ==null?"": rent_mng_id[i]);
			accid.setRent_l_cd		(rent_l_cd[i] ==null?"": rent_l_cd[i]);					
			accid.setAccid_id("");
			accid.setAccid_st(request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1"));
			accid.setReg_id	(user_id);//������
			accid.setUpdate_id(user_id);//������
			accid.setAcc_id	(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));//������
			accid.setAcc_dt	(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));//��������
			accid.setSub_etc(request.getParameter("sub_etc")==null?"":request.getParameter("sub_etc"));
			accid.setAccid_dt(request.getParameter("h_accid_dt")==null?"":request.getParameter("h_accid_dt"));//�������
			accid.setAccid_type(request.getParameter("accid_type")==null?"":request.getParameter("accid_type"));//�������
		
			accid.setAccid_type_sub(request.getParameter("accid_type_sub")==null?"":request.getParameter("accid_type_sub"));//�������
			accid.setAccid_addr(request.getParameter("accid_addr")==null?"":request.getParameter("accid_addr"));//������
			accid.setAccid_cont(request.getParameter("accid_cont")==null?"":request.getParameter("accid_cont"));//������-��
			accid.setAccid_cont2(request.getParameter("accid_cont2")==null?"":request.getParameter("accid_cont2"));//������-���
			accid.setImp_fault_st(request.getParameter("imp_fault_st")==null?"":request.getParameter("imp_fault_st"));//�ߴ���ǿ���
			accid.setImp_fault_sub(request.getParameter("imp_fault_sub")==null?"":request.getParameter("imp_fault_sub"));//�ߴ���ǿ���-�󼼳���
			accid.setOur_fault_per(request.getParameter("our_fault_per")==null?0:AddUtil.parseDigit(request.getParameter("our_fault_per")));//���Ǻ���
	
			accid.setSettle_st("0");//ó������-������
			accid.setDam_type1(request.getParameter("dam_type1")==null?"N":request.getParameter("dam_type1"));
			accid.setDam_type2(request.getParameter("dam_type2")==null?"N":request.getParameter("dam_type2"));
			accid.setDam_type3(request.getParameter("dam_type3")==null?"N":request.getParameter("dam_type3"));
			accid.setDam_type4(request.getParameter("dam_type4")==null?"N":request.getParameter("dam_type4"));
			accid.setSpeed(request.getParameter("speed")==null?"":request.getParameter("speed"));//�ӵ�
			accid.setRoad_stat(request.getParameter("road_stat")==null?"":request.getParameter("road_stat"));//���θ����
			accid.setRoad_stat2(request.getParameter("road_stat2")==null?"":request.getParameter("road_stat2"));//���θ����
			accid.setWeather(request.getParameter("weather")==null?"":request.getParameter("weather"));//����
			accid.setBus_id2(request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2"));//������ �����
			accid.setReg_ip	(request.getRemoteAddr());//����� ������
					
			accid_id = as_db.insertAccident(accid);
			
			//����ߺ���Ͽ��� üũ
			int accid_chk_cnt  =  as_db.getAccidRegChk(accid);
			
			if(accid_chk_cnt>1){
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>����ߺ����Ȯ��</SUB>"+
		  				"    <CONT>����ߺ����Ȯ�� "+rent_l_cd[i]+"</CONT>"+
		 				"    <URL></URL>";	
				xml_data += "    <TARGET>2006007</TARGET>";	
				xml_data += "    <SENDER>2006007</SENDER>"+
		  				"    <MSGICON>10</MSGICON>"+
		  				"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
		  				"</COOLMSG>";
			
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");	
				boolean flag2 = cm_db.insertCoolMsg(msg);	
			}							
	
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
</form>
<script>	

<%		if( !accid_id.equals("")){%>
			alert("���������� ó���Ǿ����ϴ�.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("�����߻�!");
<%		}%>


</script>
</body>
</html>

