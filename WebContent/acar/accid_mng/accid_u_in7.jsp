<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, tax.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");//���������ȣ
	String mode = request.getParameter("mode")==null?"7":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
			
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "02", "04");
	
	int acc_size = 0;
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	String client_id = "";
	client_id =  (String)cont.get("CLIENT_ID");
	
	String car_st = "";
	car_st =  (String)cont.get("CAR_ST");
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
		//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	int  max_nn = 0;
	int nn_cnt = 0;
	
	//����/����(��å��)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);

	if(serv_id.equals("") && s_r.length>0){
		for(int i=0; i<1; i++){
			s_bean2 = s_r[i];
			serv_id = s_bean2.getServ_id();
			
			//��û������ �ִٸ�
			if ( serv_id.substring(0,2).equals("NN")) {
			      max_nn = AddUtil.parseInt(serv_id.substring(2,6));					      	  			
			}
					
		}
	}
	
	
	// ����������
	acc_size = s_r.length;
	if (acc_size < max_nn ) {
		acc_size = max_nn;
	}	
	
	//��å�� ��û������ - �ϴ� ���Ƴ���
	if (serv_id.equals("")) serv_id = "NN0001";

	//����/����(��å��)
	ServiceBean s_bean = a_csd.getService(c_id, accid_id, serv_id);	
	
	String bus_id2 = "";
	//��å�� û����
	String req_dt = s_bean.getCust_req_dt();
		
	if ( !s_bean.getBus_id2().equals("")){
	 	bus_id2 = s_bean.getBus_id2();
	// 	req_dt = s_bean.getCust_req_dt();	 
	} else {
	    if ( !a_bean.getBus_id2().equals("") ) {  //�������� �����
	  	    bus_id2 = a_bean.getBus_id2();
	    } else {
			bus_id2 = (String)cont.get("BUS_ID2");
		}	
	}
	
	int s_cnt = 0;
	s_cnt = a_csd.getService(c_id, accid_id, serv_id, "1");	
		
	if ( s_cnt < 1) {
		req_dt = AddUtil.getDate();
	}
	
	
	if ( req_dt.equals("")){
		if ( !s_bean.getSac_dt().equals("")){ //
			req_dt = AddUtil.getDate();
		}
	}
	
  //  System.out.println("s_cnt="+s_cnt); 
	
	//û�������� ��ȸ
	TaxItemListBean ti = IssueDb.getTaxItemListServM(c_id, serv_id, s_bean.getCust_amt());
	
	//�ŷ����� ��ȸ
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(ti.getItem_id());
	
	if(ti_bean.getUse_yn().equals("N")){
		ti = new TaxItemListBean();
	}
	
	//���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean 		= IssueDb.getTax_itemId(ti.getItem_id());
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	
	//��å��û������
	Hashtable etc_cms = as_db.getRentCaseClient(m_id, l_cd);
	
	
	//��å�� ����û�� �������� - ��û�����Ե��� ������ �Ҽ� �ֵ��� ��.
	int dup_cnt = 0;
	dup_cnt = a_csd.getServCustCnt(c_id, accid_id);	
//	System.out.println("dup_cnt = " + dup_cnt);	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�����ϱ�
	function save(cmd){
	
		var fm = document.form1;	
								
		fm.cmd.value = cmd;
		var vat_chk_amt = 0;
		var vat_chk1_amt = 0;
		
			
		//���������� ������ ��꼭 ����
		if ( toInt(parseDigit(fm.cls_v_amt.value))  > 0 &&   fm.bill_doc_yn.value == '4'  ) {
		 	  alert("��������� ó���Ȱ��Դϴ�.  ���ݰ�꼭 ���౸���� Ȯ���ϼ���!!");
		 	  return;
		} 		
		
		<% if(  nm_db.getWorkAuthUser("������",user_id) ) { %>
		<% } else { %>
			//��å�� ��û���� �������� �ݾ� �Է� �Ұ� - 20140703 
			if ( fm.serv_id.value.substr(0,2)  =="NN"    &&  toInt(parseDigit(fm.cls_s_amt.value))  > 0  ) {		   
			       alert("��å�ݼ�û���ǿ� ��������ݾ��� �Է��� �� �����ϴ�.!!");
			       return;
			}
			
			if ( fm.serv_id.value.substr(0,2)  =="NN"    &&  toInt(parseDigit(fm.ext_amt.value))  > 0  ) {		   
			       alert("��å�ݼ�û���ǿ� ���Աݾ��� �Է��� �� �����ϴ�.!!");
			       return;
			}
	
		<%} %>
				
	//	if(fm.serv_id.value=="" || fm.off_id.value=="" ){ alert("�������-������ ���� �Է��� �ּ���."); return; }	
					
		//�ŷ����� �����Ƿ��� ��� ���ް�, �ΰ��� �ݾ�  - �ŷ������� ������� û������ üũ (û���ݾ��� �ִٸ� )
	//	if ( fm.bill_doc_yn.value == '4') {
		 	
			//������ ���Ա��� �ƴѰ�� 
			if ( toInt(parseDigit(fm.cls_s_amt.value))  > 0   ||  toInt(parseDigit(fm.ext_amt.value))  > 0 || fm.no_dft_yn.checked == true ) {
				
			} else {
			 
			 	if ( fm.cust_req_dt.value == ''  ) {
			 		  alert("û�����ڸ� Ȯ���ϼ���!!");
			 		  return;
			 	}
			 	
			 	if ( toInt(parseDigit(fm.cust_s_amt.value))  < 1  ) {
			 		  alert("û�����ް����� Ȯ���ϼ���!!");
			 		  return;
			 	}	
			 		 
			 	if ( toInt(parseDigit(fm.cust_v_amt.value))  > 1  ) {
			 		  alert("û���ΰ������� Ȯ���ϼ���!!");
			 		  return;
			 	}	
			}	      		         			 
	//	}
		
		if ( toInt(parseDigit(fm.cust_s_amt.value))  > 0 &&  toInt(parseDigit(fm.cls_s_amt.value))  > 0  ) {
		 		  alert("û���ݾװ� ��������ñݾ��� �����ԷµǾ����ϴ�. Ȯ���ϼ���!!");
		 		  return;
		} 	
		
		
		//���Աݾ� 
		if ( toInt(parseDigit(fm.ext_amt.value))  > 0  ) {
			if ( fm.ext_cau == ''  ) {
		 		  alert("���Աݳ����� Ȯ���ϼ���!!");
		 		  return;
		 	} 	
		}
		
		
		if ( toInt(parseDigit(fm.cust_v_amt.value))  > 1  ) {
		 		  alert("û���ΰ������� Ȯ���ϼ���!!");
		 		  return;
		} 		
	
	
		
		if ( toInt(parseDigit(fm.cls_v_amt.value))  >  1  ) {
		
			//û���ΰ������� 10% ���� Ȯ�� 
	//	 	vat_chk1_amt 	= toInt(  toInt(parseDigit(fm.cls_s_amt.value)) * 0.1  -   toInt(parseDigit(fm.cls_v_amt.value))) ;
		  		 
		// 	if (vat_chk1_amt == -1 || vat_chk1_amt == 1 || vat_chk1_amt == 0 ) {
		 //	} else {
		 	 	 alert("��������ΰ������� Ȯ���ϼ���!!");
		 		 return;
		 //	}		 	
		 } 	
		
		//�ߺ�üũ ���ϰ�
		if (  fm.user_id.value == '000063' || fm.user_id.value == '000029' ) {
		} else {
			// dup check
			if ( <%=dup_cnt%> > 0  &&  cmd == 'i'  ) {
			 	  alert("�̹� ��å���� û���Ͽ����ϴ�. Ȯ���ϼ���. !!");
				    return;		
			}	
	        }
		
		if ( cmd == 'i' ) {		
			if ( toInt(parseDigit(fm.cust_amt.value))  == 0 && toInt(parseDigit(fm.ext_amt.value))  == 0 && toInt(parseDigit(fm.cls_amt.value))  == 0 && fm.no_dft_cau.value == '') {
			 	 alert("�Է³����� Ȯ���ϼ���!!");
			 	 return;
			}	
		}		
						

		
		//Ÿ�̾���Ÿ�� ��å�� û���� warning
		if ( fm.off_id.value == '008634') {
			if ( toInt(parseDigit(fm.cust_s_amt.value))  > 1  ) {
				 alert("Ÿ�̾���Ÿ� ��å�� û���߽��ϴ�. ��å�� û���� �´��� �ٽ� �ѹ� Ȯ���ؼ� ó���ϼ���!!!!!!!");	
			} 
		}
				
			//��꼭�̹������θ�  - 20161201
		if ( fm.bill_doc_yn.value == '1') {
				 alert("��å���� ��꼭�� ������ �� �����ϴ�.!!!!!");
			 	 return;
		}	
				
		if ( fm.bill_doc_yn.value == '') {
				 alert("�ŷ����� ���������� �����ϼ���!!!!");
			 	 return;
		}	
				
			
		//û���ݾ� CHECK
		if(cmd == 'i'){ if(!confirm('����Ͻðڽ��ϱ�?')){return;}}
		else		  {	if(!confirm('�����Ͻðڽ��ϱ�?')){return;}}
		
	<% if(ti.getCar_mng_id().equals("")){%>	
		fm.biil_re_yn.value= "R";
	<%} %>	
		fm.target = "i_no";
		fm.action = "accid_u_a.jsp";
		fm.submit();
	}

	function view_serv_accid(serv_id){
		var fm = document.form1;	
	
		fm.serv_id.value = serv_id;
		fm.action='accid_u_in7.jsp';
		fm.target='_self';
		fm.submit();		
	}
	
		//û���ݾ�
	function set_cust_amt(){
		var fm = document.form1;
		
		fm.cust_amt.value 	= parseDecimal( toInt(parseDigit(fm.cust_s_amt.value)) + toInt(parseDigit(fm.cust_v_amt.value)));		
		
	}	
	
	//������ ���Աݾ�
	function set_cls_amt(){
		var fm = document.form1;
		
		fm.cls_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_s_amt.value)) + toInt(parseDigit(fm.cls_v_amt.value)));		
		
	}
	
	function reg_save(){
		var fm = document.form1;	
		fm.cmd.value= 'i';
		var s_num = '0000' + <%=acc_size+1%>;		
		var s_str = s_num.substring(s_num.length-4);
	    fm.serv_id.value= 'NN' + s_str ;
		fm.action='accid_u_in7.jsp';
		
		fm.target='_self';
		fm.submit();		
	}		
	
	//��å�� ����� �ݾ� Ȯ��
	function dft_sanction() {
		var fm = document.form1;
					
		if ( toInt(parseDigit(fm.cust_amt.value))  == 0 && toInt(parseDigit(fm.ext_amt.value))  == 0 && toInt(parseDigit(fm.cls_amt.value))  == 0 && fm.no_dft_cau.value == '') {
		 	 alert("�Է³����� Ȯ���ϼ���!!");
		 	 return;
		}	
		
		if ( fm.cust_req_dt.value == ''  ) {
			  alert("û�����ڸ� Ȯ���ϼ���!!");
			  return;
		}
		 	
		if ( fm.cust_plan_dt.value == ''  ) {
			  alert("�Աݿ������ڸ� Ȯ���ϼ���!!");
			  return;
		}
		 	
		 						
		if(confirm('��å�� �ݾ��� Ȯ���Ͻðڽ��ϱ�?')){	
			fm.action='accid_u_sac_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}
	
	
	//��å�� ���� --  ���� ����Ÿ�� ���� ��쿡 ���ؼ� 
	function accid_dft_del() {
		var fm = document.form1;
		
		
		//����Ȱ��� �����Ұ� 
	 if ( '<%=a_bean.getSettle_st()%>' == '1' ) {
	 	 alert("��� ������� ���� �� �� �����ϴ�.!!");
		 return;
	 
	 } 
					
		if ( toInt(parseDigit(fm.tot_amt.value)) > 0) {
		 	 alert("���񳻿��� �ִ� ��� �����Ұ��Դϴ�. ��å�� �ݾ� �������� ó���ϼ���!!");
		 	 return;
		}	
				 						
		if(confirm('��å�� �����Ͻðڽ��ϱ�?')){  //�ŷ����� ����Ȱ��̸� �ŷ������� ����ó�� �� �� 	
			fm.action='accid_u_del_sac_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}
	
	
	//�������μ�
	function DocPrint(){
		var fm = document.form1;
		//var SUBWIN="/tax/item_mng/doc_serv_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>";	
		var SUBWIN="/tax/item_mng/doc_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>";
		var firm_nm = '<%=cont.get("FIRM_NM")%>';
		var sub_rent_gu = '<%=a_bean.getSub_rent_gu()%>';
		if(firm_nm=='(��)�Ƹ���ī' && sub_rent_gu =='3'){
			SUBWIN="/tax/item_mng/doc_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>";
		}
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	}	
	
	//������߼�
	function reMail(){
		var SUBWIN="/acar/accid_mng/accid_u_in7_mail.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&from_page=accid_u_in7_mail.jsp";	
		
		window.open(SUBWIN, "TaxItem", "left=50, top=50, width=900, height=600, scrollbars=yes, status=yes");
	}	

	
	function serv_tax(){
	
		if(<%=s_bean.getCust_amt()%>==0){ alert('û���ݾ��� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 
		    return;		  
		} else {
			var fm = document.form1;		
		 	var SUBWIN="/tax/issue_3/serv_i_item_a.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>&client_id=<%=cont.get("CLIENT_ID")%>&bus_id2="+fm.bus_id2.value+"&item_id="+fm.item_id.value+"&cmd2=i";	
			window.open(SUBWIN, "DocReg", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	
		}	
	}
	
	function ViewTaxItem(){		
		var taxItemInvoice = window.open("about:blank", "TaxItem", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1000px, height=800px");
		var fm = document.form1;
		fm.target="TaxItem";
		fm.action = "/tax/issue_1_tax/tax_item_u.jsp";
		fm.submit();			
	}	
	
	
		//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
		
  //��å�� ����� Ȯ���� ��� 
	function get_cust_dt(){
		var fm = document.form1;
		
		if( fm.cust_req_dt.value == ""){ alert('û����¥�� �����ϴ�!!!.'); 
		    return;		  
		} else {		
			fm.target='i_no';
			fm.action='/acar/accid_mng/get_cust_dt_nodisplay.jsp';
			fm.submit();	
		}	
	}	
		
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='serv_tax_url' value=''>

    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='serv_id' value='<%=serv_id%>'>  
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <input type='hidden' name='l_cd2' value='<%=s_bean.getRent_l_cd()%>'> 
	<input type='hidden' name="item_id" value="<%=ti.getItem_id()%>"> 	
  <input type='hidden' name='client_id' value='<%=client_id%>'>
    <input type='hidden' name='off_id' value='<%=s_bean.getOff_id()%>'> 
      <input type='hidden' name='car_st' value='<%=car_st%>'>
      <input type='hidden' name='sac_yn' value='Y'>  
      <input type='hidden' name='biil_re_yn' value=''>  
 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="5%">����</td>
                    <td class=title width="10%">��������</td>
                    <td class=title width="25%">�����ü��</td>
                    <td class=title width="10%">����ݾ�</td>
                    <td class=title width="10%">û���ݾ�</td>
                    <td class=title width="10%">û������</td>
                    <td class=title width="10%">�Աݱݾ�</td>
                    <td class=title width="10%">�Ա�����</td>
                    <td class=title width="10%">��������</td>					
                </tr>
              <%for(int i=0; i<s_r.length; i++){
        			s_bean2 = s_r[i];%>
                <tr id='tr_one_accid' style="display:''"> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getServ_dt())%></td>
                    <td align="center">
                    <a href="javascript:view_serv_accid('<%=s_bean2.getServ_id()%>');"><%=s_bean2.getOff_nm()%>&nbsp;                  
                   <%if (  s_bean2.getRep_cont().equals("��å�� ��û����") )  {%><%=s_bean2.getRep_cont()%>&nbsp;  <% } %>
                    </a>                   
                   <%if ( s_bean2.getRep_cont().equals("��å�� ��û����") && s_bean2.getOff_id().equals("")  ) { %>
                   <a href="javascript:MM_openBrWindow('reg_serv_off.jsp?br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=s_bean2.getServ_id()%>&mode=<%=mode%>','popwin','scrollbars=no,status=no,resizable=no,left=100,top=120,width=500,height=200')"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a>
                  
                   <% } %>
                    </td>
                    <td align="right">
                     <% if ( s_bean2.getR_j_amt() > 0) { %>  
					 <%//=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf((s_bean2.getR_labor()+s_bean2.getR_j_amt())* 1.1)))%><%=AddUtil.parseDecimal(s_bean2.getTot_amt())%>
	                 <% } else { %>   
	                 <%=AddUtil.parseDecimal(s_bean2.getTot_amt())%>
	                 <% } %>
                    ��</td> 
                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getCust_amt())%>��</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_req_dt())%></td>
                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getExt_amt())%>��</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_pay_dt())%></td>
                    <td align="center"><%if(s_bean2.getNo_dft_yn().equals("Y")){%>����<%}%></td>						
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>	
       
    <tr> 
        <td>&nbsp;</td>
        <td align="right"> 
       
           <%	 if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id)  || a_bean.getSettle_st().equals("0")  ){%> 
          <a href='javascript:reg_save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_plus.gif" align="absmiddle" border="0"></a>
          <%    } %> 
        </td>
    </tr>
    	
    <tr>
        <td></td>
    </tr>
    
	<tr><td colspan=2 style='background-color:bebebe; height:1;'></td></tr>
	<tr><td><font color=red>�� ��å�� ��û���� �ݵ�� �ʼ��� �ƴմϴ�.  ���������  ��å��û���� ��û�����θ� �ݵ�� Ȯ���Ͻþ�, ����û������ �ʵ��� �����ϼ���!!! <br>
	                       	��  ��å���Աݿ������� �뿩�� �����Ϸ� ��û���� �ʴ� ��� û����+3�� (working day)�Դϴ� . 
	                                       <!--        �� ����û��, ��꼭 ���߹��� ���� ������ ���� ��û�� �Ұ�.(�����ذ�ñ���) --> </font></td>
	       <td>&nbsp;</td>
	
	<%if(!cms.getCms_bank().equals("")){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���ü</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                  <tr> 
                    <td class=title width=15%>CMS</td>
                    <td>&nbsp;
					  <b>
						<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
					  <%=cms.getCms_bank()%> <%=cms.getCms_acc_no()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (�ſ� <%=cms.getCms_day()%>��)
					  &nbsp;&nbsp;<a href="/fms2/con_fee/acms_list.jsp?acode=<%=l_cd%>" target="_blank"><img src=/acar/images/center/button_in_acms.gif border=0 align=absmiddle></a>
			
					</td>
					
					<td align="center" width=30%>
					<%if(etc_cms.get("ETC_CMS").equals("N")){%>
						�� ��å�� ���� �ź�
					<%}else{%>
						�� ��å�� ���� ���
					<%}%>
					</td>
					
                  </tr>
            </table>
        </td>
    </tr>	
     <tr>
        <td class=h></td>
    </tr>  
 <%}%>  	
     
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��å��</span></td>
        <td align="right"> 
      <%	if( s_cnt < 1 || ( s_bean.getSac_yn().equals("") && s_bean.getSac_dt().equals("") )  ){%>
		<a href='javascript:save("i")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
      <%	}else{ 
      			if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id) ){%> 
		<a href='javascript:save("u")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;&nbsp;
		<% if (  s_bean.getTot_amt() == 0 && s_bean.getCust_pay_dt().equals("")   ) {%>
		<a href='javascript:accid_dft_del()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
		 <% }%>
      <%		   }
      		} %>      
      	  
        </td>
    </tr>
   
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
           	  		
                <tr>                 
                    <td class=title>��������</td>
                    <td >&nbsp;<%=AddUtil.ChangeDate2(s_bean.getServ_dt())%></td>
                    <td  class=title>�����ü��</td>
                    <td >&nbsp;<%=s_bean.getOff_nm()%></td>
                    <td class=title>û������</td>
                    <td >&nbsp;<select name="paid_st">
                    	<option value="" <%if(s_bean.getPaid_st().equals("")){%>selected<%}%>>-����-</option>
                        <option value="1" <%if(s_bean.getPaid_st().equals("1")){%>selected<%}%>>��</option>
                        <option value="2" <%if(s_bean.getPaid_st().equals("2")){%>selected<%}%>>��Ÿ</option>
                        </select> 
                    </td>
                     <td class=title>���ݹ��</td>
                    <td >&nbsp;<select name="paid_type">
                        <option value="" <%if(s_bean.getPaid_type().equals("")){%>selected<%}%>>-����-</option>
                        <option value="1" <%if(s_bean.getPaid_type().equals("1")){%>selected<%}%>>CMS</option>
                        <option value="2" <%if(s_bean.getPaid_type().equals("2")){%>selected<%}%>>������</option>
                        </select> 
                    </td>
                    
                    <td class=title >���谡�Ը�å��</td>
                    <td width=14%>&nbsp; <input type="text" name="car_ja" value='<%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'> ��<br>&nbsp;&nbsp;(���ް�)</td>
              
                </tr>      
                <tr>      
                    <td class=title width=9%>û������</td>
                    <td width=12%>&nbsp; <input type="text" name="cust_req_dt"  value="<%=AddUtil.ChangeDate2(req_dt)%>" size="12" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>  
                    <td class=title width=9%>û�����ް���</td>
                    <td width=11%>&nbsp; <input type="text" name="cust_s_amt" value="<%=AddUtil.parseDecimal(s_bean.getCust_s_amt())%>" size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cust_amt();'>
                      ��</td>
                    <td class=title width=9%>û���ΰ�����</td>
                    <td width=10%>&nbsp; <input type="text" name="cust_v_amt" value="<%=AddUtil.parseDecimal(s_bean.getCust_v_amt())%>" size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cust_amt();'>
                      ��</td>
                    <td class=title width=9%>û���ݾ�</td>
                    <td width=11%>&nbsp; <input type="text" name="cust_amt"  readonly value="<%=AddUtil.parseDecimal(s_bean.getCust_amt())%>"" size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                     <td class=title width=9%>�Աݿ�����</td>
                    <td width=14%>&nbsp;                     
                    <input type="text"  name="cust_plan_dt" <% if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id) ){%> <% } else { %> readonly <%} %>  value="<%=AddUtil.ChangeDate2(s_bean.getCust_plan_dt())%>" size="12" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    <% if( s_bean.getCust_plan_dt().equals("")  ) { %>
                    <a href='javascript:get_cust_dt()' onMouseOver="window.status=''; return true" onFocus="this.blur()">[������Ȯ��]</a>                                
                    <br>&nbsp;&nbsp;<input type='checkbox' name='fee_r_yn' value="Y" >&nbsp;�뿩�������Ͽ� ��ݿ�û 
                    <% } %> 
                    
                    </td>
               </tr>
               
               <!-- ���Աݾ��� ����� �������� --20131017 -->
               <tr>                    
                    <td class=title>���Աݾ�</td>
                    <td width=12%>&nbsp; <input type="text" name="ext_amt"   <% if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id) ){%> <% } else { %> readonly <%} %>  value="<%=AddUtil.parseDecimal(s_bean.getExt_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                     ��</td>
                    <td class=title>���Աݳ���</td>
                    <td colspan=5 >&nbsp; <input type="text" name="ext_cau"   value="<%=s_bean.getExt_cau()%>"  size="80" class=text ></td>                  
                    <td class=title width=9%>�Ա���</td>
                    <td >&nbsp; <input type="text"  readonly name="cust_pay_dt" value='<%=AddUtil.ChangeDate2(s_bean.getCust_pay_dt())%>' size="12" class=text ></td>                
                </tr>
                
                <!-- serv_st :12 �� ��� ����ڰ� ��������ݾ� �Է� ������� ���� - 20130726 -->
                <tr>
                    <td class=title>���������<br>���ް���</td>
                    <td >&nbsp; <input type="text" name="cls_s_amt" 
                    <% if(   nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����Ʈ����",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id)  ){%> <% } else {   if  ( !s_bean.getServ_st().equals("12")    )  { %> readonly
                            <% } }%>   value="<%=AddUtil.parseDecimal(s_bean.getCls_s_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                      ��</td>  
                    <td class=title>���������<br>�ΰ�����</td>
                    <td >&nbsp; <input type="text" name="cls_v_amt"
                     <% if(   nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����Ʈ����",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id)   ){%> <% } else {   if  ( !s_bean.getServ_st().equals("12")    )  { %> readonly
                           <% } } %>  value="<%=AddUtil.parseDecimal(s_bean.getCls_v_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                      ��</td>  
                    <td class=title>���������<br>�ݾ�</td>
                    <td >&nbsp; <input type="text" name="cls_amt" readonly  value="<%=AddUtil.parseDecimal(s_bean.getCls_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td> 
                    <td class=title>�������</td>   
                    <td colspan=3>&nbsp;<select name='bus_id2'>
                        <option value="">������</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>   
                      
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;   <input type="hidden" name="tot_amt" value="<%=s_bean.getTot_amt()%>" >
                    <% if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id) ){%> 
                     <input type='checkbox' name='no_dft_yn' <% if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id) ){%> <% } else { %> readonly <%} %> value="Y" <%if(s_bean.getNo_dft_yn().equals("Y")){%> checked<%}%>> 
                     <% } else { %>
                    <input type="checkbox" name="no_dft_yn" value="Y"  onclick="return false;">
                    <% } %>                
                    </td>
                    <td class=title>��������</td>
                    <td colspan="7">&nbsp; <input type="text" name="no_dft_cau"   <% if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��å�ݰ�����",user_id) ){%> <% } else { %> readonly <%} %>  value="<%=s_bean.getNo_dft_cau()%>" size="100" class=text> 
                    </td>                 
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                  <tr>   <!--bill_doc : 3, 4: �ŷ������������� ��� -->
                    <td class=title width=12%>�ŷ����������û����</td>
                    <td width=35%>&nbsp;<select name="bill_doc_yn">
                        <option value="">����</option>
                        <option value="3" <%if(s_bean.getBill_doc_yn().equals("3")){%>selected<%}%>>�̹���</option>
                        <option value="4" <%if(s_bean.getBill_doc_yn().equals("4")){%>selected<%}%>>����</option> 
                    </select> 
                           
                         <% if(ti.getCar_mng_id().equals("")){%>	
                         	 <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
								<a href="javascript:serv_tax()"><img src="/acar/images/center/button_cgsbh.gif" align="absmiddle" border="0"></a>
							<%}%>
								(�ΰ����� ���� �ŷ������� ����˴ϴ�.)
						<%} %>
                                  
                      </td>                 
                    <td class=title width=12%>�Ա�ǥ�����û����</td>
                    <td width=35%>&nbsp;<select name="saleebill_yn">
                       <option value="">����</option>
                        <option value="0" <%if(s_bean.getSaleebill_yn().equals("0")){%>selected<%}%>>�̹���</option>
                        <option value="1" <%if(s_bean.getSaleebill_yn().equals("1")){%>selected<%}%>>����</option> 
                        </select> 
                        &nbsp;&nbsp;�����ּ�: <input type='text' size='40' name='agnt_email' value='<%=s_bean.getAgnt_email()%>'  maxlength='30' class='text' style='IME-MODE: inactive'>                         
                      </td>
                    
                  </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td colspan="2" align="right"><font color=red>�� �Ա�ǥ�����û�� �����ּҰ� ���� ��� ��꼭 ���Ÿ��Ϸ� ����˴ϴ�.!!!</font></td>          					  
    </tr>
  <%  if(!ti.getCar_mng_id().equals("")){%>		
    <tr> 
        <td colspan="2" align="right">
        <a href="javascript:reMail()"><img src="/acar/images/center/button_email_re_send.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
        <a href="javascript:DocPrint()"><img src="/acar/images/center/button_print_cgs.gif" align="absmiddle" border="0"></a>
		<%if(t_bean.getTax_no().equals("") && (nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || user_id.equals(bus_id2))){%>	  
	  	<!--&nbsp;&nbsp;<a href="javascript:ViewTaxItem()" title='�ŷ���������'><img src=/acar/images/center/button_modify_bill.gif align=absmiddle border=0></a>&nbsp;&nbsp;-->
	  	<%}%>
	</td>
    </tr>	
<% } %>		  

  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe>
</body>
</html>
