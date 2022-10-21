<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ page import="card.*" %>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String card_st = request.getParameter("card_st")==null?"4":request.getParameter("card_st");//ī�屸��
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//ī���ȣ-->//�������� -->ī���ȣ
	String value1[]  = request.getParameterValues("value1");//��������-->//ī���ȣ -->��������
	String value2[]  = request.getParameterValues("value2");//�̿�ݾ�-->//�������� -->�̿�ݾ�
	String value3[]  = request.getParameterValues("value3");//��������-->//�̿�ݾ� -->��������
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	
	String buy_user_nm = "";
	String firm_nm = "";
	int data_no =0;
	int flag = 0;
	int seq = 0;
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	
	//�����
	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		
		String cardno		= value0[i]  ==null?"":AddUtil.replace(value0[i],"B","");
		String cardno_o		= value0[i]  ==null?"":value0[i];
		String buy_dt		= value1[i]  ==null?"":AddUtil.replace(value1[i],".","");
		int buy_amt			= value2[i]  ==null?0:AddUtil.parseDigit(value2[i]);
		String acct_cont	= value3[i]  ==null?"":value3[i];
		
		
		String cardno_f		= "";
		
		if (cardno.length() < 6) continue;

		//20180718 cardno B763267 -> 9435-2017-****-2830 ����
		//cardno = cardno.substring(2);
		
		/*
		out.println("i="+i+"&nbsp;&nbsp;&nbsp;");
		out.println("cardno="+cardno+"&nbsp;&nbsp;&nbsp;");
		out.println("cardno length="+cardno.length()+"&nbsp;&nbsp;&nbsp;");
		out.println("buy_dt="+buy_dt+"&nbsp;&nbsp;&nbsp;");
		out.println("buy_amt="+buy_amt+"&nbsp;&nbsp;&nbsp;");
		out.println("acct_cont="+acct_cont+"&nbsp;&nbsp;&nbsp;");
		*/
		
		
		//20180718
		if (cardno.length() == 19){
			cardno_f = cardno.substring(0,9);
			cardno = cardno.substring(15);
		}
		
		//out.println("cardno_f="+cardno_f+"&nbsp;&nbsp;&nbsp;");
		//out.println("cardno="+cardno+"&nbsp;&nbsp;&nbsp;");
		//if(1==1)return;
		
		
		//ī�� ��ȸ
		Hashtable card = CardDb.getCardSearchExcel(card_st, cardno_f, cardno);
		
		//out.println("CARDNO="+String.valueOf(card.get("CARDNO"))+"&nbsp;&nbsp;&nbsp;");
		//if(1==1)return;
		
		if(!String.valueOf(card.get("CARDNO")).equals("null")){
			out.println("cardno="+String.valueOf(card.get("CARDNO"))+"&nbsp;&nbsp;&nbsp;");
			
			cardno = String.valueOf(card.get("CARDNO"));
			
			//����� buy_id ��������
			String buy_id = CardDb.getCardDocBuyIdNext(cardno);
			
			//[1�ܰ�] ��ǥ���-----------------------------------------------------------------------------------
			
			CardDocBean cd_bean = new CardDocBean();
			
			cd_bean.setCardno		(cardno);
			cd_bean.setBuy_id		(buy_id);
			cd_bean.setBuy_dt		(buy_dt);
			cd_bean.setBuy_s_amt		(buy_amt);
			cd_bean.setBuy_v_amt		(0);
			cd_bean.setBuy_amt		(buy_amt);
			cd_bean.setVen_code		(String.valueOf(card.get("COM_CODE")));
			cd_bean.setVen_name		(String.valueOf(card.get("COM_NAME")));
			cd_bean.setAcct_code		("00003");
			cd_bean.setAcct_cont		(cardno_o+" "+String.valueOf(card.get("BUY_USER_NM"))+" : "+acct_cont);
			cd_bean.setBuy_user_id		(String.valueOf(card.get("BUY_USER_ID")));
			cd_bean.setRent_l_cd		("");
			cd_bean.setTax_yn		("N");
			cd_bean.setVen_st		("3");
			cd_bean.setAcct_code_g		("20");
			cd_bean.setReg_id		("000128");
			
			if(!CardDb.insertCardDoc(cd_bean)) flag += 1;
			
			//out.println("buy_id="+buy_id+"<br><br>");
			//out.println("cd_bean.getAcct_cont()="+cd_bean.getAcct_cont()+"<br><br>");
			
			
			//[2�ܰ�] �ڵ���ǥ ����-------------------------------------------------------------------------------
			
			//ī����ǥ��ȸ
			Hashtable card_doc = CardDb.getAppCardDocSelectList(cardno, buy_id);
			
			buy_user_nm = String.valueOf(card_doc.get("USER_NM"));
			
			//���������-����
			Hashtable per = neoe_db.getPerinfoDept(buy_user_nm);
			
			//�׿��� �ڵ���ǥ ó��-------------------------------
			
			AutoDocuBean ad_bean = new AutoDocuBean();
			ad_bean.setBuy_id		(buy_id);
			ad_bean.setNode_code		("S101");
			ad_bean.setVen_code		(String.valueOf(card_doc.get("VEN_CODE")));
			ad_bean.setFirm_nm		(String.valueOf(card_doc.get("VEN_NAME")));
			ad_bean.setWrite_dt		(String.valueOf(card_doc.get("BUY_DT")));
			ad_bean.setAcct_dt		(ad_bean.getWrite_dt());
			ad_bean.setAcct_code		(String.valueOf(card_doc.get("ACCT_CODE")));
			ad_bean.setAmt			(AddUtil.parseInt(String.valueOf(card_doc.get("BUY_S_AMT"))));
			ad_bean.setAmt2			(AddUtil.parseInt(String.valueOf(card_doc.get("BUY_V_AMT"))));
			ad_bean.setInsert_id		(ck_acar_id);
			ad_bean.setItem_code		(String.valueOf(card_doc.get("ITEM_CODE")));
			ad_bean.setItem_name		(String.valueOf(card_doc.get("ITEM_NAME")));
			
			ad_bean.setCardno		(cardno);
			ad_bean.setCard_name		(String.valueOf(card_doc.get("CARD_NAME")));
			
			ad_bean.setVen_type		("0");
			ad_bean.setS_idno		(neoe_db.getVendorEnpNo(ad_bean.getVen_code()));//ven_code�� ��ȸ�ϱ�	//-> neoe_db ��ȯ
			
			ad_bean.setCom_code		(String.valueOf(card_doc.get("COM_CODE")));
			ad_bean.setCom_name		(String.valueOf(card_doc.get("COM_NAME")));
			
			if(!buy_user_nm.equals("")){
				ad_bean.setSa_code	(String.valueOf(per.get("SA_CODE")));
				ad_bean.setKname	(String.valueOf(per.get("KNAME")));
				ad_bean.setDept_code(String.valueOf(per.get("DEPT_CODE")));
				ad_bean.setDept_name(String.valueOf(per.get("DEPT_NAME")));
			}
			ad_bean.setAcct_cont	(cd_bean.getAcct_cont());
			ad_bean.setTax_yn		("N");
			
			ad_bean.setAcct_cd1		(String.valueOf(card_doc.get("ACCT_CODE_G")));
			
//			out.println("�����ڵ�="+String.valueOf(card_doc.get("ACCT_CODE"))+"<br><br>");
//			out.println("�����ڵ�="+ad_bean.getAcct_code()+"<br>");
			
			

			
			
//			if(data_no == 0){//����
//				flag = 1;
//			}else{//ī����ǥ�� �ڵ���ǥ �ۼ�����/�Ϸù�ȣ/������ ���� �ֱ�
				//ī������
				cd_bean.setApp_id			(ck_acar_id);
				cd_bean.setApp_dt			(AddUtil.getDate());
				cd_bean.setAutodocu_write_date		(ad_bean.getWrite_dt());
				cd_bean.setAutodocu_data_no		(String.valueOf(data_no));
				cd_bean.setReg_dt			(AddUtil.getDate());
//				out.println("1="+cd_bean.getApp_id()+"<br>");
//				out.println("2="+cd_bean.getApp_dt()+"<br>");
//				out.println("3="+cd_bean.getAutodocu_write_date()+"<br>");
//				out.println("4="+cd_bean.getAutodocu_data_no()+"<br>");
//				if(!CardDb.updateCardDoc(cd_bean)) flag += 1;
				
				//�ڵ���ǥ ���ν��� ȣ��----------------------------------------------------------------------------
				//if(!CardDb.updateCardDoc(cd_bean)) flag += 1;
				int flag4 = 0;
				String  d_flag1 =  neoe_db.call_sp_card_account(sender_bean.getUser_nm(), "", cardno, buy_id);
				//System.out.println(d_flag1);
				if (!d_flag1.equals("0")) flag4 = 1;
				//System.out.println(" �ڵ���ǥ ���ν��� ��� "+sender_bean.getUser_nm()+" "+cardno+" "+buy_id);
			//--------------------------------------------------------------------------------------------------					
//			}
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