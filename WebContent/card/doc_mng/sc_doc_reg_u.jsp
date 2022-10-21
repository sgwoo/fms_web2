<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.user_mng.*, acar.serv_off.*,acar.car_service.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String card_user_id 	= request.getParameter("card_user_id")==null?"":request.getParameter("card_user_id");
	
	String app_st = "";
	String single_id = "";
	String single_name = "";
	
	String car_su = "1";
	String chk="0";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "04", "07", "12");
	
	// �߰�2006.09.20 �μ��� ��ȸ
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	
	//ī������
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	String buy_dt 	= cd_bean.getBuy_dt();
	String buy_user_id 		= cd_bean.getBuy_user_id();
	String reg_user_id 		= cd_bean.getReg_id();
	
	//�ܱ��� �Ѱ� ��ȸ-�������������� ���� ����
	Hashtable res = CardDb.getRentContCase(user_id);
  	
	String CAR_NO = res.get("CAR_NO")==null?"":String.valueOf(res.get("CAR_NO"));
	String CAR_MNG_ID = res.get("CAR_MNG_ID")==null?"":String.valueOf(res.get("CAR_MNG_ID"));
	String RENT_L_CD = res.get("RENT_L_CD")==null?"":String.valueOf(res.get("RENT_L_CD"));
	
	String SERV_DT = res.get("SERV_DT")==null?"":String.valueOf(res.get("SERV_DT"));
	String TOT_DIST = res.get("TOT_DIST")==null?"":String.valueOf(res.get("TOT_DIST"));
	
	//ī����������
	Hashtable ht3 = new Hashtable();
	//ht3 = CardDb.getCardUserInfo(card_user_id); //����ں� �ֱ� ���ī�� �������� 
	ht3 = CardDb.getCardSearchExcel("", cardno);  //ī�庰 ���� ��������
	
	
	//������� ǥ�� : ������ ���� ��� ����, ����ڸ� ���� ��� �̽���, ��� ���� ��� �̵�� 
	if(!cd_bean.getApp_id().equals("")){
		if(cd_bean.getApp_id().equals("cancel")) app_st="�������";
		else if(cd_bean.getApp_id().equals("cance0")) app_st="�������";
		else app_st="����";
	}else{
		if(!reg_user_id.equals("")) app_st="�̽���";
		else app_st="�̵��";
	}

	//ȥ�� ���ý� ��������� ���̵� �������� : �̵�Ͻ� ����, �̽��ν� �����	
	if(c_db.getNameById(buy_user_id, "USER").equals("")){
		single_id = user_id;
	}else{
		single_id = buy_user_id;
	}
	
	//ȥ�� ���ý� ����� �̸� �������� : �̵�Ͻ� ����, �̽��ν� �����	
	if(c_db.getNameById(buy_user_id, "USER").equals("")){
		single_name = c_db.getNameById(user_id, "USER");
	}else{
		single_name = c_db.getNameById(buy_user_id, "USER");
	}
	
	//�����ī�� setting
	
	if ( cardno.equals("4009-0702-0423-7446") || cardno.equals("5535-3109-0005-0820") || cardno.equals("4009-0702-0741-6617")  || cardno.equals("4009-0702-0833-8646") ) {
		single_id = "000003";
	   single_name = c_db.getNameById("000003", "USER");
	}
		
     //���� setting
     if ( cardno.equals("9410-8523-8465-4800") ) {
		single_id = "000035";
	   single_name = c_db.getNameById("000035", "USER");
	}
	
	//�ŷ�ó����
	Hashtable vendor = new Hashtable();
	if(!cd_bean.getVen_code().equals("")){
		vendor = neoe_db.getVendorCase(cd_bean.getVen_code());
	}
		
	dept_id 				= c_db.getUserDept(reg_user_id);
	String brch_id 			= c_db.getUserBrch(reg_user_id);
	String chief_id			= "000004";
	if(brch_id.equals("S1") && dept_id.equals("0001"))					chief_id = "000005";
	if(brch_id.equals("S1") && dept_id.equals("0002"))					chief_id = "000026";
	if(buy_user_id.equals("000003") || buy_user_id.equals("000035"))			chief_id = "";
	if(brch_id.equals("B1"))								chief_id = "000053";
	if(brch_id.equals("D1"))								chief_id = "000052";
	if(brch_id.equals("G1"))								chief_id = "000054";
	if(brch_id.equals("J1"))								chief_id = "000020";
	if(brch_id.equals("S2"))								chief_id = "000005";
		
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
			
	Vector vt_item = CardDb.getCardDocItemList(cardno, buy_id); 
 	int vt_i_size1 = vt_item.size();
 	
 	Hashtable f_ht_item = new Hashtable();
 	
 	if ( vt_i_size1 > 0) {
 	    car_su = Integer.toString(vt_i_size1);
 	    
       	f_ht_item = (Hashtable)vt_item.elementAt(0);
 	} 
 	
 	//�Ƹ���ī ������ �ο��� ���ϱ�(20191007)
 	Vector vt_acar = CardDb.getUserSearchList("", "", "AA", "Y");
 	int vt_acar_size = vt_acar.size() + 20;		//	���� 20��
 	if(vt_acar_size%2==1){	vt_acar_size +=	1;		 }	//	Ȧ���̸� ¦���� �ǰ� +1
 	
 	//�ڷγ��濪�� ��
 //	int coamt= CardDb.getCardCorona(cardno);
 	int coamt= CardDb.getCardCoronaUser(single_id);
// 	out.println(coamt) ;
 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript" src="/include/common.js"></script>
<style type="text/css">
	td {height: 30px;}
</style>
<script language="JavaScript">

	//��������� ���� ���÷���
	function cng_input_carsu(car_su){
		var fm = document.form1;		
		
		var car_su = toInt(car_su) ;
								
		if(car_su >20){
			alert('�Է°����� �ִ�Ǽ��� 20�� �Դϴ�.');
			return;
		}
		
	<%for(int i=1;i <= 19 ;i++){%>
					
				tr_acct_plus.style.display	= 'none';
			
				tr_acct3_1.style.display	= 'none';
				tr_acct3_2.style.display	= 'none';
				tr_acct3_3.style.display	= 'none';
				tr_acct98.style.display	= 'none';
				tr_acct97.style.display	= 'none';
				
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display	= 'none';		
				tr_acct3_<%=i%>_97.style.display	= 'none';
  <% } %>					
				
	<%for(int i=1;i <= 19 ;i++){%>
			if(car_su > <%=i%>){//�켱 ��� �� ���̰�
			
				tr_acct_plus.style.display	= 'none';
			
				tr_acct3_1.style.display	= 'none';
				tr_acct3_2.style.display	= 'none';
				tr_acct3_3.style.display	= 'none';
				tr_acct98.style.display	= 'none';
				
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display	= 'none';		
	   
				if(fm.acct_code.value == '00006' || fm.acct_code_g[9].checked == true    ){//��������&�Ϲ�����
				
					tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_3.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';
					tr_acct3_<%=i%>_3.style.display	= 'table-row';
					tr_acct3_<%=i%>_98.style.display	= 'table-row';		
					
				} else if (   fm.acct_code_g[8].checked == true  ){//���������� 		- ������ �ΰ�� 
			
					tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_2.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';				
					tr_acct3_<%=i%>_2.style.display	= 'table-row';				
					tr_acct3_<%=i%>_98.style.display	= 'table-row';					
				
				}else if(fm.acct_code_g[12].checked == true || fm.acct_code_g[10].checked == true ){//�縮������&�ڵ����˻�
				
					tr_acct3_1.style.display	= 'table-row';		
					tr_acct98.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';
					tr_acct3_<%=i%>_98.style.display	= 'table-row';
				
				} else 	if(fm.acct_code.value == '00019'   ){// ������� ������ 
				 
					tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';			
					tr_acct98.style.display	= 'table-row';
					tr_acct97.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';				
					tr_acct3_<%=i%>_98.style.display	= 'table-row';		
					tr_acct3_<%=i%>_97.style.display	= 'table-row';			
									
				}else{//��ȣ�Ǵ��&��Ÿ
					
					tr_acct3_98.style.display	= 'table-row';
					tr_acct3_<%=i%>_98.style.display	= 'table-row';
				}
		
				
			}else{
				
			}
	<%}%>						
	}		

	//���&����
	function Save(){
		var fm = document.form1;
				
		if(fm.cardno.value == '')	{	alert('ī���ȣ�� �����ƽ��ϴ�.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڰ� �����ƽ��ϴ�.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('�ŷ��ݾ��� �����ƽ��ϴ�.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('�ŷ��ݾ��� �����ƽ��ϴ�.'); return; }
		if(fm.buy_amt.value == '0'){	alert('�ŷ��ݾ��� �����ƽ��ϴ�.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('�ŷ�ó�� �����ƽ��ϴ�.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_user_nm.value == '' || fm.buy_user_id.value == ''){	alert('��������ڸ� �˻����ּ���.'); return; }	

		//ven_st Ȯ�� 
		if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false  && fm.ven_st[2].checked == false  && fm.ven_st[3].checked == false)
		{ 
			    alert('���������� �����Ͻʽÿ�.'); 
			    fm.acct_code.value="";
				return;
		}
			
		
		//�����Ļ���
		if(fm.acct_code.value == '00001'  
			&& fm.acct_code_g[0].checked == false  && fm.acct_code_g[1].checked == false  && fm.acct_code_g[2].checked == false 
			&& fm.acct_code_g[3].checked == false && fm.acct_code_g[4].checked == false && fm.acct_code_g2[0].checked == false 
			&& fm.acct_code_g2[1].checked == false && fm.acct_code_g2[2].checked == false && fm.acct_code_g2[3].checked == false 
			&& fm.acct_code_g2[4].checked == false && fm.acct_code_g2[5].checked == false && fm.acct_code_g2[6].checked == false  && fm.acct_code_g2[7].checked == false  && fm.acct_code_g2[8].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
		
		//�����Ļ��� - ��Ÿ�� �ӿ��̻�, �̹���� ����
		if((fm.acct_code.value == '00001'  && fm.acct_code_g[3].checked ==true) || (fm.acct_code.value == '00002')) {
		   if(fm.buy_user_id.value != "000003" && fm.buy_user_id.value != "000004" && fm.buy_user_id.value != "000005" 
				&& fm.buy_user_id.value != "000026"  && fm.buy_user_id.value != "000237" && fm.buy_user_id.value != "000028"  && fm.buy_user_id.value != "000035" ) 
 				{	alert('\'�����Ļ��� - ��Ÿ\'�� \'�����\'�� ���� ��� ������ �����ϴ�.'); return;	}
		}
		
		//�����		
		if(fm.acct_code.value == '00002' 			
			//&& fm.acct_code_g[17].checked == false && fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false)
			&& fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false && fm.acct_code_g[20].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//�������
		if(fm.acct_code.value == '00003' 	
			//&& fm.acct_code_g[13].checked == false && fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false )
			&& fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false && fm.acct_code_g[17].checked == false )
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//����������
		if(fm.acct_code.value == '00004' ) {
			
			//if(fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false
			if(fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false && fm.acct_code_g[8].checked == false		
				&& fm.acct_code_g2[9].checked == false && fm.acct_code_g2[10].checked == false && fm.acct_code_g2[11].checked == false)
				{ alert('������ �����Ͻʽÿ�.'); return;}		
			
			if ( fm.item_code[0].value == '' ||fm.item_code[0].value == 'null'  ) { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
			
			
			if ( fm.acct_code_g2[9].checked == true) { // ������
			
				if ( fm.tot_dist[0].value == '' || fm.tot_dist[0].value == '0' ||  toInt(parseDigit(fm.tot_dist[0].value)) == 0   ) { alert('����Ÿ��� �Է��Ͻʽÿ�.'); return;}
				if ( fm.oil_liter[0].value == '' || fm.oil_liter[0].value == '0' ) { alert('�������� �Է��Ͻʽÿ�.'); return;}
				if ( toInt(parseDigit(fm.oil_liter[0].value)) > 75   ) { alert('�������� �ٽ� �ѹ� Ȯ���Ͻñ� �ٶ��ϴ�.'); }
			
			}else{
			
				if ( fm.o_cau[0].value == '') { alert('������ �����Ͻʽÿ�.'); return;}
			}
						
			if (fm.acct_code_g[8].checked == true ) {  //������ 
				var carsu = fm.car_su.value;
				 
				for(i=0; i<carsu ; i++){
					if ( fm.item_code[i].value == '') { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
				}
			}else{
				if(fm.acct_cont[0].value == '')	{	alert('���並 �Է��Ͻʽÿ�.'); return;	}
			}						
			
		}
		
		//���������
		if(fm.acct_code.value == '00005') {
		  		          
			if(fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false
				&& fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false 
				&& fm.acct_code_g2[12].checked == false && fm.acct_code_g2[13].checked == false && fm.acct_code_g2[14].checked == false)  //���� ���� �߰� - 20171020 ���������� 
						
				{ alert('������ �����Ͻʽÿ�.'); return;}			
			
			
			// �縮�������� ��� �������� �Ұ�  ó�� 	
			if (fm.acct_code_g[12].checked ==  true && fm.acct_code_g2[12].checked == true ) {
						 alert("�縮�������ΰ�� �뵵�� ������ ������ �� �����ϴ�."); 
						 return;		
			}	
				
			//if (fm.acct_code_g[10].checked ==  true && fm.acct_code_g2[10].checked == true ) {
			//	 alert("�ڵ����˻��ΰ�� �뵵�� ������ ���õ� �� �����ϴ�."); 
			//	 return;		
			//}	
			
			//����� �ݵ�� ���� ��ȸ�Ͽ� car_mng_id ���Ѵ�.		
			if (fm.acct_code_g[11].checked == false && fm.acct_code_g[13].checked == false ) {
				var carsu = fm.car_su.value;
				 
				for(i=0; i<carsu ; i++){
					if ( fm.item_code[i].value == '') { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
				}
			}else{
				if(fm.acct_cont[0].value == '')	{	alert('���並 �Է��Ͻʽÿ�.'); return;	}
			}			
		}
		
		//��������
		if (fm.acct_code.value == '00006'){
			var carsu = fm.car_su.value;
			
			for(i=0; i<carsu; i++){
				if(fm.item_code[i].value == '')		{ alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
				if(fm.acct_cont[i].value == '')		{ alert('���並 �Է��Ͻʽÿ�.'); return;}
			}	
		}		
			
		//�繫��ǰ��&�Ҹ�ǰ��&��ź�&�����μ��&���޼�����&��ǰ&���ޱ�
		if ((fm.acct_code.value == '00007' ||  fm.acct_code.value == '00008' ||  fm.acct_code.value == '00009'
			||  fm.acct_code.value == '00010' ||  fm.acct_code.value == '00011' ||  fm.acct_code.value == '00012' ||  fm.acct_code.value == '00013'  ||  fm.acct_code.value == '00021' ||  fm.acct_code.value == '00023' )
			&& fm.acct_cont[0].value == '')
			{ alert('���並 �Է��Ͻʽÿ�.'); return;}
					
		//��ݺ�, ������� �ݵ�� ���� ��ȸ�Ͽ� car_mng_id ���Ѵ�.
		if((fm.acct_code.value == '00018' ||  fm.acct_code.value == '00019') &&  fm.item_code[0].value == '') { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
		
		//��ź�
		//if(fm.acct_code.value == '00009' && fm.acct_code_g[20].checked == false && fm.acct_code_g[21].checked == false){ alert('������ �����Ͻʽÿ�.'); return;}
		if(fm.acct_code.value == '00009' && fm.acct_code_g[21].checked == false && fm.acct_code_g[22].checked == false){ alert('������ �����Ͻʽÿ�.'); return;}
			
		//���� ���ڼ� üũ
		if(fm.acct_cont[0].value != '' && !max_length(fm.acct_cont[0].value,80))	{	alert('���� ���� ���̴� '+get_length(fm.acct_cont[0].value)+'��(��������) �Դϴ�.\n\n����� �ѱ�40��/����80�ڱ��� �Է��� �����մϴ�.'); return; } 			

		//��ǥ���� üũ
		if(getRentTime('m', fm.buy_dt.value, <%=AddUtil.getDate()%>) > 3){ 
			if(!confirm('�Է��Ͻ� ��ǥ���ڰ� �����̻� ���̳��ϴ�.\n\n��ǥ�� �Է� �Ͻðڽ��ϱ�?'))			
				return;
		}
		
		var sMoney = 0;
		
		var call_nm_cnt =0;
		var call_tel_cnt =0;
		
		//����� �ݾ� check - ī�������� ����ݾ׺��� Ŭ �� ����. - �Ϲ�����	, �縮�� ���� 	
		if(fm.acct_code.value == '00005' ) {
		  // �Ϲ�����	, �縮�� ���� 
			if (fm.acct_code_g[9].checked ==  true  || fm.acct_code_g[12].checked ==  true ) {
	
					var car_su = toInt(fm.car_su.value);		
				
					for(i=0; i <car_su ; i++){			 				   
					   sMoney += toInt(parseDigit(fm.stot_amt[i].value));	
					    
					    //�������� ���  -  ī������
					   if(fm.firm_nm[i].value == '(��)�Ƹ���ī') {
					      fm.call_t_nm[i].value == fm.user_nm.value;   
					      fm.call_t_tel[i].value == '3924242'; 
					   }    
					  
					   if(fm.call_t_nm[i].value == '')   call_nm_cnt+=1;   
					   if(fm.call_t_tel[i].value == '')  call_tel_cnt+=1;  	  
					   
					}	
								
					if ( sMoney+100 < toInt(parseDigit(fm.buy_amt.value))  ) {
					 	  alert('����ݾ׺��� ����ݾ��� Ŭ �� �����ϴ�. Ȯ���ϼ���!!.'); 
					      return;				 
					}
						
					//����ݾװ� ����ݾ� ���̰� õ���̻� �ȵ�. - 20200103
					if ( sMoney  -  toInt(parseDigit(fm.buy_amt.value)) > 1000 ) {
					 	  alert('����ݾװ� ����ݾ��� õ���̻� ���̰� ���ϴ�. Ȯ���ϼ���!!.'); 
					      return;				 
					}
					
					if (fm.acct_code_g[9].checked ==  true ) {
						if(call_nm_cnt > 0)	{	alert('�����̿��ڸ� �Է��Ͻʽÿ�.'); return; }
						if(call_tel_cnt > 0)	{	alert('����ó�� �Է��Ͻʽÿ�.'); 	return; }	
					}
			}	
			
	    }	
		
		//�������� �ݾ� check - ī�������� ����ݾ׺��� Ŭ �� ����. - �Ϲ�����	, �縮�� ���� 	
		if(fm.acct_code.value == '00006' ) {
			// 		
				var car_su = toInt(fm.car_su.value);		
			
				for(i=0; i <car_su ; i++){			 				   
				   sMoney += toInt(parseDigit(fm.stot_amt[i].value));	
				    
				    //�������� ���  -  ī������
				   if(fm.firm_nm[i].value == '(��)�Ƹ���ī') {
				      fm.call_t_nm[i].value == fm.user_nm.value;   
				      fm.call_t_tel[i].value == '3924242'; 
				   }    
				  
				   if(fm.call_t_nm[i].value == '')   call_nm_cnt+=1;   
				   if(fm.call_t_tel[i].value == '')  call_tel_cnt+=1;  	  
				   
				}	
							
				if ( sMoney+100 < toInt(parseDigit(fm.buy_amt.value))  ) {
				 	  alert('����ݾ׺��� ����ݾ��� Ŭ �� �����ϴ�. Ȯ���ϼ���!!.'); 
				      return;				 
				}
					
				//����ݾװ� ����ݾ� ���̰� õ���̻� �ȵ�. - 20200103
				if ( sMoney  -  toInt(parseDigit(fm.buy_amt.value)) > 1000 ) {
				 	  alert('����ݾװ� ����ݾ��� ��õ���̻� ���̰� ���ϴ�. Ȯ���ϼ���!!.'); 
				      return;				 
				}
				
				if(call_nm_cnt > 0)	{	alert('�����̿��ڸ� �Է��Ͻʽÿ�.'); return; }
				if(call_tel_cnt > 0)	{	alert('����ó�� �Է��Ͻʽÿ�.'); 	return; }	
			
	    }	
		
		//������� �ݾ� check		
		if(fm.acct_code.value == '00019') {
		
			var car_su = toInt(fm.car_su.value);		
		
			for(i=0; i <car_su ; i++){			 				   
			   sMoney += toInt(parseDigit(fm.doc_amt[i].value));	
			}	
						
			if ( sMoney < toInt(parseDigit(fm.buy_amt.value)) || sMoney > toInt(parseDigit(fm.buy_amt.value))  ) {
			 	  alert('������� �������ݾ� �հ��  ����ݾ��� �ٸ��ϴ�. Ȯ���ϼ���!!.'); 
			      return;				 
			}
			
	    }		
		
		//if(parseInt(fm.buy_dt.value.substring(0,4)) != <%=AddUtil.getDate(1)%>){ alert('���س⵵ ��ǥ�� �Է� �����մϴ�.'); return;}		
			
		var inCnt	=	0;
		var strAccCont	=	"";			// ����
		var strClient	=	"";			// �ŷ�ó��
		var strClientNm =	"";			// �ŷ�ó �����
		var strUserCnt	=	"";			// �ļ��ο� ��
		
		var strDept_id = "";
		var strMoney = "";
		
		var totMoney = 0;
					
		//������ ����Ʈ
		inCnt = toInt(fm.user_su.value);
		if(inCnt>0){
			for(i=0; i<inCnt ; i++){
				strUserCnt = strUserCnt + fm.user_nm[i].value;
				if (inCnt > 1){
					strUserCnt = strUserCnt + ' ��';
					break;
				}
			
			}
			//��ȥ�� ���ý� ����ڸ� ���� ����.
			if(fm.acct_code_s[0].checked == true){
				if(fm.buy_user_id.value=='<%=user_id%>'){
					strUserCnt = "<%=single_name%>";
				}else{
					strUserCnt = fm.buy_user_nm.value;
				}				
			}
			
			fm.user_cont.value	=	strUserCnt;		
		}
		
		
		    //�����Ļ����� ��� �μ��� ���� �ݾ� �Է� ����. - �Ĵ�/ �߽� �� ����
		if(fm.acct_code.value == '00001' ) {		    
   
        	  if(fm.user_su.value == ''){ alert("�ο����� ����ϼž� �մϴ�. �ٽ� Ȯ�� ���ּ���"); return; }
        	   
        	  if ( toInt(fm.user_su.value) == false ) { alert("�ο����� ���ڿ��� �մϴ�. �ٽ� Ȯ�� ���ּ���"); return; }
        	  
        	        	  
        	  if(fm.txtTot.value == '' || fm.txtTot.value == '0' ){ alert("�ݾ��� ����ϼž� �մϴ�. �ٽ� Ȯ�� ���ּ���"); return; }		
        	  	  
           	  if(inCnt>0){
					for(i=0; i<inCnt ; i++){
					   strDept_id =  fm.dept_id[i].value;
					   strMoney =  fm.money[i].value;
					   
					   totMoney += toInt(parseDigit(fm.money[i].value));
					   
					//   alert(strDept_id);
					//   alert(strMoney);
					
				   if(fm.acct_code_s[0].checked == true){
						fm.user_su.value = 1;
						fm.user_case_id[0].value = fm.buy_user_id.value;
						fm.user_nm[0].value = "<%=c_db.getNameById(buy_user_id, "USER")%>";
						cng_input1();
					}else{
					   if (strDept_id == '' && parseInt(strMoney) > 0 ) {
					       alert('����ڸ� �����ϼž� �ݾ��� �Է� �����մϴ�!!!.'); 
					       return;
					   }  
					}
				}
				if ( totMoney != toInt(parseDigit(fm.buy_amt.value))  ) {
				 	  alert('�����ο��� �ݾ���  Ȯ���ϼ���!!.'); 
				      return;				 
				}
			 }	
           	strDept_id =  fm.dept_id.value;
			strMoney =  fm.buy_amt.value;
			totMoney += toInt(parseDigit(fm.buy_amt.value));
		}			
			
		var call_nm_cnt =0;
		var call_tel_cnt =0;
			    
		//���κ� ����ݾ� �հ� ����
		if(fm.txtTot.value != '' && fm.txtTot.value != '0' && fm.txtTot.value != fm.buy_amt.value){ alert("�հ�� ���谡 ���� �ʽ��ϴ�. �ٽ� Ȯ�� ���ּ���"); return; }
	    
	   //�����, ��Ÿ�� ���
		//if(fm.acct_code.value == '00005' && fm.acct_code_g[12].checked == true ){
		if(fm.acct_code.value == '00005' && fm.acct_code_g[13].checked == true ){
		   // �ϴ� �ѹ��� ����, ���� ��� �߰�
		  if (fm.user_id.value == '000058' || fm.user_id.value == '000070'  || fm.user_id.value == '000063'  ||   fm.user_id.value == '000029' ||   fm.user_id.value == '000128' ||   fm.user_id.value == '000153') {
		  
		  } else {
		 	 alert('����� - ��Ÿ�� ������ �� �����ϴ�.!!!');
		 	 return;
		  } 		    
		}   		
			
		//������, �����, �����Ļ��� ��Ÿ �������� ������ �ΰ��� 0 check - �������� ������ ���ð��� ����Ǳ⿡ �ٽ� ���������ϵ��� ��
		if ( fm.acct_code.value == "" ) {
			 alert('���������� �����ϼ���!!!');
			 return;
		}
		
		if(confirm('����Ͻðڽ��ϱ�?')){	

			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			document.domain = "amazoncar.co.kr";
			fm.action='sc_doc_reg_u_a.jsp';		
			fm.target='i_no';
//            fm.target='_self';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
	
	//�뿩�ϼ� ���ϱ�
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}		
	
	//�ݾ׼���
	function tot_buy_amt(){
		var fm = document.form1;	
		
		//�����, ����������, ������� �ƴϰ�, �Ϲݰ����� ���
		if(fm.acct_code.value != '00002' && fm.acct_code.value != '00003'  && fm.acct_code.value != '00019' && fm.acct_code.value != '00004' && fm.acct_code.value != '00005'  && fm.acct_code.value != '00009' && fm.ven_st[0].checked == true){
			if(fm.acct_code.value == '00001' && fm.acct_code_g[3].checked == true){
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;
			}else if ( fm.acct_code.value == '00019'){	
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;
			}else{
				fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
				fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));					
			}
		}else{	
			if(fm.acct_code.value == '00004' && fm.acct_code_g2[9].checked == true){		//������ 
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;	
			//} else 	
			//if(fm.acct_code.value == '00004' && fm.acct_code_g2[8].checked == false){		
			//	fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			//	fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));	
			} else if(fm.acct_code.value == '00005' && fm.acct_code_g2[12].checked == true){		
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;				
			//	fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			//	fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));
		//	} else if(fm.acct_code.value == '00005' && fm.acct_code_g2[11].checked == false){			
		//		fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
		//		fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));
			} else if(fm.acct_code.value == '00002' || fm.acct_code.value == '00003' || fm.acct_code.value == '00009'|| fm.acct_code.value == '00019' ){			
				 fm.buy_s_amt.value 		= fm.buy_amt.value;
				 fm.buy_v_amt.value 		= 0;
			}else{	
				 if ( fm.ven_st[0].checked == true) {
					 fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
					 fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));				
				
				 } else {
					 fm.buy_s_amt.value 		= fm.buy_amt.value;
					fm.buy_v_amt.value 		= 0;				 
				 }				
				
			}
				
		}		
		cng_input1();
	}	
	
	
	//�ݾ׼���
	function set_buy_amt(){
		var fm = document.form1;	
		fm.buy_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) + toInt(parseDigit(fm.buy_v_amt.value)));				
	}
	
	//�ݾ׼���
	function set_buy_s_amt(){
		var fm = document.form1;	
		fm.buy_s_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_v_amt.value)));				
	}
	
	//�ݾ׼���
	function set_buy_v_amt(){
		var fm = document.form1;	
		//�����, ������� �� �ƴϰ�, �Ϲݰ����� ���
		if( fm.acct_code.value != '00002'  &&  fm.acct_code.value != '00003' && fm.ven_st[0].checked == true ){
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		}else{
			fm.buy_v_amt.value = 0;				
		}
		set_buy_amt();			
	}	
	
	//�ŷ�ó��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.ven_name.value != '')	fm.t_wd.value = fm.ven_name.value;		
		window.open("../doc_reg/sc_vendor_list2.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=850, height=400, scrollbars=yes");		
	}
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	//������ȸ�ϱ�
	function Rent_search(idx1){
		var fm = document.form1;	
		var t_wd;	
		
	//	if( fm.acct_code.value == '00004' || fm.acct_code.value == '00005' || fm.acct_code.value == '00006' || fm.acct_code.value == '00018' || fm.acct_code.value == '00019')	{	idx1 = toInt(idx1);		}		
	
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
				
		//������ ����
		if(fm.acct_code.value == '00005' 	){ 	//���������
			//if(fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			if(fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false )
			{	alert('������ �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		}
					
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('��ȸ�� ������ȣ/��ȣ�� �Է��Ͻʽÿ�.'); 	fm.item_name[idx1].focus(); 	return;}
		
		
		if(fm.acct_code.value == '00005' ) {		
			if (fm.acct_code_g[9].checked 	== true  || fm.acct_code_g[12].checked 	== true ) { //�Ϲ������, �縮�� �����	
				window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
			} else {
			   	window.open("../doc_reg/rent_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&go_url=/doc_mng/sc_doc_reg_u.jsp", "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
			}
		} else if (fm.acct_code.value == '00006') {
			window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");
		} else if (fm.acct_code.value == '00004') {
			window.open("../doc_reg/rent_search.jsp?acct_code=00004&idx1="+idx1+"&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");	
	    } else {		
			window.open("../doc_reg/rent_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&go_url=/doc_mng/sc_doc_reg_u.jsp", "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
		}
			
	}

	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
		
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.buy_user_nm.value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "../card_mng/sc_user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}	
	
	//������ȸ-�����Է�
	function User_search2(nm, idx)
	{
		var fm = document.form1;
		if(fm.user_nm[idx].value != '') 	fm.t_wd.value = fm.user_nm[idx].value;
		else								fm.t_wd.value = '';
		window.open("about:blank",'User_search2','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/sc_user_m_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search2";
		fm.submit();		
	}
	
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	

	function cng_vs_input(){
		var fm = document.form1;
		
		//����� �ƴϰ�, �Ϲݰ����� ���
		if(fm.acct_code.value !== '00002' && fm.acct_code.value !== '00003'  && fm.acct_code_g.value !== '3' && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;	
		}
		
		tot_buy_amt();			
		
	}
	
	//�������� ���ý�
	function cng_input(val){
		var fm = document.form1;
		
		//�켱 ���� �� ���̰� �����
		tr_acct1.style.display		= 'none';
		tr_acct2.style.display		= 'none';
		tr_acct3.style.display		= 'none';
		tr_acct4.style.display		= 'none';
		tr_acct6.style.display		= 'none';
		tr_acct7.style.display		= 'none';
		tr_acct8.style.display		= 'none';			
		tr_acct3_1.style.display	= 'none';
		tr_acct3_2.style.display	= 'none';
		tr_acct3_3.style.display	= 'none';
		tr_acct98.style.display		= 'none';
		tr_acct97.style.display		= 'none';
		tr_acct99.style.display	 	= 'none';
		tr_acct101.style.display 	= 'none';	 
		tr_acct_plus.style.display	= 'none';   //������� 
		
	<%for(int i=1;i<=19 ;i++){%>
		tr_acct3_<%=i%>_1.style.display	= 'none';
		tr_acct3_<%=i%>_2.style.display	= 'none';
		tr_acct3_<%=i%>_3.style.display	= 'none';
		tr_acct3_<%=i%>_98.style.display= 'none';
		tr_acct3_<%=i%>_97.style.display= 'none';
	
	<%}%>	
		
		if(val == '00001'){ 		//�����Ļ���
			tr_acct1.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
			tr_acct99.style.display	 	= 'table-row';
			tr_acct101.style.display 	= 'table-row';	 
			fm.acct_code_g[0].checked 	= true;  //�Ĵ�
			fm.acct_code_g2[1].checked 	= true;//�߽�
			fm.acct_code_s[0].checked = true;//1/n
					
		}else if(val == '00002'){ 	//�����		
			tr_acct6.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
			tr_acct99.style.display		= 'table-row';
			tr_acct101.style.display 	= 'table-row';				
		
			fm.acct_code_g[18].checked 	= true;   //�Ĵ�
			
		}else if(val == '00003'){ 	//�������
			tr_acct4.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
			tr_acct99.style.display		= 'table-row';	
			tr_acct101.style.display 	= 'table-row';		
					
			fm.acct_code_g[14].checked 	= true;  //�����
			
		}else if(val == '00004'){ 	//����������
			tr_acct_plus.style.display	= 'none';   //������� 
			tr_acct2.style.display		= 'table-row';  //����
			tr_acct3_1.style.display	= 'table-row';		
			tr_acct3_2.style.display	= 'table-row';					
			tr_acct98.style.display		= 'table-row';
						
			fm.acct_code_g[5].checked 	= true;  //���ָ�
			fm.acct_code_g2[9].checked 	= true; //����
						
		//	fm.car_su.value = '1';	
				
		}else if(val == '00005'){ 	//���������
			tr_acct3.style.display		= 'table-row';
			tr_acct_plus.style.display	= 'table-row'; 
			tr_acct3_1.style.display	= 'table-row';
			tr_acct3_3.style.display	= 'table-row';
			tr_acct98.style.display		= 'table-row';
				
			fm.acct_code_g[9].checked = true;//�Ϲ����� 
			fm.acct_code_g2[12].checked 	= true; //���� - ���� 
			
	//		fm.car_su.value = '1';	
								
		}else if(val == '00006'){ 	//��������
			tr_acct_plus.style.display	= 'table-row';			
			tr_acct3_1.style.display	= 'table-row';
			tr_acct3_3.style.display	= 'table-row';
			tr_acct98.style.display		= 'table-row';
			
			fm.car_su.value = '1';	
			
		}else if(val == '00009'){ 	//��ź�
			tr_acct7.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
						
			fm.acct_code_g[21].checked 	= true;  //����
			
		}else if(val == '00016' || val == '00017'){ 	//�뿩�������/�����������
			tr_acct8.style.display		= 'table-row';	
			tr_acct98.style.display		= 'table-row';
						
			fm.acct_code_g[23].checked 	= true;  //������ϼ�
			
		}else if(val == '00018' ){ 	//��ݺ�
			tr_acct3_1.style.display	= 'table-row';
			tr_acct98.style.display		= 'table-row';
		
		}else if(val == '00019'){ 	//������� 
			tr_acct_plus.style.display	= 'table-row'; 
			tr_acct3_1.style.display	= 'table-row';		
			tr_acct98.style.display		= 'table-row';	
			tr_acct97.style.display		= 'table-row';
			
			//����� 1���̸�
			if ( fm.car_su.value  == '1') {
				fm.doc_amt[0].value = fm.buy_amt.value;
			}
								
		}else{
			tr_acct98.style.display		= 'table-row';  //����
			
		}
	
	}

	//�����Ļ��� ���� ���ý�
	function cng_input2(val){
		var fm = document.form1;
		
		tot_buy_amt();
		
		tr_acct1_1.style.display	= 'none';
		tr_acct1_2.style.display	= 'none';
		tr_acct98.style.display 	= 'none';
		tr_acct99.style.display 	= 'none';
		tr_acct101.style.display 	= 'none';
		
		if(val == '1'){ //�Ĵ�
			fm.acct_code_g2[1].checked 	= true;
			tr_acct1_1.style.display	= 'table-row';
			tr_acct98.style.display 	= 'table-row';
			tr_acct99.style.display 	= 'table-row';
			tr_acct101.style.display 	= 'table-row';
			
		}
		if(val == '2'){ //ȸ�ĺ�
			fm.acct_code_g2[3].checked 	= true;
			tr_acct1_2.style.display	= 'table-row';			
			tr_acct98.style.display 	= 'table-row';
			tr_acct99.style.display 	= 'table-row';			
			tr_acct101.style.display 	= 'table-row';
		
		}
		if(val == '15' || val == '3' || val == '30'){ //������, ��Ÿ, �����ް�		
			tr_acct98.style.display 	= 'table-row';
			tr_acct99.style.display 	= 'table-row';			
			tr_acct101.style.display 	= 'table-row';
			
		}
		
	}	

	//�����Ļ��� ȸ�ĺ� ���� ���ý�	
	function cng_input22(val){
		var fm = document.form1;
				
		tr_acct98.style.display 	= 'table-row';
		tr_acct99.style.display 	= 'table-row';					
		tr_acct101.style.display 	= 'table-row';	
	}
	
	//��ź� ���� ���ý�	
	function cng_input7(val){
		
		var fm = document.form1;		
		if(val == '16'){			//����			
			tr_acct99.style.display 	= 'table-row';					
			tr_acct101.style.display 	= 'table-row';			
		}
		if(val == '17'){			//����
			tr_acct99.style.display 	= 'none';					
			tr_acct101.style.display 	= 'none';	
		
		}
	}
	
		//����� , ������ �׸� ���� ���ý�
	function cng_input4(val){
	  	    
		var fm = document.form1;	
		
		fm.car_su.value='1';		
		cng_input_carsu(fm.car_su.value);
		
		 if(val == '6'){			//�Ϲ������ 
			 	tr_acct_plus.style.display	= 'table-row';
				tr_acct3_1.style.display	= 'table-row';
				tr_acct3_3.style.display	= 'table-row';
				tr_acct98.style.display	= 'table-row';
		 
	    } else  if(val == '7' || val == '21'  ){			//�ڵ����˻�, �縮�� ���� 
					
				tr_acct3_1.style.display	= 'table-row';
				tr_acct98.style.display	= 'table-row';
			
		 } else  if(val == '18' || val == '22'  ){			//��ȣ��, ��Ÿ  
						
				tr_acct98.style.display	= 'table-row';
			
		 } else  if(val == '27'  ){			//������
		 			tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_2.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';
		 } else {		 
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_2.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';		 
		 }	
		
	}		
		
				
	//���δ� ���� �ݾ�(1/n:0, �ݾ������Է�:1)
	function cng_input1(){
		var fm 		= document.form1;
		var inCnt	= toInt(fm.user_su.value);
		var inTot	= toInt(parseDigit(fm.buy_amt.value));
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;	

//		if(inCnt > 100){	alert('1/n �Է��� �ִ� 100�α��� �Դϴ�.'); return;}
		if(inCnt > acar_cnt){	alert('1/n �Է��� �ִ� '+acar_cnt+'�α��� �Դϴ�.'); return;}
		
		if(fm.user_Rdio[0].checked == true && inCnt > 0 && (toInt(parseDigit(fm.buy_amt.value)) > 0 || toInt(parseDigit(fm.buy_amt.value)) < 0 ))
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_amt.value)) / inCnt);			

			for(i=0; i<inCnt ; i++){
				fm.money[i].value = parseDecimal(inAmt);
				innTot += inAmt;
				
				
			}
	//		for(i=inCnt; i<100 ; i++){
			for(i=inCnt; i<acar_cnt ; i++){
				fm.money[i].value = '0';
			}
			
			if(inTot > innTot) 	fm.money[0].value 		= parseDecimal(toInt(parseDigit(fm.money[0].value)) 	  + (inTot-innTot));
			if(inTot < innTot) 	fm.money[inCnt-1].value = parseDecimal(toInt(parseDigit(fm.money[inCnt-1].value)) + (inTot-innTot));
			
			fm.txtTot.value = fm.buy_amt.value;
			
		}
		
		if(fm.user_Rdio[1].checked == true)
		{
	//		for(i=0; i<100 ; i++){		
			for(i=0; i<acar_cnt ; i++){
				fm.money[i].value = '0';
			}
			fm.txtTot.value = '0';
		}
	}
		
	function cng_input_vat(){
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio[0].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) + 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
		
		if(fm.vat_Rdio[1].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) - 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
	}
	
	//�����Է½� �հ��� �� ����
	function Keyvalue(){
		var fm 		= document.form1;
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;
		
	//	for(i=0; i<100 ; i++){
		for(i=0; i<acar_cnt ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		fm.txtTot.value = parseDecimal(innTot);
	}
	
	function CardDocHistory(ven_code, cardno, buy_id){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code+"&cardno="+cardno+"&buy_id="+buy_id, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
	
	function VendorHistory(ven_code){
		var fm = document.form1;
		window.open("../doc_reg/vendor_history.jsp?ven_code="+ven_code, "VENDOR_H_LIST", "left=10, top=10, width=1050, height=600, scrollbars=yes");				
	}
	
	//������氨��û�������
	function M_doc_action(st, m_doc_code, seq1, seq2, buy_user_id, doc_bit, doc_no){
		var fm = document.form1;
		fm.st.value 		= st;		
		fm.m_doc_code.value 	= m_doc_code;
		fm.seq1.value 		= seq1;
		fm.seq2.value 		= seq2;		
		fm.doc_bit.value 	= doc_bit;
		fm.doc_no.value 	= '';		
		fm.action = '/fms2/consignment/cons_oil_doc_u.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//����û����������ȸ
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		//window.open("http://www.nts.go.kr/cal/cal_check_02.asp", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}	
	
	function cng_input5(val){
		var fm = document.form1;
		
		if(fm.acct_code.value == '00001' ) {		
			tr_acct1.style.display		= 'table-row';	
        }
      
		if(val == '1'){ //��ȥ��
						
			fm.user_su.value = '1';
			fm.user_Rdio[0].checked = true;//1/n �ڵ����� üũ
			fm.user_case_id.value = "<%=single_id%>";
			fm.user_nm.value = "<%=single_name%>";
		
			if(fm.user_case_id.value != fm.buy_user_id.value){
				fm.user_case_id.value = fm.buy_user_id.value;
				fm.user_nm.value = fm.buy_user_nm.value;
			}
			
			tr_acct101.style.display 	= 'none';
				
			cng_input11();
		}
		if(val == '2'){ //��Ʈ��
		//	fm.user_su.value = "";
			tr_acct101.style.display 	= '';
			var idx = "1";
			var nm = "user_case_id";
			var dept_id = "PPPP";
			window.open("about:blank",'User_Group','scrollbars=yes,status=no,resizable=yes,width=600,height=400,left=370,top=200');		
			fm.action = "../card_mng/sc_user_m_search2.jsp?dept_id="+dept_id+"&nm="+nm+"&idx="+idx;
			fm.target = "User_Group";
			fm.submit();
						
		}
		if(val == '3'){ //����
			fm.user_su.value = "";
			tr_acct101.style.display 	= '';
		}
	}
	
	//�����̿�����ȸ
	function CarMgr_search(idx1){
		var fm = document.form1;	
		var t_wd;
	//	if(fm.acct_code.value == '00005' || fm.acct_code.value == '00006')	{	idx1 = toInt(idx1)+1;		}
		if(fm.rent_l_cd[idx1].value != ''){	fm.t_wd.value = fm.rent_l_cd[idx1].value;}
		else{ 							alert('��ȸ�� ������ȣ�� �Է��Ͻʽÿ�.');  	return;}
		window.open("../doc_reg/s_man.jsp?idx1="+idx1+"&s_kd=3&t_wd="+fm.rent_l_cd[idx1].value, "CarMgr_search", "left=10, top=10, width=600, height=400, scrollbars=yes, status=yes, resizable=yes");				
		
	}
	
	//���д� �ο� ����
	function cng_input11(){
		
		var fm = document.form1.user_Rdio;
		var val = '';
		for(i=0; i<fm.length; i++) {
			if(fm[i].checked == true) 	val=i;
		}
		
		cng_input1();
	}
	
	function cng_input3(){
		
		var fm = document.form1;
		
		tot_buy_amt();
		
		if(fm.acct_code_g2[8].checked == true){ //����		- ����
	     //	  alelt("aaa");	
			fm.item_name[0].value = "<%=CAR_NO%>";
			fm.acct_cont[0].value = "<%="(��)�Ƹ���ī - "+CAR_NO%>";
			fm.item_code[0].value = "<%=CAR_MNG_ID%>";
			fm.rent_l_cd[0].value = "<%=RENT_L_CD%>";
			fm.last_dist[0].value = "<%=TOT_DIST%>";
			fm.last_serv_dt[0].value = "<%=AddUtil.ChangeDate2((String)SERV_DT)%>";
			fm.tot_dist[0].value =""
			fm.oil_liter[0].value =""
			fm.o_cau[0].value =""
					
			fm.buy_amt.readOnly  = true;			
		
		} else if(fm.acct_code_g2[11].checked == true){ //����	 - ����  
	//	    alelt("bbb");	
		   fm.item_name[0].value = "";
			fm.acct_cont[0].value = "";
			fm.item_code[0].value = "";
			fm.rent_l_cd[0].value = "";
			fm.tot_dist[0].value =""
			fm.oil_liter[0].value =""
			fm.o_cau[0].value =""
			fm.last_dist[0].value = "";
			fm.last_serv_dt[0].value = "";
			
			fm.buy_amt.readOnly  = true;		
		
		}else{
						
				fm.item_name[0].value = "";
				fm.acct_cont[0].value = "";
				fm.item_code[0].value = "";
				fm.rent_l_cd[0].value = "";
				fm.tot_dist[0].value =""
				fm.oil_liter[0].value =""
				fm.o_cau[0].value =""
				fm.last_dist[0].value = "";
				fm.last_serv_dt[0].value = "";
				
				fm.buy_amt.readOnly  = false;				
		}		
		
	}
	
	//����ڵ�Ϲ�ȣ '-' �ڵ� �Է�
	function OnCheckBiz_no(oTa){ 
		var oForm = oTa.form ; 
		var sMsg = oTa.value ; 
		var onlynum = "" ; 
			onlynum = RemoveDash2(sMsg);
			
		if(event.keyCode != 8 ){ 
			if (GetMsgLen(onlynum) <= 2) oTa.value = onlynum ; 
			if (GetMsgLen(onlynum) == 3) oTa.value = onlynum + "-"; 
			if (GetMsgLen(onlynum) == 5) oTa.value = onlynum.substring(0,3) + "-" + onlynum.substring(3,5) + "-" + onlynum.substring(6,7); 
		} 
	}
	
	function RemoveDash2(sNo){ 
		var reNo = "" 
		
		for(var i=0; i<sNo.length; i++) { 
			if ( sNo.charAt(i) != "-" ) { 
				reNo += sNo.charAt(i) 
			} 
		} 
		return reNo 
	}
	
	function GetMsgLen(sMsg){ // 0-127 1byte, 128~ 2byte 
		var count = 0 
		for(var i=0; i<sMsg.length; i++) { 
			if ( sMsg.charCodeAt(i) > 127 ) { 
				count += 2 
			}else{ 
				count++ 
			} 
		} 
		return count 
	}
	
	
		//����
	function Del_app(){
		var fm = document.form1;
		if(confirm('�����Ͻðڽ��ϱ�?')){					
		if(confirm('��¥�� �����Ͻðڽ��ϱ�?')){					
		if(confirm('���� �����Ͻðڽ��ϱ�?')){									
			fm.action='sc_doc_reg_del.jsp';		
			fm.target='i_no';

			fm.submit();
		}}}
	}
		

	//���� - ����ī���� ������������ ī����ݾ��� ���ι޾Ƽ� ��ҷ� �Ѿ��. - ������Ҹ� �̵�ϻ��·� ����  (�Ƹ���Ź���� ����ϴ� ����ī�� )
	function Mod_app(){
		var fm = document.form1;
				
		if(confirm('������Ҹ� �̵�ϻ��·� �����Ͻðڽ��ϱ�?')){									
			fm.action='sc_doc_reg_del.jsp?cmd=oil';		
			fm.target='i_no';
	
			fm.submit();
		}
	}
		
</script>

</head>
<body <%if(app_st.equals("�̵��")){%>onLoad="javascript: cng_input5('1'); "<%}%>>
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type="hidden" name="buy_id" value="<%=buy_id%>">
	<input type='hidden' name='st' 	 value=''>
	<input type='hidden' name='m_doc_code' value=''>  
	<input type='hidden' name='seq1' 	 value=''>
	<input type='hidden' name='seq2' 	 value=''>
	<input type='hidden' name="doc_bit" 	 value="">
	<input type='hidden' name="doc_no" 	 value="">
	<input type='hidden' name='nts_yn' value=''>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type="hidden" name="acar_cnt" value="<%=vt_acar_size%>">

<table border=0 cellspacing=0 cellpadding=0 width=98% class="search-area">
	<tr>
		<td colspan="2">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp; <span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>New ī����ǥ����</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
    <tr> 
		<td colspan="2">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
    				<td><label><i class="fa fa-check-circle"></i> �ŷ����� </label></td>
    				<td align="right">
    					<%if(reg_user_id.equals("") && cd_bean.getApp_id().equals("")){%>
    					   	
    					  <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
				      		<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;
				      	    <%}%>	
						<%}else if(!reg_user_id.equals("") && cd_bean.getApp_id().equals("")){%>
							<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id) || cd_bean.getBuy_user_id().equals(user_id)){%>
							<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
							<%}%>
						<%}else{%>
							<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id)){%>	
							<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
							<%} %>
						<%} %>
			      	    <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
			      	    <%if(reg_user_id.equals("") && ( cd_bean.getApp_id().equals("") || cd_bean.getApp_id().equals("cance0") ) ){%>
			      	    	<%if(nm_db.getWorkAuthUser("������",user_id) ){%>
			      	    		<a  href="javascript:Del_app()" style="margin-left:60px;"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>
			      	    	<% }%>
			      	    	
			      	    <%}%><!-- ���� ��ư ��ġ ���� 2018.02.27 -->
			      	    </td>
			      	</td>
    			</tr><!-- 
				<tr>
					<td class=line2 colspan=2></td>
				</tr> -->
			    <tr> 
			    	<td colspan="2" class="line">
			    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
							<tr>
								<td width="10%" class='title'>�������</td>
								<td width="15%">
									&nbsp;<input name="app_st" type="text" class="whitetext" value="<%=app_st%>" size="10"  style="font-weight: bold;"readonly>
									<% if ( !cd_bean.getReg_dt().equals("") && app_st.equals("�������")) { %>
										<%if(nm_db.getWorkAuthUser("������",user_id)){%>
			      	    				<a  href="javascript:Del_app()" style="margin-left:60px;"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>
			      	    				<% }%>
			      	    				<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id)){%>
			      	    					<a  href="javascript:Mod_app()" style="margin-left:60px;">[��������]</a>
			      	    				<% }%>
			      	    			<% }%>
			      	    			<% if ( cd_bean.getReg_dt().equals("") && app_st.equals("�������")  ) { %> <!--  �Ƹ���Ź�ۻ�� ��������  String.valueOf(ht3.get("BUY_USER_ID")).equals("000223")-->
			      	    				<%if (nm_db.getWorkAuthUser("������",user_id)  ){%>
			      	    				<a  href="javascript:Mod_app()" style="margin-left:60px;"> [�̵������] </a>
			      	    				<% }%>
			      	    			<% }%>
									</td>
								<td width='10%' class='title'>�ſ�ī���ȣ</td>
								<td width="15%">
									&nbsp;<input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="20" readonly></td>
								<td width="10%" class='title'>ī��߱�����</td>
								<td width="*">
									&nbsp;<input name="card_sdate" type="text" class="whitetext" value='<%=AddUtil.ChangeDate3(String.valueOf(ht3.get("USE_S_DT")))%>' size="20" readonly></td>
							</tr>
							<tr>
								<td class='title'>����ڱ���</td>
								<td>
									&nbsp;<input name="card_name" type="text" class="whitetext" value="<%=ht3.get("CARD_NAME")==null?"":ht3.get("CARD_NAME")%>" size="20" readonly></td>
								<td class='title'>�����</td>
								<td>
									&nbsp;<input name="reg_id" type="text" class="whitetext" value="<%=c_db.getNameById(reg_user_id, "USER")%>" size="20" readonly>
								<td class='title'>�������</td>
								<td>
									&nbsp;<input name="reg_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cd_bean.getReg_dt())%>" size="20" readonly></td>
							</tr>
							<tr>
								<td class='title'><font color="red">*</font> ���������</td>
								<td>
									&nbsp;<input name="buy_user_nm" type="text" class="text" value="<%=single_name%>" size="12" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id', '0')">
									<input type="hidden" name="buy_user_id" value="<%=single_id%>">
									<a href="javascript:User_search('buy_user_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
								<td class='title'>������</td>
								<td>
									&nbsp;<input name="app_id" type="text" class="whitetext" value="<%=c_db.getNameById(cd_bean.getApp_id(), "USER")%>" size="30" readonly></td>
								<td class='title'>��������</td>
								<td>
									&nbsp;<input name="app_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cd_bean.getApp_dt())%>" size="20" readonly></td>
							</tr>
						</table>
			        </td>
			    </tr> 
      		</table>
      	</td>
    </tr>    
    <tr><td class=h></td></tr>
	<tr>
		<td colspan="2" class=line>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="3%" class='title' rowspan="3">��<br>��<br>��<br>��</td>
					<td width="7%" class='title'>���ް�</td>
					<td width="15%">&nbsp;<input type="text" name="buy_s_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_s_amt())%>" size="12" class=num   <% if( nm_db.getWorkAuthUser("������",user_id) ||nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)   ){%> <% } else { %> readonly <%} %> onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();'>��</td><!-- onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();' -->
					<td width="10%" class='title'>�ŷ�����</td>
					<td width="*">&nbsp;<input class="whitetext" name="buy_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(cd_bean.getBuy_dt())%>" size="12" readonly></td>
				</tr>
				<tr>
					<td class='title'>�ΰ���</td>
					<td>&nbsp;<input type="text" name="buy_v_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_v_amt())%>" size="12" class=num  <% if( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)  ){%> <% } else { %> readonly <%} %> onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();'>��</td> <!-- onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();' -->
					<td class='title'>�ŷ�ó</td>
					<td>&nbsp;<input class="whitetext" name="ven_name" type="text" class="text" size="22" value="<%=cd_bean.getVen_name()%>" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)" readonly>
						&nbsp;(����ڵ�Ϲ�ȣ:<input type="text" class="whitetext" size="11" name="ven_nm_cd" value="<%=AddUtil.ChangeEnt_no(String.valueOf(vendor.get("S_IDNO")))%>" onfocus="OnCheckBiz_no(this.value)" onKeyup="OnCheckBiz_no(this.value)" readonly>)
						<input type="hidden" name="ven_code" value="<%=cd_bean.getVen_code()%>"> &nbsp;
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
						&nbsp;<a href="javascript:CardDocHistory('<%=cd_bean.getVen_code()%>','<%=cd_bean.getCardno()%>','<%=cd_bean.getBuy_id()%>');"><img src=/acar/images/center/button_in_uselist.gif border=0 align=absmiddle></a>
						&nbsp;<a href="javascript:VendorHistory('<%=cd_bean.getVen_code()%>');"><img src=/acar/images/center/button_in_bgir.gif border=0 align=absmiddle></a><br>
						<div style="vertical-align:middle; padding-top:5px;">&nbsp;<font color="red" >�� �������� ���� �ŷ�ó ������ �ٸ� ���, '�˻�'�� ���� �ùٸ� ������ �����ٶ��ϴ�.</font></div>
					</td>
				</tr>
				<tr>
					<td class='title'>�հ�</td>
					<td>&nbsp;<input type="text" name="buy_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_amt())%>" size="12" class=num readonly>��<!--  onBlur='javascript:this.value=parseDecimal(this.value); tot_buy_amt();' -->
					</td>
					<td class='title'>��������</td>
					<td>
						&nbsp;<input type="radio" name="ven_st" value="1" <%if(cd_bean.getVen_st().equals("1"))%>checked<%%>  onClick="javascript:cng_vs_input()">�Ϲݰ���
			     		&nbsp;<input type="radio" name="ven_st" value="2" <%if(cd_bean.getVen_st().equals("2"))%>checked<%%>  onClick="javascript:cng_vs_input()">���̰���
			     		&nbsp;<input type="radio" name="ven_st" value="3" <%if(cd_bean.getVen_st().equals("3"))%>checked<%%>  onClick="javascript:cng_vs_input()">�鼼
			     		&nbsp;<input type="radio" name="ven_st" value="4" <%if(cd_bean.getVen_st().equals("4"))%>checked<%%>  onClick="javascript:cng_vs_input()">�񿵸�����(�������/��ü)
						<%-- <%if(cd_bean.getVen_st().equals("1"))%><input type="text" name="" value="�Ϲݰ���" size="8" class="whitetext" readonly><input type="hidden" name="ven_st" value='1'><%%> 
						<%if(cd_bean.getVen_st().equals("2"))%><input type="text" name="" value="���̰���" size="8" class="whitetext" readonly><input type="hidden" name="ven_st" value='2'><%%> 
						<%if(cd_bean.getVen_st().equals("3"))%><input type="text" name="" value="�鼼" size="8" class="whitetext" readonly><input type="hidden" name="ven_st" value='3'><%%> 
						<%if(cd_bean.getVen_st().equals("4"))%><input type="text" name="" value="�񿵸�����(�������/��ü)" size="25" class="whitetext" readonly><input type="hidden" name="ven_st" value='4'><%%> --%> 
						&nbsp; <a href="javascript:search_nts();"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<tr>
		<td colspan="2"><label><i class="fa fa-check-circle"></i> ��볻�� </label></td>
	</tr>
	<tr>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>��������</td>
			    	<td width="*">&nbsp;
	  					<select name="acct_code" onchange="javascript:cng_input(this.options[this.selectedIndex].value); cng_input3(); tot_buy_amt();">
		  					<optgroup label="����">
				  				<option value="00001"<%if(cd_bean.getAcct_code().equals("00001"))%> selected<%%>>�����Ļ���</option>
				  				<option value="00002"<%if(cd_bean.getAcct_code().equals("00002"))%> selected<%%>>�����</option>
				  				<option value="00003"<%if(cd_bean.getAcct_code().equals("00003"))%> selected<%%>>�������</option>
				  				<option value="00004"<%if(cd_bean.getAcct_code().equals("00004"))%> selected<%%>>����������</option>
				  				<option value="00005"<%if(cd_bean.getAcct_code().equals("00005"))%> selected<%%>>���������</option>
				  				<option value="00006"<%if(cd_bean.getAcct_code().equals("00006"))%> selected<%%>>��������</option>
				  				<option value="00007"<%if(cd_bean.getAcct_code().equals("00007"))%> selected<%%>>�繫��ǰ��</option>
				  				<option value="00009"<%if(cd_bean.getAcct_code().equals("00009"))%> selected<%%>>��ź�</option>
			  				</optgroup>
			  				<optgroup label="����">
			  					<option value="00008"<%if(cd_bean.getAcct_code().equals("00008"))%> selected<%%>>�Ҹ�ǰ��</option>
			  					<option value="00010"<%if(cd_bean.getAcct_code().equals("00010"))%> selected<%%>>�����μ��</option>
			  					<option value="00011"<%if(cd_bean.getAcct_code().equals("00011"))%> selected<%%>>���޼�����</option>
			  					<option value="00012"<%if(cd_bean.getAcct_code().equals("00012"))%> selected<%%>>��ǰ</option>
			  					<option value="00013"<%if(cd_bean.getAcct_code().equals("00013"))%> selected<%%>>���ޱ�</option>
			  					<option value="00014"<%if(cd_bean.getAcct_code().equals("00014"))%> selected<%%>>�����Ʒú�</option>
			  					<option value="00015"<%if(cd_bean.getAcct_code().equals("00015"))%> selected<%%>>���ݰ�����</option>
			  					<option value="00016"<%if(cd_bean.getAcct_code().equals("00016"))%> selected<%%>>�뿩�������</option>
			  					<option value="00017"<%if(cd_bean.getAcct_code().equals("00017"))%> selected<%%>>�����������</option>
			  					<option value="00018"<%if(cd_bean.getAcct_code().equals("00018"))%> selected<%%>>��ݺ�</option>
			  					<option value="00019"<%if(cd_bean.getAcct_code().equals("00019"))%> selected<%%>>�������</option>
			  					<option value="00021"<%if(cd_bean.getAcct_code().equals("00021"))%> selected<%%>>�����񼱱ޱ�</option>
			  					<option value="00023"<%if(cd_bean.getAcct_code().equals("00023"))%> selected<%%>>��������</option>
			  				</optgroup>					  				
			  			</select>
			  		</td>
			    </tr>		
			</table>
		</td>
	</tr>
	<tr id=tr_acct1 style='display:<%if(cd_bean.getAcct_code().equals("00001")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" rowspan="2" class='title'>����</td>
					<td width="*">&nbsp;
						<input type="radio" name="acct_code_g" value="1" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("1") || cd_bean.getAcct_code_g().equals(""))%>checked<%%>>�Ĵ�
						<input type="radio" name="acct_code_g" value="2" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("2"))%>checked<%%>>ȸ�ĺ�
						<input type="radio" name="acct_code_g" value="15" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("15"))%>checked<%%>>������	
						<input type="radio" name="acct_code_g" value="3" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("3"))%>checked<%%>>��Ÿ	
						<input type="radio" name="acct_code_g" value="30" disabled  onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("30"))%>checked<%%>>�����ް�				
					</td>
				</tr>
				<tr>
					<td>
						<table width="90%"  border="0" cellpadding="0" cellspacing="0">
							<tr id=tr_acct1_1 style='display:<%if(cd_bean.getAcct_code_g().equals("1") || cd_bean.getAcct_code_g2().equals("")){%>table-row<%}else{%>none<%}%>'>
								<td>&nbsp;
									<input type="radio" name="acct_code_g2" value="1" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("1"))%>checked<%%>>����
									<input type="radio" name="acct_code_g2" value="2" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("2") || cd_bean.getAcct_code_g2().equals(""))%>checked<%%>>�߽�
									<input type="radio" name="acct_code_g2" value="3" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("3"))%>checked<%%>>Ư�ٽ�
								</td>
							</tr>
							<tr id=tr_acct1_2 style='display:<%if(cd_bean.getAcct_code_g().equals("2")){%>table-row<%}else{%>none<%}%>'>
								<td>&nbsp;
									<input type="radio" name="acct_code_g2" value="15" <%if(cd_bean.getAcct_code_g2().equals("15"))%>checked<%%>>�系��ȣȸ
									<input type="radio" name="acct_code_g2" value="4" <%if(cd_bean.getAcct_code_g2().equals("4"))%>checked<%%>>ȸ����ü����
									<input type="radio" name="acct_code_g2" value="5" <%if(cd_bean.getAcct_code_g2().equals("5"))%>checked<%%>>�μ��� �������
									<input type="radio" name="acct_code_g2" value="6" <%if(cd_bean.getAcct_code_g2().equals("6"))%>checked<%%>>�μ��� ������ȸ��
									<br>&nbsp;&nbsp;<input type="radio" name="acct_code_g2" value="31" <%if(cd_bean.getAcct_code_g2().equals("31"))%>checked<%%>>�繫�������ġ��
									&nbsp;&nbsp;&nbsp;&nbsp;<font color=blue>*�繫�������ġ�� �μ��� ���ǰ� �ִ� ��쿡 ���Ͽ� ������� �����Ͽ� ó���� �� ����. ����� �μ��� �յ�δ� </font> 	
									<br>&nbsp;&nbsp;<input type="radio" name="acct_code_g2" value="33" <%if(cd_bean.getAcct_code_g2().equals("33"))%>checked<%%>>�ڷγ��濪��	
									&nbsp;(* ������� : <%=Util.parseDecimal(coamt)%> )  																	
								</td>
							</tr>
					     </table>
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="5%" class='title' rowspan="2">����</td>
          			<td width="5%" class='title'>����</td>
					<td width="*">&nbsp;
						<input type="radio" name="acct_code_g" value="13"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("13"))%>checked<%%>>���ָ�
						<input type="radio" name="acct_code_g" value="4"   onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("4"))%>checked<%%>>����
						<input type="radio" name="acct_code_g" value="5"   onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("5"))%>checked<%%>>LPG			
						<input type="radio" name="acct_code_g" value="27"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>����/����	<!-- ���������� �߰� -->
					</td>
				</tr>
				<tr>
					<td class='title'>�뵵</td>
					<td> &nbsp;
						<input type="radio" name="acct_code_g2" value="11" <%if(cd_bean.getAcct_code_g2().equals("11"))%>checked<%%> onClick="javascript:cng_input3(this.value)">����
						<input type="radio" name="acct_code_g2" value="12" <%if(cd_bean.getAcct_code_g2().equals("12"))%>checked<%%> onClick="javascript:cng_input3(this.value)">������ ����
						<input type="radio" name="acct_code_g2" value="13" <%if(cd_bean.getAcct_code_g2().equals("13"))%>checked<%%> onClick="javascript:cng_input3(this.value)">������
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct3 style='display:<%if(cd_bean.getAcct_code().equals("00005")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="5%" class='title' rowspan="2">����</td>
					<td width="5%" class='title'>����</td>
				   <td width="*">&nbsp;
						<input type="radio" name="acct_code_g" value="6"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("6"))%>checked<%%>>�Ϲ�����
						<input type="radio" name="acct_code_g" value="7"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("7"))%>checked<%%>>�ڵ����˻�
						<!--<input type="radio" name="acct_code_g" value="8"  onClick="javascript:cng_input4(this.value)" <%if(cd_bean.getAcct_code_g().equals("8"))%>checked<%%>>���˱�Ϻ� -->	
						<input type="radio" name="acct_code_g" value="18" onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("18"))%>checked<%%>>��ȣ�Ǵ��
						<input type="radio" name="acct_code_g" value="21" onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("21"))%>checked<%%>>�縮������
						<input type="radio" name="acct_code_g" value="22" onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("22"))%>checked<%%>>��Ÿ
					</td>
				</tr>
				</tr>
				<tr>
					<td class='title'>�뵵</td>
					<td> &nbsp;
						<input type="radio" name="acct_code_g2" value="21" <%if(cd_bean.getAcct_code_g2().equals("21"))%>checked<%%> onClick="javascript:cng_input3(this.value)">����
						<input type="radio" name="acct_code_g2" value="22" <%if(cd_bean.getAcct_code_g2().equals("22"))%>checked<%%> onClick="javascript:cng_input3(this.value)">������
						<input type="radio" name="acct_code_g2" value="23" <%if(cd_bean.getAcct_code_g2().equals("23"))%>checked<%%> onClick="javascript:cng_input3(this.value)">����
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct4 style='display:<%if(cd_bean.getAcct_code().equals("00003")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="9"  <%if(cd_bean.getAcct_code_g().equals("9"))%>checked<%%>>�����
						<input type="radio" name="acct_code_g" value="10" <%if(cd_bean.getAcct_code_g().equals("10"))%>checked<%%>>��Ÿ�����
						<input type="radio" name="acct_code_g" value="20" <%if(cd_bean.getAcct_code_g().equals("20"))%>checked<%%>>�����н�
						<input type="radio" name="acct_code_g" value="32" <%if(cd_bean.getAcct_code_g().equals("32"))%>checked<%%>>��������
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id=tr_acct6 style='display:<%if(cd_bean.getAcct_code().equals("00002")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="11" <%if(cd_bean.getAcct_code_g().equals("11"))%>checked<%%>>�Ĵ�
						<input type="radio" name="acct_code_g" value="12" <%if(cd_bean.getAcct_code_g().equals("12"))%>checked<%%>>������
						<input type="radio" name="acct_code_g" value="14" <%if(cd_bean.getAcct_code_g().equals("14"))%>checked<%%>>��Ÿ
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id=tr_acct7 style='display:<%if(cd_bean.getAcct_code().equals("00009")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="16" onClick="javascript:cng_input7(this.value)" <%if(cd_bean.getAcct_code_g().equals("16"))%>checked<%%>>����
						<input type="radio" name="acct_code_g" value="17" onClick="javascript:cng_input7(this.value)" <%if(cd_bean.getAcct_code_g().equals("17"))%>checked<%%>>����
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id=tr_acct8 style='display:<%if(cd_bean.getAcct_code().equals("00016")||cd_bean.getAcct_code().equals("00017")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="19" <%if(cd_bean.getAcct_code_g().equals("19"))%>checked<%%>>������ϼ�
						<input type="radio" name="acct_code_g" value="23" <%if(cd_bean.getAcct_code_g().equals("23"))%>checked<%%>>������漼
						<input type="radio" name="acct_code_g" value="24" <%if(cd_bean.getAcct_code_g().equals("24"))%>checked<%%>>�����ڵ�����
						<input type="radio" name="acct_code_g" value="25" <%if(cd_bean.getAcct_code_g().equals("25"))%>checked<%%>>����ȯ�氳���δ��
						<input type="radio" name="acct_code_g" value="26" <%if(cd_bean.getAcct_code_g().equals("26"))%>checked<%%>>���������Һ�			
					 </td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr id=tr_acct_plus style='display:<%if(  ( cd_bean.getAcct_code().equals("00004") && cd_bean.getAcct_code_g().equals("27") )  || ( cd_bean.getAcct_code().equals("00005") && cd_bean.getAcct_code_g().equals("6")) ||   cd_bean.getAcct_code().equals("00006")  ){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" ></td>
					<td align=right>
						&nbsp;�Է� ��� : <input type="text" name="car_su" value="<%=car_su%>" size="2" class="text" onBlur='javscript:cng_input_carsu(this.value);'>&nbsp;&nbsp;&nbsp;��
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>* �Է� ����� 20����� �����մϴ�.</font>
					</td> 
				</tr>
			</table>
		</td>
	</tr>	
	<tr id=tr_acct3_1 style='display:<%if(cd_bean.getAcct_code().equals("00004") || cd_bean.getAcct_code().equals("00018") || cd_bean.getAcct_code().equals("00019") 
			|| ( cd_bean.getAcct_code().equals("00005") && (cd_bean.getAcct_code_g().equals("7") || cd_bean.getAcct_code_g().equals("21")) ) ){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
					<td width="25%">&nbsp;
						<input name="item_name" type="text" class="text" value="<%=cd_bean.getItem_name()%>" size="20" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')">
						<input type="hidden" name="rent_l_cd" value="<%=cd_bean.getRent_l_cd()%>">
						<input type="hidden" name="serv_id" value="<%=cd_bean.getServ_id()%>">
						<input type="hidden" name="item_code" value="<%=cd_bean.getItem_code()%>">
						<input type="hidden" name="stot_amt" value="">
						<input type="hidden" name="firm_nm" value="">
						<a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a><br>
						&nbsp;(������ȣ/��ȣ�� �˻�)
					</td> 
					<td width="10%" class='title'>�ֱ�����Ÿ�</td>
					<td width="35%" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_dist" value="" size="10" class=num style="text-align: right;"readonly>&nbsp;km</td>
					<td width="8%" class='title'>�ֱٵ����</td>
					<td width="12%" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_serv_dt" value="" size="10" readonly>&nbsp;</td>
				</tr>     
			</table>
		</td>
	 </tr>
	<tr id=tr_acct3_2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
					<td width="25%">&nbsp;
						<select name="o_cau" >
							<option value="">--����--</option>
						<%for(int i = 0 ; i < c_size ; i++){
								CodeBean code = codes[i];	%>
							<option value='<%=code.getNm_cd()%>' <%if(cd_bean.getO_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
						<%}%>
						</select>
						<br>
						&nbsp;*�������� ��� ���þ��ص� ��.
					<%if(!from_page.equals("/fms2/consignment/cons_oil_doc_frame.jsp") && (nm_db.getWorkAuthUser("������",user_id)||user_id.equals(reg_user_id)||user_id.equals(cd_bean.getBuy_user_id())) && cd_bean.getBuy_amt()>0 && cd_bean.getAcct_code_g2().equals("12") && cd_bean.getAcct_code().equals("00004") && cd_bean.getM_doc_code().equals("")){%>
						<font color=red>[������氨��û����</font><a href="javascript:M_doc_action('card', '', '<%=cd_bean.getCardno()%>', '<%=cd_bean.getBuy_id()%>', '<%=cd_bean.getBuy_user_id()%>', '1', '');" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='������氨��û���� ����ϱ�'><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a><font color=red>]</font>
					<%}%>
					<td width="10%" class='title'>����(����)��</td>
					<td width="35%">&nbsp;
						<input type='text' size='7' class='num'  value="<%=cd_bean.getOil_liter()%>" name='oil_liter' >&nbsp;L (����kWh,����kg)
						<br>
						&nbsp;*�������� ��� �ʼ� (�Ҽ������ڸ����� �Է°���)		
					</td>
					<td width="8%" class='title'>����Ÿ�</td>
					<td width="12%">&nbsp;
						<input type='text' size='6' class='num'  name='tot_dist' value='<%=cd_bean.getTot_dist()%>' >&nbsp;km		
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct3_3 style='display:none;'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>�����̿���</td>
					<td width="25%">&nbsp;
		  				<input type='text' size='30' class='text' name='call_t_nm' value="<%=cd_bean.getCall_t_nm()%>" >		                
					 </td>
					<td width="10%" class='title'>����ó</td>
					<td width="55%">&nbsp;
						<input type='text' size='30' class='text'  name='call_t_tel' value="<%=cd_bean.getCall_t_tel()%>" >
						<a href="javascript:CarMgr_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>	
					</td>
				</tr>
			</table>
		</td>
	</tr>  
    <tr id=tr_acct97 style='display:<%if(cd_bean.getAcct_code().equals("00019")){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="10%" class='title'>�ݾ�</td>
			          			<td>&nbsp;
			            			<input name="doc_amt" class="num" value="<%=Util.parseDecimal(String.valueOf(f_ht_item.get("DOC_AMT")))%>" size="12" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value);'>��
			            		</td>
			            	</tr>
			            </table>
			        </td>    		
        		</tr>
      		</table>
      	</td>
    </tr> 	 	
	<tr id=tr_acct98 style='display:table-row'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
				    <td>&nbsp;
						<textarea name="acct_cont" cols="90" rows="2" class="text"><%=cd_bean.getAcct_cont()%></textarea>
						(�ѱ�40���̳�)
					</td>
				</tr>
			</table>
		</td>
	</tr> 

    <tr>
    	<td class=h></td>
    </tr>
    
 <%	 
 	 
 	 String ht_item_name = "";
 	 String ht_rent_l_cd = "";
 	 String ht_item_code = "";
 	 String ht_serv_id = "";
 	 String ht_call_t_nm = "";
 	 String ht_call_t_tel = "";
 	 String ht_o_cau = "";
 	 String ht_oil_liter = "";
  	 String ht_tot_dist = "";
  	 String ht_doc_amt = "";
 	
 	 String ht_acct_cont = ""; 	 
 	 
      for(int j=1; j<= 19; j++){
      
        if ( j < vt_i_size1 ) {
        	Hashtable ht_item = (Hashtable)vt_item.elementAt(j);
        	ht_item_name = String.valueOf(ht_item.get("ITEM_NAME"));
        	ht_rent_l_cd = String.valueOf(ht_item.get("RENT_L_CD"));
        	ht_item_code = String.valueOf(ht_item.get("ITEM_CODE"));
        	ht_serv_id = String.valueOf(ht_item.get("SERV_ID"));
        	ht_call_t_nm = String.valueOf(ht_item.get("CALL_T_NM"));
        	ht_call_t_tel = String.valueOf(ht_item.get("CALL_T_TEL"));
        	ht_acct_cont = String.valueOf(ht_item.get("ACCT_CONT"));
         	ht_o_cau = String.valueOf(ht_item.get("O_CAU"));
        	ht_oil_liter =String.valueOf(ht_item.get("OIL_LITER"));
     		ht_tot_dist = String.valueOf(ht_item.get("TOT_DIST")); 	
         	ht_doc_amt = String.valueOf(ht_item.get("DOC_AMT"));
        	        			        					
        } else {	
        	ht_item_name = "";
        	ht_rent_l_cd = "";
        	ht_item_code = "";
        	ht_serv_id = "";
        	ht_call_t_nm = "";
     		ht_call_t_tel = "";
     		ht_acct_cont = ""; 	
     		ht_o_cau = "";  
     		ht_oil_liter = "";
     		ht_tot_dist = "";		
     		ht_doc_amt = "";
        }
        
  	%>
     <tr id=tr_acct3_<%=j%>_1  style='display:<%if( j < vt_i_size1 ){%>table-row<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="10%" class='title'>����</td>
       	<td width="33%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=ht_item_name%>" size="20" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('<%=j%>')">
				<input type="hidden" name="rent_l_cd" value="<%=ht_rent_l_cd%>">
				<input type="hidden" name="serv_id" value="<%=ht_serv_id%>">
				<input type="hidden" name="item_code" value="<%=ht_item_code%>">
				<input type="hidden" name="stot_amt" value="">
				<input type="hidden" name="firm_nm" value="">
            <a href="javascript:Rent_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>&nbsp;(������ȣ/��ȣ�� �˻�)</td>
          <td width="9%" class='title'>�ֱ�����Ÿ�</td>
			<td width="*" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_dist" value="" size="10" class=num style="text-align: right;"readonly>&nbsp;km</td>
			<td width="7%" class='title'>�ֱٵ����</td>
			<td width="9%" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_serv_dt" value="" size="10" readonly>&nbsp;</td>    
        </tr>
     		
      </table></td>
    </tr> 
     
    	<tr id=tr_acct3_<%=j%>_2 style='display:<%if( j < vt_i_size1 && !cd_bean.getAcct_code().equals("00019") ){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>����</td>
					<td width="33%">&nbsp;
						<select name="o_cau" >
							<option value="">--����--</option>
						<%for(int i = 0 ; i < c_size ; i++){
								CodeBean code = codes[i];	%>
							<option value='<%=code.getNm_cd()%>' <%if(ht_o_cau.equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
						<%}%>
						</select>
						&nbsp;*�������� ��� ���þ��ص� ��.
					
					<td width="9%" class='title'>������</td>
					<td width="*">&nbsp;
						<input type='text' size='7' class='num'  value="<%=ht_oil_liter%>" name='oil_liter' >&nbsp;L<br>
						&nbsp;*�������� ��� �ʼ� (�Ҽ������ڸ����� �Է°���)		
					</td>
					<td width="7%" class='title'>����Ÿ�</td>
					<td width="9%">&nbsp;
						<input type='text' size='6' class='num'  name='tot_dist' value='<%=ht_tot_dist%>' >&nbsp;km		
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	
          
     <tr id=tr_acct3_<%=j%>_3 style='display:<%if( j < vt_i_size1 && !cd_bean.getAcct_code().equals("00019") ){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="10%" class='title'>�����̿���</td>
		          <td width="33%">&nbsp;
		       		   <input type='text' size='30' class='text'  name='call_t_nm'  value="<%=ht_call_t_nm%>">	                
		          </td>
		         <td width="9%" class='title'>����ó</td>
		         <td width="*">&nbsp;
		         	<input type='text' size='30' class='text'  name='call_t_tel'  value="<%=ht_call_t_tel%>">
		         	<a href="javascript:CarMgr_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
		          </td>
		        </tr>	
      		</table>
      	</td>
    </tr>      
   
    <tr id=tr_acct3_<%=j%>_97 style='display:<%if( j < vt_i_size1 && cd_bean.getAcct_code().equals("00019") ){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="10%" class='title'>�ݾ�</td>
			          			<td>&nbsp;
			            			<input name="doc_amt" class="num" value="<%=Util.parseDecimal(ht_doc_amt)%>" size="12" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value);'>��
			            		</td>
			            	</tr>
			            </table>
			        </td>    		
        		</tr>		         
      		</table>
      	</td>
    </tr>  
       
    <tr id=tr_acct3_<%=j%>_98 style='display:<%if( j < vt_i_size1 ){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="10%" class='title'>����</td>
			          			<td>&nbsp;
			            			<textarea name="acct_cont" cols="90" rows="2" class="text"><%=ht_acct_cont%></textarea> (�ѱ�40���̳�)
			            		</td>
			            	</tr>
			            </table>
			        </td>    		
        		</tr>
		        <tr>
		        <td colspan=2 class=h>&nbsp;</td> 
		        </tr>	 
    
      		</table>
      	</td>
    </tr>
    
  
              
<% } %>

	<tr>
    	<td class=h></td>
    </tr>
    <tr id=tr_acct99 style="display:<%if(cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003") || cd_bean.getAcct_code().equals("")){%>table-row<%}else{%>none<%}%>">
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td colspan='4'>
						<div style="vertical-align:middle; padding-top:6px;">
							&nbsp;<font color="red">�� "ȥ��" ���ý� ī������ڳ� ����ڰ� �ƴ� "���������"�� ����� ������ ��ϵ�. �ٸ������� ��ǥ�� ��� ����ϴ� ��� �ݵ�� "����"�� ���� �� �Ʒ����� ����ڸ� ����ٶ�.</font>
						</div>
					</td>
				</tr>
        		<tr>
          			<td width="10%" class='title'>���д�</td>                                                                                                                                                                                                          
          			<td width="40%" align='left'>&nbsp;
						<input type='radio' name="acct_code_s" value='1' onClick="javascript:cng_input5(this.value)" <%if(cd_bean.getUser_su().equals(""))%>checked<%%>>ȥ��&nbsp;&nbsp;
						<input type='radio' name="acct_code_s" value='2' onClick="javascript:cng_input5(this.value)" >��Ʈ��&nbsp;&nbsp;
						<input type='radio' name="acct_code_s" value='3' onClick="javascript:cng_input5(this.value)" <%if(!cd_bean.getUser_su().equals(""))%>checked<%%>>����&nbsp;&nbsp;
            			<input name="user_su" type="text" class="text" value ="<%if(cd_bean.getUser_su().equals("")){%>1<%}else{%><%=cd_bean.getUser_su()%><%}%>" size="3" onBlur="javascript:cng_input11();">��&nbsp;       		  
            			<input name="user_cont" type="<%if(!cd_bean.getUser_cont().equals("")){%>text<%}else{%>hidden<%}%>" class="text"  value="<%=cd_bean.getUser_cont()%>" size="10">
					</td>
          			<td width="13%" class='title'>���κ� ����ݾ�</td>
              		<td width="*">&nbsp;
			     		<input type="radio" name="user_Rdio" value="0" onClick="javascript:cng_input1(this.value)" <%if(reg_user_id.equals(""))%>checked<%%>> 1/n
			      		<input type="radio" name="user_Rdio" value="1" onClick="javascript:cng_input1(this.value)">�ݾ� �����Է�
			      		<input type="hidden"  name="buy_a_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					</td>
          		</tr>
          	</table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr>
        <td><label><i class="fa fa-check-circle"></i> �μ�/����/�ݾ� �Է� </label></td>
        <%-- <td align="right">
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
      		<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
      	    <%}%>	
      	    <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
      	</td> --%>
    </tr>
    
  	<tr  id=tr_acct101 style="display:<%if((cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003"))/*  && !cd_bean.getUser_su().equals("") */){%>table-row<%}else{%>none<%}%>" >
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
			    <tr><td class=line2></td></tr>
				<tr>
					<td class=line>
						<table width="100%" border="0" cellspacing="1" cellpadding="0">
                        	<tr>
                        		<td width="7%" class='title'>����</td>
	                         	<td width="15%" class='title'>�μ�</td>
								<td width="15%" class='title'>����</td>
							 	<td width="13%" class='title'>�ݾ�</td>
								<td width="7%" class='title'>����</td>
	                         	<td width="15%" class='title'>�μ�</td>
								<td width="15%" class='title'>����</td>
							 	<td width="13%" class='title'>�ݾ�</td>
							</tr>
                        <%	Vector vts1 = CardDb.getCardDocUserList(cardno, buy_id, "1");
							int vt_size1 = vts1.size();
							
							if ( vt_size1 % 2 == 1 ) {
							  chk = "1";
							}
						%>
							
						<%for(int j = 0 ; j < vt_size1 ; j+=2){
							
								Hashtable ht = (Hashtable)vts1.elementAt(j);
								Hashtable ht2 = new Hashtable();
								if(j+1 < vt_size1){
										ht2 = (Hashtable)vts1.elementAt(j+1);
										
								}%>								
								
                        	<tr>
	                         	<td align="center"><%=j+1%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+1%>);">>	
          								<option value=''>����</option>
          								<option value='AAAA'>��ü</option>
          								<option value='TTTT'>�����̻�</option>
										<option value='PPPP'>��Ʈ��</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(String.valueOf(ht.get("DEPT_ID")).equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden" value='<%=ht.get("DOC_USER")%>'>
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" value='<%=ht.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=Util.parseDecimal(String.valueOf(ht.get("DOC_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
					           	<td align="center"><%=j+2%></td>
					            <%if(j+1 < vt_size1){%>
								<td align="center">
								   		<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>����</option>
          								<option value='AAAA'>��ü</option>
          								<option value='TTTT'>�����̻�</option>
										<option value='PPPP'>��Ʈ��</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(String.valueOf(ht2.get("DEPT_ID")).equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden" value='<%=ht2.get("DOC_USER")%>'>
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" value='<%=ht2.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=Util.parseDecimal(String.valueOf(ht2.get("DOC_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								<% } else  { %>	
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>����</option>
          								<option value='AAAA'>��ü</option>
          								<option value='TTTT'>�����̻�</option>
										<option value='PPPP'>��Ʈ��</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								<% }  %>
							</tr>								
							<%}%>		
						<!-- �߰� -->						
						<%	if 	(chk.equals("1"))  {
									 vt_size1 = vt_size1 + 1;
							}	
						//	for( int j = vt_size1 ; j < 100 ; j+=2){
							for( int j = vt_size1 ; j < vt_acar_size; j+=2){
							
						
						%>
                        	<tr>
	                         	<td align="center"><%=j+1%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+1%>);">>	
          								<option value=''>����</option>
          								<option value='AAAA'>��ü</option>
          								<option value='TTTT'>�����̻�</option>
										<option value='PPPP'>��Ʈ��</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
						
	                         	<td align="center"><%=j+2%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>����</option>
          								<option value='AAAA'>��ü</option>
          								<option value='TTTT'>�����̻�</option>
										<option value='PPPP'>��Ʈ��</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
							</tr>									
							<%}%>
							<tr>
								<td colspan="7" class='title'>����</td>
								<td align="center">
									<input name="txtTot" class="text" value="" style="text-align:right;" size="14" readonly>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</tr>         	
	<tr><td class=h></td></tr><tr><td class=h></td></tr>
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	Keyvalue();
//-->
</script>
</body>
</html>
