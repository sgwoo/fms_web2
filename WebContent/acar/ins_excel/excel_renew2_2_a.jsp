<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*, acar.bill_mng.*, acar.user_mng.*,  acar.im_email.*, tax.*, acar.cont.*, acar.client.*"%>
<%@ page import="acar.kakao.*" %>

<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	//������ ���� ����� �̽��߻��� : ���谡�Ե�Ϻ� ������ ������ ������, ��ǥ������ �ȵȰ� ó��	
	
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	
	String ins_start_dt 	= request.getParameter("ins_start_dt")==null?"":AddUtil.replace(request.getParameter("ins_start_dt"),"-","");	//����-���������
	String ins_est_dt 	= request.getParameter("ins_est_dt")==null?"":AddUtil.replace(request.getParameter("ins_est_dt"),"-","");	//����-���������
	
	Vector inss = ai_db.getInsRegExcelErrorList(ins_start_dt, "1");
	int ins_size = inss.size();
	

	out.println("ins_start_dt="+ins_start_dt);
	out.println("ins_est_dt="+ins_est_dt);
			
			
	for (int i = 0 ; i < ins_size ; i++){
 		Hashtable ht = (Hashtable)inss.elementAt(i);		
	
	
		//��������
		InsurBean ins = ai_db.getInsCase(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("INS_ST")));


		out.println("car_mng_id="+ins.getCar_mng_id());
		out.println("ins_st="+ins.getCar_mng_id());
	
	
		//������ ����ó��-----------------------------------------------
		if(!ai_db.changeInsSts(ins.getCar_mng_id(), AddUtil.parseInt(ins.getIns_st())-1, "2"))	flag += 1;
		
		out.println("������ ����ó��");
					
						
						//���谻�� ������ ���------------------------------------------
						
						//1ȸ��
						InsurScdBean scd = new InsurScdBean();
						scd.setCar_mng_id	(ins.getCar_mng_id());
						scd.setIns_st		(ins.getIns_st());
						scd.setIns_tm		("1");																														
						scd.setIns_est_dt	(ins_est_dt);
						scd.setR_ins_est_dt	(ai_db.getValidDt(scd.getIns_est_dt()));//������/�ָ��� ��� ������ ó��												
						scd.setPay_amt		(AddUtil.parseInt(String.valueOf(ht.get("TOT_AMT"))));
						scd.setPay_dt		("");
						scd.setPay_yn		("0");
						scd.setIns_tm2		("0");
						
						if(!ai_db.insertInsScd(scd)) flag += 1;
						
		out.println("���谻�� ������ ���");	
		
		
					//�ڵ���ǥó���Ѱ��� ���ٸ� �ٽ� ����
					Vector fi_vt = neoe_db.getFI_ADOCU_LIST(ins.getIns_rent_dt(), "ins_add", String.valueOf(ht.get("CAR_NO")));
					int fi_size = fi_vt.size();		
		
					if(fi_size==0){
		
							
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
			
						if(ins.getIns_st().equals("0")) 			acct_cont = acct_cont+ " �ű� ���� ("+String.valueOf(ht.get("CAR_NO"))+")";
						else  							acct_cont = acct_cont+ " ���� ���� ("+String.valueOf(ht.get("CAR_NO"))+")";
			
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
						ht1.put("DR_AMT",    	scd.getPay_amt());
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
						ht2.put("CR_AMT",     	scd.getPay_amt());
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

				
							String row_id = neoe_db.insertDebtSettleAutoDocu(ins.getIns_start_dt(), vt);	//-> neoe_db ��ȯ
				
							if(row_id.equals("")){
								count = 1;
							}
						}
						
		out.println("�ڵ���ǥó����");												
						
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
						
						
						String msg 		= client.getFirm_nm()+"���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�. ������ �뿩�ڵ��� ����ȸ�簡 ������ ���� ���ŵǾ������ �̿뿡 ���� ��Ź�帳�ϴ�. ������ ����� : "+ ins_name + " ("+ ins_tel +"), ����⵿ �� ���� : ����Ÿ����⵿ 1588-6688   (��)�Ƹ���ī www.amazoncar.co.kr ";
						
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
							
             				//acar0045-> acar0059 (������ȣ �߰�) -> acar0091 (��������) -> acar00112 (�ִ�ī����) -> acar0157 (sk��Ʈ���� �߰�) -> acar0232	 -> acar0259						
              				List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, ins_name, ins_tel, update_date, AddUtil.ChangeDate2(ins.getIns_start_dt()), AddUtil.ChangeDate2(ins.getIns_exp_dt()), marster_car_num, sk_net_num, sos_url);
							at_db.sendMessageReserve("acar0259", fieldList, destphone,  sendphone, null , etc1,  etc2);
						}
						
					}	
				
			
		out.println("<br>");																									

	}
	int ment_cnt=0;
	
	
	
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

<SCRIPT LANGUAGE="JavaScript">
<!--		

//-->
</SCRIPT>
</BODY>
</HTML>