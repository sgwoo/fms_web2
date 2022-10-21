<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*, acar.car_register.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	out.println("���ݰ�꼭 �����ϱ� 1�ܰ�"+"<br><br>");
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "11");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_dt 		= request.getParameter("tax_dt")==null?"":request.getParameter("tax_dt");
	String seq_no 		= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String rent_s_cd	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String cust_st		= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	
	String count 		= request.getParameter("count")==null?"":request.getParameter("count");
	String i_site_id 	= request.getParameter("i_site_id")==null?"":request.getParameter("i_site_id");
	String o_br_id 		= request.getParameter("o_br_id")==null?"":request.getParameter("o_br_id");
	String tax_g 		= request.getParameter("tax_g")==null?"":request.getParameter("tax_g");
	String tax_bigo 	= request.getParameter("tax_bigo")==null?"":request.getParameter("tax_bigo");
	String req_y 		= request.getParameter("req_y")==null?"":request.getParameter("req_y");	
	String req_m 		= request.getParameter("req_m")==null?"":AddUtil.addZero(request.getParameter("req_m"));	
	String req_d 		= request.getParameter("req_d")==null?"":AddUtil.addZero(request.getParameter("req_d"));	
	String tax_bigo_t 	= request.getParameter("tax_bigo_t")==null?"":request.getParameter("tax_bigo_t");
	String tax_bigo_50 	= request.getParameter("tax_bigo_50")==null?"":request.getParameter("tax_bigo_50");
	
	String con_agnt_nm 		= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	String con_agnt_nm2 		= request.getParameter("con_agnt_nm2")==null?"":request.getParameter("con_agnt_nm2");
	String con_agnt_dept2 	= request.getParameter("con_agnt_dept2")==null?"":request.getParameter("con_agnt_dept2");
	String con_agnt_title2 	= request.getParameter("con_agnt_title2")==null?"":request.getParameter("con_agnt_title2");
	String con_agnt_email2 	= request.getParameter("con_agnt_email2")==null?"":request.getParameter("con_agnt_email2");
	String con_agnt_m_tel2 	= request.getParameter("con_agnt_m_tel2")==null?"":request.getParameter("con_agnt_m_tel2");	
	String pubform		 	= request.getParameter("pubform")==null?"":request.getParameter("pubform");
	String car_use		 	= request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String i_taxregno 	= request.getParameter("i_taxregno")==null?"":request.getParameter("i_taxregno");
	
	String o_client_id 	= request.getParameter("o_client_id")==null?"":request.getParameter("o_client_id");
	
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	if(!o_client_id.equals("") && !o_client_id.equals(client_id)){
		ClientBean client2 = al_db.getClient(client_id); //����� �� ����
		con_agnt_nm 	= client2.getCon_agnt_nm();
		con_agnt_dept 	= client2.getCon_agnt_dept();
		con_agnt_title 	= client2.getCon_agnt_title();
		con_agnt_email 	= client2.getCon_agnt_email();
		con_agnt_m_tel 	= client2.getCon_agnt_m_tel();	
		con_agnt_nm2 	= client2.getCon_agnt_nm2();
		con_agnt_dept2 	= client2.getCon_agnt_dept2();
		con_agnt_title2 = client2.getCon_agnt_title2();
		con_agnt_email2 = client2.getCon_agnt_email2();
		con_agnt_m_tel2 = client2.getCon_agnt_m_tel2();
		
		out.println(o_client_id+" ");
		out.println(client2.getCon_agnt_email()+" ");
		out.println(con_agnt_email+" ");
	}
		
	String seq[] 		= request.getParameterValues("seq");
	String item_g[] 	= request.getParameterValues("item_g");
	String item_car_no[] 	= request.getParameterValues("item_car_no");
	String item_car_nm[] 	= request.getParameterValues("item_car_nm");
	String item_dt1[] 	= request.getParameterValues("item_dt1");
	String item_dt2[] 	= request.getParameterValues("item_dt2");
	String item_supply[] 	= request.getParameterValues("item_supply");
	String item_value[] 	= request.getParameterValues("item_value");
	String item_amt[] 	= request.getParameterValues("item_amt");
	String l_cd[] 		= request.getParameterValues("l_cd");
	String c_id[] 		= request.getParameterValues("c_id");
	String tm[] 		= request.getParameterValues("tm");
	String rent_st[] 	= request.getParameterValues("rent_st");
	
	String item_id = "";
	String reg_gu = "";
	int vid_size = 0;
	int flag = 0;
	int notreg = 0;
	
	vid_size = l_cd.length;
	
	if(req_dt.equals("")) 			req_dt=req_y+req_m+req_d;
	if(tax_dt.equals("")) 			tax_dt = req_dt;
	
	if(reg_gu.equals("3_9")){
		tax_dt = tax_dt;
	}
	
	
	out.println("���ðǼ� ="+count+"<br><br>");	
	out.println("�ŷ����� ����Ʈ�� ="+vid_size+"<br><br>");
	//if(1==1)return;

	//�����ڵ� ��������
	String reg_code  = Long.toString(System.currentTimeMillis());
	out.println("�����ڵ�="+reg_code+"<br>");

	//����� item_id ��������
	item_id = IssueDb.getItemIdNext(req_y+req_m+req_d);
	out.println("item_id="+item_id+"<br><br>");

	//int for_i = 0;
	//if(reg_gu.equals("3_9")){
	//	for_i = 1;
	//}
	
	//[1�ܰ�] �ŷ����� ����Ʈ ����
	for(int i=0;i < vid_size;i++){
		
		
		String today 		= AddUtil.getDate(4);
		//���ݰ�꼭���ڰ� ���ú��� ũ�� ó������.
		if(AddUtil.parseInt(AddUtil.replace(tax_dt,"-","")) > AddUtil.parseInt(today)){
			notreg++;
			System.out.println(item_id+":���ݰ�꼭���ڰ� ���ú��� ũ�� ó������");
			
			continue;
		}
		
		TaxItemListBean til_bean = new TaxItemListBean();
		
		
		if(AddUtil.parseDigit(item_supply[i]) >0 || AddUtil.parseDigit(item_supply[i]) <0){
			
			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(AddUtil.parseInt(seq[i]));
			til_bean.setItem_g(item_g[i]);
			if(!item_car_no[i].equals("�̵��")){
				til_bean.setItem_car_no(item_car_no[i]);
			}
			til_bean.setItem_car_nm(item_car_nm[i]);
			til_bean.setItem_dt1(item_dt1[i]);
			til_bean.setItem_dt2(item_dt2[i]);
			til_bean.setItem_supply(AddUtil.parseDigit(item_supply[i]));
			til_bean.setItem_value(AddUtil.parseDigit(item_value[i]));
			til_bean.setRent_l_cd(l_cd[i]);
			til_bean.setCar_mng_id(c_id[i]);
			til_bean.setTm(tm[i]);
			til_bean.setRent_st(rent_st[i]==null?"":rent_st[i]);
			if(item_g[i].equals("������")){
				til_bean.setGubun("3");
			}else if(item_g[i].equals("���ô뿩��")){
			 	til_bean.setGubun("4");
			}else if(item_g[i].equals("�����")){
				til_bean.setGubun("5");
			}else if(item_g[i].equals("�����Ű����")){
				til_bean.setGubun("6");
			}else if(item_g[i].equals("����������")){
				til_bean.setGubun("7");
			}else if(item_g[i].equals("�������ظ�å��")){
				til_bean.setGubun("7");
			}else if(item_g[i].equals("�������� ������")){
				til_bean.setGubun("7");
			}else if(item_g[i].equals("���·�")){
				til_bean.setGubun("8");
			}else if(item_g[i].equals("�ܱ�뿩")){
				til_bean.setGubun("9");
			}else if(item_g[i].equals("����Ʈ")){
				til_bean.setGubun("16");
			}else if(item_g[i].equals("�������")){
				til_bean.setGubun("17");
			}else if(item_g[i].equals("�������")){
			 	til_bean.setGubun("10");
			}else if(item_g[i].equals("������")){
			 	til_bean.setGubun("11");
				til_bean.setRent_seq(seq_no);
			}else if(item_g[i].equals("������")){
			 	til_bean.setGubun("12");
			}else if(item_g[i].equals("�°������")){
			 	til_bean.setGubun("14");
			}
			
			//ī���ĳ�������-�ι���ī
			if(car_use.equals("4")){
				til_bean.setGubun("7");
			}
			
			til_bean.setReg_id		(user_id);
			til_bean.setReg_code		(reg_code);
			til_bean.setItem_dt		(tax_dt);
			
			til_bean.setCar_use		(car_use);
			
			//�����������
			if(til_bean.getCar_use().equals("") && !til_bean.getCar_mng_id().equals("")){
				cr_bean = crd.getCarRegBean(til_bean.getCar_mng_id());
				til_bean.setCar_use		(cr_bean.getCar_use());
			}
			
			
			if(reg_gu.equals("3_9") && til_bean.getItem_supply() == 0) continue;
			
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
			//gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩, 14 �°������, 15 ��������, 16 ����Ʈ, 17 �������, 18 ĳ������� 
			
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'tax_reg_step2.jsp';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' 	value='<%=client_id%>'>
<input type='hidden' name='site_id' 	value='<%=i_site_id%>'>
<input type='hidden' name='reccotaxregno' value='<%=i_taxregno%>'>
<input type='hidden' name='brch_id' 	value='<%=o_br_id%>'>
<input type='hidden' name='tax_g' 		value='<%=tax_g%>'>
<input type='hidden' name='tax_bigo' 	value='<%=tax_bigo%>'>
<input type='hidden' name='tax_bigo_t' 	value='<%=tax_bigo_t%>'>
<input type='hidden' name='tax_dt' 		value='<%=tax_dt%>'>
<input type='hidden' name='tax_bigo_50'	value='<%=tax_bigo_50%>'>

<%if(gubun1.equals("6") || gubun1.equals("9")){%>
<input type='hidden' name='req_dt' 		value='<%=req_dt%>'>
<%}else{%>
<input type='hidden' name='req_dt' 		value='<%=req_y+req_m+req_d%>'>
<%}%>
<input type='hidden' name='reg_gu' 		value='3_<%=gubun1%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='item_list_cnt' value='<%=vid_size%>'>

<input type='hidden' name='con_agnt_nm' 	value='<%=con_agnt_nm%>'>
<input type='hidden' name='con_agnt_dept' 	value='<%=con_agnt_dept%>'>
<input type='hidden' name='con_agnt_title' 	value='<%=con_agnt_title%>'>
<input type='hidden' name='con_agnt_email' 	value='<%=con_agnt_email%>'>
<input type='hidden' name='con_agnt_m_tel' 	value='<%=con_agnt_m_tel%>'>
<input type='hidden' name='con_agnt_nm2' 		value='<%=con_agnt_nm2%>'>
<input type='hidden' name='con_agnt_dept2' 	value='<%=con_agnt_dept2%>'>
<input type='hidden' name='con_agnt_title2' value='<%=con_agnt_title2%>'>
<input type='hidden' name='con_agnt_email2' value='<%=con_agnt_email2%>'>
<input type='hidden' name='con_agnt_m_tel2' value='<%=con_agnt_m_tel2%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>
<input type="hidden" name="rent_s_cd" value="<%=rent_s_cd%>">      
<input type="hidden" name="cust_st" value="<%=cust_st%>">             
<input type="hidden" name="pubform" value="<%=pubform%>">             

</form>
<a href="javascript:go_step()">2�ܰ�� ����</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�
		//�̹� �ۼ��� �ŷ����� ����Ʈ ����
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("�ŷ����� ����Ʈ �ۼ��� ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>

		<%if(notreg > 0){%>
			alert('���ݰ�꼭���ڰ� ���ú��� Ŀ ������� �ʽ��ϴ�');
		<%}else{%>
			go_step();
		<%}%>

<%	}%>
//-->
</script>
</body>
</html>
