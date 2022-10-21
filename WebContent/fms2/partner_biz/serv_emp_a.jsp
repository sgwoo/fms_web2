<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*, acar.partner.*, acar.pay_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="emp_Bn" class="acar.partner.Serv_EmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	int count = 0;
	int count2 = 0;
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String off_nm = request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String off_st = request.getParameter("off_st")==null?"":request.getParameter("off_st");
	String off_tel = request.getParameter("off_tel")==null?"":request.getParameter("off_tel");
	String off_post = request.getParameter("off_post")==null?"":request.getParameter("off_post");
	String off_addr = request.getParameter("off_addr")==null?"":request.getParameter("off_addr");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String bank = request.getParameter("bank")==null?"":request.getParameter("bank");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String acc_no = request.getParameter("acc_no")==null?"":request.getParameter("acc_no");
	String acc_nm = request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm");
	String acc_note = request.getParameter("acc_note")==null?"":request.getParameter("acc_note");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String close_dt = request.getParameter("close_dt")==null?"":request.getParameter("close_dt");
	String deal_note = request.getParameter("deal_note")==null?"":request.getParameter("deal_note");
	String gubun_b 	= request.getParameter("gubun_b")==null?"":request.getParameter("gubun_b");
	String off_type 	= request.getParameter("off_type")==null?"1":request.getParameter("off_type");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String emp_nm 	= request.getParameter("emp_nm")==null?"":request.getParameter("emp_nm");

	int seq = request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String dept_nm 	= request.getParameter("dept_nm")==null?"":request.getParameter("dept_nm");
	String pos 	= request.getParameter("pos")==null?"":request.getParameter("pos");
	String emp_level 	= request.getParameter("emp_level")==null?"":request.getParameter("emp_level");
	String emp_tel 	= request.getParameter("emp_tel")==null?"":request.getParameter("emp_tel");
	String emp_htel 	= request.getParameter("emp_htel")==null?"":request.getParameter("emp_htel");
	String emp_fax 	= request.getParameter("emp_fax")==null?"":request.getParameter("emp_fax");
	String emp_mtel 	= request.getParameter("emp_mtel")==null?"":request.getParameter("emp_mtel");
	String emp_email 	= request.getParameter("emp_email")==null?"":request.getParameter("emp_email");
	String emp_role 	= request.getParameter("emp_role")==null?"":request.getParameter("emp_role");
	String emp_valid 	= request.getParameter("emp_valid")==null?"":request.getParameter("emp_valid");
	String emp_addr 	= request.getParameter("emp_addr")==null?"":request.getParameter("emp_addr");
	String emp_post 	= request.getParameter("emp_post")==null?"":request.getParameter("emp_post");
	
//	String emp_email_yn 	= request.getParameter("emp_email_yn")==null?"":request.getParameter("emp_email_yn");
	
	off_st = "7";
	String text = "";
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	if(cmd.equals("off_i")){//ȸ����
		//���¾�ü ����ߺ� Ȯ��
		Hashtable ht = se_dt.getServOffChk(off_nm);
		
		if(ht.size()!=0){
			text = "�̹� ��ϵ� ��ȣ���� �ֽ��ϴ�. Ȯ�����ּ���.";
			count = 0;
		}else{
			if(!bank_id.equals("")){
				bank_id = bank.substring(0,4);
			}
			c61_soBn.setCar_comp_id(car_comp_id);  	//��������
			c61_soBn.setOff_nm(off_nm); 						//��ȣ
			c61_soBn.setOff_st(off_st); 							//7
			c61_soBn.setBr_id(br_id); 							//����/����
			c61_soBn.setOff_tel(off_tel); 						//��ǥ��ȭ
			c61_soBn.setOff_post(off_post); 					//�����ȣ
			c61_soBn.setOff_addr(off_addr); 					//�ּ�
			c61_soBn.setAcc_no(acc_no);						//���¹�ȣ
			c61_soBn.setAcc_note(acc_note);					//����
			c61_soBn.setNote(note);								//�ŷ�����
			c61_soBn.setReg_id(user_id);						//�����
			c61_soBn.setStart_dt(start_dt);					//���ʰŷ���������
			c61_soBn.setClose_dt(close_dt);					//�ŷ���������
			c61_soBn.setDeal_note(deal_note);				//���
			c61_soBn.setGubun_b(gubun_b);					//������ ����(1=����, 2=��������, 3=ĳ��Ż, 4=ī��)
			
			count = se_dt.insertServOff(c61_soBn, bank_id);
			
			/*
               20200420 ������ �ڵ���� �߰��� �ʿ䰡 ����.
			//�����翬��ó�� �ڵ嵵 ���� ����(20190701)
			Hashtable ht2 = ps_db.getFinanceCode(off_nm);
			
			if(ht2.size()==0 && count==1){	//������ �ڵ���
				CodeBean c_bean = new CodeBean();
				c_bean.setC_st("0003");
				c_bean.setNm_cd(off_nm);
				c_bean.setNm(off_nm);
				String gubun_e = "";
				if(AddUtil.parseInt(gubun_b)>2){	gubun_e="3";}else{	gubun_e = gubun_b;		} 
				c_bean.setGubun(	gubun_e);
				boolean flag = ps_db.insertFinanceCode(c_bean);
				if(flag==false){
					count = 0;
					text = "������ �ڵ��� ����!";
				}
			}
			*/
		}
		
	}else if(cmd.equals("off_u")){//ȸ�����
	
		c61_soBn.setOff_id(off_id);  							//off_id
		c61_soBn.setCar_comp_id(car_comp_id);  	//��������
		c61_soBn.setOff_nm(off_nm); 						//��ȣ
		c61_soBn.setOff_st(off_st); 							//7
		c61_soBn.setBr_id(br_id); 							//����/����
		c61_soBn.setOff_tel(off_tel); 						//��ǥ��ȭ
		c61_soBn.setOff_post(off_post); 					//�����ȣ
		c61_soBn.setOff_addr(off_addr); 					//�ּ�
		c61_soBn.setNote(note);								//�ŷ�����
		c61_soBn.setUpd_id(user_id);						//������
		c61_soBn.setStart_dt(start_dt);					//���ʰŷ���������
		c61_soBn.setClose_dt(close_dt);					//�ŷ���������
		c61_soBn.setDeal_note(deal_note);				//���
		c61_soBn.setGubun_b(gubun_b);					//������ ����(1=����, 2=��������, 3=ĳ��Ż, 4=ī��)
		c61_soBn.setCpt_cd(cpt_cd);					//�������ڵ�
		count = se_dt.updateServOff(c61_soBn);
	
	}else if(cmd.equals("emp_i")){//����ڵ��
	
		emp_Bn.setOff_id(off_id);	
		emp_Bn.setEmp_nm(emp_nm);
		emp_Bn.setDept_nm(dept_nm);
		emp_Bn.setPos(pos);
		emp_Bn.setEmp_level(emp_level);
		emp_Bn.setEmp_tel(emp_tel);
		emp_Bn.setEmp_htel(emp_htel);
		emp_Bn.setEmp_fax(emp_fax);
		emp_Bn.setEmp_mtel(emp_mtel);
		emp_Bn.setEmp_email(emp_email.trim());
		emp_Bn.setEmp_role(emp_role);
		emp_Bn.setEmp_valid(emp_valid);
		emp_Bn.setEmp_addr(emp_addr);
		emp_Bn.setEmp_post(emp_post);
		emp_Bn.setEmp_email_yn("Y");	//����(2018.04.03)
		
		count = se_dt.insertServEmp(emp_Bn);
		
	}else if(cmd.equals("emp_u")){ //����� ����

		emp_Bn.setOff_id(off_id);	
		emp_Bn.setSeq(seq);
		emp_Bn.setEmp_nm(emp_nm);
		emp_Bn.setDept_nm(dept_nm);
		emp_Bn.setPos(pos);
		emp_Bn.setEmp_level(emp_level);
		emp_Bn.setEmp_tel(emp_tel);
		emp_Bn.setEmp_htel(emp_htel);
		emp_Bn.setEmp_fax(emp_fax);
		emp_Bn.setEmp_mtel(emp_mtel);
		emp_Bn.setEmp_email(emp_email.trim());
		emp_Bn.setEmp_role(emp_role);
		emp_Bn.setEmp_valid(emp_valid);
		emp_Bn.setEmp_addr(emp_addr);
		emp_Bn.setEmp_post(emp_post);
		
		count = se_dt.updateServEmp(emp_Bn);
	}
%> 
	
<html>
<head>
<title>FMS</title>
</head>
<body>
<script language="JavaScript">
<!--
	//alert('<%=count%> : ó����� ���°�');
	
<% if(count==1){ %>
	<%if(cmd.equals("emp_i")||cmd.equals("off_i") ){%>
	alert("���������� ��ϵǾ����ϴ�.");
	<%}else if(cmd.equals("emp_u")||cmd.equals("off_u")){%>
	alert("���������� �����Ǿ����ϴ�.");
	<%}%>
	<%//if(from_page.equals("/fms2/partner_biz/serv_emp_frame.jsp")){%>
	parent.opener.location.reload();
	parent.close();
	<%//}%>
	
<% }else{ %>
	<%if(!text.equals("")){%>
		alert('<%=text%>');
	<%}else{%>
		alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n�����ڴԲ� �����ϼ���!");
		parent.close();
	<%}%>
<% } %>
//-->
</script>
</body>
</html>