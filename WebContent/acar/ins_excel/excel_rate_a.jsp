<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*"%>
<%@ page import="acar.bill_mng.*, acar.accid.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	String ch_dt = request.getParameter("ch_dt")==null?"":request.getParameter("ch_dt");//�輭������
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	
	String result[]   = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	  
	String value1[]  	= request.getParameterValues("value1" );	//��������                       	  
	String value2[]  	= request.getParameterValues("value2" );    //����                     
	String value3[]  	= request.getParameterValues("value3" );    //����ڹ�ȣ                   
	String value4[]  	= request.getParameterValues("value4" );    //������ȣ                    
	String value5[]  	= request.getParameterValues("value5" );    //�����ȣ                    
	String value6[]  	= request.getParameterValues("value6" );    //����                      
	String value7[]  	= request.getParameterValues("value7" );    //���ʵ����                   
	String value8[]  	= request.getParameterValues("value8" );    //��ϻ���                        
	String value9[]  	= request.getParameterValues("value9" );    //�㺸����                        
	String value10[] 	= request.getParameterValues("value10");    //����ȸ��                        
	String value11[] 	= request.getParameterValues("value11");    //���ǹ�ȣ                        
	String value12[] 	= request.getParameterValues("value12");    //����Ⱓ                        
	String value13[] 	= request.getParameterValues("value13");    //�����                         
	String value14[] 	= request.getParameterValues("value14");    //���ڽ�                        
	String value15[] 	= request.getParameterValues("value15");    //�ø����ȣ                       
	String value16[] 	= request.getParameterValues("value16");    //���ڽ��ݾ�                      
	String value17[] 	= request.getParameterValues("value17");    //���ι��1                       
	String value18[] 	= request.getParameterValues("value18");    //���ι��2                       
	String value19[] 	= request.getParameterValues("value19");    //�빰���                        
	String value20[] 	= request.getParameterValues("value20");    //�ڱ��ü���                      
	String value21[] 	= request.getParameterValues("value21");    //�������ڵ��������ѻ���                 
	String value22[] 	= request.getParameterValues("value22");    //�ڱ���������                      
	String value23[] 	= request.getParameterValues("value23");    //�����ܵ������                    
	String value24[] 	= request.getParameterValues("value24");    //�ٸ��ڵ���������������Ư�����             
	String value25[] 	= request.getParameterValues("value25");    //���׺����                        
	String value26[] 	= request.getParameterValues("value26");    //�������� �� �����                  
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	int flag = 1;
	String result_str = "";
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	
	
%>

<html>
<head>
<title>fms</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="javascript" src="/include/info.js"></script>
<style type="text/css">
.style1 {color: #999999; }
input.text{border:0px;text-align:center;}
.title{}
</style>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width="">
  <tr>
    <td>&lt;��ϵ� ���� &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td class="line">
	<table border="0" cellspacing="1" cellpadding="0"> 	
		  <tr style="height:30px;">
          <td class="title">���</td>
          <td class="title">No</td>
          <td class="title">��������</td>
          <td class="title">����</td>
          <td class="title">����ڹ�ȣ</td>
          <td class="title">������ȣ</td>
          <td class="title">�����ȣ</td>
          <td class="title">����</td>
          <td class="title">���ʵ����</td>
          <td class="title">��ϻ���</td>
          <td class="title">�㺸����</td>
          <td class="title">����ȸ��</td>
          <td class="title">���ǹ�ȣ</td>
          <td class="title">����Ⱓ</td>
          <td class="title">�����</td>
          <td class="title">���ڽ�</td>
          <td class="title">�ø����ȣ</td>
          <td class="title">���ڽ��ݾ�</td>
          <td class="title">���ι��1</td>
          <td class="title">���ι��2</td>
          <td class="title">�빰���</td>
          <td class="title">�ڱ��ü���</td>
          <td class="title">�������ڵ��������ѻ���</td>
          <td class="title">�ڱ���������</td>
          <td class="title">�����ܵ������</td>
          <td class="title">�ٸ��ڵ���������������Ư�����</td>
          <td class="title">���׺����</td>
          <td class="title">�������� �� �����</td>
  		</tr>
<%
	for(int i=start_row ; i < value_line ; i++){
		
		result_str = "����";
		String vins_spe ="";
		int vins_spe_amt =0;
		
		//��������
		InsurBean ins = ai_db.getInsInfo(value11[i]);
		
		
		if(!ins.getCar_mng_id().equals("")){
			if(!value17[i].equals("")) ins.setRins_pcp_amt(Integer.parseInt(value17[i].replaceAll(",",""))); 		//���ι��1 rins_pcp_amt                     
			if(!value18[i].equals(""))ins.setVins_pcp_amt(Integer.parseInt(value18[i].replaceAll(",","")));		//���ι��2 vins_pcp_amt                     
			if(!value19[i].equals(""))ins.setVins_gcp_amt(Integer.parseInt(value19[i].replaceAll(",","")));		//�빰���   vins_gcp_amt                    
			if(!value20[i].equals(""))ins.setVins_bacdt_amt(Integer.parseInt(value20[i].replaceAll(",","")));		//�ڱ��ü���  vins_bacdt_amt                   
			
			if(!value21[i].equals(""))ins.setVins_canoisr_amt(Integer.parseInt(value21[i].replaceAll(",","")));	//�������ڵ��������ѻ��� vins_canoisr_amt                
			if(!value22[i].equals(""))ins.setVins_cacdt_cm_amt(Integer.parseInt(value22[i].replaceAll(",","")));//�ڱ���������   vins_cacdt_cm_amt                  
			
			if(!vins_spe.equals("")) ins.setVins_spe(vins_spe);                           
			if(!value23[i].equals("")){
				vins_spe_amt = Integer.parseInt(value23[i].replaceAll(",", ""));
				vins_spe = "�����ܵ������";
			}
			if(!value24[i].equals("")){
				vins_spe_amt +=Integer.parseInt(value24[i].replaceAll(",", ""));
				vins_spe += ", �ٸ��ڵ���������������Ư�����";
			}
		
			if(vins_spe_amt!=0) ins.setVins_spe_amt(vins_spe_amt);//�����ܵ������ + �ٸ��ڵ���������������Ư�����  vins_spe                            
			if(vins_spe_amt!=0) ins.setVins_spe(vins_spe);//�����ܵ������ + �ٸ��ڵ���������������Ư�����  vins_spe_amt                            
			

			//CAR_MNG_ID, INS_ST, CH_TM, CH_DT, CH_ITEM, CH_BEFORE, CH_AFTER, CH_AMT, REG_ID, REG_DT
			//���ڽ� ���κ����   
			
			if(!ai_db.updateIns(ins)){
				flag=0;
				result_str = "����(�������)";
			}
			
			int ch_amt = Integer.parseInt(value25[i].replaceAll(",",""));
			String c_id = ins.getCar_mng_id();
			String ins_st = ins.getIns_st();
			
			String m_id = ins.getRent_mng_id();
			String l_cd = ins.getRent_l_cd();
			
			Hashtable cont = as_db.getRentCase(m_id, l_cd);
			
			Vector ins_cha = ai_db.getInsChanges(c_id, ins_st);
			int ins_cha_size = ins_cha.size();	
		 	
			
			
			InsurChangeBean ins_chg = new InsurChangeBean();
			ins_chg.setCar_mng_id		(c_id);
			ins_chg.setIns_st			(ins_st);
			ins_chg.setCh_tm			(String.valueOf(ins_cha_size + 1));
			ins_chg.setCh_dt			(ch_dt.replaceAll("-", ""));
			ins_chg.setCh_item			("13");
			ins_chg.setCh_before		("����������");
			ins_chg.setCh_after			("����������");
			if(ch_amt>0)	ins_chg.setCh_amt (ch_amt);
			ins_chg.setUpdate_id		(ck_acar_id); 
			
		//	System.out.println(c_id  + " / " + ins_st + " / " + String.valueOf(ins_cha_size + 1) );
		//	System.out.println(ch_dt.replaceAll("-", "")+ " / " +ch_amt + " / " + ck_acar_id);
			
			if(!ai_db.insertInsChange(ins_chg)){
				flag=0;
				result_str = "����(�������)";
			}
			
			/*  */
			
			//���轺����
			Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
			int ins_scd_size = ins_scd.size();
			
			InsurScdBean scd = new InsurScdBean();
			scd.setCar_mng_id		(c_id);
			scd.setIns_st			(ins_st);
			scd.setIns_tm			(Integer.toString(ins_scd_size+1));
			
			if(ch_amt >0 ){	//�߰����� -> ������ 10��
				scd.setIns_est_dt	(ch_dt);
				if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038") || ins.getIns_com_id().equals("0007")){
					String ch_est_dt = c_db.addMonth(ch_dt, 1);
					ch_est_dt = ch_est_dt.substring(0,8)+"10";
					scd.setIns_est_dt	(ch_est_dt);
				}
				scd.setPay_dt		("");
				scd.setPay_yn		("0");
			}else{			//ȯ�޺� -> ���Ա���
				scd.setIns_est_dt	(ch_dt);
				if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038") || ins.getIns_com_id().equals("0007")){
					String ch_est_dt = c_db.addMonth(ch_dt, 1);
					ch_est_dt = ch_est_dt.substring(0,8)+"10";
					scd.setIns_est_dt	(ch_est_dt);
				}
				scd.setPay_dt		("");
				scd.setPay_yn		("0");
			}
			
			/*
			if(ch_item.equals("11")){//������ü
				String ch_est_dt = c_db.addMonth(ch_dt, 1);
				ch_est_dt = ch_est_dt.substring(0,8)+"10";
				scd.setIns_est_dt(ch_est_dt);
				scd.setPay_dt("");
				scd.setPay_yn("0");
			}else{
				scd.setIns_est_dt(ch_dt);
				scd.setPay_dt(ch_dt);
				scd.setPay_yn("1");
			}
			*/
			//������/�ָ��� ��� ������ ó��
			scd.setR_ins_est_dt		(ai_db.getValidDt(scd.getIns_est_dt()));
			scd.setPay_amt			(ch_amt);
			scd.setIns_tm2			("1");
			scd.setCh_tm			(ins_chg.getCh_tm());
			
			if(!ai_db.insertInsScd(scd)){
				flag=0;
				result_str = "����(������)";
			}
				
			
			
			//1. ���躯���ؼ� �߰������� ��� �Ⱓ��� ó�� �� �ڵ���ǥ ����
			//2. ����ȭ���� ��� �̼���,�����ޱ� �ٷ� ó��
			//if(scd.getPay_amt() > 0 || ins.getIns_com_id().equals("0008")){
			//System.out.println(c_id +" / "+ ins_st+" / "+ ch_dt+" / "+  ch_amt);
			//�Ⱓ��� ó��
			if(!ai_db.settleInsurPrecost_InsCng(c_id, ins_st, ch_dt, ch_amt)){
				flag=0;
				result_str = "����(�Ⱓ���)";
			}
			//�ڵ���ǥ ����
			
			//�ڵ���ǥó����
			Vector vt = new Vector();
			int line = 0;
			int count =0;
			String acct_cont = "";
			String acct_code = "";
			
			UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
			Hashtable per 		= neoe_db.getPerinfoDept(user_bean.getUser_nm());	//-> neoe_db ��ȯ
			String insert_id = String.valueOf(per.get("SA_CODE"));
						
			//�����
			Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
			
			//�ڵ��� ����
			Hashtable car_reg = ai_db.getCarRegInfo(c_id);
			
			//�뿩�������޺����
			if(ins.getCar_use().equals("1")){
				acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " ������";
				acct_code = "13300";
			//�����������޺����
			}else{
				acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " ������";
				acct_code = "13200";
			}
			if(scd.getPay_amt() > 0){
				acct_cont = acct_cont+ " ���� ("+String.valueOf(car_reg.get("CAR_NO"))+")";
			}else{
				acct_cont = acct_cont+ " ����ȯ�� ("+String.valueOf(car_reg.get("CAR_NO"))+")";
				
				ch_amt = 0-ch_amt;
			}
			
			line++;
			
			//���޺����
			Hashtable ht1 = new Hashtable();
			ht1.put("DATA_GUBUN", 	"53");
			ht1.put("WRITE_DATE", 	ch_dt);
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
			ht1.put("DR_AMT",    	ch_amt);
			ht1.put("CR_AMT",     	"0");
			if(scd.getPay_amt() < 0){
				ht1.put("AMT_GUBUN",  	"4");//�뺯
				ht1.put("DR_AMT",    	"0");
				ht1.put("CR_AMT",     	ch_amt);
			}
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
			ht2.put("WRITE_DATE", 	ch_dt);
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
			ht2.put("CR_AMT",     	ch_amt);
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
				
			if(scd.getPay_amt() < 0){//�̼���
				ht2.put("AMT_GUBUN",  	"3");//����
				ht2.put("DR_AMT",    	ch_amt);
				ht2.put("CR_AMT",     	"0");
				ht2.put("ACCT_CODE",  	"12000");
				ht2.put("CHECK_CODE1",	"A07");//�ŷ�ó
				ht2.put("CHECK_CODE2",	"F19");//�߻�����
				ht2.put("CHECK_CODE3",	"A19");//��ǥ��ȣ
				ht2.put("CHECK_CODE4",	"A05");//ǥ������
				ht2.put("CHECK_CODE5",	"");
				ht2.put("CHECK_CODE6",	"");
				ht2.put("CHECK_CODE7",	"");
				ht2.put("CHECK_CODE8",	"");
				ht2.put("CHECK_CODE9",	"");
				ht2.put("CHECK_CODE10",	"");
				ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//�ŷ�ó
				ht2.put("CHECKD_CODE2",	"");//�߻�����
				ht2.put("CHECKD_CODE3",	"");//��ǥ��ȣ
				ht2.put("CHECKD_CODE4",	"0");//ǥ������
				ht2.put("CHECKD_CODE5",	"");
				ht2.put("CHECKD_CODE6",	"");
				ht2.put("CHECKD_CODE7",	"");
				ht2.put("CHECKD_CODE8",	"");
				ht2.put("CHECKD_CODE9",	"");
				ht2.put("CHECKD_CODE10","");
				ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//�ŷ�ó
				ht2.put("CHECKD_NAME2",	"");//�߻�����
				ht2.put("CHECKD_NAME3",	"");//��ǥ��ȣ
				ht2.put("CHECKD_NAME4",	acct_cont);//ǥ������
				ht2.put("CHECKD_NAME5",	"");
				ht2.put("CHECKD_NAME6",	"");
				ht2.put("CHECKD_NAME7",	"");
				ht2.put("CHECKD_NAME8",	"");
				ht2.put("CHECKD_NAME9",	"");
				ht2.put("CHECKD_NAME10","");
			}
			
			ht2.put("INSERT_ID", insert_id);
				
			vt.add(ht1);
			vt.add(ht2);
				
			if(line > 0 && vt.size() > 0){
				String row_id = neoe_db.insertDebtSettleAutoDocu(ch_dt, vt);	//-> neoe_db ��ȯ
			}
		
		}else{
			result_str = "���ǹ�ȣ �ٸ�";
			
		}
		
		
		
		
%>
	 <tr>
    	  <td align="center"><input name="result" 	type="text" 	class="text"   		value="<%=result_str%> "> </td>     
    	  <td align="center"><input name="value0" 	type="text" 	class="text"   		value="<%=value0[i]%> "> </td>     
    	  <td align="center"><input name="value1"	type="text" 	class="text"   		value="<%=value1[i]%> "> </td>     <!-- �������� -->               
    	  <td align="center"><input name="value2"	type="text" 	class="text"   		value="<%=value2[i]%> "> </td>     <!-- ���� -->                
    	  <td align="center"><input name="value3"	type="text" 	class="text"   		value="<%=value3[i]%> "> </td>     <!-- ����ڹ�ȣ -->              
    	  <td align="center"><input name="value4"	type="text" 	class="text"   		value="<%=value4[i]%> "> </td>     <!-- ������ȣ -->               
    	  <td align="center"><input name="value5"	type="text" 	class="text"   		value="<%=value5[i]%> "> </td>     <!-- �����ȣ -->             
    	  <td align="center"><input name="value6"	type="text" 	class="text"   		value="<%=value6[i]%> "> </td>     <!-- ���� -->                
    	  <td align="center"><input name="value7"	type="text" 	class="text"   		value="<%=value7[i]%> "> </td>     <!-- ���ʵ���� -->              
    	  <td align="center"><input name="value8"	type="text" 	class="text"   		value="<%=value8[i]%> "> </td>     <!-- ��ϻ��� -->              
    	  <td align="center"><input name="value9"	type="text" 	class="text"   		value="<%=value9[i]%> "> </td>     <!-- �㺸���� -->              
    	  <td align="center"><input name="value10"	type="text" 	class="text"   		value="<%=value10[i]%>"> </td>    <!-- ����ȸ�� -->               
    	  <td align="center"><input name="value11"	type="text" 	class="text"   		value="<%=value11[i]%>"> </td>    <!-- ���ǹ�ȣ -->               
    	  <td align="center"><input name="value12"	type="text" 	class="text"   		value="<%=value12[i]%>"> </td>    <!-- ����Ⱓ -->               
    	  <td align="center"><input name="value13"	type="text" 	class="text"   		value="<%=value13[i]%>"> </td>    <!-- ����� -->             
    	  <td align="center"><input name="value14"	type="text" 	class="text"   		value="<%=value14[i]%>"> </td>    <!-- ���ڽ� -->            
    	  <td align="center"><input name="value15"	type="text" 	class="text"   		value="<%=value15[i]%>"> </td>    <!-- �ø����ȣ -->            
    	  <td align="center"><input name="value16"	type="text" 	class="text"   		value="<%=value16[i]%>"> </td>    <!-- ���ڽ��ݾ� -->           
    	  <td align="center"><input name="value17"	type="text" 	class="text"   		value="<%=value17[i]%>"> </td>    <!-- ���ι��1 -->            
    	  <td align="center"><input name="value18"	type="text" 	class="text"   		value="<%=value18[i]%>"> </td>    <!-- ���ι��2 -->           
    	  <td align="center"><input name="value19"	type="text" 	class="text"   		value="<%=value19[i]%>"> </td>    <!-- �빰���  -->              
    	  <td align="center"><input name="value20"	type="text" 	class="text"   		value="<%=value20[i]%>"> </td>    <!-- �ڱ��ü���   -->           
    	  <td align="center"><input name="value21"	type="text" 	class="text"   		value="<%=value21[i]%>"> </td>    <!-- �������ڵ��������ѻ��� -->
    	  <td align="center"><input name="value22" 	type="text" 	class="text"   		value="<%=value22[i]%>"> </td>    <!-- �ڱ��������� -->            
    	  <td align="center"><input name="value23"	type="text" 	class="text"   		value="<%=value23[i]%>"> </td>    <!-- �����ܵ������ -->      
    	  <td align="center"><input name="value24"	type="text" 	class="text"   		value="<%=value24[i]%>"> </td>    <!-- �ٸ��ڵ���������������Ư����� -->  
    	  <td align="center"><input name="value25"	type="text" 	class="text"   		value="<%=value25[i]%>"> </td>    <!-- ���׺���� -->            
    	  <td align="center"><input name="value26"	type="text" 	class="text"   		value="<%=value26[i]%>"> </td>    <!-- �������� �� �����  -->      
  		</tr>       
<%} %>
</table>
</body>
</html>