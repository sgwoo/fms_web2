<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.car_office.*, acar.cont.*, acar.user_mng.*, acar.coolmsg.*, acar.client.*, acar.car_mst.*, acar.estimate_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>


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
	String value2[]  = request.getParameterValues("value2"); //Ư�ǰ���ȣ
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5"); //��������
	String value6[]  = request.getParameterValues("value6"); //����������
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


	String com_con_no	= "";
	String dlv_st		= "";
	String dlv_est_dt	= "";
	int    add_dc_amt = 0;

	
	boolean flag1 = true;
	boolean flag2 = true;
	int count = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String add_dc_yn = e_db.getEstiSikVarCase("1", "", "add_dc_yn");//�߰�DC���˿���
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag1 = true;
		String add_dc_chk = "";
		
		//out.println(value6[i]);
		
		com_con_no 	= value2[i]  ==null?"":value2[i];
		dlv_st 		= value5[i]  ==null?"":value5[i];
		dlv_est_dt 	= value6[i]  ==null?"":AddUtil.replace(AddUtil.replace(value6[i]," ",""),"-","");
		add_dc_amt 	= value19[i] ==null?0:AddUtil.parseDigit(value19[i]);
		
		
		if(!com_con_no.equals("")){
		
			if(dlv_est_dt.equals("ERROR 42")) dlv_est_dt = "";
		
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
						String app_y = "20"+AddUtil.addZero(app_value[0]);
						String app_m = AddUtil.addZero(app_value[1]);
						String app_d = AddUtil.addZero(app_value[2]);
						dlv_est_dt = app_y+""+app_m+""+app_d;
					}
				}
				if(dlv_est_dt.length() > 5){// && dlv_est_dt.length() < 8
					StringTokenizer st = new StringTokenizer(dlv_est_dt,"/");
					int s=0; 
					String app_value[] = new String[3];
					while(st.hasMoreTokens()){
						app_value[s] = st.nextToken();
						s++;
					}
					//out.println(app_value[0]+" ");
					//out.println(app_value[1]+" ");
					//out.println(app_value[2]+" ");
					//out.println(dlv_est_dt.length()+" ");
					if(s == 3){
						String app_y = "20"+AddUtil.addZero(app_value[2]);
						String app_m = AddUtil.addZero(app_value[0]);
						String app_d = AddUtil.addZero(app_value[1]);
						if(dlv_est_dt.length() == 10 && app_value[2].length() == 4){
							app_y = app_value[2];
							app_m = AddUtil.addZero(app_value[1]);
							app_d = AddUtil.addZero(app_value[0]);
						}
						dlv_est_dt = app_y+""+app_m+""+app_d;
						
						//out.println(dlv_est_dt);
					}			
				}
			}		
	
			
		
			//��������(�����)		
			CarPurDocListBean cpd_bean = cod.getCarPurCom(com_con_no);
		
			ContBaseBean base = a_db.getCont(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd());
		
			//������
			ClientBean client = al_db.getNewClient(base.getClient_id());
			
			//car_etc
			ContCarBean car 	= a_db.getContCarNew(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd());
	
			//�ڵ����⺻����
			cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
			//��������
			ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");			
		
			UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
		
			String old_dlv_est_dt 	= cpd_bean.getDlv_est_dt();
			String old_dlv_con_dt 	= cpd_bean.getDlv_con_dt();	
			String msg_yn = "N"; 
			String sub 	= "";
			String cont 	= "";	
		
			if(dlv_st.equals("����")){
				cpd_bean.setDlv_st		("1");	
				
				if(dlv_est_dt.equals("null")) dlv_est_dt = "";
			
				if(!dlv_est_dt.equals("����")){
					cpd_bean.setDlv_est_dt		(dlv_est_dt);	
				}
			
				if(dlv_est_dt.equals("ERROR 42")) cpd_bean.setDlv_est_dt("");	
			
				if(!cpd_bean.getDlv_est_dt().equals("����") && !AddUtil.replace(cpd_bean.getDlv_est_dt(),"-","").equals(old_dlv_est_dt)){
					sub 	= "������� �ڵ�����ǰ ����������";
					cont 	= "[ "+cpd_bean.getRent_l_cd()+" "+client.getFirm_nm()+" "+cm_bean.getCar_nm()+" ] ���������� ("+cpd_bean.getDlv_est_dt()+")";			
				
					if(!old_dlv_est_dt.equals("")){
						sub 	= "������� �ڵ�����ǰ ���������� ����";
						cont 	= "[ "+cpd_bean.getRent_l_cd()+" "+client.getFirm_nm()+" "+cm_bean.getCar_nm()+" ] ���������� ����  ("+old_dlv_est_dt+" -> "+cpd_bean.getDlv_est_dt()+")";							
					}
				
					msg_yn = "Y";
				}
			
			}else if(dlv_st.equals("����")){
				cpd_bean.setDlv_st		("2");	
				cpd_bean.setDlv_con_dt		(dlv_est_dt);			
				
				if(dlv_est_dt.equals("ERROR 42")) 				cpd_bean.setDlv_con_dt("");	
				if(dlv_est_dt.equals("����") || dlv_est_dt.equals("")) 		cpd_bean.setDlv_con_dt(AddUtil.getDate(4));	
			
				if(!AddUtil.replace(cpd_bean.getDlv_con_dt(),"-","").equals(old_dlv_con_dt)){
					sub 	= "������� �ڵ�����ǰ ������";
					cont 	= "[ "+cpd_bean.getRent_l_cd()+" "+client.getFirm_nm()+" "+cm_bean.getCar_nm()+" ] ������ ("+cpd_bean.getDlv_con_dt()+")";			
				
					if(!old_dlv_con_dt.equals("")){
						sub 	= "������� �ڵ�����ǰ ������ ����";
						cont 	= "[ "+cpd_bean.getRent_l_cd()+" "+client.getFirm_nm()+" "+cm_bean.getCar_nm()+" ] ������ ����  ("+old_dlv_con_dt+" -> "+cpd_bean.getDlv_con_dt()+")";								
					}
				
					msg_yn = "Y";
				}			
				
				cpd_bean.setAdd_dc_amt	(add_dc_amt);
				cpd_bean.setCar_d_amt		(cpd_bean.getDc_amt()+add_dc_amt);
				cpd_bean.setCar_g_amt		(cpd_bean.getCar_f_amt()-(cpd_bean.getDc_amt()+add_dc_amt));
				
				//�߰�DC�Է� üũ
				if(cpd_bean.getCar_off_id().equals("03900") && cpd_bean.getAdd_dc_amt() == 0 && add_dc_yn.equals("Y") && !ej_bean.getJg_g_7().equals("3") && !ej_bean.getJg_g_7().equals("4")){
					add_dc_chk = "N";
				}
				
			}
			cpd_bean.setReg_id			(ck_acar_id);
			
			
			
			
			
		
		
			if(cpd_bean.getSettle_dt().equals("") && add_dc_chk.equals("")){
	
				flag1 = cod.updateCarPurCom(cpd_bean);
		
				if(flag1){
					result[i] = "����߽��ϴ�.";
			
					if(msg_yn.equals("Y")){
			
						//��޽��� �޼��� ����------------------------------------------------------------------------------------------
				
						String url 	= "/fms2/pur_com/lc_rent_c.jsp?rent_mng_id="+cpd_bean.getRent_mng_id()+"|rent_l_cd="+cpd_bean.getRent_l_cd()+"|com_con_no="+com_con_no;
						String m_url ="/fms2/pur_com/lc_rent_frame.jsp";
						
						String xml_data = "";
						xml_data =  "<COOLMSG>"+
  						"<ALERTMSG>"+
							"    <BACKIMG>4</BACKIMG>"+
							"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
							"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	 
 						
						//20211217 ���������Ȳ�����̸� �޽��� �߼����� �ʴ´�. -> ������������׸� ������.						
						if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){
							UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("���������"));
							xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
						}else{
						
							xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					
							//���� �������� ���������ô����(������)���� �޽��� �߼�
							if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
								UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("���������"));
								xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
							}
							//���� �������� ���������ô����(������)���� �޽��� �߼�
							if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
								UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("���������"));
								xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
							}
						}

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
						System.out.println("��޽���(�������-����)"+cont+"-----------------------"+target_bean.getUser_nm());
				
						flag2 = cm_db.insertCoolMsg(msg);
					
						//���ڹ߼�
						//������ڿ��� ���ڹ߼�
						String sendphone 	= "02-392-4243";
						String sendname 	= "(��)�Ƹ���ī";
						String destphone 	= target_bean.getUser_m_tel();
						String destname 	= target_bean.getUser_nm();
						String msg_cont		= cont;
					
						//������Ʈ ���Ƿ������� ��û
						if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
							CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
							destname 	= a_coe_bean.getEmp_nm();
							destphone = a_coe_bean.getEmp_m_tel();
						}
						
						if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){
							
						}else{
							at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
						}	
					
					}
				
				}else{
					result[i] = "���� �߻�";
				}
			}else{
				result[i] = "�߰�D/C�� �Է��ϰ� ����ó���Ͻʽÿ�.";
			}
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