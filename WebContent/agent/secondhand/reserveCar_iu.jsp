<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.res_search.*" %>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="rs_db" class="acar.res_search.ResSearchDatabase" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");	
	String ret_dt 		= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));	
	String reg_dt 		= request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));	
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String sr_size 		= request.getParameter("sr_size")==null?"":request.getParameter("sr_size");
	String o_situation	= situation;
	
	int result = 0;
	
	ShResBean srBn_chk = shDb.getShRes3(car_mng_id);	//����� ��ȸ
	
	//���ó���Ҷ� �̹� ��ϵȰ��� �ִٸ� ��������� ó��
	if(o_situation.equals("2") && srBn_chk.getSituation().equals("2")){
		situation = "0";
	}
	
	
	shBn.setCar_mng_id	(car_mng_id);
	shBn.setSeq		(seq);
	shBn.setDamdang_id	(damdang_id);
	shBn.setSituation	(situation);
	shBn.setMemo		(memo);
	shBn.setReg_dt		(reg_dt);
	
	if(gubun.equals("i"))		result = shDb.shRes_i(shBn);
	else if(gubun.equals("u"))	result = shDb.shRes_u(shBn);
	
	//�������
	ShResBean srBn2 = shDb.getShRes(car_mng_id, damdang_id, reg_dt);
	
	if(situation.equals("2")){//���Ȯ��
		if(AddUtil.parseInt(AddUtil.replace(reg_dt,"-","")) > AddUtil.parseInt(AddUtil.replace(ret_dt,"-",""))){
			ret_dt = "";
		}
	}else{
		ret_dt = "";
	}
	
	if(ret_dt.equals("")) ret_dt = srBn2.getReg_dt();
	
	String  d_flag1 =  shDb.call_sp_sh_res_dire_dtset("i", car_mng_id, srBn2.getSeq(), ret_dt);
	
	
	
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	CarRegDatabase 	crd 	= CarRegDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(damdang_id);
	
	
	
	//���Ȯ���� ��� ����ý��� ������ �ڵ���� �� ����������ڿ��� �޽��� �뺸
	if(gubun.equals("i") && situation.equals("2")){
		//�ܱ�뿩���� ���
		RentContBean rc_bean = new RentContBean();
		rc_bean.setCar_mng_id		(car_mng_id);
		rc_bean.setRent_st		("11");
		rc_bean.setRent_dt		(reg_dt);
		rc_bean.setBrch_id		(sender_bean.getBr_id());
		rc_bean.setBus_id		(damdang_id);
		rc_bean.setRent_start_dt	(reg_dt+"0000");
		rc_bean.setEtc			("�縮���������� ���Ȯ�� �ڵ�����, "+memo);
		rc_bean.setDeli_plan_dt		(reg_dt+"0000");
		rc_bean.setUse_st		("1");
		rc_bean.setReg_id		(damdang_id);
		rc_bean = rs_db.insertRentCont(rc_bean);				
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--

<%	if(result >= 1){
		if(gubun.equals("i")){%>
		alert("��ϵǾ����ϴ�.");
		<%if(o_situation.equals("2") && srBn_chk.getSituation().equals("2")){%>
		alert("���Ȯ������ ��ϵ� ���� �־� ��������� ����մϴ�.");
		<%}%>
	<%	}else if(gubun.equals("u")){%>
		alert("�����Ǿ����ϴ�.");
	<%	}%>
	parent.opener.location.reload();
	parent.window.close();	
<%	}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.close();				
<%	}%>
//-->
</script>
</body>
</html>
