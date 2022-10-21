<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.customer.*, acar.offls_sui.*, acar.user_mng.*, acar.asset.*"%>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String result[]  = new String[value_line];
	
	String value0[]  = request.getParameterValues("value0");//A  	// ������ 
	String value1[]  = request.getParameterValues("value1");//B  	// �������
	String value2[]  = request.getParameterValues("value2");//C		// �Ա�����
	String value3[]  = request.getParameterValues("value3");//D  	// ���ȸ��
	String value4[]  = request.getParameterValues("value4");//E  	// ��ǰ��ȣ
	String value5[]  = request.getParameterValues("value5");//F  	// ������ȣ
	String value6[]  = request.getParameterValues("value6");//G		// �����/�ֹι�ȣ 
	String value7[]  = request.getParameterValues("value7");//H		// ������
	String value8[]  = request.getParameterValues("value8");//I		// ����������
	String value9[]  = request.getParameterValues("value9");//J		// ��ǰ������
	String value10[]  = request.getParameterValues("value10");//K		// Ź�۷�


	int seq = 0;
	int seq2 = 0;
	int count = 0;
	
	String c_id = 	"";
	String car_no 		= "";
	String search_num = "";
	String firm_nm = "";
       
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	for(int i=start_row ; i < value_line ; i++){
	
		car_no 			= value5[i] ==null?"":value5[i].trim();  //������ȣ
		search_num		= value6[i] ==null?"":value6[i];		 //�����/�ֹι�ȣ 

		Hashtable ht = cu_db.client_search_enp_info(search_num); //�ϴ� ����� �� ��츸 ���� 
				
		Hashtable ht2 = cu_db.Serach_c_id(car_no);
	
		c_id = String.valueOf(ht2.get("CAR_MNG_ID")); 
		
		firm_nm = String.valueOf(ht.get("FIRM_NM"));
			
		if ( firm_nm.equals("") || firm_nm.equals("null") ) {
			result[i] = "�ŷ�ó���";
			continue;
		}
			 		
		SuiBean sui = olsD.getSui(c_id);
		sui.setCar_mng_id(c_id);
		sui.setSui_nm(String.valueOf(ht.get("FIRM_NM")));
		sui.setSsn(String.valueOf(ht.get("SSN_DE")));  //��ȣȭ Ǯ� 
		sui.setH_tel(String.valueOf(ht.get("O_TEL")));
		sui.setM_tel(String.valueOf(ht.get("M_TEL")));
		sui.setCont_dt(value1[i] ==null?"":value1[i]);
		sui.setH_addr(String.valueOf(ht.get("HO_ADDR")));
		sui.setH_zip(String.valueOf(ht.get("HO_ZIP")));
		sui.setD_addr(String.valueOf(ht.get("O_ADDR")));
		sui.setD_zip(String.valueOf(ht.get("O_ZIP")));
		sui.setModify_id(user_id);
		sui.setMm_pr(value7[i] ==null?0: AddUtil.parseDigit(AddUtil.parseFloatTruncZero   (AddUtil.replace(value7[i],"?",""))));
		sui.setJan_pr_dt(value2[i] ==null?"":value2[i]);
		//sui.setMigr_no(value5[i] ==null?"":value5[i]);
		sui.setEnp_no(String.valueOf(ht.get("ENP_NO")));
		sui.setEmail(String.valueOf(ht.get("CON_AGNT_EMAIL")));
		sui.setClient_id(String.valueOf(ht.get("CLIENT_ID")));
		sui.setSui_st("2");
				
		seq = olsD.inSui(sui); //�����ϸ鼭 ��ȣȣ�� 

		AssetDatabase as_db = AssetDatabase.getInstance();
		
		bean.setCar_mng_id(c_id);
		bean.setComm_date(value1[i] ==null?"":value1[i]);
		
		long tot_amt1 = 0;
		long tot_amt2 = 0;
		long tot_amt3 = 0;
		
		tot_amt1 = value8[i]  ==null?0: AddUtil.parseDigit(AddUtil.parseFloatTruncZero   (AddUtil.replace(value8[i],"?","")));
		tot_amt2 = value9[i]  ==null?0: AddUtil.parseDigit(AddUtil.parseFloatTruncZero   (AddUtil.replace(value9[i],"?","")));
		tot_amt3 = value10[i] ==null?0: AddUtil.parseDigit(AddUtil.parseFloatTruncZero   (AddUtil.replace(value10[i],"?","")));
				
		bean.setComm1_sup(AddUtil.parseInt(String.valueOf(Math.round(tot_amt1-Math.round(tot_amt1 * 0.1/1.1)))));
		bean.setComm1_vat(AddUtil.parseInt(String.valueOf(Math.round(tot_amt1 * 0.1/1.1))));
		bean.setComm1_tot(AddUtil.parseInt(String.valueOf(tot_amt1)));
		
		bean.setComm2_sup(AddUtil.parseInt(String.valueOf(Math.round(tot_amt2-Math.round(tot_amt2 * 0.1/1.1)))));
		bean.setComm2_vat(AddUtil.parseInt(String.valueOf(Math.round(tot_amt2 * 0.1/1.1))));
		bean.setComm2_tot(AddUtil.parseInt(String.valueOf(tot_amt2)));
		
		bean.setComm3_sup(AddUtil.parseInt(String.valueOf(Math.round(tot_amt3-Math.round(tot_amt3 * 0.1/1.1)))));
		bean.setComm3_vat(AddUtil.parseInt(String.valueOf(Math.round(tot_amt3 * 0.1/1.1))));
		bean.setComm3_tot(AddUtil.parseInt(String.valueOf(tot_amt3)));
		
		seq2 = as_db.updateSuiEtc(bean);
	
		if(seq > 0){
				result[i] = "����ó���Ǿ����ϴ�.";
		}else{
				result[i] = "�����߻�!";
		}			

		System.out.println("��ŵ��=="+ c_id + "|" + tot_amt1 );
	}
	
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	int result_cnt = 0;
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ������ ����ϱ�
</p>
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("����ó���Ǿ����ϴ�.")) continue;
		result_cnt++;%>
<input type='hidden' name='car_no'     value='<%=value5[i] ==null?"":value5[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
<input type='hidden' name='result_cnt' value='<%=result_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();

//-->
</SCRIPT>
</BODY>
</HTML>