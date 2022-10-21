<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, tax.*, acar.accid.*, acar.car_service.*, acar.cont.*, acar.car_register.*,acar.user_mng.*, acar.res_search.*"%>
<jsp:useBean id="IssueDb" 	scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" 	scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" 	scope="page" class="acar.car_register.CarRegBean"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	CarRegDatabase crd 			= CarRegDatabase.getInstance();
	AccidDatabase as_db 		= AccidDatabase.getInstance();
	AddCarServDatabase a_csd 	= AddCarServDatabase.getInstance();
	
	out.println("�ŷ����� �����ϱ�"+"<br><br>");
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "11");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String bus_id2	 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String cmd	 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String cmd2	 	= request.getParameter("cmd2")==null?"":request.getParameter("cmd2");
	String cust_s_amt	 	= request.getParameter("cust_s_amt")==null?"":request.getParameter("cust_s_amt");
	String site_id		= "";
	
	
	String from_page	 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(car_mng_id, accid_id);
	
	//����/����(��å��)
	ServiceBean s_bean = a_csd.getService(car_mng_id, accid_id, serv_id);
		
	if ( bus_id2.equals("")) bus_id2 = user_id;
	
	//�ڵ�������
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//���:������
	ContBaseBean base 		= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	if(base.getTax_type().equals("2")){//����
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	
	
	 //�����ΰ��  
    if ( !a_bean.getRent_s_cd().equals("") ) {    	   				    	   
    	 //�ܱ�������
    		RentContBean rc_bean = rs_db.getRentContCase(a_bean.getRent_s_cd(), car_mng_id);	
    	 //������
    		RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());	    		
    		client_id = rc_bean2.getCust_id();				    						    	   
    }
	 
	
  //�ŷ�ó����
  	ClientBean client = al_db.getClient(client_id);
  	
	ClientSiteBean site = null; 
	if(!site_id.equals("")){
		//�ŷ�ó��������
		site = al_db.getClientSite(client_id, site_id);
		if(site.getEnp_no().equals("")){
			site_id = "";
		}
	}
	
	int flag = 0;
	TaxItemListBean til_bean = new TaxItemListBean();
	
	//String item_id = "";
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String reg_code  = Long.toString(System.currentTimeMillis());
	
		
	
	//20161227 ���� tax_item ������ ��� 
	if(item_id.equals("") && cmd2.equals("i")){ 
		//�����ڵ� ��������
	
	out.println("�����ڵ�="+reg_code+"<br>");
	
	//����� item_id ��������
	item_id = IssueDb.getItemIdNext(s_bean.getCust_req_dt());
	out.println("item_id="+item_id+"<br><br>");
	
	
	til_bean.setItem_id			(item_id);
	til_bean.setItem_seq		(1);
	til_bean.setItem_g			("��å��");
	til_bean.setItem_car_no	(cr_bean.getCar_no());
	til_bean.setItem_car_nm	(cr_bean.getCar_nm());
	til_bean.setItem_dt1		("");
	til_bean.setItem_dt2		("");
	til_bean.setItem_supply	(s_bean.getCust_amt());
	til_bean.setItem_value	(0);
	til_bean.setRent_l_cd		(rent_l_cd);
	til_bean.setCar_mng_id	(car_mng_id);
	til_bean.setTm					(serv_id);
	til_bean.setGubun				("7");
	til_bean.setReg_id			(bus_id2);
	til_bean.setReg_code		(reg_code);
	til_bean.setItem_dt			(s_bean.getCust_req_dt());
	til_bean.setCar_use			(cr_bean.getCar_use());
	til_bean.setEtc					(AddUtil.getDate3((a_bean.getAccid_dt()).substring(0,8))+" ���");
	
	
	if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
	//gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 
	
	
	//20161226 ���Ϲ߼۱���߰�
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	String con_agnt_nm			= "";
	String con_agnt_email		= "";
	String con_agnt_m_tel		= "";
	String con_agnt_nm2			= "";
	String con_agnt_email2		= "";
	String con_agnt_m_tel2		= "";
	
	if(!site_id.equals("")){
		con_agnt_nm			= site.getAgnt_nm();
		con_agnt_email		= site.getAgnt_email();
		con_agnt_m_tel		= site.getAgnt_m_tel();
		con_agnt_nm2			= site.getAgnt_nm2();
		con_agnt_email2		= site.getAgnt_email2();
		con_agnt_m_tel2		= site.getAgnt_m_tel2();
	}else{
		con_agnt_nm			= client.getCon_agnt_nm();
		con_agnt_email		= client.getCon_agnt_email();
		con_agnt_m_tel		= client.getCon_agnt_m_tel();
		con_agnt_nm2			= client.getCon_agnt_nm2();
		con_agnt_email2		= client.getCon_agnt_email2();
		con_agnt_m_tel2		= client.getCon_agnt_m_tel2();
	}
	
	
	//[2�ܰ�] �ŷ����� ����
	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		TaxItemBean ti_bean = new TaxItemBean();
		ti_bean.setClient_id	(client_id);
		ti_bean.setSeq			(site_id);
		ti_bean.setItem_dt		(s_bean.getCust_req_dt());
		ti_bean.setTax_id		("");
		ti_bean.setItem_id		(String.valueOf(ht.get("ITEM_ID")));
		ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"��");
		ti_bean.setItem_hap_num	(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
		ti_bean.setItem_man		(String.valueOf(ht.get("ITEM_MAN")));
		ti_bean.setItem_dt		(String.valueOf(ht.get("ITEM_DT")));
		ti_bean.setTax_item_etc	("");
		
		if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
	}
	
		//�����
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	if(!item_id.equals("")){
		
		//���ν��� ȣ��
		int flag5 = 0;
		String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm, con_agnt_email, con_agnt_m_tel);
		if(!con_agnt_email2.equals("")){
			d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm2, con_agnt_email2, con_agnt_m_tel2);
		}	
		System.out.println(d_flag2);
		if (!d_flag2.equals("0")) flag5 = 1;
		System.out.println(" �ŷ����� ���� ���ν��� �ڵ����"+item_id + ","+ sender_bean.getUser_nm() +","+ con_agnt_nm + "," + con_agnt_email);
		}
	
	}else if(cmd2.equals("u") && !cust_s_amt.equals("0")){
		int flag3 = 0;
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		ti_bean.setUse_yn			("N");
		if(!IssueDb.updateTaxItem(ti_bean)) flag3 += 1;
		cmd2 ="u";
	}
		
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = '/tax/item_mng/doc_print.jsp';
		<%if(cmd2.equals("u")){%>
		window.open("about:blank","_self").close();
		<%}else{%>
			fm.submit();
			opener.location.reload();
		<%}%>
		
		
		
		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
<input type='hidden' name='accid_id' 	value='<%=accid_id%>'>
<input type='hidden' name='serv_id' 	value='<%=serv_id%>'>
<input type='hidden' name='item_id' 	value='<%=item_id%>'>
</form>
<a href="javascript:go_step()">2�ܰ�� ����</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�
		//�̹� �ۼ��� �ŷ����� ����Ʈ ����
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("�ŷ����� ����Ʈ �ۼ��� ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
