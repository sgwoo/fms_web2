<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*, acar.bill_mng.*, acar.user_mng.*,  acar.im_email.*, tax.*, acar.cont.*, acar.client.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	String ins_rent_dt 	= request.getParameter("ins_rent_dt")==null?"":request.getParameter("ins_rent_dt");	//����-���谡����
	String ins_start_dt 	= request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");	//����-���������
	String ins_end_dt 	= request.getParameter("ins_end_dt")==null?"":request.getParameter("ins_end_dt");	//����-���踸����
	String t_pay_est_dt 	= request.getParameter("t_pay_est_dt")==null?"":request.getParameter("t_pay_est_dt");	//����-���賳����
	String ins_com_id 	= request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");	//����-������ڵ�
	
	
	String result[]  = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 ���ǹ�ȣ
	String value1[]  	= request.getParameterValues("value1");	//2 ������ȣ
	String value2[]  	= request.getParameterValues("value2");	//3 ���ι��
	String value3[]  	= request.getParameterValues("value3");	//4 ���ι��
	String value4[]  	= request.getParameterValues("value4");	//5 �빰���
	String value5[]  	= request.getParameterValues("value5");	//6 �ڱ��ü���
	String value6[]  	= request.getParameterValues("value6");	//7 ������������
	String value7[]  	= request.getParameterValues("value7");	//8 �д����������
	String value8[]  	= request.getParameterValues("value8");	//9 �ڱ���������
	String value9[]  	= request.getParameterValues("value9");	//10 �ִ�ī
	String value10[] 	= request.getParameterValues("value10");//11 �Ѻ����
	String value11[] 	= request.getParameterValues("value11");//12 �������������ڵ������谡�Կ���
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
	String f_dt 		= "";
	int    t_amt 		= 0;
	String t_dt 		= "";
	String ins_est_dt	= "";
	String com_emp_yn	= "";
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		
		ins_con_no 		= value0[i] ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value0[i],"_","")," ",""),"_ ","");
		car_no 			= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");
		ins_amt1 		= value2[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value2[i],"_ ",""));
		ins_amt2 		= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],"_ ",""));
		ins_amt3 		= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],"_ ",""));
		ins_amt4 		= value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"_ ",""));
		ins_amt5 		= value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],"_ ",""));
		ins_amt8 		= value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"_ ",""));		
		ins_amt6 		= value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],"_ ",""));
		ins_amt7 		= value9[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value9[i],"_ ",""));
		tot_amt 		= value10[i]==null?0: AddUtil.parseDigit(AddUtil.replace(value10[i],"_ ",""));
		com_emp_yn		= value11[i] ==null?"":AddUtil.replace(value11[i]," ","");
		
		ins_amt1 		= value2[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value2[i],",",""));
		ins_amt2 		= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],",",""));
		ins_amt3 		= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],",",""));
		ins_amt4 		= value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],",",""));
		ins_amt5 		= value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],",",""));
		ins_amt8 		= value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],",",""));
		ins_amt6 		= value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],",",""));
		ins_amt7 		= value9[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value9[i],",",""));
		tot_amt 		= value10[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value10[i],",",""));
	

		
		//�ߺ��Է� üũ-----------------------------------------------------
		int over_cnt = ai_db.getCheckOverIns(car_no, ins_con_no);
		
		out.println("�ߺ��Է� üũ="+over_cnt);
		
		
		if(!ins_con_no.equals("") && over_cnt == 0){
			//�ֱٺ��� ��ȸ-------------------------------------------------
			InsurBean ins = ai_db.getInsExcelCase(car_no);
			
			InsurBean old_ins = ins;
			
			out.println("car_no="+car_no);
			out.println("ins_con_no="+ins_con_no);
			out.println("ins.getIns_start_dt()="+ins.getIns_start_dt());
			out.println("AddUtil.getDate(1)="+AddUtil.getDate(1));
			out.println("<br>");
		
			

			if(!ins.getCar_mng_id().equals("") && ins.getIns_start_dt().length()>4 && ins.getIns_start_dt().substring(0,4).equals(AddUtil.getDate(1))){
			
				//���谻�� ���-------------------------------------------------
				int ins_st = AddUtil.parseInt(ins.getIns_st())+1;
				ins.setIns_st			(Integer.toString(ins_st));
				ins.setIns_sts			("1");//1:��ȿ, 2:����, 3:�ߵ�����, 4:������������
				ins.setIns_con_no		(ins_con_no);
				ins.setRins_pcp_amt		(ins_amt1);//���ι��1
				ins.setVins_pcp_amt		(ins_amt2);//���ι��2
				ins.setVins_gcp_amt		(ins_amt3);//�빰���
				ins.setVins_bacdt_amt		(ins_amt4);//�ڱ��ü���
				ins.setVins_canoisr_amt		(ins_amt5);//������������
				ins.setVins_share_extra_amt	(ins_amt8);//�д����������
				ins.setVins_cacdt_cm_amt	(ins_amt6);//�ڱ���������
				ins.setVins_spe_amt		(ins_amt7);//�ִ�ī
				ins.setVins_spe			("");//20090210���� ����⵿ �̰���
				ins.setPay_tm			(Integer.toString(pay_tm));
				ins.setReg_cau			("4");//4:����
				ins.setIns_com_id		(ins_com_id);
				ins.setIns_rent_dt		(ins.getIns_start_dt());			
				ins.setCom_emp_yn		(com_emp_yn);			
				
				if(!ai_db.insertIns(ins))	flag += 1;
				else{
					
					//������ ����ó��-----------------------------------------------
					if(!ai_db.changeInsSts(ins.getCar_mng_id(), ins_st-1, "2"))	flag += 1;
					else{
						
						//���谻�� ������ ���------------------------------------------
						
						//1ȸ��
						InsurScdBean scd = new InsurScdBean();
						scd.setCar_mng_id	(ins.getCar_mng_id());
						scd.setIns_st		(Integer.toString(ins_st));
						scd.setIns_tm		("1");
						
						
						
						ins_est_dt = t_pay_est_dt;
						
						scd.setIns_est_dt	(ins_est_dt);
						scd.setR_ins_est_dt	(ai_db.getValidDt(scd.getIns_est_dt()));//������/�ָ��� ��� ������ ó��
						
						
						scd.setPay_amt		(tot_amt);						
						scd.setPay_dt		("");
						scd.setPay_yn		("0");
						scd.setIns_tm2		("0");
						
						if(!ai_db.insertInsScd(scd)) flag += 1;
						
						
						UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
						//�����
						Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
						
						
						//20140618 ��� ���ŵ�� ���� �� ���� �߼�
						
						//cont_view
						Hashtable cont = a_db.getContViewUseYCarCase(ins.getCar_mng_id());
						String rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
						String rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
						
						String car_num = String.valueOf(cont.get("CAR_NO"));
						String car_name = String.valueOf(cont.get("CAR_NM"));
																
						//�ŷ�ó
						ClientBean client = al_db.getClient(String.valueOf(cont.get("CLIENT_ID")));
				
						String subject 		= client.getFirm_nm()+"��, �ڵ������� ���� �ȳ������Դϴ�.";
																
						int seqidx		= 0;
		
				
						if(!client.getCon_agnt_email().equals("")){
							//	1. d-mail ���-------------------------------
							DmailBean d_bean = new DmailBean();
							d_bean.setSubject			(subject);
							d_bean.setSql				("SSV:"+client.getCon_agnt_email().trim());
							d_bean.setReject_slist_idx	(0);
							d_bean.setBlock_group_idx	(0);
							d_bean.setMailfrom			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
							d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+client.getCon_agnt_email().trim()+">");
							d_bean.setReplyto			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
							d_bean.setErrosto			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
							d_bean.setHtml				(1);
							d_bean.setEncoding			(0);
							d_bean.setCharset			("euc-kr");
							d_bean.setDuration_set		(1);
							d_bean.setClick_set			(0);
							d_bean.setSite_set			(0);
							d_bean.setAtc_set			(0);
							d_bean.setGubun				("insur");
							d_bean.setRname				("mail");
							d_bean.setMtype       		(0);
							d_bean.setU_idx       		(1);//admin����
							d_bean.setG_idx				(1);//admin����
							d_bean.setMsgflag     		(0);													
							d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/ins_gs_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&ins_start_dt="+ins.getIns_start_dt());
							d_bean.setV_content			("http://fms1.amazoncar.co.kr/mailing/ins/ins_gs_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&ins_start_dt="+ins.getIns_start_dt());
				
							seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");					
						}
							
						String ins_name = String.valueOf(ins_com.get("INS_COM_NM"));
						String ins_tel 	= "";
						if ( ins_name.equals("�Ｚȭ��") ) {
		    					ins_tel = "1588-5114, ";
						} else if  ( ins_name.equals("����ȭ��") || ins_name.equals("DB���غ���")) {
		    					ins_tel = "1588-0100,";
		    			} else if  ( ins_name.equals("����ī��������") ) {
								ins_tel = "1661-7977, ";					
						}
						
						if(!String.valueOf(cont.get("BUS_ID2")).equals("")){
							user_bean 	= umd.getUsersBean(String.valueOf(cont.get("BUS_ID2")));
						}
						
						String etc1 = rent_l_cd;
						String etc2 = ck_acar_id;
	
						String sendname 	= "(��)�Ƹ���ī "+user_bean.getUser_nm();
						String sendphone 	= user_bean.getUser_m_tel();
						
						
						//String msg 		= "[�ڵ������� ����] ������ "+ ins_name + " "+ ins_tel +" ����⵿�� ����Ÿ�ڵ��� 1588-6688 �Դϴ�. (��)�Ƹ���ī ";
						String msg 		= client.getFirm_nm()+"���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�. ������ �뿩�ڵ��� ����ȸ�簡 ������ ���� ���ŵǾ������ �̿뿡 ���� ��Ź�帳�ϴ�. ������ ����� : "+ ins_name + " ("+ ins_tel +"), ����⵿ �� ���� : ����Ÿ����⵿ 1588-6688, SK��Ʈ���� 1670-5494   (��)�Ƹ���ī www.amazoncar.co.kr ";
						//��� ����� ���� ���� ����
						Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
			
						String destphone 	= String.valueOf(sms.get("TEL"));			
						String destname 	= String.valueOf(sms.get("NM"));
						String customer_name =client.getFirm_nm();										// �� �̸�
						String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";								// ����⵿
						
						String marster_car_num = "1588-6688"; //������ �ڵ��� ����ó
						String sk_net_num = "1670-5494"; //sk��Ʈ���� ����ó
						
						String url_1 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
						String sos_url = ShortenUrlGoogle.getShortenUrl(url_1);
						
						Date today = new Date();
						SimpleDateFormat format = new SimpleDateFormat("yyyy�� MM�� dd��");
						String update_date = String.valueOf(format.format(today));
						
						if(!destphone.equals("")){
							//������ ����⵿ ���ڸ޼��� 
							
							/* List<String> fieldList = Arrays.asList(customer_name, ins_name, ins_tel, sos_service_info);	
							at_db.sendMessageReserve("acar0112", fieldList, destphone,  sendphone, null , etc1,  etc2); */
							
							//acar0045-> acar0059 (������ȣ �߰�) -> acar0091 (��������) -> acar00112 (�ִ�ī����) -> acar0157 (sk��Ʈ���� �߰�) -> acar0232 -> acar0259
							List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, ins_name, ins_tel, update_date, AddUtil.ChangeDate2(ins.getIns_start_dt()), AddUtil.ChangeDate2(ins.getIns_exp_dt()), marster_car_num, sk_net_num, sos_url);
							at_db.sendMessageReserve("acar0259", fieldList, destphone,  sendphone, null , etc1,  etc2);
						}
						
					}
					if(flag != 0)	result[i] = "���� ����� ���� �߻�";
					else			result[i] = "���� ��ϵǾ����ϴ�.";
				}
			}else{
				result[i] = "���� ����� �ƴմϴ�.";
			}
		}else{
		
		
			//�̹� ��ϵ� �����̴�.. �����ٻ��� Ȯ���Ұ�..
			if(!ins_con_no.equals("") && over_cnt > 0){
						
				//�ֱٺ��� ��ȸ-------------------------------------------------
				InsurBean ins = ai_db.getInsChkExcelCase(car_no);
				
				InsurScdBean scd = ai_db.getInsScd(ins.getCar_mng_id(), ins.getIns_st(), "1");
				
				if(scd.getCar_mng_id().equals("")){
				
					out.println("�̹� ��ϵ� �����̳� �����ٹ̻�����");
					out.println("car_no="+car_no);
					out.println("ins_con_no="+ins_con_no);
					out.println("ins.getIns_start_dt()="+ins.getIns_start_dt());
					out.println("AddUtil.getDate(1)="+AddUtil.getDate(1));
					out.println("<br>");
				
				
						//1ȸ��				
						scd.setCar_mng_id	(ins.getCar_mng_id());
						scd.setIns_st		(ins.getIns_st());
						scd.setIns_tm		("1");
												
						ins_est_dt = t_pay_est_dt;
						
						scd.setIns_est_dt	(ins_est_dt);
						scd.setR_ins_est_dt	(ai_db.getValidDt(scd.getIns_est_dt()));//������/�ָ��� ��� ������ ó��
						
						
						scd.setPay_amt		(tot_amt);						
						scd.setPay_dt		("");
						scd.setPay_yn		("0");
						scd.setIns_tm2		("0");
						
						if(!ai_db.insertInsScd(scd)) flag += 1;
						
						UsersBean user_bean 	= umd.getUsersBean("000056");
						
						//�����
						Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
						
						
						//20140618 ��� ���ŵ�� ���� �� ���� �߼�
						
						//cont_view
						Hashtable cont = a_db.getContViewUseYCarCase(ins.getCar_mng_id());
						String rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
						String rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
						
						String car_num = String.valueOf(cont.get("CAR_NO"));
						String car_name = String.valueOf(cont.get("CAR_NM"));
																
						//�ŷ�ó
						ClientBean client = al_db.getClient(String.valueOf(cont.get("CLIENT_ID")));
				
						String subject 		= client.getFirm_nm()+"��, �ڵ������� ���� �ȳ������Դϴ�.";
																
						int seqidx		= 0;
		
				
						if(!client.getCon_agnt_email().equals("")){
							//	1. d-mail ���-------------------------------
							DmailBean d_bean = new DmailBean();
							d_bean.setSubject			(subject);
							d_bean.setSql				("SSV:"+client.getCon_agnt_email().trim());
							d_bean.setReject_slist_idx	(0);
							d_bean.setBlock_group_idx	(0);
							d_bean.setMailfrom			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
							d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+client.getCon_agnt_email().trim()+">");
							d_bean.setReplyto			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
							d_bean.setErrosto			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
							d_bean.setHtml				(1);
							d_bean.setEncoding			(0);
							d_bean.setCharset			("euc-kr");
							d_bean.setDuration_set		(1);
							d_bean.setClick_set			(0);
							d_bean.setSite_set			(0);
							d_bean.setAtc_set			(0);
							d_bean.setGubun				("insur");
							d_bean.setRname				("mail");
							d_bean.setMtype       		(0);
							d_bean.setU_idx       		(1);//admin����
							d_bean.setG_idx				(1);//admin����
							d_bean.setMsgflag     		(0);													
							d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/ins_gs_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&ins_start_dt="+ins.getIns_start_dt());
							d_bean.setV_content			("http://fms1.amazoncar.co.kr/mailing/ins/ins_gs_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&ins_start_dt="+ins.getIns_start_dt());
				
							seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");					
						}
							
						String ins_name = String.valueOf(ins_com.get("INS_COM_NM"));
						String ins_tel 	= "";
						if ( ins_name.equals("�Ｚȭ��") ) {
		    					ins_tel = "1588-5114 ";
						} else if  ( ins_name.equals("����ȭ��") || ins_name.equals("DB���غ���")) {
		    					ins_tel = "1588-0100";
		    			} else if  ( ins_name.equals("����ī��������") ) {
								ins_tel = "1661-7977 ";							
						}
						
						if(!String.valueOf(cont.get("BUS_ID2")).equals("")){
							user_bean 	= umd.getUsersBean(String.valueOf(cont.get("BUS_ID2")));
						}
		
						String etc1 = rent_l_cd;
						String etc2 = ck_acar_id;
						
						String sendname 	= "(��)�Ƹ���ī "+user_bean.getUser_nm();
						String sendphone 	= user_bean.getUser_m_tel();
						
						
						//String msg 		= "[�ڵ������� ����] ������ "+ ins_name + " "+ ins_tel +" ����⵿�� ����Ÿ�ڵ��� 1588-6688 �Դϴ�. (��)�Ƹ���ī ";
						String msg 		= client.getFirm_nm()+"���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�. ������ �뿩�ڵ��� ����ȸ�簡 ������ ���� ���ŵǾ������ �̿뿡 ���� ��Ź�帳�ϴ�. ������ ����� : "+ ins_name + " ("+ ins_tel +"), ����⵿ �� ���� : ����Ÿ����⵿ 1588-6688   (��)�Ƹ���ī www.amazoncar.co.kr ";
						
						//��� ����� ���� ���� ����
						Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
			
						String destphone 	= String.valueOf(sms.get("TEL"));			
						String destname 	= String.valueOf(sms.get("NM"));
						String customer_name =client.getFirm_nm();		// �� �̸�
						String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";								// ����⵿
														
						String marster_car_num = "1588-6688"; //������ �ڵ��� ����ó
						String sk_net_num = "1670-5494"; //sk��Ʈ���� ����ó
						
						String url_1 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
						String sos_url = ShortenUrlGoogle.getShortenUrl(url_1);
						
						Date today = new Date();
						SimpleDateFormat format = new SimpleDateFormat("yyyy�� MM�� dd��");
						String update_date = String.valueOf(format.format(today));
						
						if(!destphone.equals("")){
							//������ ����⵿ ���ڸ޼��� 
					    
							/* List<String> fieldList = Arrays.asList(customer_name, ins_name, ins_tel, sos_service_info);		
							at_db.sendMessageReserve("acar0112", fieldList, destphone,  sendphone, null , etc1,  etc2); */
							
							//acar0045-> acar0059 (������ȣ �߰�) -> acar0091 (��������) -> acar00112 (�ִ�ī����) -> acar0157 (sk��Ʈ���� �߰�) -> acar0232 -> acar0259
							List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, ins_name, ins_tel, update_date, AddUtil.ChangeDate2(ins.getIns_start_dt()), AddUtil.ChangeDate2(ins.getIns_exp_dt()), marster_car_num, sk_net_num, sos_url);
							at_db.sendMessageReserve("acar0259", fieldList, destphone,  sendphone, null , etc1,  etc2);
							
						}								
						
					result[i] = "�̹� ��ϵ� �����Դϴ�. �����ٹ̻������� �߰�ó�� ";	
				}else{
					result[i] = "�̹� ��ϵ� �����Դϴ�.";	
				}
				
			}
		
			//System.out.println(car_no+" �̹� ��ϵ� �����Դϴ�.");
			
		}
	}
	int ment_cnt=0;
	
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
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("���� ��ϵǾ����ϴ�.")) continue;
		ment_cnt++;%>
<input type='hidden' name='ins_con_no' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='car_no'     value='<%=value1[i] ==null?"":value1[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>