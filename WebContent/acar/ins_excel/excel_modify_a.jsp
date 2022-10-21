<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.*, acar.bill_mng.*, acar.user_mng.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	String result[]  = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 ���ǹ�ȣ
	String value1[]  	= request.getParameterValues("value1");	//2 ������ȣ
	String value2[]  	= request.getParameterValues("value2");	//3 ���ι��
	String value3[]  	= request.getParameterValues("value3");	//4 ���ι��
	String value4[]  	= request.getParameterValues("value4");	//5 �빰���
	String value5[]  	= request.getParameterValues("value5");	//6 �ڱ��ü���
	String value6[]  	= request.getParameterValues("value6");	//7 ������������
	String value7[]  	= request.getParameterValues("value7");	//8 �д����������
	String value8[]  	= request.getParameterValues("value8");	//9 �Ѻ����
	String value9[]  	= request.getParameterValues("value9");	//10 ��������
	String value10[] 	= request.getParameterValues("value10");//11 
	String value11[] 	= request.getParameterValues("value11");//12 
	String value12[] 	= request.getParameterValues("value12");
	String value13[] 	= request.getParameterValues("value13");
	String value14[] 	= request.getParameterValues("value14");
	String value15[] 	= request.getParameterValues("value15");
	String value16[] 	= request.getParameterValues("value16");
	String value17[] 	= request.getParameterValues("value17");
	String value18[] 	= request.getParameterValues("value18");
	String value19[] 	= request.getParameterValues("value19");
			
	
	
	String ins_con_no 	= "";
	String car_no 		= "";
	int    ins_amt1 	= 0;
	int    ins_amt2 	= 0;
	int    ins_amt3 	= 0;
	int    ins_amt4 	= 0;
	int    ins_amt5 	= 0;
	int    ins_amt6 	= 0;
	int    ins_amt7 	= 0;
	int    ins_amt8 	= 0;
	int    tot_amt 		= 0;
	int    pay_tm 		= 1;
	int    f_amt 		= 0;
	String ins_rent_dt	= "";
	
	int flag = 0;
	
	InsDatabase ai_db = InsDatabase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		
		ins_con_no 		= value0[i] ==null?"":AddUtil.replace(AddUtil.replace(value0[i]," ",""),"_ ","");
		car_no 			= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");
		ins_amt1 		= value2[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value2[i],"_ ",""));
		ins_amt2 		= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],"_ ",""));
		ins_amt3 		= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],"_ ",""));
		ins_amt4 		= value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"_ ",""));
		ins_amt5 		= value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],"_ ",""));
		ins_amt8 		= value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"_ ",""));
		tot_amt 		= value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],"_ ",""));
		ins_rent_dt		= value9[i] ==null?"":AddUtil.replace(value9[i]," ","");
		

		
		//�ֱٺ��� ��ȸ-------------------------------------------------
		InsurBean now_ins = ai_db.getInsConNoExcelCase(ins_con_no, car_no);

		InsurBean ins = ai_db.getInsCase(now_ins.getCar_mng_id(), now_ins.getIns_st());
								
		out.println("car_no="+car_no);
		out.println("ins_con_no="+ins_con_no);
		out.println("ins.getCar_mng_id()="+ins.getCar_mng_id());
		out.println("ins.getIns_rent_dt()="+ins.getIns_rent_dt());
		
		//if(1==1)return;
		
		
			

		if(!ins.getCar_mng_id().equals("") && ins.getIns_rent_dt().equals(ins_rent_dt)){
			
			//���谻�� ����-------------------------------------------------
			ins.setRins_pcp_amt		(ins_amt1);//���ι��1 rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_cacdt_cm_amt+vins_spe_amt
			ins.setVins_pcp_amt		(ins_amt2);//���ι��2
			ins.setVins_gcp_amt		(ins_amt3);//�빰���
			ins.setVins_bacdt_amt		(ins_amt4);//�ڱ��ü���
			ins.setVins_canoisr_amt		(ins_amt5);//������������
			ins.setVins_share_extra_amt	(ins_amt8);//�д����������
				
			if(!ai_db.updateIns(ins))	flag += 1;
				

			//���谻�� ������ ���------------------------------------------
			InsurScdBean scd = ai_db.getInsScd(ins.getCar_mng_id(), ins.getIns_st(), "1");
			scd.setPay_amt		(tot_amt);
				
			if(!ai_db.updateInsScd(scd)) flag += 1;
			
			//�Ⱓ��� ���Ϻ� ����
			PrecostBean cost = ai_db.getInsurPrecostCase("2", ins.getCar_mng_id(), ins.getIns_st(), ins.getIns_rent_dt());
			if(!ai_db.deleteNextPrecostCase(cost)) flag += 1;
			
					
							
						//�ڵ���ǥó����
						Vector vt = new Vector();
						int line = 0;
						int count =0;
						String acct_cont = "";
						String acct_code = "";
			
						UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
						Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
						String insert_id = String.valueOf(per.get("SA_CODE"));
						String dept_code = String.valueOf(per.get("DEPT_CODE"));
	
					
						//�����
						Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
			
						//�뿩�������޺����
						if(ins.getCar_use().equals("1")){
							acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " ������";
							acct_code = "13300";
						//�����������޺����
						}else{
							acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " ������";
							acct_code = "13200";
						}
			
						if(ins.getIns_st().equals("0")) 			acct_cont = acct_cont+ " �ű� ���� ("+car_no+")";
						else  							acct_cont = acct_cont+ " ���� ���� ("+car_no+")";
			
						line++;
			
						//���޺����
						Hashtable ht1 = new Hashtable();
						ht1.put("DATA_GUBUN", 	"53");
						ht1.put("WRITE_DATE", 	ins.getIns_rent_dt());
						ht1.put("DATA_NO",    	"");
						ht1.put("DATA_LINE",  	String.valueOf(line));
						ht1.put("DATA_SLIP",  	"1");
						ht1.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
						ht1.put("NODE_CODE",  	"S101");
						ht1.put("C_CODE",     	"1000");
						ht1.put("DATA_CODE",  	"");
						ht1.put("DOCU_STAT",  	"0");
						ht1.put("DOCU_TYPE",  	"11");
						ht1.put("DOCU_GUBUN", 	"3");
						ht1.put("AMT_GUBUN",  	"3");//����
						ht1.put("DR_AMT",    	tot_amt);
						ht1.put("CR_AMT",     	"0");
						ht1.put("ACCT_CODE",  	acct_code);
						ht1.put("CHECK_CODE1",	"A19");//��ǥ��ȣ
						ht1.put("CHECK_CODE2",	"A07");//�ŷ�ó
						ht1.put("CHECK_CODE3",	"A05");//ǥ������
						ht1.put("CHECK_CODE4",	"");
						ht1.put("CHECK_CODE5",	"");
						ht1.put("CHECK_CODE6",	"");
						ht1.put("CHECK_CODE7",	"");
						ht1.put("CHECK_CODE8",	"");
						ht1.put("CHECK_CODE9",	"");
						ht1.put("CHECK_CODE10",	"");
						ht1.put("CHECKD_CODE1",	"");//��ǥ��ȣ
						ht1.put("CHECKD_CODE2",	String.valueOf(ins_com.get("VEN_CODE")));//�ŷ�ó
						ht1.put("CHECKD_CODE3",	"");//ǥ������
						ht1.put("CHECKD_CODE4",	"");
						ht1.put("CHECKD_CODE5",	"");
						ht1.put("CHECKD_CODE6",	"");
						ht1.put("CHECKD_CODE7",	"");
						ht1.put("CHECKD_CODE8",	"");
						ht1.put("CHECKD_CODE9",	"");
						ht1.put("CHECKD_CODE10","");
						ht1.put("CHECKD_NAME1",	"");//��ǥ��ȣ
						ht1.put("CHECKD_NAME2",	String.valueOf(ins_com.get("VEN_NAME")));//�ŷ�ó
						ht1.put("CHECKD_NAME3",	acct_cont);//ǥ������
						ht1.put("CHECKD_NAME4",	"");
						ht1.put("CHECKD_NAME5",	"");
						ht1.put("CHECKD_NAME6",	"");
						ht1.put("CHECKD_NAME7",	"");
						ht1.put("CHECKD_NAME8",	"");
						ht1.put("CHECKD_NAME9",	"");
						ht1.put("CHECKD_NAME10","");
						ht1.put("INSERT_ID",	insert_id);
			
						line++;
			
						//�����ޱ�
						Hashtable ht2 = new Hashtable();
						ht2.put("DATA_GUBUN", 	"53");
						ht2.put("WRITE_DATE", 	ins.getIns_rent_dt());
						ht2.put("DATA_NO",    	"");
						ht2.put("DATA_LINE",  	String.valueOf(line));
						ht2.put("DATA_SLIP",  	"1");
						ht2.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
						ht2.put("NODE_CODE",  	"S101");
						ht2.put("C_CODE",     	"1000");
						ht2.put("DATA_CODE",  	"");
						ht2.put("DOCU_STAT",  	"0");
						ht2.put("DOCU_TYPE",  	"11");
						ht2.put("DOCU_GUBUN", 	"3");
						ht2.put("AMT_GUBUN",  	"4");//�뺯
						ht2.put("DR_AMT",    	"0");
						ht2.put("CR_AMT",     	tot_amt);
						ht2.put("ACCT_CODE",  	"25300");
						ht2.put("CHECK_CODE1",	"A07");//�ŷ�ó
						ht2.put("CHECK_CODE2",	"A19");//��ǥ��ȣ
						ht2.put("CHECK_CODE3",	"F47");//�ſ�ī���ȣ
						ht2.put("CHECK_CODE4",	"A13");//project
						ht2.put("CHECK_CODE5",	"A05");//ǥ������
						ht2.put("CHECK_CODE6",	"");
						ht2.put("CHECK_CODE7",	"");
						ht2.put("CHECK_CODE8",	"");
						ht2.put("CHECK_CODE9",	"");
						ht2.put("CHECK_CODE10",	"");
						ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//�ŷ�ó
						ht2.put("CHECKD_CODE2",	"");//��ǥ��ȣ
						ht2.put("CHECKD_CODE3",	"");//�ſ�ī���ȣ
						ht2.put("CHECKD_CODE4",	"");//project
						ht2.put("CHECKD_CODE5",	"0");//ǥ������
						ht2.put("CHECKD_CODE6",	"");
						ht2.put("CHECKD_CODE7",	"");
						ht2.put("CHECKD_CODE8",	"");
						ht2.put("CHECKD_CODE9",	"");
						ht2.put("CHECKD_CODE10","");
						ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//�ŷ�ó
						ht2.put("CHECKD_NAME2",	"");//��ǥ��ȣ
						ht2.put("CHECKD_NAME3",	"");//�ſ�ī���ȣ
						ht2.put("CHECKD_NAME4",	"");//project
						ht2.put("CHECKD_NAME5",	acct_cont);//ǥ������
						ht2.put("CHECKD_NAME6",	"");
						ht2.put("CHECKD_NAME7",	"");
						ht2.put("CHECKD_NAME8",	"");
						ht2.put("CHECKD_NAME9",	"");
						ht2.put("CHECKD_NAME10","");
						ht2.put("INSERT_ID",	insert_id);
			
						vt.add(ht1);
						vt.add(ht2);
			
						if(line > 0 && vt.size() > 0){

				
							String row_id = neoe_db.insertDebtSettleAutoDocu(ins.getIns_rent_dt(), vt);	//-> neoe_db ��ȯ
				
							if(row_id.equals("")){
								count = 1;
							}
						}
			result[i] = "���� �����߽��ϴ�.";			

		}else{
			result[i] = "���ǹ�ȣ,������ȣ,�������ڷ� ������ ã�� ���߽��ϴ�.";			
		}					

		
		out.println("result="+result[i]);
		out.println("<br>");

	}
	
	if(1==1)return;	
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

<form action="excel_result.jsp" method='post' name="form1">
</form>

<SCRIPT LANGUAGE="JavaScript">
<!--		

//-->
</SCRIPT>
</BODY>
</HTML>