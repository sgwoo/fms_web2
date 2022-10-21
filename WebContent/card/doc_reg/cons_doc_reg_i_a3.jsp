<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.user_mng.*, acar.bill_mng.*, acar.car_service.*, acar.cus_reg.*, acar.consignment.* "%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String user_cont = request.getParameter("user_cont")==null?"":request.getParameter("user_cont");
	
	String ven_name 	= request.getParameter("ven_name")==null?"":request.getParameter("ven_name");
		
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 		= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_g2 = request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2");
	String buy_dt 		= request.getParameter("buy_dt")==null?"":request.getParameter("buy_dt");	
	String buy_user_id 	= request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id");
	String acct_code_s 	= request.getParameter("acct_code_s")==null?"":request.getParameter("acct_code_s");
	String siokno 		= request.getParameter("siokno")==null?"":request.getParameter("siokno");
	String cons_no 		= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	
	int buy_amt 		=request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt"));
	
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");  //����
	
	String currdate   = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	
	
	//�����Է����� ���� ���� - 20091015	
	String acct_cont[] 		= request.getParameterValues("acct_cont"); //���� : ���� �� ����ܴ̿� 1��
	String item_name[] 		= request.getParameterValues("item_name"); // car_no
	String rent_l_cd[] 		= request.getParameterValues("rent_l_cd"); //rent_l_cd
	String serv_id[] 		= request.getParameterValues("serv_id"); //����id
	String item_code[] 		= request.getParameterValues("item_code"); //car_mng_id
	
	//String buy_id = "";
	int flag = 0;
	
	String car_mng_id = item_code[0];
	
	String acct_cont0 = acct_cont[0];

	buy_dt = AddUtil.replace(buy_dt, "-", "");
	
	String item_name0 = item_name[0];

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String buy_user_nm = "";
	buy_user_nm = c_db.getNameById(buy_user_id, "USER"); //����ڸ� - ������, �����, ��������	
	
	out.println("��ǥ���"+"<br><br>");
	
	//����� buy_id ��������
	//buy_id = CardDb.getCardDocBuyIdNext(cardno);
	//out.println("buy_id="+buy_id+"<br><br>");
	
	//��ǥ����
	CardDocBean cd_bean = new CardDocBean();
	
	cd_bean.setCardno(cardno);
	cd_bean.setBuy_id(buy_id);
	cd_bean.setBuy_dt(buy_dt);
	cd_bean.setBuy_s_amt(request.getParameter("buy_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_s_amt")));
	cd_bean.setBuy_v_amt(request.getParameter("buy_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_v_amt")));
	cd_bean.setBuy_amt(buy_amt);
	cd_bean.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	cd_bean.setVen_name(ven_name);
	cd_bean.setAcct_code(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
	cd_bean.setAcct_cont(acct_cont0);

	cd_bean.setUser_su(request.getParameter("user_su")==null?"":request.getParameter("user_su"));
	cd_bean.setUser_cont(user_cont);
	cd_bean.setBuy_user_id(buy_user_id);
	cd_bean.setRent_l_cd(rent_l_cd[0]);
	cd_bean.setTax_yn(request.getParameter("tax_yn")==null?"N":request.getParameter("tax_yn"));
	cd_bean.setVen_st(request.getParameter("ven_st")==null?"1":request.getParameter("ven_st"));
	
	cd_bean.setReg_dt(currdate);
	
	cd_bean.setSiokno(siokno);		//���ݿ����� ���ι�ȣ ���
	
	cd_bean.setCons_no(cons_no+seq);	//Ź�۹�ȣ���

//System.out.println("cons_no+seq :"+cons_no+seq);	
//System.out.println("seq :"+seq);		
	
	
	//����������
	cd_bean.setAcct_code_g(request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g"));

	//������
	cd_bean.setAcct_code_g2(request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2"));
	
	//����������, �����
	cd_bean.setItem_code(item_code[0]);
	cd_bean.setItem_name(item_name0);		
	cd_bean.setAcct_cont(acct_cont0+ "(" + buy_user_nm + ")");


	//����������
	//if(acct_code.equals("00004")) {
	cd_bean.setO_cau	(request.getParameter("o_cau")==null?"":request.getParameter("o_cau"));
	cd_bean.setOil_liter	(request.getParameter("oil_liter")==null?0:AddUtil.parseFloat(AddUtil.parseDigit3(request.getParameter("oil_liter") ) )   );
	cd_bean.setTot_dist		(request.getParameter("tot_dist")==null?0:AddUtil.parseInt(request.getParameter("tot_dist") ) );
		
		
	//}
	
	
//System.out.println("user_id :"+user_id);		
	cd_bean.setReg_id(user_id);

	//if(!CardDb.insertCardDoc(cd_bean)) flag += 1; 
	if(!CardDb.updateCardDocScard(cd_bean)) flag += 1;

//System.out.println("ac: "+acct_code);	
//System.out.println("acg: "+acct_code_g2);
//System.out.println("bui: "+buy_user_id);
	
	
	//int tot_dist = request.getParameter("tot_dist")==null?0:AddUtil.parseInt(request.getParameter("tot_dist")) ; //����Ÿ�
	
	boolean flag1 = true;
		
	//if(acct_code.equals("00004")) {//������ ī����ǥ ��Ͻ� Service ���� �Է�.
		/*
		if(tot_dist > 1000 ) {  //����Ÿ��� 100���� ũ�� Service�� ���. - ī�������  ���� ��Ͼ��� 
			String serv_id2 = "";
			CusReg_Database cr_db = CusReg_Database.getInstance();
			CarServDatabase    	csD 	= CarServDatabase.getInstance();			
			
			CarInfoBean ci_bean = new CarInfoBean();
			
			ci_bean = cr_db.getCarInfo(car_mng_id);
			
			ServiceBean siBn = new ServiceBean();
			
			if ( !ci_bean.getRent_mng_id().equals("") ) { 
				siBn.setCar_mng_id	(car_mng_id);
				siBn.setRent_mng_id	(ci_bean.getRent_mng_id());
				siBn.setRent_l_cd	(ci_bean.getRent_l_cd());
				siBn.setServ_st		("1");  //��ȸ����
				siBn.setServ_dt		(buy_dt);
				siBn.setChecker		(user_id);
				siBn.setSpdchk_dt	(buy_dt);
				siBn.setTot_dist	(Integer.toString(request.getParameter("tot_dist")==null?0:AddUtil.parseInt(request.getParameter("tot_dist"))) );
				siBn.setReg_id		(user_id);
				
				serv_id2 = csD.insertService(siBn);
			}
		}
		*/
		
		// -  ����: ������ ���� Ź���Ƿڽ� car_mng_id�� ���� �� ������ rent_l_cd�� ó���ؾ� �� - 20141112, ������ �պ��ΰ�찡 �־ seq ���������ؼ�ó���ؾ� �� - 20141117
	if(acct_code.equals("00004")) {
		flag1 = cs_db.updateConsignmentOil_card_amt(cons_no, seq, rent_l_cd[0], request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")));
	} else {
		flag1 = cs_db.updateConsignmentWash_card_amt(cons_no, seq, rent_l_cd[0], request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")));	
	}	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
		
	function go_step(){	
		
			var fm = document.form1;
			alert("������ ��ĵ������ ����� �ֽñ� �ٶ��ϴ�.");
			scan_reg();
			fm.action = 'cons_settle_frame.jsp.jsp';
			fm.target = "_parent";
			fm.submit();
			
			parent.window.close();
	}
	
		//��ĵ���
function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&cardno=<%=cardno%>&buy_id=<%=buy_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action=''  target='d_content' method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='cardno' 	value='<%=cardno%>'>

</form>

<a href="javascript:go_step()">��������</a>

<script language='javascript'>
<!--
<%		if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%		}else{//����
				seq = String.valueOf(AddUtil.parseInt(seq)-1);
				%>
				alert("��ϵǾ����ϴ�.");
				var fm = parent.opener.document;
		<%	if(acct_code.equals("00004")) {	%>	
				fm.form1.oil_card_amt[<%=seq%>].value="<%=buy_amt%>";
		<% } else  {%>		
				fm.form1.wash_card_amt[<%=seq%>].value="<%=buy_amt%>";
		<% } %>		
				//fm.location.reload();
				parent.window.close();
		//go_step();
<%		}%>
//-->
</script>
</body>
</html>