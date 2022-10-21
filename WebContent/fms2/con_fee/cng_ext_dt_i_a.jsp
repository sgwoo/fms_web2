<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	/* �Աݿ����Ϻ��� */
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//����������Ⱓ���Կ���
	String m_id			= request.getParameter("m_id");
	String l_cd			= request.getParameter("l_cd");
	String h_all		= request.getParameter("h_all");
	String s_fee_tm		= request.getParameter("s_fee_tm");			//���õ� ȸ��
	String fee_est_dt	= request.getParameter("t_fee_est_dt");
	String pay_cng_cau	= request.getParameter("t_pay_cng_cau");
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();

	/*����ȸ������ ��� ����*/
	if(h_all.equals("Y")){
		Vector fees = af_db.getScdGroup(m_id, l_cd, s_fee_tm, "ALL");//�ش� ȸ���� ������ �� ������ �뿩�� �� �ܾ� ��θ� vector�� ����
		int fee_size = fees.size();
		for(int i = 0 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
			fee.setFee_est_dt(c_db.addMonth(fee_est_dt, i));
			fee.setR_fee_est_dt(af_db.getValidDt(fee.getFee_est_dt()));
			fee.setDly_days("");	/* �뿩 �Աݿ������� �ٽ� �����ϸ� ��ü�� �� ��ü�ᵵ �ٽ� ����ؾ� �Ѵ�. */
			fee.setDly_fee(0);
			fee.setPay_cng_dt(c_db.getSysDate());
			fee.setPay_cng_cau(pay_cng_cau);
			fee.setUpdate_id(user_id);
			af_db.updateFeeScd(fee);
		}
	}
	/* ����ȸ���� ���� */
	else if(h_all.equals("N")){
		Vector fees = af_db.getScdGroup(m_id, l_cd, s_fee_tm, "ONE");			//�ش� ȸ���� ���� �뿩�� �� �ܾ� ��θ� vector�� ����
		int fee_size = fees.size();
		for(int i = 0 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
			fee.setFee_est_dt(c_db.addMonth(fee_est_dt, i));
			fee.setR_fee_est_dt(af_db.getValidDt(fee.getFee_est_dt()));
			fee.setDly_days("");	/* �뿩 �Աݿ������� �ٽ� �����ϸ� ��ü�� �� ��ü�ᵵ �ٽ� ����ؾ� �Ѵ�. */
			fee.setDly_fee(0);
			fee.setPay_cng_dt(c_db.getSysDate());
			fee.setPay_cng_cau(pay_cng_cau);
			fee.setUpdate_id(user_id);
			af_db.updateFeeScd(fee);
		}
	}
	else{	}
	
	af_db.calDelay(m_id, l_cd);	//��ü�� ���
%>
<html><head><title>FMS</title></head>
<body>
<form name='form1' action='/fms2/con_fee/fee_c_mgr_in.jsp' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('�����߻�!');
		location='about:blank';
<%	}else{%>
		alert('ó���Ǿ����ϴ�');
		parent.opener.i_in.location='/fms2/con_fee/fee_c_mgr_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&prv_mon_yn=<%=prv_mon_yn%>';		
		parent.close();		
<%	}%>
</script>
</body>
</html>
