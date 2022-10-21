<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<%@ page import="acar.admin.*, card.*" %>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String card_st = request.getParameter("card_st")==null?"":request.getParameter("card_st");//ī�屸��
	String buy_dt = request.getParameter("buy_dt")==null?"":request.getParameter("buy_dt");//�ŷ�����
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//
	String value1[]  = request.getParameterValues("value1");//��������
	String value2[]  = request.getParameterValues("value2");//���ι�ȣ
	String value3[]  = request.getParameterValues("value3");//�̿�ī��
	String value4[]  = request.getParameterValues("value4");//�̿밡������
	String value5[]  = request.getParameterValues("value5");//���ⱸ��
	String value6[]  = request.getParameterValues("value6");//�Һΰ���
	String value7[]  = request.getParameterValues("value7");//���αݾ�
	String value8[]  = request.getParameterValues("value8");//����/���
	String value9[]  = request.getParameterValues("value9");//
	String value10[] = request.getParameterValues("value10");//
	
	int flag = 0;
	
	out.println("buy_dt="+buy_dt+"<br><br>");
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		String cardno			= value3[i]  ==null?"":AddUtil.replace(value3[i],"-","");
		String cardno_o			= value3[i]  ==null?"":AddUtil.replace(value3[i],"-","");
		String acct_cont		= value4[i]  ==null?"":value4[i];
		int buy_amt				= value7[i]  ==null?0:AddUtil.parseDigit(value7[i]);
		
		out.println("i="+i+"&nbsp;&nbsp;&nbsp;");
		out.println("cardno="+cardno+"&nbsp;&nbsp;&nbsp;");
		out.println("acct_cont="+acct_cont+"&nbsp;&nbsp;&nbsp;");
		out.println("buy_amt="+buy_amt+"&nbsp;&nbsp;&nbsp;");
		
		//ad_db.insertConvBusid2Case(rent_l_cd, bus_nm2);
		
		//ī�� ��ȸ
		Hashtable card = CardDb.getCardSearchExcel(card_st, cardno);
		
		if(!String.valueOf(card.get("CARDNO")).equals("null")){
			out.println("cardno="+String.valueOf(card.get("CARDNO"))+"&nbsp;&nbsp;&nbsp;");
			
			cardno = String.valueOf(card.get("CARDNO"));
			
			//����� buy_id ��������
			String buy_id = CardDb.getCardDocBuyIdNext(cardno);
			out.println("buy_id="+buy_id+"<br><br>");
			
			//��ǥ����
			CardDocBean cd_bean = new CardDocBean();
			
			cd_bean.setCardno		(cardno);
			cd_bean.setBuy_id		(buy_id);
			cd_bean.setBuy_dt		(buy_dt);
			cd_bean.setBuy_s_amt	(buy_amt);
			cd_bean.setBuy_v_amt	(0);
			cd_bean.setBuy_amt		(buy_amt);
			cd_bean.setVen_code		(String.valueOf(card.get("COM_CODE")));
			cd_bean.setVen_name		(String.valueOf(card.get("COM_NAME")));
			cd_bean.setAcct_code	("00003");
			cd_bean.setAcct_cont	(cardno_o+" "+String.valueOf(card.get("BUY_USER_NM"))+" : "+acct_cont);
//			cd_bean.setUser_su		("1");
//			cd_bean.setUser_cont	(String.valueOf(card.get("BUY_USER_NM")));
			cd_bean.setBuy_user_id	(String.valueOf(card.get("BUY_USER_ID")));
			cd_bean.setRent_l_cd	("");
			cd_bean.setTax_yn		("N");
			cd_bean.setVen_st		("3");
			cd_bean.setAcct_code_g	("20");
			cd_bean.setReg_id		("000128");
			
			if(!CardDb.insertCardDoc(cd_bean)) flag += 1;
		}
		
		
		out.println("<br>");
	}
	if(1==1)return;
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