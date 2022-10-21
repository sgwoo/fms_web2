<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,  acar.bill_mng.*, acar.common.*, tax.*,  acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String trusbill_gubun 	= request.getParameter("trusbill_gubun")==null?"":request.getParameter("trusbill_gubun");
	
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 	= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_st 	= request.getParameter("car_st")==null?"":request.getParameter("car_st");
		
	String item_dt	= request.getParameter("item_dt")==null?Util.getDate():request.getParameter("item_dt");
	
	int pay_amt		= request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	
	
	String tax_branch= request.getParameter("tax_branch")==null?"S1":request.getParameter("tax_branch");
	String enp_no	= request.getParameter("enp_no")==null?"":request.getParameter("enp_no");
	String ssn		= request.getParameter("ssn")==null?"":request.getParameter("ssn");
	String bigo		= request.getParameter("bigo")==null?"":request.getParameter("bigo");
	
	int flag = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag5 = 0;
		
	String from_page 	= "";	

	from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	
	//�Ҽӿ����� ����Ʈ ��ȸ
	Hashtable br = c_db.getBranch("S1"); //������ ���� 
	
	
	TaxItemListBean til_bean = new TaxItemListBean();
		
	String item_id = "";
	String gubun_nm ="";
		
	//�����ڵ� ��������
	String reg_code  = Long.toString(System.currentTimeMillis());
	out.println("�����ڵ�="+reg_code+"<br>");
	
	//����� item_id ��������
	item_id = IssueDb.getItemIdNext(item_dt);
	out.println("item_id="+item_id+"<br><br>");
		
	if(trusbill_gubun.equals("dft")){
	  	gubun_nm = "�����";
	}else if(trusbill_gubun.equals("etc4")){
		gubun_nm = "��Ÿ���ع���";
	}
		
	til_bean.setItem_id		(item_id);
	til_bean.setItem_seq	(1);
	til_bean.setItem_g("���������");
	til_bean.setItem_car_no	(car_no);
	til_bean.setItem_car_nm	(car_nm);
	til_bean.setItem_dt1	("");
	til_bean.setItem_dt2	("");
	til_bean.setItem_supply	(pay_amt);
	til_bean.setItem_value	(0);
	til_bean.setRent_l_cd	(l_cd);
	til_bean.setCar_mng_id	(c_id);	
	til_bean.setGubun	("15");
	til_bean.setReg_id	(user_id);
	til_bean.setReg_code	(reg_code);
	til_bean.setItem_dt	(item_dt);
	til_bean.setCar_use	(car_st);
	til_bean.setEtc(gubun_nm);
	
	if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
	//gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 
		
	
	//[2�ܰ�] �ŷ����� ����
	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		TaxItemBean ti_bean = new TaxItemBean();
		ti_bean.setClient_id	(client_id);
		ti_bean.setSeq		(site_id);
		ti_bean.setItem_dt	(item_dt);
		ti_bean.setTax_id	("");
		ti_bean.setItem_id	(String.valueOf(ht.get("ITEM_ID")));
		ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"��");
		ti_bean.setItem_hap_num	(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
		ti_bean.setItem_man	(String.valueOf(ht.get("ITEM_MAN")));
		ti_bean.setItem_dt	(String.valueOf(ht.get("ITEM_DT")));
		
		if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
	}
	
	//�̵���ȭ�� ������ �Աݹ��� �ȳ����ڸ� ������.
	String agnt_nm	= request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm");
	String agnt_email	= request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email");
	String agnt_m_tel	= request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel");
	String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	if(!agnt_m_tel.equals("")){
		String sendname = "(��)�Ƹ���ī";
		String sendphone = "02-392-4243";
		if(!agnt_m_tel.equals("")){
			IssueDb.insertsendMail(sendphone, sendname, agnt_m_tel, firm_nm, "", "+0.01", firm_nm+"�� �ŷ������� �����Ͽ����ϴ�.-�Ƹ���ī-");
		}
	}
		
	if(!item_id.equals("")){
		
		//���ν��� ȣ��
		
		String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", user_bean.getUser_nm(), reg_code, item_id, agnt_nm, agnt_email, agnt_m_tel);
//		System.out.println(d_flag2);
		if (!d_flag2.equals("0")) flag5 = 1;
//		System.out.println(" �ŷ����� ���� ���ν��� ���(�����) "+item_id);
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
<%	}else if(flag5 == 1){%>
		alert('�ŷ��������� �����߻�!');
		location='about:blank';	

<%	}else{%>
		alert('ó���Ǿ����ϴ�');
		parent.opener.location.href = "<%=from_page%>";
		parent.window.close();	
<%	}%>
</script>
</body>
</html>
