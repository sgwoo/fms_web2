<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	out.println("���ݰ�꼭 ����"+"<br><br>");
	
	String tax_no	 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String item_id	 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_size	= request.getParameter("item_size")==null?"":request.getParameter("item_size");
	String ebill_yn		= request.getParameter("ebill_yn")==null?"N":request.getParameter("ebill_yn");	
	//�ŷ����� �߰��϶� ���
	String reg_code	 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String pubform	 	= request.getParameter("pubform")==null?"":request.getParameter("pubform");
	String reccoregnotype	= request.getParameter("reccoregnotype")==null?"":request.getParameter("reccoregnotype");
	
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	
	int flag = 0;
	int vid_size = 0;
	
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
	if(!item_id.equals("")){
		vid_size = item_seq.length;
	}
	
	//System.out.println(vid_size);
	
	//���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	
	
	//�ŷ�ó����
	ClientBean client       = al_db.getClient(t_bean.getClient_id().trim());
	
	if(!client_id.equals("") && !t_bean.getClient_id().equals(client_id)){
		client       = al_db.getClient(client_id);
		t_bean.setClient_id	(client_id);
	}
	
	if(!site_id.equals("") && !t_bean.getSeq().equals(site_id)){
		t_bean.setSeq		(site_id);
	}
	
	if(!rent_l_cd.equals("") && !t_bean.getRent_l_cd().equals("") && !t_bean.getRent_l_cd().equals(rent_l_cd)){
		t_bean.setRent_l_cd		(rent_l_cd);
	}
	
	t_bean.setTax_dt		(tax_dt[1]);
	t_bean.setBranch_g		(o_br_id[1]);
	t_bean.setTax_g			(tax_g[1]);
	t_bean.setTax_supply	(AddUtil.parseDigit(tax_supply[1]));
	t_bean.setTax_value		(AddUtil.parseDigit(tax_value[1]));
	t_bean.setTax_bigo		(tax_bigo[1]==null?"":tax_bigo[1]);
	
	t_bean.setRecTel		(rectel[1]		==null?"":rectel[1]);
	t_bean.setRecCoRegNo	(reccoregno[1]	==null?"":AddUtil.replace(reccoregno[1],"-",""));
	t_bean.setRecCoName		(recconame[1]	==null?"":AddUtil.substringb(recconame[1],40));
	t_bean.setRecCoCeo		(reccoceo[1]	==null?"":AddUtil.substringb(reccoceo[1],20));
	t_bean.setRecCoAddr		(reccoaddr[1]	==null?"":AddUtil.substringb(reccoaddr[1],160));
	t_bean.setRecCoBizType	(reccobiztype[1]==null?"":AddUtil.substringb(reccobiztype[1],40));
	t_bean.setRecCoBizSub	(reccobizsub[1]	==null?"":AddUtil.substringb(reccobizsub[1],40));
	t_bean.setCon_agnt_nm	(con_agnt_nm[1]	==null?"":con_agnt_nm[1]);
	t_bean.setRecCoSsn		(reccossn[1]	==null?"":AddUtil.replace(reccossn[1],"-",""));	
	t_bean.setRecCoTaxRegNo	(reccotaxregno[1]==null?"":reccotaxregno[1]);
	t_bean.setReccoregnotype(reccoregnotype);
	
	//20090701���� ����ڴ�������
	if(!o_br_id[1].equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
		//�������
		Hashtable br2 = c_db.getBranch(o_br_id[1]);
//		t_bean.setTax_bigo		(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
		t_bean.setBranch_g		("S1");
		t_bean.setBranch_g2		(o_br_id[1]);
		t_bean.setTaxregno		(String.valueOf(br2.get("TAXREGNO"))==null?"":String.valueOf(br2.get("TAXREGNO")));
	}
	
	if(t_bean.getRecCoRegNo().equals("") || t_bean.getRecCoRegNo().equals("0000000000")){
		t_bean.setRecCoRegNo(t_bean.getRecCoSsn());
	}
	
	
	//�ܱ���
	if(reccoregnotype.equals("03")){
		t_bean.setRecCoRegNo("9999999999999");
	}
	
	//���޹޴��ڰ� �����϶��� �����ϴ��� ó��
//	if(AddUtil.replace(t_bean.getRecCoRegNo(),"-","").length() == 13 && reccoregnotype.equals("01")){//����
//		t_bean.setReccoregnotype("02");//����ڱ���-�ֹε�Ϲ�ȣ
//	}
//	if(AddUtil.replace(t_bean.getRecCoRegNo(),"-","").length() == 10 && reccoregnotype.equals("02")){//����
//		t_bean.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
//	}
	
	
//	if(!t_bean.getReccoregnotype().equals(reccoregnotype)){
//		
//	}else{
//		t_bean.setReccoregnotype(reccoregnotype);
//	}
	
	t_bean.setPubForm		(pubform);
	
	
	if(!IssueDb.updateTax(t_bean)) flag += 1;


	SaleEBillBean sb_bean = new SaleEBillBean();
	
	if(ebill_yn.equals("Y") && !t_bean.getResseq().equals("")){
		//Ʈ������ ����� ��߱�ó��
		
		sb_bean.setResSeq		(t_bean.getResseq());
		sb_bean.setTaxSNum1		(tax_no);
		sb_bean.setPubDate		(t_bean.getTax_dt());
		sb_bean.setRemarks		(t_bean.getTax_bigo());
		sb_bean.setSupPrice		(t_bean.getTax_supply());
		sb_bean.setTax			(t_bean.getTax_value());
		
		//����-������
		Hashtable br1 = c_db.getBranch("S1");
		//�߻�-������
		Hashtable br = c_db.getBranch(t_bean.getBranch_g());
		
		if(!String.valueOf(br.get("BR_ENT_NO")).equals(String.valueOf(br1.get("BR_ENT_NO")))){
//			sb_bean.setRefCoRegNo(String.valueOf(br1.get("BR_ENT_NO")));
//			sb_bean.setRefCoName("(��)�Ƹ���ī");
		}
		
		sb_bean.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
		sb_bean.setCoName		("(��)�Ƹ���ī");
		sb_bean.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
		sb_bean.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
		sb_bean.setCoBizType	(String.valueOf(br.get("BR_STA")));
		sb_bean.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
		sb_bean.setCoTaxRegNo	(String.valueOf(br.get("TAXREGNO")));
		
		sb_bean.setRecCoRegNoType(t_bean.getReccoregnotype());
		sb_bean.setRecCoTaxRegNo("");
		sb_bean.setRecMemName	(t_bean.getCon_agnt_nm	());
		sb_bean.setRecTel		(t_bean.getRecTel		());
		sb_bean.setRecCoRegNo	(t_bean.getRecCoRegNo	());
		sb_bean.setRecCoName	(t_bean.getRecCoName	());
		sb_bean.setRecCoCeo		(t_bean.getRecCoCeo		());
		sb_bean.setRecCoAddr	(t_bean.getRecCoAddr	());
		sb_bean.setRecCoBizType	(t_bean.getRecCoBizType	());
		sb_bean.setRecCoBizSub	(t_bean.getRecCoBizSub	());
		sb_bean.setPubForm		(t_bean.getPubForm		());
		sb_bean.setRecCoTaxRegNo(t_bean.getRecCoTaxRegNo());
		
		if(sb_bean.getPubForm().equals("")) sb_bean.setPubForm("D");
		
		if(!IssueDb.updateSaleEBillTaxUpdate(sb_bean)) flag += 1;
		
		
		//Ʈ������ǰ�񸮽�Ʈ
		if(t_bean.getEtax_item_st().equals("2")){
		
		}else{
			sb_bean.setItemDate1	(t_bean.getTax_dt		());
			sb_bean.setItemName1	(t_bean.getTax_g		());
			
			if(t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){
				sb_bean.setItemName1(t_bean.getFee_tm()+"ȸ�� "+t_bean.getTax_g());
			}
			
			sb_bean.setItemSupPrice1(t_bean.getTax_supply	());
			sb_bean.setItemTax1		(t_bean.getTax_value	());
			sb_bean.setItemRemarks1	("");
			sb_bean.setItemSeqId	(t_bean.getResseq		());
			
			if(!IssueDb.updateSaleEBillTaxItemUpdate(sb_bean)) flag += 1;
		}
	}
	

	if(!item_id.equals("")){
	
		//�ŷ����� ��ȸ
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean.setItem_dt(item_dt[1]);
		ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(item_hap_num)+"��");
		ti_bean.setItem_hap_num(AddUtil.parseInt(item_hap_num));
		if(!client_id.equals("") && !ti_bean.getClient_id().equals(client_id)){
			ti_bean.setClient_id	(client_id);
		}
		if(!site_id.equals("") && !ti_bean.getSeq().equals(site_id)){
			ti_bean.setSeq			(site_id);
		}
		if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;


		//�ŷ����� ����Ʈ ��ȸ
		if(vid_size == 1){
				TaxItemListBean til_bean = IssueDb.getTaxItemListCase(item_id, request.getParameter("item_seq"));
				
				til_bean.setItem_g(request.getParameter("item_g"));
				til_bean.setItem_car_no(request.getParameter("item_car_no"));
				til_bean.setItem_car_nm(request.getParameter("item_car_nm"));
				til_bean.setItem_dt1(request.getParameter("item_dt1"));
				til_bean.setItem_dt2(request.getParameter("item_dt2"));
				til_bean.setItem_supply(AddUtil.parseDigit(request.getParameter("item_supply")));
				til_bean.setItem_value(AddUtil.parseDigit(request.getParameter("item_value")));
				if(!rent_l_cd.equals("") && !til_bean.getRent_l_cd().equals("") && !til_bean.getRent_l_cd().equals(rent_l_cd)){
					til_bean.setRent_l_cd	(rent_l_cd);
				}
				if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
				
				//Ʈ������ǰ�� ���ǥ���϶�
				if(ebill_yn.equals("Y") && !t_bean.getResseq().equals("") && t_bean.getEtax_item_st().equals("2")){
					sb_bean.setItemDate1	(t_bean.getTax_dt());
					sb_bean.setItemName1	(til_bean.getItem_g());
					if(t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){
						sb_bean.setItemName1(til_bean.getTm()+"ȸ�� "+til_bean.getItem_g());
					}
					sb_bean.setItemSupPrice1(til_bean.getItem_supply());
					sb_bean.setItemTax1		(til_bean.getItem_value());
					sb_bean.setItemRemarks1	(til_bean.getItem_car_no());
					sb_bean.setItemSeqId	(til_bean.getItem_id()+""+til_bean.getItem_seq());
					if(!IssueDb.updateSaleEBillTaxItemUpdate(sb_bean)) flag += 1;
				}
		}else{
			for(int i=0;i < vid_size;i++){
			//   System.out.println("del_chk=" + del_chk[i]);
			   
				if ( del_chk[i].equals("A") ) {  // �߰� ���� 
					if (!item_g[i].equals("") ) {  //�׸��� ������ 
						TaxItemListBean til_bean = new TaxItemListBean();
						
						til_bean.setItem_id		(item_id);
						til_bean.setItem_seq	(AddUtil.parseInt(item_seq[i]));
						til_bean.setItem_g		(item_g[i]);
						til_bean.setItem_car_no	(item_car_no[i]);
						til_bean.setItem_car_nm	(item_car_nm[i]);
						til_bean.setItem_dt1	(item_dt1[i]);
						til_bean.setItem_dt2	(item_dt2[i]);
						til_bean.setItem_supply	(AddUtil.parseDigit(item_supply[i]));
						til_bean.setItem_value	(AddUtil.parseDigit(item_value[i]));
						til_bean.setRent_l_cd	("");
						til_bean.setCar_mng_id	("");
						til_bean.setTm			("");
						til_bean.setGubun		("");
						til_bean.setReg_id		(user_id);
						til_bean.setReg_code	(reg_code);
						if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
						
						//Ʈ������ǰ�� ���ǥ���϶�
						if(ebill_yn.equals("Y") && !t_bean.getResseq().equals("") && t_bean.getEtax_item_st().equals("2")){
							sb_bean.setItemDate1	(t_bean.getTax_dt());
							sb_bean.setItemName1	(til_bean.getItem_g());
							if(t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){
								sb_bean.setItemName1(til_bean.getTm()+"ȸ�� "+til_bean.getItem_g());
							}
							sb_bean.setItemSupPrice1(til_bean.getItem_supply());
							sb_bean.setItemTax1		(til_bean.getItem_value());
							sb_bean.setItemRemarks1	(til_bean.getItem_car_no());
							sb_bean.setItemSeqId	(til_bean.getItem_id()+""+til_bean.getItem_seq());
							if(!IssueDb.insertSaleEBillItem(sb_bean)) flag += 1;
						}
					}
				} else {
					TaxItemListBean til_bean = IssueDb.getTaxItemListCase(item_id, item_seq[i]);
					if(del_chk[i].equals("N") ){//����
						if (!item_g[i].equals("")) {
							til_bean.setItem_g(item_g[i]);
							til_bean.setItem_car_no(item_car_no[i]);
							til_bean.setItem_car_nm(item_car_nm[i]);
							til_bean.setItem_dt1(item_dt1[i]);
							til_bean.setItem_dt2(item_dt2[i]);
							til_bean.setItem_supply(AddUtil.parseDigit(item_supply[i]));
							til_bean.setItem_value(AddUtil.parseDigit(item_value[i]));
							if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
							
							//Ʈ������ǰ�� ���ǥ���϶�
							if(ebill_yn.equals("Y") && !t_bean.getResseq().equals("") && t_bean.getEtax_item_st().equals("2")){
								sb_bean.setItemDate1	(t_bean.getTax_dt());
								sb_bean.setItemName1	(til_bean.getItem_g());
								if(t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){
									sb_bean.setItemName1(til_bean.getTm()+"ȸ�� "+til_bean.getItem_g());
								}
								sb_bean.setItemSupPrice1(til_bean.getItem_supply());
								sb_bean.setItemTax1		(til_bean.getItem_value());
								sb_bean.setItemRemarks1	(til_bean.getItem_car_no());
								sb_bean.setItemSeqId	(til_bean.getItem_id()+""+til_bean.getItem_seq());
								if(!IssueDb.updateSaleEBillTaxItemUpdate(sb_bean)) flag += 1;
							}
						}	
					}else if(del_chk[i].equals("Y")){//����
						if(!IssueDb.deleteTaxItemList(til_bean)) flag += 1;
						
						//Ʈ������ǰ�� ���ǥ���϶�
						if(ebill_yn.equals("Y") && !t_bean.getResseq().equals("") && t_bean.getEtax_item_st().equals("2")){
							sb_bean.setItemSeqId	(til_bean.getItem_id()+""+til_bean.getItem_seq());
							if(!IssueDb.deleteSaleEBillTaxItem(sb_bean)) flag += 1;
						}
					}
				}
			}
		}
		
	}	
	
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		var fm = document.form1;
		fm.action = 'tax_mng_c.jsp';
		fm.target = 'd_content';
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
</form>
<a href="javascript:go_step()">2�ܰ�� ����</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("���ݰ�꼭 ������ ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("����ó���Ǿ����ϴ�. ��꼭�� ����Ǿ����� �׿��� ��ǥ�� Ȯ���ϼ���.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
