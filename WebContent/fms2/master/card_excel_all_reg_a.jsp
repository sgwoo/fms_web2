<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ page import="card.*" %>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//ī���ȣ
	String value1[]  = request.getParameterValues("value1");//����ڱ���
	String value2[]  = request.getParameterValues("value2");//ī������
	String value3[]  = request.getParameterValues("value3");//�����ѵ��ݾ�
	String value4[]  = request.getParameterValues("value4");//ī�������
	String value5[]  = request.getParameterValues("value5");//��ǥ������
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	
	String buy_user_nm = "";
	int data_no =0;
	int flag = 0;
	String seq = "";
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	
	
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		String cardno			= value0[i]  ==null?"":value0[i];
		String card_name		= value1[i]  ==null?"":value1[i];
		String card_user_nm		= value2[i]  ==null?"":value2[i];
		long   card_limit_amt	= value3[i]  ==null?0:AddUtil.parseDigit4(value3[i]);
		String card_mng_nm		= value4[i]  ==null?"":value4[i];
		String card_app_nm		= value5[i]  ==null?"":value5[i];
		
		if (cardno.length() < 6) continue;
		
		//ī�� ��ȸ
		Hashtable card = CardDb.getCardSearchExcelChk(cardno);
		
		if(String.valueOf(card.get("CARDNO")).equals("null")){
			
			//ī�������
			UsersBean card_mng_bean 	= umd.getUserNmBean(card_mng_nm);
			//��ǥ������
			UsersBean card_app_bean 	= umd.getUserNmBean(card_app_nm);
			
			//ī������
			CardBean c_bean = new CardBean();
			
			c_bean.setCardno		(cardno);
			
			c_bean.setCard_kind_cd	(card_kind);
			c_bean.setCard_kind		(c_db.getNameByIdCode("0031", c_bean.getCard_kind_cd(), ""));		
			c_bean.setCard_name		(card_name);
			c_bean.setCard_st		(request.getParameter("card_st")==null?"":request.getParameter("card_st"));
			c_bean.setCard_type		(request.getParameter("card_type")==null?"":request.getParameter("card_type"));
			c_bean.setCom_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
			c_bean.setCom_name		(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
			c_bean.setCard_sdate	(request.getParameter("card_sdate")==null?"":request.getParameter("card_sdate"));
			c_bean.setCard_edate	(request.getParameter("card_edate")==null?"":request.getParameter("card_edate"));
			c_bean.setPay_day		(request.getParameter("pay_day")==null?"":request.getParameter("pay_day"));
			c_bean.setUse_s_m		(request.getParameter("use_s_m")==null?"":request.getParameter("use_s_m"));
			c_bean.setUse_s_day		(request.getParameter("use_s_day")==null?"":request.getParameter("use_s_day"));
			c_bean.setUse_e_m		(request.getParameter("use_e_m")==null?"":request.getParameter("use_e_m"));
			c_bean.setUse_e_day		(request.getParameter("use_e_day")==null?"":request.getParameter("use_e_day"));
			c_bean.setLimit_st		(request.getParameter("limit_st")==null?"":request.getParameter("limit_st"));
			c_bean.setLimit_amt		(card_limit_amt);
			c_bean.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
			c_bean.setUse_yn		("Y");
			c_bean.setReceive_dt	(request.getParameter("receive_dt")==null?"":request.getParameter("receive_dt"));
			c_bean.setCard_mng_id	(card_mng_bean.getUser_id());
			c_bean.setDoc_mng_id	(card_app_bean.getUser_id());
			//c_bean.setAcc_no		("140-004-023871");
			c_bean.setAcc_no		(request.getParameter("acc_no")==null?"":request.getParameter("acc_no"));
			c_bean.setCard_paid		(request.getParameter("card_paid")==null?"":request.getParameter("card_paid"));
			
			if(!CardDb.insertCard(c_bean)) flag += 1;
			
			
			
			//����� seq ��������
			seq = CardDb.getCardUserSeqNext(cardno);
			
			//�����
			UsersBean card_user_bean 	= umd.getUserNmBean(card_user_nm);
			
			//ī����������
			CardUserBean cu_bean = new CardUserBean();
			cu_bean.setCardno	(cardno);
			cu_bean.setSeq		(seq);
			cu_bean.setUser_id	(card_user_bean.getUser_id());
			cu_bean.setUse_s_dt	(request.getParameter("use_s_dt2")==null?"":request.getParameter("use_s_dt2"));
			cu_bean.setUse_e_dt	(request.getParameter("use_e_dt2")==null?"":request.getParameter("use_e_dt2"));
			cu_bean.setReg_id	(ck_acar_id);
			
			if(!CardDb.insertCardUser(cu_bean)) flag += 1;
			
			
			
			out.println("ī������� ����� �Ϸù�ȣ ���� "+"<br><br>");
			
			//ī������
			c_bean.setUser_seq(seq);
			if(!CardDb.updateCard(c_bean)) flag += 1;
			
			
			
			//�׿����� ī�� �Է�Ȯ���� �̵���̸� �׿������� ī�������� ����Ѵ�.
			if(neoe_db.getCodeByNm("cardno", cardno).equals("")){
				UsersBean user_bean = umd.getUsersBean(c_bean.getCard_mng_id());
				Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
				Hashtable br = c_db.getBranch(user_bean.getBr_id());
				flag = neoe_db.insertCardmana(c_bean, per, br);
			}
			
			
		}
		
		out.println("<br>");
	}
//	if(1==1)return;
	int result_cnt = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ���� ����ϱ�
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
//-->
</SCRIPT>
</BODY>
</HTML>