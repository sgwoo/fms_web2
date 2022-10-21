<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.car_office.*, acar.cont.*, acar.client.*, acar.user_mng.*, acar.coolmsg.*, acar.consignment.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size 	= request.getParameter("row_size")	==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size 	= request.getParameter("col_size")	==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row 	= request.getParameter("start_row")	==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line 	= request.getParameter("value_line")	==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	String seq 	= request.getParameter("seq")		==null?"":request.getParameter("seq");
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line);
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");
	String value1[]  = request.getParameterValues("value1");
	String value2[]  = request.getParameterValues("value2");
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");
	String value20[] = request.getParameterValues("value20");


	String rent_l_cd 	= "";
	String com_con_no	= "";
	String dlv_est_dt	= "";
	String dlv_ext 		= "";
	String car_nm 		= "";
	String opt 		= "";
	String colo 		= "";
	int    car_c_amt	= 0;
	int    car_f_amt	= 0;
	String udt_st 		= "";
	int    cons_amt 	= 0;
	int    car_amt 		= 0;
	int    dc_amt 		= 0;
	int    add_dc_amt = 0;
	int    car_g_amt 	= 0;

	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag4 = true;
	int count = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String dlv_mng_id = nm_db.getWorkAuthUser("��������");
	
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
	UsersBean udt_mng_bean_b2 = umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));

	
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag1 = true;
		
		rent_l_cd 	= value0[i]  ==null?"":c_db.getReplaceUpper(value0[i]);
		com_con_no 	= value1[i]  ==null?"":value1[i];
		dlv_est_dt 	= value2[i]  ==null?"":AddUtil.replace(value2[i],"-","");
		dlv_ext 	= value3[i]  ==null?"":value3[i];
		car_nm 		= value4[i]  ==null?"":value4[i];
		opt 		= value5[i]  ==null?"":value5[i];
		colo 		= value6[i]  ==null?"":value6[i];
		car_c_amt 	= value7[i]  ==null?0:AddUtil.parseDigit(value7[i]);
		car_f_amt 	= value8[i]  ==null?0:AddUtil.parseDigit(value8[i]);
		udt_st 		= value9[i]  ==null?"":value9[i];
		cons_amt 	= value10[i] ==null?0:AddUtil.parseDigit(value10[i]);
		dc_amt 		= value12[i] ==null?0:AddUtil.parseDigit(value12[i]);
		add_dc_amt 		= value13[i] ==null?0:AddUtil.parseDigit(value13[i]);
		car_g_amt 	= value14[i] ==null?0:AddUtil.parseDigit(value14[i]);
		

		//10. 3. 23(->10.3.23) ��¥���� -> 20100323�� ����
		if(!dlv_est_dt.equals("")){	
			if(dlv_est_dt.length() > 5){
				StringTokenizer st = new StringTokenizer(dlv_est_dt,".");
				int s=0; 
				String app_value[] = new String[3];
				while(st.hasMoreTokens()){
					app_value[s] = st.nextToken();
					s++;
				}
				if(s == 3){
					String app_y = "20"+app_value[0];
					String app_m = AddUtil.addZero(app_value[1]);
					String app_d = AddUtil.addZero(app_value[2]);
					dlv_est_dt = app_y+""+app_m+""+app_d;
				}
			}
			if(dlv_est_dt.length() > 5 && dlv_est_dt.length() < 8){
				StringTokenizer st = new StringTokenizer(dlv_est_dt,"/");
				int s=0; 
				String app_value[] = new String[3];
				while(st.hasMoreTokens()){
					app_value[s] = st.nextToken();
					s++;
				}
				if(s == 3){
					String app_y = "20"+app_value[0];
					String app_m = AddUtil.addZero(app_value[1]);
					String app_d = AddUtil.addZero(app_value[2]);
					dlv_est_dt = app_y+""+app_m+""+app_d;
				}			
			}
		}		
		
		
		
		Hashtable ht = a_db.getContCase(rent_l_cd);

		
		if(!String.valueOf(ht.get("RENT_MNG_ID")).equals("")){
		
			Hashtable ht2 = cod.getCarPurContListCase(String.valueOf(ht.get("RENT_MNG_ID")), rent_l_cd);
			
			//���� ���Ź�� ����� �ִ��� Ȯ��
			ConsignmentBean cons = cs_db.getConsignmentPur(String.valueOf(ht.get("RENT_MNG_ID")), rent_l_cd);
			
		
			//Ư�ǰ���ȣ �ߺ�üũ
			count = cod.checkComConNo(com_con_no);
		
			
			//out.println(count+",<br>");
			//out.println(value0[i]+",<br>");
			//out.println(value1[i]+",<br>");
			//out.println(value2[i]+",<br>");
			//out.println(value3[i]+",<br>");
			//out.println(value4[i]+",<br>");
			//out.println(value5[i]+",<br>");
			//out.println(value6[i]+",<br>");
			//out.println(value7[i]+",<br>");
			//out.println(value8[i]+",<br>");
			//out.println(value9[i]+",<br>");
			//out.println(value10[i]+",<br>");
			//out.println(value11[i]+",<br>");
			//out.println(value12[i]+",<br>");				
			//out.println(String.valueOf(ht2.get("PURC_GU"))+",<br>");
			//out.println(String.valueOf(ht2.get("AUTO"))+",<br>");

					
			if(count == 0){
		
				
				CarPurDocListBean cpd_bean = new CarPurDocListBean();
	
				cpd_bean.setRent_mng_id		(String.valueOf(ht.get("RENT_MNG_ID")));
				cpd_bean.setRent_l_cd		(rent_l_cd);
				cpd_bean.setCom_con_no		(com_con_no);	
				cpd_bean.setCar_nm		(car_nm);	
				cpd_bean.setOpt			(opt);	
				cpd_bean.setColo		(colo);	
				cpd_bean.setPurc_gu		(String.valueOf(ht2.get("PURC_GU")));	
				cpd_bean.setAuto		(String.valueOf(ht2.get("AUTO")));		
				
				cpd_bean.setCar_c_amt		(car_c_amt);	
				cpd_bean.setCar_f_amt		(car_f_amt);
				cpd_bean.setDc_amt		(dc_amt);
				cpd_bean.setAdd_dc_amt		(add_dc_amt);
				cpd_bean.setCar_d_amt		(dc_amt+add_dc_amt);
				cpd_bean.setCar_g_amt		(car_f_amt-(dc_amt+add_dc_amt));
				cpd_bean.setCons_amt		(cons_amt);
				
				if(dlv_est_dt.equals("null")) dlv_est_dt = "";
				
				cpd_bean.setDlv_st		("1");	
				cpd_bean.setDlv_est_dt		(dlv_est_dt);	
				cpd_bean.setDlv_con_dt		("");	
				cpd_bean.setDlv_ext		(dlv_ext);	
				cpd_bean.setDlv_mng_id		(dlv_mng_id);	
				cpd_bean.setUdt_st		(udt_st);
				
				
				if(cons.getUdt_mng_nm().equals("")){
				
					if(udt_st.equals("����") || udt_st.equals("����")){
						cpd_bean.setUdt_st		("1");
						cpd_bean.setUdt_firm		("������ ����������");	
						cpd_bean.setUdt_addr		("����� �������� �������� 34�� 9");		
						cpd_bean.setUdt_mng_id		(udt_mng_bean_s.getUser_id());	
						cpd_bean.setUdt_mng_nm		(udt_mng_bean_s.getDept_nm()+" "+udt_mng_bean_s.getUser_nm()+" "+udt_mng_bean_s.getUser_pos());	
						cpd_bean.setUdt_mng_tel		(udt_mng_bean_s.getHot_tel());				
					}
					if(udt_st.equals("�λ�") || udt_st.equals("�λ�����")){
						cpd_bean.setUdt_st		("2");						
						cpd_bean.setUdt_firm		("������������� ������");	
						cpd_bean.setUdt_addr		("�λ걤���� ������ ����4�� 585-1");
						//20210204 �̻�
				  		if(AddUtil.getDate2(4) >= 20210205){
				  			cpd_bean.setUdt_firm		("������TS");	
							cpd_bean.setUdt_addr		("�λ�� ������ �ȿ���7������ 10(���굿 363-13����)");
				  		}						
						cpd_bean.setUdt_mng_id		(udt_mng_bean_b2.getUser_id());	
						cpd_bean.setUdt_mng_nm		(udt_mng_bean_b2.getDept_nm()+" "+udt_mng_bean_b2.getUser_nm()+" "+udt_mng_bean_b2.getUser_pos());	
						cpd_bean.setUdt_mng_tel		(udt_mng_bean_b2.getHot_tel());							
					}
					if(udt_st.equals("����") || udt_st.equals("��������")){
						cpd_bean.setUdt_st		("3");
						cpd_bean.setUdt_firm		("�̼���ũ");	
						cpd_bean.setUdt_addr		("���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)");		
						cpd_bean.setUdt_mng_id		(udt_mng_bean_d.getUser_id());	
						cpd_bean.setUdt_mng_nm		(udt_mng_bean_d.getDept_nm()+" "+udt_mng_bean_d.getUser_nm()+" "+udt_mng_bean_d.getUser_pos());	
						cpd_bean.setUdt_mng_tel		(udt_mng_bean_d.getHot_tel());							
					}
					if(udt_st.equals("�뱸") || udt_st.equals("�뱸����")){
						cpd_bean.setUdt_st		("2");
						cpd_bean.setUdt_firm		("�뱸 ������");	
						cpd_bean.setUdt_addr		("�뱸������ �޼��� �Ŵ絿 321-86");		
						cpd_bean.setUdt_mng_id		(udt_mng_bean_g.getUser_id());	
						cpd_bean.setUdt_mng_nm		(udt_mng_bean_g.getDept_nm()+" "+udt_mng_bean_g.getUser_nm()+" "+udt_mng_bean_g.getUser_pos());	
						cpd_bean.setUdt_mng_tel		(udt_mng_bean_g.getHot_tel());							
					}
					if(udt_st.equals("����") || udt_st.equals("��������")){
						cpd_bean.setUdt_st		("3");
						cpd_bean.setUdt_firm		("������ڵ�����ǰ��");	
						cpd_bean.setUdt_addr		("���ֱ����� ���걸 �󹫴�� 233 (������ 1360)");		
						cpd_bean.setUdt_mng_id		(udt_mng_bean_j.getUser_id());	
						cpd_bean.setUdt_mng_nm		(udt_mng_bean_j.getDept_nm()+" "+udt_mng_bean_j.getUser_nm()+" "+udt_mng_bean_j.getUser_pos());	
						cpd_bean.setUdt_mng_tel		(udt_mng_bean_j.getHot_tel());							
					}
					if(udt_st.equals("�̿���") || udt_st.equals("��")){
						cpd_bean.setUdt_st		("4");
						cpd_bean.setUdt_firm		(String.valueOf(ht2.get("FIRM_NM")));	
						cpd_bean.setUdt_addr		(String.valueOf(ht2.get("O_ADDR")));		
						cpd_bean.setUdt_mng_id		("");	
						cpd_bean.setUdt_mng_nm		(String.valueOf(ht2.get("CON_AGNT_NM")));	
						cpd_bean.setUdt_mng_tel		(String.valueOf(ht2.get("O_TEL")));							
					}
				}else{
				
					if(udt_st.equals("����") || udt_st.equals("����")){
						cpd_bean.setUdt_st		("1");
					}
					if(udt_st.equals("�λ�") || udt_st.equals("�λ�����")){
						cpd_bean.setUdt_st		("2");
					}
					if(udt_st.equals("����") || udt_st.equals("��������")){
						cpd_bean.setUdt_st		("3");
					}
					if(udt_st.equals("�뱸") || udt_st.equals("�뱸����")){
						cpd_bean.setUdt_st		("2");
					}
					if(udt_st.equals("����") || udt_st.equals("��������")){
						cpd_bean.setUdt_st		("3");
					}
					if(udt_st.equals("�̿���") || udt_st.equals("��")){
						cpd_bean.setUdt_st		("4");
					}
									
					cpd_bean.setUdt_firm		(cons.getUdt_firm());	
					cpd_bean.setUdt_addr		(cons.getUdt_addr());		
					cpd_bean.setUdt_mng_id		(cons.getUdt_mng_id());	
					cpd_bean.setUdt_mng_nm		(cons.getUdt_mng_nm());	
					cpd_bean.setUdt_mng_tel		(cons.getUdt_mng_tel());				
				
				}
			
				cpd_bean.setReg_id		(ck_acar_id);
				cpd_bean.setUse_yn		("Y");
				cpd_bean.setCar_comp_id		(String.valueOf(ht2.get("CAR_COMP_ID")));		
				cpd_bean.setCar_off_id		(String.valueOf(ht2.get("CAR_OFF_ID2")));		
				
													
				flag1 = cod.insertCarPurCom(cpd_bean);
				
				
				ContBaseBean base = a_db.getCont(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd());
	
				//������
				ClientBean client = al_db.getNewClient(base.getClient_id());
		
				//car_pur
				ContPurBean pur = a_db.getContPur(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd());
				
				if(cpd_bean.getCar_comp_id().equals("0001") && client.getClient_st().equals("1") && pur.getPur_com_firm().equals("")){
					pur.setPur_com_firm(client.getFirm_nm());	
					//=====[CAR_PUR] update=====
					flag4 = a_db.updateContPur(pur);
				}
				
				
				
				
				
				//��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
				String sub 	= "�����ڵ��� ����ȣ���";
				String cont 	= "[ "+rent_l_cd+" "+String.valueOf(ht2.get("FIRM_NM"))+" ] �����ڵ��� ����ȣ("+com_con_no+")�� ������ �̿��Ͽ� ��ϵǾ����ϴ�. Ȯ�ιٶ��ϴ�.";
	
				UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
						
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
					"    <URL></URL>";
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				xml_data += "    <SENDER></SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";
			
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
			
				//flag2 = cm_db.insertCoolMsg(msg);
				
				//������ڿ��� ���ڹ߼�
				//if(cpd_bean.getDlv_st().equals("2")){
					UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
					String sendphone 	= sender_bean.getUser_m_tel();
					String sendname 	= "(��)�Ƹ���ī "+sender_bean.getUser_nm();
					String destphone 	= target_bean.getUser_m_tel();
					String destname 	= target_bean.getUser_nm();
					String msg_cont		= cont;
					
					//������Ʈ ���Ƿ������� ��û
					if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
						CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
						destname 	= a_coe_bean.getEmp_nm();
						destphone = a_coe_bean.getEmp_m_tel();
					}
					
					
					//at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
				//}
						
				if(flag1)
					result[i] = "����߽��ϴ�.";
				else
					result[i] = "���� �߻�";
			}else{
				//����
				result[i] = "Ư�ǰ���ȣ "+com_con_no+"�� �̹� ��ϵ� ��ȣ�Դϴ�.";
			}
		}else{
			result[i] = "����ȣ "+rent_l_cd+"�� �Ƹ���ī ������� ã�� �� �����ϴ�.";
		}
	}
	
	
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
<form action="lc_rent_excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){%>
<input type='hidden' name='sh_code' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='cars'    value='<%=value2[i] ==null?"":value2[i]%>'>
<input type='hidden' name='result'  value='<%=result[i]%>'>
<%	}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>