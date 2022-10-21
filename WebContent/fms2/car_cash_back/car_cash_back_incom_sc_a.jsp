<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.out_car.*, acar.bill_mng.*, acar.coolmsg.*, acar.user_mng.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String size 		= request.getParameter("size")==null?"":request.getParameter("size");
	String incom_st 	= request.getParameter("incom_st")==null?"":request.getParameter("incom_st");
	
	String incom_dt 	= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	long   incom_amt 	= request.getParameter("incom_amt")==null?0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String autodoc_yn 	= request.getParameter("autodoc_yn")==null?"":request.getParameter("autodoc_yn");
		
	//String tran_date_seq 	= request.getParameter("tran_date_seq")==null?"":request.getParameter("tran_date_seq");
	//String acct_seq 	= request.getParameter("acct_seq")==null?"":request.getParameter("acct_seq");
	//String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	//String bank_nm 	= request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	//String bank_no 	= request.getParameter("bank_no")==null?"":request.getParameter("bank_no");
	
	String tran_date_seq[] 	= request.getParameterValues("tran_date_seq");
	String acct_seq[] 		= request.getParameterValues("acct_seq");
	String bank_id[] 		= request.getParameterValues("bank_id");
	String bank_nm[] 		= request.getParameterValues("bank_nm");
	String bank_no[] 		= request.getParameterValues("bank_no");
	String bank_incom_dt[] 	= request.getParameterValues("bank_incom_dt");

	String serial[] 		= request.getParameterValues("serial");
	String base_amt[] 		= request.getParameterValues("base_amt");
	String base_incom_amt[] = request.getParameterValues("base_incom_amt");
	String m_amt[] 			= request.getParameterValues("m_amt");
	String rest_amt[] 		= request.getParameterValues("rest_amt");
	String incom_bigo[] 	= request.getParameterValues("incom_bigo");
	String incom_bigo2[] 	= request.getParameterValues("incom_bigo2");
	
	int flag = 0;
	boolean flag2 = true;
	long total_m_amt = 0;
	String cont = "";
	int cnt = 0; 
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	OutStatBean f_scd_bean = new OutStatBean();
	
	//���������-����
	Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(ck_acar_id));
	String insert_id = String.valueOf(per.get("SA_CODE"));
	
	String target_id = nm_db.getWorkAuthUser("��ü���ĳ����-�Ǹ������");
	UsersBean target_bean = umd.getUsersBean(target_id);	
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	for(int i=0; i < serial.length; i++){
		
		//ī��ĳ���齺����
		OutStatBean scd_bean = oc_db.getCarCashBackBase(AddUtil.parseInt(serial[i]));
		
		scd_bean.setIncom_dt		(incom_dt);
		
		scd_bean.setIncom_amt		(base_incom_amt[i]==null?0 :AddUtil.parseDigit4(base_incom_amt[i]));
		scd_bean.setIncom_bigo		(incom_bigo[i]==null?"" :incom_bigo[i]);
		scd_bean.setM_amt			(m_amt[i]==null?0 :AddUtil.parseDigit4(m_amt[i]));
		
		if(scd_bean.getIncom_amt() == 0 ){
			scd_bean.setM_amt(0);
		}
		
		total_m_amt = total_m_amt + scd_bean.getM_amt();
		
		if(i==0) cont = scd_bean.getBase_bigo();
		
		if(scd_bean.getIncom_amt()+scd_bean.getM_amt() >0 || scd_bean.getIncom_amt()+scd_bean.getM_amt() < 0){
			//����
			if(incom_st.equals("2")){
				scd_bean.setIncom_seq		(acct_seq[0]+""+incom_dt+""+tran_date_seq[0]);
				scd_bean.setBank_id			(bank_id[0]);
				scd_bean.setBank_nm			(bank_nm[0]);
				scd_bean.setBank_no			(bank_no[0]);
				
				if(i==0){
					//�����Ա� ����ó��
					if(!ib_db.updateIbAcctTallTrDdFmsYnCardCashback(acct_seq[0]+""+AddUtil.getReplace_dt(incom_dt)+""+tran_date_seq[0])) flag += 1;
				}
			}else{
				scd_bean.setIncom_seq		(acct_seq[i]+""+incom_dt+""+tran_date_seq[i]);
				scd_bean.setBank_id			(bank_id[i]);
				scd_bean.setBank_nm			(bank_nm[i]);
				scd_bean.setBank_no			(bank_no[i]);	
				
				//if(!bank_incom_dt[i].equals("")){
				//	scd_bean.setIncom_dt	(bank_incom_dt[i]);
				//}
				
				//�����Ա� ����ó��
				if(!ib_db.updateIbAcctTallTrDdFmsYnCardCashback(acct_seq[i]+""+AddUtil.getReplace_dt(scd_bean.getIncom_dt())+""+tran_date_seq[i])) flag += 1;
			}
				
			//�Ա�ó��
			if(!oc_db.updateCarStatScd(scd_bean)) flag += 1;
			
			//�ڵ���ǥ ����
			if(autodoc_yn.equals("Y")){
							
				//���� ���뿹�� 10300
				Hashtable ht1 = new Hashtable();
				ht1.put("DEPT_CODE",  	"200");
				ht1.put("INSERT_ID",	insert_id);
				ht1.put("WRITE_DATE", 	scd_bean.getIncom_dt());
				ht1.put("AMT_GUBUN",  	"3");//����
				ht1.put("ACCT_CODE",  	"10300");
				ht1.put("DR_AMT",    	String.valueOf(base_incom_amt[i]));
				ht1.put("CR_AMT",     	"0");
				ht1.put("CHECKD_CODE1",	scd_bean.getBank_id());//�������
				ht1.put("CHECKD_CODE2",	scd_bean.getBank_no());//�����ݰ���
				ht1.put("CHECKD_NAME4",	"[�̼���]"+scd_bean.getBase_bigo());//����
				
				//�뺯 ������ 25900 -> �̼��� 12000
				Hashtable ht2 = new Hashtable();
				ht2.put("DEPT_CODE",  	"200");
				ht2.put("INSERT_ID",	insert_id);
				ht2.put("WRITE_DATE", 	scd_bean.getIncom_dt());
				ht2.put("AMT_GUBUN",  	"4");//����
				ht2.put("ACCT_CODE",  	"12000");
				ht2.put("DR_AMT",    	"0");
				ht2.put("CR_AMT",     	String.valueOf(scd_bean.getBase_amt()));
				ht2.put("CHECKD_CODE1",	scd_bean.getVen_code());//�ŷ�ó
				ht2.put("CHECKD_NAME4",	"[�̼���]"+scd_bean.getBase_bigo());//����
				
				vt.add(ht1);
				vt.add(ht2);

				//��ս�
				if(scd_bean.getM_amt() > 0 ){
					//���� ��ս� 96000
					Hashtable ht3 = new Hashtable();
					ht3.put("DEPT_CODE",  	"200");
					ht3.put("INSERT_ID",	insert_id);
					ht3.put("WRITE_DATE", 	scd_bean.getIncom_dt());
					ht3.put("AMT_GUBUN",  	"3");//����
					ht3.put("ACCT_CODE",  	"96000");
					ht3.put("DR_AMT",    	String.valueOf(scd_bean.getM_amt()));
					ht3.put("CR_AMT",     	"0");
					ht3.put("CHECKD_CODE4",	scd_bean.getVen_code());//�ŷ�ó		
					ht3.put("CHECKD_NAME5",	"[�̼���]"+scd_bean.getBase_bigo());//����		
					vt.add(ht3);
				}
				//������
				if(scd_bean.getM_amt() < 0 ){
					//�뺯 ������ 93000
					Hashtable ht3 = new Hashtable();
					ht3.put("DEPT_CODE",  	"200");
					ht3.put("INSERT_ID",	insert_id);
					ht3.put("WRITE_DATE", 	scd_bean.getIncom_dt());
					ht3.put("AMT_GUBUN",  	"4");//����
					ht3.put("ACCT_CODE",  	"93000");
					ht3.put("DR_AMT",    	"0");
					ht3.put("CR_AMT",     	String.valueOf(-1*scd_bean.getM_amt()));
					ht3.put("CHECKD_CODE4",	scd_bean.getVen_code());//�ŷ�ó
					ht3.put("CHECKD_NAME5",	"[�̼���]"+scd_bean.getBase_bigo());//����	
					vt.add(ht3);
				}
				
				
				vt_size++;
				
				//String row_id2 = neoe_db.insertDebtSettleAutoDocu(scd_bean.getIncom_dt(), vt);	
				
				//vt = new Vector();
				
				if(scd_bean.getM_amt() > 5000 || scd_bean.getM_amt() < -5000){
					cont = "�Ǹ��������Ȳ �Ա� �ݾ��� ���̳��ϴ�. Ȯ���Ͻʽÿ�.  &lt;br&gt; &lt;br&gt; ["+incom_dt+"] "+ scd_bean.getBase_bigo();
					
					//Ȯ�θ޽��� �߼�
					String xml_data = "";
					xml_data =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
				  				"    <BACKIMG>4</BACKIMG>"+
				  				"    <MSGTYPE>104</MSGTYPE>"+
				  				"    <SUB>�Ǹ������</SUB>"+
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
					
					flag2 = cm_db.insertCoolMsg(msg);
					
				}				
				
			}			
		}
	}
	
	if(vt_size>0){
		String row_id = neoe_db.insertDebtSettleAutoDocu(incom_dt, vt);
	}
	
	

	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'car_cash_back_incom_sc.jsp';
		fm.target = "c_foot";
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='car_off_id' 	value='<%=car_off_id%>'>
</form>
<a href="javascript:go_step()">��������</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("ó���Ǿ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
