<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*, acar.user_mng.*, acar.client.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	out.println("���ݰ�꼭 ����"+"<br><br>");
	
	String tax_no	 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String item_id	 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_size	= request.getParameter("item_size")==null?"":request.getParameter("item_size");
	String doctype	 	= request.getParameter("doctype")==null?"":request.getParameter("doctype");
	
	String pubform	 	= request.getParameter("pubform")==null?"":request.getParameter("pubform");
	String reccoregnotype	= request.getParameter("reccoregnotype")==null?"":request.getParameter("reccoregnotype");
	
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	
	int flag = 0;
	int vid_size = 0;
	
	//�����
	UsersBean o_sender_bean 	= umd.getUsersBean(user_id);
	
	String o_br_id[] 		= request.getParameterValues("o_br_id");
	String tax_dt[] 		= request.getParameterValues("tax_dt");
	String tax_supply[]	 	= request.getParameterValues("tax_supply");
	String tax_value[] 		= request.getParameterValues("tax_value");
	String tax_g[] 			= request.getParameterValues("tax_g");
	String tax_bigo[] 		= request.getParameterValues("tax_bigo");
	
	String reccoregno[] 		= request.getParameterValues("reccoregno");
	String recconame[] 		= request.getParameterValues("recconame");
	String reccoceo[] 		= request.getParameterValues("reccoceo");
	String reccoaddr[] 		= request.getParameterValues("reccoaddr");
	String reccobiztype[] 		= request.getParameterValues("reccobiztype");
	String reccobizsub[] 		= request.getParameterValues("reccobizsub");
	String rectel[] 		= request.getParameterValues("rectel");
	String con_agnt_nm[] 		= request.getParameterValues("con_agnt_nm");
	String reccossn[] 		= request.getParameterValues("reccossn");
	String reccotaxregno[] 		= request.getParameterValues("reccotaxregno");
	
	String item_dt[] 		= request.getParameterValues("item_dt");
	String item_seq[] 		= request.getParameterValues("item_seq");
	String item_g[] 		= request.getParameterValues("item_g");
	String item_car_no[]		= request.getParameterValues("item_car_no");
	String item_car_nm[]		= request.getParameterValues("item_car_nm");
	String item_dt1[] 		= request.getParameterValues("item_dt1");
	String item_dt2[] 		= request.getParameterValues("item_dt2");
	String item_supply[]		= request.getParameterValues("item_supply");
	String item_value[] 		= request.getParameterValues("item_value");
	String del_chk[] 		= request.getParameterValues("del_chk");
	String item_hap_num		= request.getParameter("item_hap_num")==null?"":request.getParameter("item_hap_num");
	String ven_code[] 		= request.getParameterValues("ven_code");
	
	String tax_supply02[] 	= request.getParameterValues("tax_supply02");
	String tax_supply03[] 	= request.getParameterValues("tax_supply03");
	String tax_supply04[] 	= request.getParameterValues("tax_supply04");
	String tax_value02[] 	= request.getParameterValues("tax_value02");
	String tax_value03[] 	= request.getParameterValues("tax_value03");
	String tax_value04[] 	= request.getParameterValues("tax_value04");
	
	String tax_supply_st02	= request.getParameter("tax_supply_st02")==null?"":request.getParameter("tax_supply_st02");
	String tax_supply_st03	= request.getParameter("tax_supply_st03")==null?"":request.getParameter("tax_supply_st03");
	String tax_supply_st04	= request.getParameter("tax_supply_st04")==null?"":request.getParameter("tax_supply_st04");
	
	String tax_bigo03	= request.getParameter("tax_bigo03")==null?"":request.getParameter("tax_bigo03");
	
	String doctype_01_dt = request.getParameter("doctype_01_dt")==null?"":request.getParameter("doctype_01_dt");
	
	
	if(!item_id.equals("")){
		vid_size = item_seq.length;
	}
	
	out.println("�����ڵ�="+doctype+"<br><br>");
	out.println("���� ��꼭��ȣ="+tax_no+"<br><br>");
	
	//�����ڵ� ��������
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	
	//���� ���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	
	//���� �ŷ����� ��ȸ
	TaxItemBean ti_bean 		= IssueDb.getTaxItemCase(item_id);
	
	//���� �ŷ����� ����Ʈ
	Vector tils	            	= IssueDb.getTaxItemListCase(item_id);
	int til_size            	= tils.size();
	
	//���� ����û���ι�ȣ
	String org_nts_issueid = IssueDb.getOrgNtsIssueid(t_bean.getResseq());
	
	//�ŷ�ó����
	ClientBean client = al_db.getClient(t_bean.getClient_id());
	
	if(!t_bean.getSeq().equals("")){
		//�ŷ�ó��������
		ClientSiteBean site = al_db.getClientSite(t_bean.getClient_id(), t_bean.getSeq());
		
		client.setCon_agnt_nm	(site.getAgnt_nm());
		client.setCon_agnt_dept	(site.getAgnt_dept());
		client.setCon_agnt_title(site.getAgnt_title());
		client.setCon_agnt_email(site.getAgnt_email().trim());
		client.setCon_agnt_m_tel(site.getAgnt_m_tel());
		
		client.setCon_agnt_nm2	(site.getAgnt_nm2());
		client.setCon_agnt_dept2(site.getAgnt_dept2());
		client.setCon_agnt_title2(site.getAgnt_title2());
		client.setCon_agnt_email2(site.getAgnt_email2().trim());
		client.setCon_agnt_m_tel2(site.getAgnt_m_tel2());

	}
	
	
	//���� ���ݰ�꼭�� ���޹޴��� ����Ÿ ���°��
	if(t_bean.getRecCoRegNo().equals("")){
		t_bean.setRecTel			(rectel[1]	==null?"":rectel[1]);
		t_bean.setRecCoRegNo		(reccoregno[1]	==null?"":AddUtil.replace(AddUtil.replace(reccoregno[1]," ",""),"-",""));
		t_bean.setRecCoName			(recconame[1]	==null?"":AddUtil.substringb(recconame[1],40));
		t_bean.setRecCoCeo			(reccoceo[1]	==null?"":AddUtil.substringb(reccoceo[1],20));
		t_bean.setRecCoAddr			(reccoaddr[1]	==null?"":AddUtil.substringb(reccoaddr[1],160));
		t_bean.setRecCoBizType		(reccobiztype[1]==null?"":AddUtil.substringb(reccobiztype[1],40));
		t_bean.setRecCoBizSub		(reccobizsub[1]	==null?"":AddUtil.substringb(reccobizsub[1],40));
		t_bean.setCon_agnt_nm		(con_agnt_nm[1]	==null?"":con_agnt_nm[1]);
		t_bean.setRecCoSsn			(reccossn[1]	==null?"":AddUtil.replace(reccossn[1],"-",""));	
		t_bean.setBranch_g2			(o_br_id[1]);
		t_bean.setRecCoTaxRegNo		(reccotaxregno[1]	==null?"":reccotaxregno[1]);
		//t_bean.setVen_code			(ven_code[1]	==null?"":ven_code[1]);
	}
	
	
	//������������϶� : ���� ������ ���ݰ�꼭 ������ �ϵ� ��(-)�� ���ݰ�꼭�� ����.
	if(doctype.equals("01")){
		
		
		
		//���޹޴��ڹ�ȣ : ���� �ֹε�Ϲ�ȣ 
		if(t_bean.getRecCoRegNo().equals("") && AddUtil.replace(t_bean.getRecCoSsn(),"-","").length() == 13){
			t_bean.setRecCoRegNo		(t_bean.getRecCoSsn());
		}		
		
		if(t_bean.getReccoregnotype().equals("")){
			if(t_bean.getRecCoRegNo().length() == 13){//����
				t_bean.setReccoregnotype("02");//����ڱ���-�ֹε�Ϲ�ȣ
			}else{
				t_bean.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
			}
		}
		
		//tax
		tax.TaxBean t_bean1	= t_bean;
		t_bean1.setTax_supply		(0-t_bean1.getTax_supply());
		t_bean1.setTax_value		(0-t_bean1.getTax_value());
		
		t_bean1.setDoctype		(doctype);
		t_bean1.setM_tax_no		(tax_no);
		t_bean1.setTax_st		("M");
		
		t_bean1.setTax_bigo		(tax_bigo[0]+" "+doctype_01_dt+" (����,���������� �ν��� ��)");
				
		out.println(t_bean1.getTax_supply());
		out.println(t_bean1.getTax_value()+"<br>");
		
		t_bean1.setOrg_nts_issueid(org_nts_issueid);
		
		
		if(!t_bean.getGubun().equals("18")){
			//���ô뿩��ó�� ���ſ� ������ ��꼭��� ���ݰ�꼭 ����ڰ� ����Ǿ������� ������ ���� ��꼭 ����ڷ� �ִ´�.		
			t_bean1.setCon_agnt_nm		(client.getCon_agnt_nm());
			t_bean1.setCon_agnt_dept	(client.getCon_agnt_dept());
			t_bean1.setCon_agnt_title	(client.getCon_agnt_title());
			t_bean1.setCon_agnt_email	(client.getCon_agnt_email().trim());
			t_bean1.setCon_agnt_m_tel	(client.getCon_agnt_m_tel());	
			t_bean1.setCon_agnt_nm2		(client.getCon_agnt_nm2());
			t_bean1.setCon_agnt_dept2	(client.getCon_agnt_dept2());
			t_bean1.setCon_agnt_title2	(client.getCon_agnt_title2());
			t_bean1.setCon_agnt_email2	(client.getCon_agnt_email2().trim());
			t_bean1.setCon_agnt_m_tel2	(client.getCon_agnt_m_tel2());	

		}
		t_bean1.setReg_id		(user_id);
		
		String tax_no1 = IssueDb.getTaxNoNext();
		String item_id1 = IssueDb.getItemIdNext();
				
		t_bean1.setTax_no		(tax_no1);
		t_bean1.setItem_id		(item_id1);
		
		if(!IssueDb.insertTax(t_bean1)) flag += 1;
		out.println("1����꼭���"+"<br>");
		out.println("��꼭��ȣ="+tax_no1+"<br>");
		out.println("��꼭���="+t_bean1.getTax_bigo()+"<br><br>");
		
		
		
		TaxItemBean ti_bean1 = ti_bean;
		ti_bean1.setItem_id		(item_id1);
		ti_bean1.setItem_hap_num(0-ti_bean1.getItem_hap_num());
		if(ti_bean1.getItem_hap_num()>0){
			ti_bean1.setItem_hap_str(ti_bean1.getItem_hap_str());
		}else{
			ti_bean1.setItem_hap_str("-"+ti_bean1.getItem_hap_str());
		}
		ti_bean1.setTax_no		(tax_no1);
		out.println(ti_bean1.getItem_hap_str());
		out.println(ti_bean1.getItem_hap_num()+"<br>");
		out.println("������ȣ="+item_id1+"<br><br>");
		if(!IssueDb.insertTaxItem(ti_bean1)) flag += 1;
		
		
		
		
		for(int i = 0 ; i < til_size ; i++){
		    TaxItemListBean til_bean1 = (TaxItemListBean)tils.elementAt(i);
			til_bean1.setItem_id		(item_id1);
			til_bean1.setItem_supply	(0-til_bean1.getItem_supply());
			til_bean1.setItem_value		(0-til_bean1.getItem_value());
			til_bean1.setReg_id			(user_id);
			til_bean1.setReg_code		(reg_code);
			out.println(til_bean1.getItem_supply());
			out.println(til_bean1.getItem_value()+"<br>");
			if(!IssueDb.insertTaxItemList(til_bean1)) flag += 1;
		}
		
	}
	
	
	
	//���� ���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean2		= IssueDb.getTax(tax_no);
	
	
	t_bean2.setTax_dt		(tax_dt[1]);
	t_bean2.setBranch_g		(o_br_id[1]);
	t_bean2.setTax_g		(tax_g[1]);
	t_bean2.setTax_supply		(AddUtil.parseDigit(tax_supply[1]));
	t_bean2.setTax_value		(AddUtil.parseDigit(tax_value[1]));
	t_bean2.setTax_bigo		(tax_bigo[1]==null?"":tax_bigo[1]);
	
	
	if(doctype.equals("01") || doctype.equals("02")){
	
		if(!client_id.equals("") && !t_bean2.getClient_id().equals(client_id)){
			t_bean2.setClient_id	(client_id);
		}
		if(!site_id.equals("") && !t_bean2.getSeq().equals(site_id)){
			t_bean2.setSeq		(site_id);
			if(t_bean2.getTax_type().equals("1")) t_bean2.setTax_type	("2");
		}
		if(site_id.equals("") && !t_bean2.getSeq().equals(site_id)){
			t_bean2.setSeq		(site_id);
			if(t_bean2.getTax_type().equals("2")) t_bean2.setTax_type	("1");
		}
		if(til_size==1 && !rent_l_cd.equals("") && !t_bean2.getRent_l_cd().equals("") && !t_bean2.getRent_l_cd().equals(rent_l_cd)){
			t_bean2.setRent_l_cd		(rent_l_cd);
		}
		t_bean2.setRecTel		(rectel[1]	==null?"":rectel[1]);
		t_bean2.setRecCoRegNo	(reccoregno[1]	==null?"":AddUtil.replace(AddUtil.replace(reccoregno[1]," ",""),"-",""));
		t_bean2.setRecCoName	(recconame[1]	==null?"":AddUtil.substringb(recconame[1],40));
		t_bean2.setRecCoCeo		(reccoceo[1]	==null?"":AddUtil.substringb(reccoceo[1],20));
		t_bean2.setRecCoAddr	(reccoaddr[1]	==null?"":AddUtil.substringb(reccoaddr[1],160));
		t_bean2.setRecCoBizType	(reccobiztype[1]==null?"":AddUtil.substringb(reccobiztype[1],40));
		t_bean2.setRecCoBizSub	(reccobizsub[1]	==null?"":AddUtil.substringb(reccobizsub[1],40));
		t_bean2.setCon_agnt_nm	(con_agnt_nm[1]	==null?"":con_agnt_nm[1]);
		t_bean2.setRecCoSsn		(reccossn[1]	==null?"":AddUtil.replace(reccossn[1],"-",""));	
		t_bean2.setRecCoTaxRegNo(reccotaxregno[1]==null?"":reccotaxregno[1]);
		t_bean2.setReccoregnotype(reccoregnotype);
		
		if(doctype.equals("01")){
			t_bean2.setVen_code		(ven_code[1]==null?"":ven_code[1]);
		}
		
		//20090701���� ����ڴ�������
		if(!o_br_id[1].equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean2.getTax_dt(),"-","")) > 20090631){
			//�������
			Hashtable br2 = c_db.getBranch(o_br_id[1]);
			t_bean2.setBranch_g		("S1");
			t_bean2.setBranch_g2	(o_br_id[1]);
			t_bean2.setTaxregno		(String.valueOf(br2.get("TAXREGNO"))==null?"":String.valueOf(br2.get("TAXREGNO")));
		}
		
		//���޹޴��ڰ� �����϶��� �����ϴ��� ó��
		if(t_bean2.getRecCoRegNo().equals("") || t_bean2.getRecCoRegNo().equals("0000000000") || t_bean2.getRecCoRegNo().length() == 13){//����
			t_bean2.setRecCoRegNo	(t_bean.getRecCoSsn());
		}
		
		//�ܱ���
		if(reccoregnotype.equals("03")){
			t_bean2.setRecCoRegNo("9999999999999");
		}
		
		t_bean2.setPubForm		(pubform);
	}else{
		if(t_bean.getRecCoRegNo().equals("")){
			t_bean2.setRecTel		(rectel[1]	==null?"":rectel[1]);
			t_bean2.setRecCoRegNo	(reccoregno[1]	==null?"":AddUtil.replace(AddUtil.replace(reccoregno[1]," ",""),"-",""));
			t_bean2.setRecCoName	(recconame[1]	==null?"":AddUtil.substringb(recconame[1],40));
			t_bean2.setRecCoCeo		(reccoceo[1]	==null?"":AddUtil.substringb(reccoceo[1],20));
			t_bean2.setRecCoAddr	(reccoaddr[1]	==null?"":AddUtil.substringb(reccoaddr[1],160));
			t_bean2.setRecCoBizType	(reccobiztype[1]==null?"":AddUtil.substringb(reccobiztype[1],40));
			t_bean2.setRecCoBizSub	(reccobizsub[1]	==null?"":AddUtil.substringb(reccobizsub[1],40));
			t_bean2.setCon_agnt_nm	(con_agnt_nm[1]	==null?"":con_agnt_nm[1]);
			t_bean2.setRecCoSsn		(reccossn[1]	==null?"":AddUtil.replace(reccossn[1],"-",""));	
			t_bean2.setBranch_g2	(o_br_id[1]);
			t_bean2.setRecCoTaxRegNo(reccotaxregno[1]==null?"":reccotaxregno[1]);
			t_bean2.setReccoregnotype(reccoregnotype);
			//���޹޴��ڰ� �����϶��� �����ϴ��� ó��
			if(t_bean2.getRecCoRegNo().equals("") || t_bean2.getRecCoRegNo().equals("0000000000") || t_bean2.getRecCoRegNo().length() == 13){//����
				t_bean2.setRecCoRegNo	 (t_bean.getRecCoSsn());
			}
			//�ܱ���
			if(reccoregnotype.equals("03")){
				t_bean2.setRecCoRegNo("9999999999999");
			}
		}
	}
	
	
	if(doctype.equals("01")){		//��������� ����.����
		t_bean2.setM_tax_no		("");		
		t_bean2.setTax_bigo		(t_bean2.getTax_bigo()+" "+doctype_01_dt+" (����,���������� �ν��� ��)");
	}else if(doctype.equals("02")){	//���ް��׺���
		t_bean2.setM_tax_no		(tax_no);
		t_bean2.setTax_dt		(request.getParameter("doctype_02_dt")==null?"":request.getParameter("doctype_02_dt"));
		t_bean2.setTax_bigo		(t_bean2.getTax_bigo()+" "+t_bean.getTax_dt()+" (���� ���ݰ�꼭 �ۼ���)");
	}else if(doctype.equals("03")){	//ȯ��
		t_bean2.setM_tax_no		(tax_no);
		t_bean2.setTax_dt		(request.getParameter("doctype_03_dt")==null?"":request.getParameter("doctype_03_dt"));//ȯ�Եȳ�
		t_bean2.setTax_bigo		(tax_bigo03+" "+t_bean.getTax_dt()+" (���� ���ݰ�꼭 �ۼ���)");
		t_bean2.setTax_supply	(-AddUtil.parseDigit(tax_supply03[1]));
		t_bean2.setTax_value	(-AddUtil.parseDigit(tax_value03[1]));
	}else if(doctype.equals("04")){	//�������
		t_bean2.setTax_dt		(request.getParameter("doctype_04_dt")==null?"":request.getParameter("doctype_04_dt"));//ȯ�Եȳ�
		t_bean2.setM_tax_no		(tax_no);
		t_bean2.setTax_bigo		(t_bean2.getTax_bigo()+" "+t_bean.getTax_dt()+" (���� ���ݰ�꼭 �ۼ���)");		
		t_bean2.setTax_supply	(-AddUtil.parseDigit(tax_supply04[1]));
		t_bean2.setTax_value	(-AddUtil.parseDigit(tax_value04[1]));
	}else if(doctype.equals("06")){	//������ ���� ���߹߱�
		t_bean2.setM_tax_no		(tax_no);
		t_bean2.setTax_supply	(-t_bean.getTax_supply());
		t_bean2.setTax_value	(-t_bean.getTax_value());
	}
	
	
	t_bean2.setResseq				("");
	t_bean2.setAutodocu_write_date	("");
	t_bean2.setAutodocu_data_no		("");
	t_bean2.setMail_dt				("");
	t_bean2.setPrint_dt				("");
	t_bean2.setPrint_id				("");
	t_bean2.setDoctype				(doctype);
	t_bean2.setTax_st				("O");
	
	//���޹޴��ڹ�ȣ : ���� �ֹε�Ϲ�ȣ 
	if(t_bean2.getRecCoRegNo().equals("") && AddUtil.replace(t_bean2.getRecCoSsn(),"-","").length() == 13){
		t_bean2.setRecCoRegNo		(t_bean2.getRecCoSsn());
	}
	
	if(t_bean2.getReccoregnotype().equals("")){
		if(AddUtil.replace(t_bean2.getRecCoRegNo(),"-","").length() == 13){//����
			t_bean2.setReccoregnotype("02");//����ڱ���-�ֹε�Ϲ�ȣ
		}else{
			t_bean2.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
		}
	}
	t_bean2.setOrg_nts_issueid(org_nts_issueid);
	
	if(!t_bean.getGubun().equals("18")){
		//���ô뿩��ó�� ���ſ� ������ ��꼭��� ���ݰ�꼭 ����ڰ� ����Ǿ������� ������ ���� ��꼭 ����ڷ� �ִ´�.
		t_bean2.setCon_agnt_nm		(client.getCon_agnt_nm());
		t_bean2.setCon_agnt_dept	(client.getCon_agnt_dept());
		t_bean2.setCon_agnt_title	(client.getCon_agnt_title());
		t_bean2.setCon_agnt_email	(client.getCon_agnt_email().trim());
		t_bean2.setCon_agnt_m_tel	(client.getCon_agnt_m_tel());	
		t_bean2.setCon_agnt_nm2		(client.getCon_agnt_nm2());
		t_bean2.setCon_agnt_dept2	(client.getCon_agnt_dept2());
		t_bean2.setCon_agnt_title2	(client.getCon_agnt_title2());
		t_bean2.setCon_agnt_email2	(client.getCon_agnt_email2().trim());
		t_bean2.setCon_agnt_m_tel2	(client.getCon_agnt_m_tel2());	
	}
	t_bean2.setReg_id		(user_id);

	String tax_no2 = IssueDb.getTaxNoNext();	
	String item_id2 = IssueDb.getItemIdNext();
	t_bean2.setTax_no		(tax_no2);
	t_bean2.setItem_id		(item_id2);
	
	
	if(!IssueDb.insertTax(t_bean2)) flag += 1;
	out.println("2����꼭���"+"<br>");
	out.println("��꼭���="+t_bean2.getTax_bigo()+"<br>");
	out.println("��꼭��ȣ="+tax_no2+"<br>");
	out.println("������ȣ="+item_id2+"<br><br>");
	
	if(doctype.equals("01") || doctype.equals("02")){		//��������� ����.����, ���ް��׺���
		
		//�ŷ����� ��ȸ
		TaxItemBean ti_bean2 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean2.setItem_id		(item_id2);
		ti_bean2.setItem_dt		(item_dt[1]);
		ti_bean2.setItem_hap_str	(AddUtil.parseDecimalHan(item_hap_num)+"��");
		ti_bean2.setItem_hap_num	(AddUtil.parseInt(item_hap_num));
		if(!client_id.equals("") && !ti_bean2.getClient_id().equals(client_id)){
			ti_bean2.setClient_id	(client_id);
		}
		if(!site_id.equals("") && !ti_bean2.getSeq().equals(site_id)){
			ti_bean2.setSeq		(site_id);
		}
		ti_bean2.setTax_no		(tax_no2);
		if(!IssueDb.insertTaxItem(ti_bean2)) flag += 1;
		
		
		int item_seq2 = 1;
		
		
		//�ŷ����� ����Ʈ ��ȸ
		for(int i = 0 ; i < til_size ; i++){
		    TaxItemListBean til_bean2 = (TaxItemListBean)tils.elementAt(i);
			if (del_chk[i].equals("N")) {  // ����
				til_bean2.setItem_id		(item_id2);
				til_bean2.setItem_g		(item_g[i]);
				til_bean2.setItem_car_no	(item_car_no[i]);
				til_bean2.setItem_car_nm	(item_car_nm[i]);
				til_bean2.setItem_dt1		(item_dt1[i]);
				til_bean2.setItem_dt2		(item_dt2[i]);
				til_bean2.setItem_supply	(AddUtil.parseDigit(item_supply[i]));
				til_bean2.setItem_value		(AddUtil.parseDigit(item_value[i]));
				til_bean2.setReg_id		(user_id);
				til_bean2.setReg_code		(reg_code);
				if(til_size==1 && !rent_l_cd.equals("") && !til_bean2.getRent_l_cd().equals("") && !til_bean2.getRent_l_cd().equals(rent_l_cd)){
					til_bean2.setRent_l_cd	(rent_l_cd);
				}
				if(!IssueDb.insertTaxItemList(til_bean2)) flag += 1;
				
				
				item_seq2++;
			}
		}
		for(int i=til_size;i < til_size+3;i++){
			if ( del_chk[i].equals("A")) {  // �߰�
				if (!item_g[i].equals("") ) {  //�׸��� ������ 
					TaxItemListBean til_bean2 = new TaxItemListBean();
					
					til_bean2.setItem_id		(item_id2);
					til_bean2.setItem_seq		(item_seq2);
					til_bean2.setItem_g			(item_g[i]);
					til_bean2.setItem_car_no	(item_car_no[i]);
					til_bean2.setItem_car_nm	(item_car_nm[i]);
					til_bean2.setItem_dt1		(item_dt1[i]);
					til_bean2.setItem_dt2		(item_dt2[i]);
					til_bean2.setItem_supply	(AddUtil.parseDigit(item_supply[i]));
					til_bean2.setItem_value		(AddUtil.parseDigit(item_value[i]));
					til_bean2.setReg_id			(user_id);
					til_bean2.setReg_code		(reg_code);
					if(!IssueDb.insertTaxItemList(til_bean2)) flag += 1;
					
					item_seq2++;
				}
			} 
		}
	}else if(doctype.equals("03") || doctype.equals("04") || doctype.equals("06")){	//ȯ��, �������, ���߹߱�
		//�ŷ����� ����Ʈ ��ȸ
		for(int i = 0 ; i < til_size ; i++){
		    TaxItemListBean til_bean2 = (TaxItemListBean)tils.elementAt(i);
			til_bean2.setItem_id		(item_id2);
			til_bean2.setItem_supply	(0-til_bean2.getItem_supply());
			til_bean2.setItem_value		(0-til_bean2.getItem_value());
			til_bean2.setReg_id		(user_id);
			til_bean2.setReg_code		(reg_code);
			if(!IssueDb.insertTaxItemList(til_bean2)) flag += 1;			
		}
		
		//�ŷ����� ��ȸ
		TaxItemBean ti_bean2 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean2.setItem_id		(item_id2);
		ti_bean2.setItem_dt		(t_bean2.getTax_dt());
		ti_bean2.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(t_bean2.getTax_supply()+t_bean2.getTax_value()))+"��");
		ti_bean2.setItem_hap_num	(t_bean2.getTax_supply()+t_bean2.getTax_value());
		ti_bean2.setTax_no		(tax_no2);
		if(!IssueDb.insertTaxItem(ti_bean2)) flag += 1;
		
		
	}else{//��������� ����.����/������� �� ������꼭�϶�
		
		TaxItemListBean til_bean2 = IssueDb.getTaxItemListCase(item_id, "1");
		
		til_bean2.setItem_id		(item_id2);
		til_bean2.setItem_supply	(t_bean2.getTax_supply());
		til_bean2.setItem_value		(t_bean2.getTax_value());
		til_bean2.setReg_id		(user_id);
		til_bean2.setReg_code		(reg_code);
		if(!IssueDb.insertTaxItemList(til_bean2)) flag += 1;
		
		
		//�ŷ����� ��ȸ
		TaxItemBean ti_bean2 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean2.setItem_id		(item_id2);
		ti_bean2.setItem_dt		(t_bean2.getTax_dt());
		ti_bean2.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(t_bean2.getTax_supply()+t_bean2.getTax_value()))+"��");
		ti_bean2.setItem_hap_num	(t_bean2.getTax_supply()+t_bean2.getTax_value());
		ti_bean2.setTax_no		(tax_no2);
		if(!IssueDb.insertTaxItem(ti_bean2)) flag += 1;
		
	}

%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		//fm.action = '/tax/issue_3/tax_reg_step3_proc.jsp';
		//fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/call_sp_tax_ebill_etc.jsp';
		fm.action = '/acar/admin/call_sp_tax_ebill_etc.jsp';
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
<input type='hidden' name='tax_no' 		value='<%=tax_no%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='reg_gu' 		value='tax_mng_eu'>
<input type='hidden' name='sender_nm' 	value='<%=o_sender_bean.getSa_code()%>'>
</form>
<a href="javascript:go_step()">2�ܰ�� ����</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�
		//�̹� �ۼ��� �ŷ����� ����Ʈ ����
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("���ݰ�꼭 ������ ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		go_step();
<%	}%>
<%//	if(flag > 0){//�����߻�%>
//		alert("���ݰ�꼭 ������ ������ �߻��Ͽ����ϴ�.");
<%//	}else{//����%>
		//go_step();
<%//	}%>
//-->
</script>
</body>
</html>
