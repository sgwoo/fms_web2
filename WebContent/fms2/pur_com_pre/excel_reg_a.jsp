<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.car_office.*, acar.cont.*, acar.car_mst.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//�������
	String value1[]  = request.getParameterValues("value1");//�����ȣ
	String value2[]  = request.getParameterValues("value2");//��û�Ͻ�(20181108)
	String value3[]  = request.getParameterValues("value3");//����
	String value4[]  = request.getParameterValues("value4");//���
	String value5[]  = request.getParameterValues("value5");//�������
	String value6[]  = request.getParameterValues("value6");//�������
	String value7[]  = request.getParameterValues("value7");//���Ͻ����� 2021.07.21 �߰�
	String value8[]  = request.getParameterValues("value8");//�Һ��ڰ�
	String value9[]  = request.getParameterValues("value9");//����
	String value10[]  = request.getParameterValues("value10");//������������
	String value11[] = request.getParameterValues("value11");//�������
	String value12[] = request.getParameterValues("value12");//���
	String value13[] = request.getParameterValues("value13");//�����
	String value14[] = request.getParameterValues("value14");//����
	String value15[] = request.getParameterValues("value15");//���ּ���
	String value16[] = request.getParameterValues("value16");//�Ƹ���ī����ȣ
	String value17[] = request.getParameterValues("value17");//��������
	String value18[] = request.getParameterValues("value18");//������Ʈ���⿩��
	String value19[] = request.getParameterValues("value19");//��ü��������
	//String value20[] = request.getParameterValues("value20");//Q�ڵ�
	String value20[] = request.getParameterValues("value20");//�������޹��
	String value21[] = request.getParameterValues("value21");//ī��/������
	String value22[] = request.getParameterValues("value22");//��������
	String value23[] = request.getParameterValues("value23");//ī��/���¹�ȣ
	String value24[] = request.getParameterValues("value24");//����/������
	String value25[] = request.getParameterValues("value25");//�������⿹����
	
	
	
	String car_off_nm 	= "";
	String car_off_id 	= "";
	String com_con_no 	= "";
	String req_dt		= "";	//��û�Ͻ� �߰�(20181108)
	String car_nm 	  	= "";
	String opt 		  	= "";
	String colo 	  	= "";
	String in_col	  	= "";
	String garnish_col	  	= "";
	int    car_amt 	  	= 0;
	int    con_amt 	  	= 0;
	String con_pay_dt 	= "";
	String dlv_est_dt 	= "";
	String etc 			= "";
	String bus_nm 		= "";
	String firm_nm 		= "";
	String addr 		= "";
	String rent_l_cd	= "";
	String eco_yn 		= "";
	String agent_view_yn = "";
	String bus_self_yn = "";
	//String q_reg_dt = "";

	int 	flag  = 0;
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
		
	

	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		result[i] = "";
		
		car_off_nm 		= value0[i]  ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value0[i],"-",""),"_ ","")," ","");
		com_con_no 		= value1[i]  ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value1[i],"-",""),"_ ","")," ","");
		req_dt			= value2[i]	 ==null?"":value2[i];	//��û�Ͻ� �߰�(20181108)
		car_nm 			= value3[i]  ==null?"":value3[i];
		opt 			= value4[i]  ==null?"":value4[i];
		colo 			= value5[i]  ==null?"":value5[i];
		in_col			= value6[i]  ==null?"":value6[i];
		garnish_col		= value7[i]	 == null ? "" : value7[i];	 // ���Ͻ� ���� �߰�.
		car_amt 		= value8[i]  ==null?0:AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(AddUtil.replace(value8[i],"-",""),"_ ","")," ",""));
		con_amt 		= value9[i]  ==null?0:AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(AddUtil.replace(value9[i],"-",""),"_ ","")," ",""));
		con_pay_dt 		= value10[i]  ==null?"":AddUtil.replace(AddUtil.replace(value10[i]," ",""),"-","");
		dlv_est_dt 		= value11[i] ==null?"":AddUtil.replace(AddUtil.replace(value11[i]," ",""),"-","");
		etc 			= value12[i] ==null?"":value12[i];
		bus_nm 			= value13[i] ==null?"":value13[i];
		firm_nm 		= value14[i] ==null?"":value14[i];
		addr 			= value15[i] ==null?"":value15[i];
		rent_l_cd 		= value16[i] ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value16[i],"-",""),"_ ","")," ","");
		eco_yn 			= value17[i] ==null?"":value17[i];
		agent_view_yn	= value18[i] ==null?"":AddUtil.replace(value18[i]," ","");
		bus_self_yn		= value19[i] ==null?"":AddUtil.replace(value19[i]," ","");
		//q_reg_dt		= value20[i] ==null?"":AddUtil.replace(value20[i]," ","");
		
		
		CarOffPreBean bean = cop_db.getCarOffPreComConNo(com_con_no);
		
		//out.println("<br>"+com_con_no);
		
		String o_rent_l_cd = bean.getRent_l_cd();
		String o_q_reg_dt = bean.getQ_reg_dt();
		
		bean.setCar_nm			(car_nm);	
		bean.setOpt				(opt);	
		bean.setColo			(colo);	
		bean.setIn_col			(in_col);	
		bean.setGarnish_col		(garnish_col);	
		bean.setCar_amt			(car_amt);	
		bean.setCon_amt			(con_amt);	
		bean.setCon_pay_dt		(con_pay_dt);		
		bean.setDlv_est_dt		(dlv_est_dt);	
		bean.setEtc				(etc);
		bean.setReq_dt			(req_dt);	//��û�Ͻ� �߰�(20181108)
		bean.setEco_yn			(eco_yn);	//��������(20191122)
		bean.setAgent_view_yn	(agent_view_yn);	//������Ʈ ���� ���̱�(20220421)
		bean.setBus_self_yn		(bus_self_yn);	//��ü��������(20220822)
		//bean.setQ_reg_dt		(q_reg_dt);	//Q�ڵ�(20220822)
		
		bean.setTrf_st0			(value20[i] ==null?"":AddUtil.replace(value20[i]," ",""));	//�������޹��
		bean.setCon_bank		(value21[i] ==null?"":AddUtil.replace(value21[i]," ",""));	//ī��/������
		bean.setAcc_st0			(value22[i] ==null?"":AddUtil.replace(value22[i]," ",""));	//��������
		bean.setCon_acc_no		(value23[i] ==null?"":AddUtil.replace(value23[i]," ",""));	//ī��/���¹�ȣ
		bean.setCon_acc_nm		(value24[i] ==null?"":AddUtil.replace(value24[i]," ",""));	//����/������
		bean.setCon_est_dt		(value25[i] ==null?"":AddUtil.replace(AddUtil.replace(value25[i]," ",""),"-",""));	//�������⿹����
		
		if(bean.getTrf_st0().equals("����")) 				bean.setTrf_st0("1");
		if(bean.getTrf_st0().equals("�ĺ�ī��")) 			bean.setTrf_st0("3");
		if(bean.getTrf_st0().equals("ī��")) 				bean.setTrf_st0("3");
		
		//���
		if(bean.getSeq() == 0){
		
			if(car_off_nm.equals("����")) 				car_off_nm = "������û������";
			else if(car_off_nm.equals("������û")) 		car_off_nm = "������û������";
			else if(car_off_nm.equals("������û�븮��")) 	car_off_nm = "������û������";
			else if(car_off_nm.equals("����")) 			car_off_nm = "B2B������";
			else if(car_off_nm.equals("�����Ǹ�")) 		car_off_nm = "B2B������";
			else if(car_off_nm.equals("���Ǵ�")) 			car_off_nm = "���Ǵ�븮��";
			else if(car_off_nm.equals("���Ǵ��Ǹ���")) 		car_off_nm = "���Ǵ�븮��";
			else if(car_off_nm.equals("������")) 			car_off_nm = "�����δ븮��";
			else if(car_off_nm.equals("����")) 			car_off_nm = "����븮��";
			else if(car_off_nm.equals("����")) 			car_off_nm = "���ʹ븮��";
			
			if(car_off_nm.equals("B2B������")) 		car_off_id = "03900";
			else if(car_off_nm.equals("������û������")) 	car_off_id = "02176";
			else if(car_off_nm.equals("�д缭��������")) 	car_off_id = "04741";
			else if(car_off_nm.equals("���Ǵ�븮��")) 		car_off_id = "00998";
			else if(car_off_nm.equals("�������߾Ӵ븮��")) 	car_off_id = "04128";
			else if(car_off_nm.equals("�����δ븮��")) 		car_off_id = "04500";
			else if(car_off_nm.equals("����븮��")) 		car_off_id = "03548";
			else if(car_off_nm.equals("�ѽŴ�")) 			car_off_id = "00588";
			else if(car_off_nm.equals("���ʹ븮��")) 		car_off_id = "03579";
			else if(car_off_nm.equals("ȿ��������κ���")) 	car_off_id = "03923";

			bean.setCar_off_nm		(car_off_nm);
			bean.setCar_off_id		(car_off_id);
			bean.setCom_con_no		(com_con_no);
			bean.setReg_id			(ck_acar_id);		
			bean.setUse_yn			("Y");	
			bean.setBus_nm			(bus_nm);	
			bean.setFirm_nm			(firm_nm);	
			bean.setAddr			(addr);
			
			
			
			//insert
			flag1 = cop_db.insertCarOffPre(bean);
			
			result[i] = "��ϵǾ����ϴ�.";
		
		//����
		}else{
			
			//out.println(bus_nm);
			//out.println(bean.getBus_nm());
			
			if(!bus_nm.equals("")){
			
				//���� �����ڰ� �ִ�
				if(!bean.getBus_nm().equals("")){
					//�����ڰ� �ٸ� ��� : ���������� ����� �ļ����ڷ� ���
					if(!bean.getBus_nm().equals(bus_nm)){
					
						//update ������������
						flag2 = cop_db.updateCarOffPreResCls(bean.getSeq(), bean.getR_seq());
					
						//������� ���
						bean.setBus_nm			(bus_nm);	
						bean.setFirm_nm			(firm_nm);	
						bean.setAddr			(addr);	
						
						//if(q_reg_dt.equals("Y")){
						//	bean.setCust_q("Q");
						//}
					
						//insert
						flag3 = cop_db.insertCarOffPreRes(bean);
					
						result[i] = "��������� ����� ������� ��ϵǾ����ϴ�.";
					
					//�����ڰ� ���� ��� : ����
					}else{
						bean.setFirm_nm			(firm_nm);	
						bean.setAddr			(addr);	
					
						//update
						flag2 = cop_db.updateCarOffPreRes(bean);
					
						result[i] = "�����Ǿ����ϴ�.";
					}
				}else{
					//������ ���
					bean.setBus_nm			(bus_nm);	
					bean.setFirm_nm			(firm_nm);	
					bean.setAddr			(addr);
					
					//if(q_reg_dt.equals("Y")){
					//	bean.setCust_q("Q");
					//}
				
					//insert
					flag3 = cop_db.insertCarOffPreRes(bean);
				
					result[i] = "����� ��� �� �����Ǿ����ϴ�.";
				}
			}
			
			//update
			flag1 = cop_db.updateCarOffPre(bean);
			
			//�����϶� Q�ڵ�����
			//if(o_q_reg_dt.equals("") && q_reg_dt.equals("Y")){
			//	flag1 = cop_db.updateCarOffPreQ(bean);
			//}
			
			
			if(result[i].equals("")) result[i] = "�����Ǿ����ϴ�.";
			
		}
		
		//��� ��Ī
		if(!rent_l_cd.equals("")){
			//����Īó��
			if(o_rent_l_cd.equals("")){
			
				//����� Ȯ��
				Hashtable cont = a_db.getContCase(rent_l_cd);
				
				//20190221 ������ ��ó�� : �߸� �Էº� ã���� ����.
				if(!String.valueOf(cont.get("RENT_L_CD")).equals("") && !String.valueOf(cont.get("RENT_L_CD")).equals("null")){
				
					//�����⺻����
					ContCarBean car 	= a_db.getContCarNew(String.valueOf(cont.get("RENT_MNG_ID")), rent_l_cd);
				
					//�ڵ����⺻����
					CarMstBean cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
				
					//������
					//bean.setCar_nm			(cm_bean.getCar_nm());	
					//bean.setOpt				(cm_bean.getCar_name()+" "+car.getOpt());	
					//bean.setColo			(car.getColo());	
					//bean.setIn_col			(car.getIn_col());	
					//bean.setCar_amt			(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt());
				
					//result[i] = result[i]+" ����Ī �� �������� �������Ǿ����ϴ�.";
					
				}
				
			}	
			
			bean.setRent_l_cd			(rent_l_cd);
			
			//update
			flag1 = cop_db.updateCarOffPre(bean);
		}
		
		//out.println("(���)"+result[i]);
		
	}
	

	
	int ment_cnt=0;
	
	//if(1==1)return;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ����ϱ�
</p>
<form action="excel_result.jsp" method="post" name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%for (int i = start_row; i < value_line; i++) {
	//if(result[i].equals("�����Ǿ����ϴ�.")||result[i].equals("��ϵǾ����ϴ�.")) continue;
	ment_cnt++;
%>
	<input type="hidden" name='car_off_nm' value='<%=value0[i] ==null?"":value0[i]%>'>
	<input type="hidden" name='com_con_no' value='<%=value1[i] ==null?"":value1[i]%>'>
	<input type="hidden" name='result' value='<%=result[i]%>'>
	<%if (i==value_line-1) {%>
	<input type="hidden" name="ment_cnt" value="<%=ment_cnt%>"/>
	<%}%>
<%}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
	document.form1.submit();
//-->
</SCRIPT>
</BODY>
</HTML>