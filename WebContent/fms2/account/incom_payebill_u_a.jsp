<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,  acar.ext.*, acar.bill_mng.*, acar.common.*, tax.*,  acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String trusbill_gubun 	= request.getParameter("trusbill_gubun")==null?"":request.getParameter("trusbill_gubun");  //cash:���cashback 
	String SeqId 	= request.getParameter("seqid")==null?"":request.getParameter("seqid"); // ���� ������ ������
	
	String tm 	= request.getParameter("tm")==null?"":request.getParameter("tm");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String ext_id 	= request.getParameter("ext_id")==null?"":request.getParameter("ext_id");
		
	String pay_dt	= request.getParameter("pay_dt")==null?Util.getDate():request.getParameter("pay_dt");
	
	int pay_amt		= request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	
	String ebill	= request.getParameter("ebill")==null?"N":request.getParameter("ebill");
	String tax_branch= request.getParameter("tax_branch")==null?"S1":request.getParameter("tax_branch");
	String enp_no	= request.getParameter("enp_no")==null?"":request.getParameter("enp_no");
	String ssn		= request.getParameter("ssn")==null?"":request.getParameter("ssn");
	String bigo		= request.getParameter("bigo")==null?"":request.getParameter("bigo");
	
	String client_st		= request.getParameter("client_st")==null?"":request.getParameter("client_st");
	String foreigner		= request.getParameter("foreigner")==null?"":request.getParameter("foreigner");
	
	int flag = 0;
	int flag2 = 0;
	int flag3 = 0;
		
	String from_page 	= "";	

	from_page = "/fms2/account/incom_d_frame.jsp";	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	
	//�Ҽӿ����� ����Ʈ ��ȸ
	Hashtable br = c_db.getBranch("S1"); //������ ���� 

	if (SeqId.equals("")) {

		//�����Ա�ǥ�Ϸù�ȣ
	 	SeqId = IssueDb.getSeqIdNext("PayEBill","PE");
		out.println("SeqId ="+SeqId+"<br>");
    }

	
	//�Ա�ǥ����----------------------------
	if(ebill.equals("Y")){
	
		SaleEBillBean sb_bean = new SaleEBillBean();
		
		sb_bean.setSeqID		(SeqId);
		sb_bean.setDocCode		("03");
		sb_bean.setRefCoRegNo	("");
		sb_bean.setRefCoName	("");
		sb_bean.setTaxSNum1		("");
		sb_bean.setTaxSNum2		("");
		sb_bean.setTaxSNum3		("");
		sb_bean.setDocAttr		("N");
		sb_bean.setOrigin		("");
		sb_bean.setPubDate		(pay_dt);
		sb_bean.setSystemCode	("KF");
		
		sb_bean.setDocKind		("03");
		sb_bean.setS_EbillKind	("1");//1:�Ϲ��Ա�ǥ 2:����Ź�Ա�ǥ					
							
		//������------------------------------------------------------------------------------
		sb_bean.setMemID		("amazoncar11");
		sb_bean.setMemName		(user_bean.getUser_nm());
	//	sb_bean.setMemName		("�̼���"); //����� setting //
		sb_bean.setEmail		("tax@amazoncar.co.kr");				//��꼭 ��� ���� �ּ�
		sb_bean.setTel			("02-392-4243");
	
		sb_bean.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
		sb_bean.setCoName		("(��)�Ƹ���ī");
		sb_bean.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
		sb_bean.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
		sb_bean.setCoBizType	(String.valueOf(br.get("BR_STA")));
		sb_bean.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
		//���޹޴���--------------------------------------------------------------------------
		
		sb_bean.setRecMemID		("");
		sb_bean.setRecMemName	(request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm"));
		sb_bean.setRecEMail		(request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email"));
		sb_bean.setRecTel		(request.getParameter("tel")==null?"":request.getParameter("tel"));
		
		//���޹޴��ڰ� �����϶��� �����ϴ��� ó��
	//	if(enp_no.length() == 13){
	//		sb_bean.setRemarks	(bigo+"-"+ssn + "-" + l_cd);
	//		sb_bean.setRecCoRegNo("0000000000");
	//	}else{
	//		sb_bean.setRemarks	(bigo+  "-" + l_cd );
	//		sb_bean.setRecCoRegNo(enp_no);
	//	}
		
		sb_bean.setRemarks	(bigo+  "-" + l_cd );
		sb_bean.setRecCoRegNo(enp_no);
		
		//�ܱ����̰� ������ ��� 
		if (foreigner.equals("2") && client_st.equals("2") ) {
			sb_bean.setRecCoRegNo("0000000000");
			sb_bean.setRemarks	(bigo+  "-" + l_cd+ "-" + ssn);
		}
										
		sb_bean.setItemName1	(bigo+  "-" + l_cd  );
				
		sb_bean.setRecCoName	(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
		sb_bean.setRecCoCeo		(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
		sb_bean.setRecCoAddr	(request.getParameter("addr")==null?"":request.getParameter("addr"));
		sb_bean.setRecCoBizType	(request.getParameter("i_sta")==null?"":request.getParameter("i_sta"));
		sb_bean.setRecCoBizSub	(request.getParameter("i_item")==null?"":request.getParameter("i_item"));
		//����-----------------------------------------------------------------------------------
		sb_bean.setSupPrice		(pay_amt);
		sb_bean.setTax			(0);
		sb_bean.setPubKind		("N");
		sb_bean.setLoadStatus	(0);
		sb_bean.setPubCode		("");
		sb_bean.setPubStatus	("");
		sb_bean.setClient_id	(client_id);
		
		if(!IssueDb.insertPayEBill(sb_bean)){
			flag3 += 1;
		} else {
		   
			//�̵���ȭ�� ������ �Աݹ��� �ȳ����ڸ� ������.
			String agnt_m_tel	= request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel");
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			if(!agnt_m_tel.equals("")){
				String sendname = "(��)�Ƹ���ī";
				String sendphone = "02-392-4243";
				if(!agnt_m_tel.equals("")){
					IssueDb.insertsendMail(sendphone, sendname, agnt_m_tel, firm_nm, "", "+0.01", firm_nm+"�� �Ա�ǥ�� �����Ͽ����ϴ�.-�Ƹ���ī-");
				}
			}
		}
		
		if ( trusbill_gubun.equals("grt") || trusbill_gubun.equals("car_ja") || trusbill_gubun.equals("commi") ) {		
			if(flag3 == 0){
				if (ebill.equals("Y") ) {
				   if ( trusbill_gubun.equals("car_ja") ) {
				  	 	if(!ae_db.updateScdExtSeqId(m_id, l_cd, rent_st, ext_id, tm, SeqId, trusbill_gubun ))	flag += 1;
				   } else {
				   		if(!ae_db.updateScdExtSeqId(m_id, l_cd, rent_st, tm, SeqId, trusbill_gubun ))	flag += 1;
				   }	
				}
			}			
			
		} else {
			if(flag3 == 0){
							
				PayBean pay_bean = new PayBean();
				
				if(ebill.equals("Y") ){
					pay_bean.setRent_mng_id(m_id);
					pay_bean.setRent_l_cd(l_cd);
					pay_bean.setClient_id(client_id);
					pay_bean.setSeqid(SeqId);
					pay_bean.setGubun(trusbill_gubun);
					pay_bean.setPay_amt(pay_amt);
					pay_bean.setPay_dt(pay_dt);
					pay_bean.setReg_id(user_id);
					if(!IssueDb.insertPayIncom(pay_bean)) flag += 1;	
				}
			}
		}	
		
	}

%>
<html>
<head><title>FMS</title></head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>

</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('�����߻�!');
		location='about:blank';
<%	}else if(flag3 == 1){%>
		alert('�Ա�ǥ���� �����߻�!');
		location='about:blank';	

<%	}else{%>
		alert('ó���Ǿ����ϴ�');
		parent.opener.location.href = "<%=from_page%>";
		parent.window.close();	
<%	}%>
</script>
</body>
</html>
