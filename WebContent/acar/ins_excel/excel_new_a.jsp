<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*,acar.car_register.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String ins_com_id = request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	
	String result[]   = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");		//1 ���ǹ�ȣ
	String value1[]  	= request.getParameterValues("value6");		//2 ������ȣ
	String value2[]  	= request.getParameterValues("value8");		//3 ����
	String value3[]  	= request.getParameterValues("value9");		//4 �����Ⱓ
	String value4[]  	= request.getParameterValues("value10");	//5 ���Թ��
	String value5[]  	= request.getParameterValues("value18");	//6 ������
	String value6[]  	= request.getParameterValues("value19");	//7 �빰���
	String value7[]  	= request.getParameterValues("value20");	//8 �ڼ�
	String value8[]  	= request.getParameterValues("value29");	//9 ��⿩��
	String value9[]  	= request.getParameterValues("value32");	//10 ����������
	String value10[] 	= request.getParameterValues("value33");	//11 �輭������
	String value11[] 	= request.getParameterValues("value39");	//12 ���ο�		
	String value12[] 	= request.getParameterValues("value40");	//13 ������
	String value13[] 	= request.getParameterValues("value41");	//14 �빰���
	String value14[] 	= request.getParameterValues("value42");	//15 �ڼ�
	String value15[] 	= request.getParameterValues("value43");	//16 ������
	String value16[] 	= request.getParameterValues("value49");	//17 �д������
	String value17[] 	= request.getParameterValues("value51");	//18 �������̸�
	String value18[] 	= request.getParameterValues("value35");	//19 �ű�üũ
	String value19[] 	= request.getParameterValues("value3");	//20 ����ڸ�
	String value20[] 	= request.getParameterValues("value2");	//21 �ǰ����ڸ�
	String value21[] 	= request.getParameterValues("value44");	//22 ����
	String value22[] 	= request.getParameterValues("value47");	//23 ����

			
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	int flag = 0;
	int count = 0;
	String v1 ="";
	String v2 ="";
	String v3 ="";
	String v4 ="";
	String v5 ="";
	String v6 ="";
	String v7 ="";
	String v8 ="";
	String v9 ="";
	String v10 ="";
	String v11 ="";
	String v12 ="";
	String v13 ="";
	String v14 ="";
	String v15 ="";
	String v16 ="";
	String v17 ="";
	String v18 ="";
	String v19 ="";
	String v20 ="";
	String v21 ="";
	String v22 ="";
	String v23 ="";
	String ins_start_dt = "";
	String ins_end_dt = "";

	
	String result_value = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	String chk_before_dt = AddUtil.getDate();
	String chk_after_dt = AddUtil.getDate();	
	int chk_current_dt = 0;
	
	chk_before_dt = c_db.addMonth(chk_before_dt, -1);
	chk_after_dt =  c_db.addMonth(chk_after_dt, 1); 
	
	chk_before_dt = AddUtil.ChangeString(chk_before_dt);
	chk_after_dt =  AddUtil.ChangeString(chk_after_dt); 
	ck_acar_id ="000048"; //000277
	
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		
		v1 		= value0[i]  ==null?"":value0[i];  //1 ���ǹ�ȣ
		v2		= value1[i]  ==null?"":value1[i];  //2 ������ȣ
		v3		= value2[i]  ==null?"":value2[i];  //3 ����
		v4		= value3[i]  ==null?"":value3[i];  //4 �����Ⱓ
		v5		= value4[i]  ==null?"":value4[i];	 //5 ���Թ��
		v6		= value5[i]  ==null?"":value5[i];  //6 ������
		v7		= value6[i]  ==null?"":value6[i];  //7 �빰���
		v8		= value7[i]  ==null?"":value7[i];  //8 �ڼ�
		v9		= value8[i]  ==null?"":value8[i];  //9 ��⿩��
		v10		= value9[i]  ==null?"":value9[i];  //10 ����������
		v11		= value10[i] ==null?"":value10[i];  //11 �輭������
		v12		= value11[i] ==null?"":value11[i];  //12 ���ο�		
		v13		= value12[i] ==null?"":value12[i];  //13 ������
		v14		= value13[i] ==null?"":value13[i];  //14 �빰���
		v15		= value14[i] ==null?"":value14[i];  //15 �ڼ�
		v16		= value15[i] ==null?"":value15[i];  //16 ������
		v17		= value16[i] ==null?"":value16[i];  //17 �д������
		v18		= value17[i] ==null?"":value17[i];  //18 �������̸�
		v19		= value18[i] ==null?"":value18[i];  //19 �ű�üũ
		v20		= value19[i] ==null?"":value19[i];  //20 ����ڸ�
		v21		= value20[i] ==null?"":value20[i];  //21 �ǰ����ڸ�
		v22		= value21[i] ==null?"":value21[i];  //22 ����         
		v23		= value22[i] ==null?"":value22[i];  //23 ����         
		
		
		
		//�ߺ��Է� üũ-----------------------------------------------------
		int over_cnt = ai_db.getCheckOverIns(v2,v1);
		int over_cnt2 = 0;
		int over_cnt3 = ai_db.getCheckOverIns2(v2);
		
		chk_current_dt = AddUtil.getDate2(0) ;
		int  v17_m  = AddUtil.parseInt(v11.substring(0,6));
		
		if(chk_current_dt <= 9 ){ //��� ��
			if(      (  AddUtil.parseInt(chk_before_dt.substring(0,6))  <=   v17_m  )    &&     (  AddUtil.parseInt(chk_after_dt.substring(0,6))  >=   v17_m  )       ){
				
			}else{
				over_cnt2++;
			}					
		}else{ //��� ��
			if(   (  AddUtil.parseInt(AddUtil.getDate(5))  <=   v17_m  )    &&     (  AddUtil.parseInt(chk_after_dt.substring(0,6))  >=   v17_m  )      ){
			
			}else{
				over_cnt2++;
			}	
		}
		
		if(over_cnt != 0){
			out.println("<�ߺ��Է�Ȯ���ʿ�>������ȣ: "+v2+", ���ǹ�ȣ: "+v1+ " <br>");
		}
		if(over_cnt2 != 0){
			out.println("<�輭������ Ȯ���ʿ�>������ȣ: "+v2+", ���ǹ�ȣ: "+v1+", �輭������: "+v11+" <br>");
		}
		if(over_cnt3 == 0){
			out.println("<������� Ȯ���ʿ�>������ȣ: "+v2+", ���ǹ�ȣ: "+v1+"<br>");
		}
						
	 	/* System.out.println(v1);
		System.out.println(v9);
		System.out.println(v10);
		System.out.println(over_cnt);
		System.out.println(over_cnt2);
		System.out.println(over_cnt3); 
		 */
		 if(!v1.equals("") && !v9.equals("") && !v10.equals("")  && over_cnt == 0  &&  over_cnt2 == 0  &&  over_cnt3 != 0 ){
					
			InsurExcelBean ins = new InsurExcelBean();
						
			ins.setReg_code	(reg_code);
			ins.setSeq	(count);
			ins.setReg_id	(ck_acar_id);
			ins.setGubun	("7");
			
			ins.setValue01	(v1);//1 ���ǹ�ȣ
			ins.setValue02	(v2);//2 ������ȣ
			ins.setValue03	(v3);//3 ����
			//ins.setValue04	(v4);//4 �����Ⱓ	
			ins.setValue05	(v5);//5 ���Թ��	
			
			ins.setValue06	(v6);//6 ������
			ins.setValue07	(v7);//7 �빰���
			ins.setValue08	(v8);//8 �ڼ�	
			ins.setValue09	(v9);//9 ��⿩��	
			ins.setValue10	(AddUtil.replace(v10,",",""));//10 ����������	
			
			ins.setValue11	(v11);//11 �輭������	
			ins.setValue12	(AddUtil.replace(v12,",",""));//12 ���ο�			
			ins.setValue13	(AddUtil.replace(v13,",",""));//13 ������	
			ins.setValue14	(AddUtil.replace(v14,",",""));//14 �빰���	
			ins.setValue15	(AddUtil.replace(v15,",",""));//15 �ڼ�	
			
			ins.setValue16	(AddUtil.replace(v16,",",""));//16 ������
			ins.setValue17	(AddUtil.replace(v17,",",""));//17 �д������
			ins.setValue18	(v18);//18 �������̸�
			
			ins_start_dt    = v4.substring(0,10);
			ins_start_dt    = AddUtil.replace(ins_start_dt,"/","");
			ins.setValue19	(ins_start_dt);//19 ���������
			
			ins_end_dt   = v4.substring(11,21);
			ins_end_dt   = AddUtil.replace(ins_end_dt,"/","");
			ins.setValue20	(ins_end_dt);//20 ���踸����
			ins.setValue21	(v19);//21 �ű�üũ
			ins.setValue22	(v20);//22 ����ڸ�
			ins.setValue23	(v21);//23 �ǰ����ڸ�
			String r_ins_est_dt = c_db.addMonth(ins_start_dt, 1);
			r_ins_est_dt = r_ins_est_dt.substring(0,8)+"10";
			r_ins_est_dt = ai_db.getValidDt(r_ins_est_dt);
			ins.setValue24	(AddUtil.replace(r_ins_est_dt,"-",""));//24 ���� �Ա���

			
			
			if(!ai_db.insertInsExcel2(ins))	flag += 1;
			
			//System.out.println("flag:"+ flag);
			//if(1==1)return;
		
			}
		
		if(flag == 0){ //ins table�� insert ���� ��

				
				String car_no = v2;
			 	String firm_nm = v18;
				
				Hashtable cont_ht = a_db.getContInfo(car_no, firm_nm);
			
				String rent_l_cd = (String)cont_ht.get("RENT_L_CD");
				
			
				String gubun = "����";
				//String gubun = "Ȯ��";
				String car_num = "";
				
				
				Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
				
				
				String rent_mng_id = String.valueOf(cont_ht.get("RENT_MNG_ID"));
				
			/* 	System.out.println("rent_l_cd:"+rent_l_cd);
				System.out.println("rent_mng_id:"+rent_mng_id);
			 */	
				CarRegBean cr_bean = new CarRegBean();
				
				if(String.valueOf(cont_ht.get("CAR_MNG_ID")).equals("")){
					car_no  = String.valueOf(ht.get("EST_CAR_NO"));
					car_num = String.valueOf(ht.get("CAR_NUM"));
				}else{
					cr_bean = crd.getCarRegBean(String.valueOf(cont_ht.get("CAR_MNG_ID")));
					car_no  = cr_bean.getCar_no();
					car_num = cr_bean.getCar_num();
				}
				car_no  = AddUtil.replace(car_no," ","");
				car_num = AddUtil.replace(car_num," ","");
				
				
				//�����ȣ�� ������ȣ �ִ°� Ȯ��
				if(car_no.equals("") && car_num.equals("")){
					result_value = "�����ȣ�� ������ȣ�� �����ϴ�.";
				}
				
				//�����ȣ�� ������ȣ �ִ°� Ȯ��
				if(car_no.length() < 7 && car_num.length() < 17){
					result_value = "�����ȣ�� ������ȣ�� �߸� �ԷµǾ����ϴ�. car_no="+car_no+"/len="+car_no.length()+"/car_num="+car_num+"/len="+car_num.length()+" ";
				}
				
				//������ Ȯ��
				if(result_value.equals("") && ins_com_id.equals("0038") && String.valueOf(cont_ht.get("CAR_ST")).equals("3")){
					result_value = "��������Դϴ�.";
				}
				
				//�ߺ�üũ
				if(result_value.equals("")){
					over_cnt = ic_db.getCheckOverInsExcelCom(gubun, "", rent_mng_id, rent_l_cd, "", "");
					if(over_cnt > 0){
						result_value = "�̹� ��ϵǾ� �ֽ��ϴ�.";
					}
				}
				if(result_value.equals("")){ //validation ���� ��
					
					Hashtable ht2 = ec_db.getRentBoardInsAc(rent_mng_id, rent_l_cd);
					if(ht2.isEmpty()){
						 ht2 = ec_db.getRentBoardIns(rent_mng_id, rent_l_cd);
					}
				
					
					InsurExcelBean ins = new InsurExcelBean();
					
					ins.setReg_code		(reg_code);
					ins.setSeq				(count);
					ins.setReg_id			(ck_acar_id);
					ins.setGubun			(gubun);
					ins.setRent_mng_id(rent_mng_id);
					ins.setRent_l_cd	(rent_l_cd);
					
					ins.setValue01		(String.valueOf(ht2.get("FIRM_NM")));
					
					if(String.valueOf(ht2.get("CAR_ST")).equals("�����뿩")){
						ins.setValue01	("(��)�Ƹ���ī/"+String.valueOf(ht2.get("FIRM_NM")));
					}
					
					ins.setValue02		(AddUtil.ChangeEnpH(String.valueOf(ht2.get("SSN"))));
					ins.setValue03		(String.valueOf(ht2.get("CAR_NM"))+" "+String.valueOf(ht2.get("CAR_NAME")));
					ins.setValue04		(String.valueOf(ht2.get("CAR_NO")));
					ins.setValue05		(String.valueOf(ht2.get("CAR_NUM")));
					
					ins.setValue06		(String.valueOf(ht2.get("TOT_AMT")));
					
					String driving_age = String.valueOf(ht2.get("DRIVING_AGE"));
					String driving_age_nm = "";
					if(driving_age.equals("0")){      driving_age_nm = "26���̻�";
					}else if(driving_age.equals("3")){driving_age_nm = "24���̻�";
					}else if(driving_age.equals("1")){driving_age_nm = "21���̻�";
					}else if(driving_age.equals("5")){driving_age_nm = "30���̻�";
					}else if(driving_age.equals("6")){driving_age_nm = "35���̻�";
					}else if(driving_age.equals("7")){driving_age_nm = "43���̻�";
					}else if(driving_age.equals("8")){driving_age_nm = "48���̻�";
					}else if(driving_age.equals("2")){driving_age_nm = "��������";
					}
					ins.setValue07		(driving_age_nm);
					
					String gcp_kd = String.valueOf(ht2.get("GCP_KD"));
					String gcp_kd_nm = "";
					if(gcp_kd.equals("1")){      gcp_kd_nm = "5õ����";
					}else if(gcp_kd.equals("2")){gcp_kd_nm = "1���";
					}else if(gcp_kd.equals("3")){gcp_kd_nm = "5���";
					}else if(gcp_kd.equals("4")){gcp_kd_nm = "2���";
					}else if(gcp_kd.equals("8")){gcp_kd_nm = "3���";
					}
					ins.setValue08		(gcp_kd_nm);
					
					String bacdt_kd = String.valueOf(ht2.get("BACDT_KD"));
					String bacdt_kd_nm = "";
					if(bacdt_kd.equals("1")){      bacdt_kd_nm = "5õ����";
					}else if(bacdt_kd.equals("2")){bacdt_kd_nm = "1���";
					}
					ins.setValue09		(bacdt_kd_nm);
					
					ins.setValue10		(String.valueOf(ht2.get("COM_EMP_YN")));
					
					ins.setValue11		(String.valueOf(ht2.get("B_COM_NM"))+"-"+String.valueOf(ht2.get("B_MODEL_NM")));
					
					if(!String.valueOf(ht2.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(String.valueOf(ht2.get("B_AMT"))).equals("0")){
						ins.setValue12	("92727");
					}else{
						ins.setValue12	(String.valueOf(ht2.get("B_AMT")));
					}
					ins.setValue13		(String.valueOf(ht2.get("B_SERIAL_NO")));
					ins.setValue14		("0038");
					
					if(!ins_com_id.equals("")){
						ins.setValue14		(ins_com_id);
					}
					
					if(String.valueOf(ht2.get("B_SERIAL_NO")).equals("") && AddUtil.parseDecimal(String.valueOf(ht2.get("B_AMT"))).equals("0")){
						ins.setValue11	("");
					}		
					
					ins.setValue15	(v1);  //1 ���ǹ�ȣ
					ins.setValue16 	(v2);  //2 ������ȣ
					
					
					ins.setValue17 	(AddUtil.replace(v12,",","")); //12 ���ο�	
					ins.setValue18 	(AddUtil.replace(v13,",","")); //13 ������  
					ins.setValue19 	(AddUtil.replace(v14,",","")); //14 �빰��� 
					ins.setValue20 	(AddUtil.replace(v15,",","")); //15 �ڼ�  (�ڱ��ü���) 
					ins.setValue21 	(AddUtil.replace(v16,",","")); //16 ������  
					ins.setValue22 	(AddUtil.replace(v17,",","")); //17 �д������
					
					
					ins.setValue23 	(v22); //22 ����       
					ins.setValue24 	(v23); //23 ����       

					//�ѱݾ��� ����
					String val17  = ins.getValue17() == null ? "0" : ins.getValue17(); //���ο�
					String val18  = ins.getValue18() == null ? "0" : ins.getValue18(); //������
					String val19  = ins.getValue19() == null ? "0" : ins.getValue19(); //�빰���
					String val20  = ins.getValue20() == null ? "0" : ins.getValue20(); //�ڼ�
					String val21  = ins.getValue21() == null ? "0" : ins.getValue21(); //������
					String val22  = ins.getValue22() == null ? "0" : ins.getValue22(); //�д������
					
					
					int sum =  Integer.parseInt(val17) + Integer.parseInt(val18) + Integer.parseInt(val19) + 
							Integer.parseInt(val20) + Integer.parseInt(val21) + Integer.parseInt(val22);
					
					
					ins.setValue25	(String.valueOf(sum)); // �ѱݾ�    
					
					//�������� ����
					String com_emp_yn = "";
					if(String.valueOf(ht2.get("COM_EMP_YN")).equals("����")){
						com_emp_yn = "Y";
					}else{
						com_emp_yn = "N";
					}
					ins.setValue26	(com_emp_yn); // ������     
					
					if(ins.getValue01().equals("null") && ins.getValue02().equals("null") && ins.getValue03().equals("null null") && ins.getValue04().equals("null") && ins.getValue05().equals("null")){
						result_value = "��೻���� ���������� �������� ���߽��ϴ�.";
					}else{
					
						if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							result_value = "��Ͽ����Դϴ�.";
						}else{
							result_value = "��ϿϷ�";//ins_excel_com insert ����
							
						}
					}
					
				
				
					if(result_value.equals("��ϿϷ�")){
						InsurExcelBean ins_e = ic_db.getInsExcelCom(reg_code, String.valueOf(count));
						
						//System.out.println("ins_e.getUse_st():"+ins_e.getUse_st());
						
						if(ins_e.getUse_st().equals("���")){
							
							ins_e.setUse_st("��û");
							ins_e.setReq_id(ck_acar_id);
							if(!ic_db.updateInsExcelComUseSt(ins_e)){
								flag += 1;
								result_value = "��û�����Դϴ�.";
							}else{
								result_value = "��û�Ϸ�";
							}
						}
					}
					
					//System.out.println("result_value :"+result_value);
					
					if(result_value.equals("��û�Ϸ�")){
						InsurExcelBean ins_r = ic_db.getInsExcelCom(reg_code, String.valueOf(count));
						
						if(ins_r.getUse_st().equals("��û")){
							
							ins_r.setUse_st("Ȯ��");
							ins_r.setReq_id(ck_acar_id);
							if(!ic_db.updateInsExcelComUseSt(ins_r)){
								flag += 1;
								result_value = "Ȯ�ο����Դϴ�.";
							}else{
								result_value = "Ȯ�οϷ�";
							}
						}
					}
				
				} 
			}
		}
		
	if(count >0 && result_value.equals("Ȯ�οϷ�")){
		//���ν��� ȣ��
		String  d_flag1 =  ai_db.call_sp_ins_excel_new(reg_code);
		
		//System.out.println("d_flag1 : "+ d_flag1);
		
		if(d_flag1.equals("")){ //ins_excel insert ���� ��
			String act_code  = Long.toString(System.currentTimeMillis());
			
			if(!ic_db.updateInsExcelComActCode(reg_code, count, act_code)){
				flag += 1;
				result_value ="REG_CODE ������ ������ �߻��߽��ϴ�";
			}else{
				
				//���ν��� ȣ��
				 result_value  =  ic_db.call_sp_ins_excel_com_new(act_code, user_id);
				if(result_value.equals("")){
					result_value = "������";
				}
				
			}
			
		}else{//ins_excel insert ���� ��
			result_value = "ins_excel insert ����";
		}
		
	}
				//System.out.println("result_value :"+result_value);
	
	
	
	
			
				 
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>


<SCRIPT LANGUAGE="JavaScript">
		 if('<%=result_value%>'!= "������"){
			<%-- alert('<%=result_value%>');  --%>
			// window.history.back();
		}else{
			/* alert('����մϴ�. ����� ���躯����ȸ���� ��� Ȯ���ϼ���.'); */
		//	window.close(); 
			
		}
</SCRIPT>
</BODY>
</HTML>