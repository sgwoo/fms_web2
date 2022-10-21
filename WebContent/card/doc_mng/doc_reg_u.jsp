<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	// �߰�2006.09.20 �μ��� ��ȸ
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	
	//ī������
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	String buy_dt 	= cd_bean.getBuy_dt();
	
	//�ŷ�ó����
	Hashtable vendor = new Hashtable();
	if(!cd_bean.getVen_code().equals("")){
		vendor = neoe_db.getVendorCase(cd_bean.getVen_code());
	}
	
	//�ŷ�ó�����ڵ�
	Hashtable ven_reg = neoe_db.getTradeHisRegIds(cd_bean.getVen_code(), cd_bean.getReg_dt());//-> neoe_db ��ȯ
	
	String buy_user_id 		= cd_bean.getBuy_user_id();
	String reg_user_id 		= cd_bean.getReg_id();
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
	
	
	String chk="0";
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	String car_su = "1";
	
	
	Vector vt_item = CardDb.getCardDocItemList(cardno, buy_id); 
 	int vt_i_size1 = vt_item.size();
 	
 	if ( vt_i_size1 > 0) {
 	    car_su = Integer.toString(vt_i_size1);
 	} 
	
//	String file_path = cd_bean.getFile_path();
	//file_path = file_path.substring(0,4);
	
	String file_path = AddUtil.replace(AddUtil.replace(AddUtil.replace(cd_bean.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/");             	         
	String theURL = "https://fms3.amazoncar.co.kr/data/";	

	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	int size = 0;
	
	String content_code = "CARD_DOC";
	String content_seq  = cardno+buy_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}
	}
	
	//�Ƹ���ī ������ �ο��� ���ϱ�(20191007)
 	Vector vt_acar = CardDb.getUserSearchList("", "", "AA", "Y");
 	int vt_acar_size = vt_acar.size() + 20;		//	���� 20��
 	if(vt_acar_size%2==1){	vt_acar_size +=	1;		 }	//	Ȧ���̸� ¦���� �ǰ� +1
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

//	document.domain = "amazoncar.co.kr";
	

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
				
			   tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
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
	
				if (fm.acct_code.value == '00006' || fm.acct_code_g[9].checked == true    ){//��������&�Ϲ�����
				
					tr_acct_plus.style.display	= '';
					tr_acct3_1.style.display	= '';
					tr_acct3_3.style.display	= '';
					tr_acct98.style.display	= '';
					
					tr_acct3_<%=i%>_1.style.display	= '';
					tr_acct3_<%=i%>_3.style.display	= '';
					tr_acct3_<%=i%>_98.style.display	= '';		
					
				} else if (   fm.acct_code_g[8].checked == true  ){//���������� 		- ������ �ΰ�� 
			
					tr_acct_plus.style.display	= '';
					tr_acct3_1.style.display	= '';
					tr_acct3_2.style.display	= '';
					tr_acct98.style.display	= '';
			
					tr_acct3_<%=i%>_1.style.display	= '';				
				   tr_acct3_<%=i%>_2.style.display	= '';				
					tr_acct3_<%=i%>_98.style.display	= '';					
				
				}else if(fm.acct_code_g[12].checked == true || fm.acct_code_g[10].checked == true ){//�縮������&�ڵ����˻�
				
					tr_acct3_1.style.display	= '';		
					tr_acct98.style.display	= '';
					tr_acct3_<%=i%>_1.style.display	= '';
					tr_acct3_<%=i%>_98.style.display	= '';
			   
			  } else if (   fm.acct_code.value = '00019'  ){// ������� 
			
					tr_acct_plus.style.display	= '';
					tr_acct3_1.style.display	= '';
					tr_acct98.style.display	= '';
			
					tr_acct3_<%=i%>_1.style.display	= '';				
					tr_acct3_<%=i%>_98.style.display	= '';					  
			     		
				}else{//��ȣ�Ǵ��&��Ÿ
					tr_acct3_98.style.display	= '';
					tr_acct3_<%=i%>_98.style.display	= '';
				}
		
			}else{
			     
			}
	<%}%>							
		
	}		

	
	//����
	function Save(){
		var fm = document.form1;
		if(fm.cardno.value == '')	{	alert('ī���ȣ�� �Է��Ͻʽÿ�.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('�ŷ��ݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_amt.value == '0'){	alert('�ŷ��ݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('�ŷ�ó�� �Է��Ͻʽÿ�.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('�ŷ�ó�� ��ȸ�Ͻʽÿ�?'); return; }
		if($("#user_nm").val() == '' || fm.buy_user_id.value == ''){
			
			//alert(fm.user_nm.value);
			//alert(fm.buy_user_id.value);
			alert('����ڸ� �˻��Ͻʽÿ�.'); return; 	
		}
		
		if ( fm.cardno.value == '0000-0000-0000-0000' || fm.cardno.value == '9410-4991-0759-0613' || fm.cardno.value == '9410-8531-0110-4200' ) {
	
		} else {
			if(parseInt(fm.buy_dt.value.substring(0,4)) >=  2012){
			
			
			
			}
		}
		//����� ������
		if(fm.acct_code[1].checked == false && (fm.acct_code[3].checked == true && fm.acct_code_g2[7].checked == false)){
			if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false  && fm.ven_st[2].checked == false  && fm.ven_st[3].checked == false)
				{ alert('���������� �����Ͻʽÿ�.'); return;}
			
			if(fm.ven_st[0].checked == true && fm.buy_v_amt.value == '0'){	alert('�Ϲݰ������Դϴ�. �ΰ����� Ȯ�����ּ���.'); return; }	
			
			if(fm.ven_st[1].checked == true || fm.ven_st[2].checked == true ) {
			   if ( fm.buy_v_amt.value != '0' ) {		  
					alert('���̰����� �鼼�Դϴ�. �ΰ����� Ȯ�����ּ���.'); 
					return;
			   }	
			}
		}
	
		//�����Ļ���
		if(fm.acct_code.value == '00001' 
	//if(fm.acct_code[0].checked == true 
			&& fm.acct_code_g[0].checked == false  && fm.acct_code_g[1].checked == false  && fm.acct_code_g[2].checked == false && fm.acct_code_g[3].checked == false && fm.acct_code_g[4].checked == false
			&& fm.acct_code_g2[0].checked == false && fm.acct_code_g2[1].checked == false && fm.acct_code_g2[2].checked == false 
			&& fm.acct_code_g2[3].checked == false && fm.acct_code_g2[4].checked == false && fm.acct_code_g2[5].checked == false && fm.acct_code_g2[6].checked == false && fm.acct_code_g2[7].checked == false && fm.acct_code_g2[8].checked == false )
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//�����		
		if(fm.acct_code.value == '00002' 			
			&& fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false && fm.acct_code_g[20].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//������� - ��������
		if(fm.acct_code.value == '00003' 	
			&& fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false && fm.acct_code_g[17].checked == false )
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//����������
		if(fm.acct_code.value == '00004' 			
			&& fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false && fm.acct_code_g[8].checked == false	
			&& fm.acct_code_g2[9].checked == false && fm.acct_code_g2[10].checked == false && fm.acct_code_g2[11].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}		
	
	
	//	if(fm.acct_code.value == '00004' 	) {	
	//		if ( fm.acct_code_g2[7].checked == true) {
	//			if ( fm.oil_liter.value == '' || fm.oil_liter.value == '0' ||  toInt(parseDigit(fm.oil_liter.value)) == 0   ) { alert('�������� �Է��Ͻʽÿ�.'); return;}
	//		}
	//	}	
			
		//���������
		if(fm.acct_code.value == '00005' 			
			&& fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false
			&& fm.acct_code_g2[12].checked == false && fm.acct_code_g2[13].checked == false && fm.acct_code_g2[14].checked == false) 
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
			
		//��������&�繫��ǰ��&�Ҹ�ǰ��&��ź�&�����μ��&���޼�����&��ǰ&���ޱ�
		if ((fm.acct_code.value == '00006' || fm.acct_code.value == '00007' ||  fm.acct_code.value == '00008' ||  fm.acct_code.value == '00009' 
		  || fm.acct_code.value == '00007' ||  fm.acct_code.value == '00010' ||  fm.acct_code.value == '00011' ||  fm.acct_code.value == '00012' ||  fm.acct_code.value == '00013'  )
//		if((fm.acct_code[5].checked == true || fm.acct_code[6].checked == true || fm.acct_code[7].checked == true || fm.acct_code[8].checked == true
//				|| fm.acct_code[9].checked == true || fm.acct_code[10].checked == true || fm.acct_code[11].checked == true || fm.acct_code[12].checked == true || fm.acct_code[13].checked == true)
			&& fm.acct_cont[0].value == '')
			{ alert('���並 �Է��Ͻʽÿ�.'); return;}
		
			
		//����, ����, ���, ��ݺ�� �ݵ�� ���� ��ȸ�Ͽ� car_mng_id ���Ѵ�.
		if(fm.acct_code.value == '00004' || fm.acct_code.value == '00005' ||  fm.acct_code.value == '00006' ||  fm.acct_code.value == '00018' ||  fm.acct_code.value == '00019'  ) {
	  //	  if (fm.acct_code_g[10].checked == true  || fm.acct_code_g[12].checked == true ) {
		//   } else {
		//   	if ( fm.item_code[0].value == '') { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
		 //  }	
		}		
		
			//��ź�
		if(fm.acct_code.value == '00009' 				
			&& fm.acct_code_g[21].checked == false && fm.acct_code_g[22].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//���� ���ڼ� üũ
		if(fm.acct_cont[0].value != '' && !max_length(fm.acct_cont[0].value,80)){	
			alert('���� ���� ���̴� '+get_length(fm.acct_cont[0].value)+'��(��������) �Դϴ�.\n\n����� �ѱ�40��/����80�ڱ��� �Է��� �����մϴ�.'); return; } 			

		//��ǥ���� üũ
		if(getRentTime('m', fm.buy_dt.value, <%=AddUtil.getDate()%>) > 3){ 
			if(!confirm('�Է��Ͻ� ��ǥ���ڰ� �����̻� ���̳��ϴ�.\n\n��ǥ�� �Է� �Ͻðڽ��ϱ�?'))			
				return;
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
				strUserCnt = strUserCnt + fm.user_nm[i+1].value;
				if (inCnt > 1){
					strUserCnt = strUserCnt + ' ��';
					break;
				}
			//	if(i+1 < inCnt)	strUserCnt = strUserCnt + ',';
			}
			fm.user_cont.value	=	strUserCnt;		
		}
		
		
		    //�����Ļ����� ��� �μ��� ���� �ݾ� �Է� ����. - �Ĵ�/ �߽� �� ����
		if(fm.acct_code.value == '00001' ) {		    
       //    if(fm.acct_code[0].checked == true   ){ 	   
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
					   
					   if (strDept_id == '' && parseInt(strMoney) > 0 ) {
					       alert('����ڸ� �����ϼž� �ݾ��� �Է� �����մϴ�!!!.'); 
					       return;
					   }  
					}
					
					if ( totMoney != toInt(parseDigit(fm.buy_amt.value))  ) {
					 	  alert('�����ο��� �ݾ���  Ȯ���ϼ���!!.'); 
					      return;				 
					}
			 }	
		}			
			
		var call_nm_cnt =0;
		var call_tel_cnt =0;
		
		//����� �ݾ� check - ī�������� ����ݾ׺��� Ŭ �� ����. - �Ϲ�����
		if(fm.acct_code.value == '00005' 	&& fm.acct_code_g[7].checked ==  true) { 	
	
			var car_su = toInt(fm.car_su.value);		
		
			for(i=0; i <car_su ; i++){			 				   
			   
			   if(fm.call_t_nm[i].value == '')   call_nm_cnt+=1;   
			   if(fm.call_t_tel[i].value == '')  call_tel_cnt+=1;  			     
			   
			}	
								
			if(call_nm_cnt > 0)	{	alert('�����̿��ڸ� �Է��Ͻʽÿ�.'); return; }
			if(call_tel_cnt > 0)	{	alert('����ó�� �Է��Ͻʽÿ�.'); 	return; }		
			
	    }	
	    
	   //�����, ��Ÿ�� ���
		if(fm.acct_code.value == '00005' 	 && fm.acct_code_g[12].checked == true ){		   
		   // �ϴ� �ѹ��� ����, ���� ��� �߰�
		  if (fm.user_id.value == '000058' || fm.user_id.value == '000070' ||  fm.user_id.value == '000063'  ||   fm.user_id.value == '000029' ||   fm.user_id.value == '000128' ||   fm.user_id.value == '000153') {
		  
		  } else {
		 	 alert('����� - ��Ÿ�� ������ �� �����ϴ�.!!!');
		 	 return;
		  } 		    
		}   		
	    		
					
		//���κ� ����ݾ� �հ� ����
		if(fm.acct_code.value == '00001' ) {
			if(fm.txtTot.value != '' && fm.txtTot.value != '0' && fm.txtTot.value != fm.buy_amt.value){ alert("�հ�� ���谡 ���� �ʽ��ϴ�. �ٽ� Ȯ�� ���ּ���"); return; }
		}
		
		if(fm.acct_code.value == '00001' && fm.acct_code_g[3].checked == true){ //�����Ļ��񿡼� '��Ÿ' ���ý� ������ ��ȯ�Ǿ� �ΰ��� 0������ �ٲ㼭 ���� 
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;
		}	
						
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			document.domain = "amazoncar.co.kr";
			fm.action='doc_reg_u_a.jsp';		
			fm.target='i_no';
//			fm.target='CardDocView';
			fm.submit();
		}
	}

	//�������
	function Cancel(){
		var fm = document.form1;		
		if(confirm('������� �Ͻðڽ��ϱ�?')){					
			fm.action='doc_reg_c_a.jsp';		
			fm.target='i_no';
//			fm.target='CardDocView';
			fm.submit();
		}
	}	
	
	//�μ���Ȯ��
	function Save_chief(){
		var fm = document.form1;		
		if(confirm('�μ��� Ȯ�� �Ͻðڽ��ϱ�?')){					
			fm.action='doc_reg_chief.jsp';		
			fm.target='i_no';
//			fm.target='CardDocView';
			fm.submit();
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
		
		//����� �ƴϰ�, �Ϲݰ����� ���
		if(fm.acct_code.value !== '00002' && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}				
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
		//����� �ƴϰ�, �Ϲݰ����� ���
		if(fm.acct_code.value !== '00002' && fm.ven_st[0].checked == true){
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		}else{
			fm.buy_v_amt.value = 0;				
		}
		set_buy_amt();			
	}	
	
	//�׿�����ȸ-�ſ�ī��
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "../doc_reg/neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
	//�׿�����ȸ-ǰ��
	function Neom_search2(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'item')	fm.t_wd.value = fm.item_name.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "../card_mng/neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter2(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search2(s_kd);
	}
	
	//�ŷ�ó��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.ven_name.value != '')	fm.t_wd.value = fm.ven_name.value;		
		window.open("../doc_reg/vendor_list2.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=700, height=400, scrollbars=yes");		
	}
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	//������ȸ�ϱ�
	function Rent_search(idx1){
		var fm = document.form1;	
		var t_wd;		 
	
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
				
		//������ ����
			if(fm.acct_code.value == '00005' 	){ 	//���������
			if(fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			{	alert('������ �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		}
					
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('��ȸ�� ������ȣ/��ȣ�� �Է��Ͻʽÿ�.'); 	fm.item_name.focus(); 	return;}
		
		
	if(fm.acct_code.value == '00005' 	) {
			if (fm.acct_code_g[8].checked 	== true  || fm.acct_code_g[11].checked 	== true ) { //�Ϲ������, �縮�� �����
				window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
		    } else {
		    	//window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
		    	window.open("../doc_reg/rent_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");
		    }
		} else if (fm.acct_code.value == '00006') {
			window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
	    } else {		
			//window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
			window.open("../doc_reg/rent_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");
		}
			
	}
	
	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
		
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "../card_mng/user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
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
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	
	
	//�������� �ȳ���
	function help(){
		var fm = document.form1;
		var SUBWIN="../doc_reg/help.jsp";	
		window.open(SUBWIN, "help", "left=350, top=350, width=400, height=300, scrollbars=yes, status=yes");
	}
	
	function cng_vs_input(){
		var fm = document.form1;
		
		//����� �ƴϰ�, �Ϲݰ����� ���
		if(fm.acct_code.value !== '00002' && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}					
	}
	
	//�������� ���ý�
	function cng_input(val){
		var fm = document.form1;
						
		tot_buy_amt();
		
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
		tr_acct99.style.display	 	= 'none';
		tr_acct101.style.display 	= 'none';	 
		tr_acct_plus.style.display	= 'none';   //������� 
		
	<%for(int i=1;i<=19 ;i++){%>
		tr_acct3_<%=i%>_1.style.display	= 'none';
		tr_acct3_<%=i%>_2.style.display	= 'none';
		tr_acct3_<%=i%>_3.style.display	= 'none';
		tr_acct3_<%=i%>_98.style.display= 'none';
	
	<%}%>	
			
		if(val == '00001'){ 		//�����Ļ���

			tr_acct1.style.display		= '';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display	 	= '';
			tr_acct101.style.display 	= '';
		
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[0].checked 	= true;
			fm.acct_code_g2[1].checked 	= true;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(val == '00002'){ 	//�����
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= '';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= '';
			tr_acct101.style.display 	= '';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[17].checked 	= true;  //�Ĵ�
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(val == '00003'){ 	//�������
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= '';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';	
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= '';			
			tr_acct101.style.display 	= '';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[13].checked 	= true;    //�����
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';	
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(val == '00004'){ 	//����������
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= '';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';	
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= '';
			tr_acct3_3.style.display	= 'none';	
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[5].checked 	= true;  //���ָ�
			fm.acct_code_g2[9].checked 	= true;
			
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(val == '00005'){ 	//���������
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= '';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';	
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';			
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';
		
		//	fm.acct_code_g[7].checked 	= true;
			if(fm.acct_code_g[8].checked == true){ 
				tr_acct_plus.style.display	= '';
				tr_acct3_3.style.display	= '';	
			} else {
				tr_acct_plus.style.display	= 'none';
				tr_acct3_3.style.display	= 'none';	
			}	
			
			<%for(int i=1;i < 19 ;i++){%>
				if( toInt(fm.car_su.value) > <%=i%>){
					tr_acct3_<%=i%>_1.style.display	= '';
					tr_acct3_<%=i%>_2.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= '';
					tr_acct3_<%=i%>_98.style.display	= '';
					
				}else{
					tr_acct3_<%=i%>_1.style.display	= 'none';
					tr_acct3_<%=i%>_2.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= 'none';
					tr_acct3_<%=i%>_98.style.display	= 'none';
				
				}
			<%}%>	
			
		}else if(val == '00006'){ 	//��������
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';			
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';
		
			tr_acct_plus.style.display	= '';
			tr_acct3_3.style.display	= ''; 
			
			<%for(int i=1;i < 19 ;i++){%>
				if( toInt(fm.car_su.value) > <%=i%>){
					tr_acct3_<%=i%>_1.style.display	= '';
					tr_acct3_<%=i%>_2.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= '';
					tr_acct3_<%=i%>_98.style.display	= '';					
				}else{
					tr_acct3_<%=i%>_1.style.display	= 'none';
					tr_acct3_<%=i%>_2.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= 'none';
					tr_acct3_<%=i%>_98.style.display	= 'none';				
				}
			<%}%>	
				
		}else if(val == '00009'){ 	//��ź�
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= '';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';	
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';			
			tr_acct101.style.display 	= 'none';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[20].checked 	= true;	 //����
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';	
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}else if(val == '00016' || val == '00017'){ 	//�뿩/�����������
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= '';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';			
			tr_acct101.style.display 	= 'none';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[22].checked 	= true;  //������ϼ�
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';	
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}else if(val == '00018' ){ 	//��ݺ�
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';		
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';					
			tr_acct_plus.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';		
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
			<%}%>
		}else if( val == '00019'){ 	// �������
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';		
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';					
			tr_acct_plus.style.display	= '';
			tr_acct3_3.style.display	= 'none';		
			<%for(int i=1;i < 19 ;i++){%>
				if( toInt(fm.car_su.value) > <%=i%>){
					tr_acct3_<%=i%>_1.style.display	= '';
					tr_acct3_<%=i%>_2.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= 'none';
					tr_acct3_<%=i%>_98.style.display	= '';					
				}else{
					tr_acct3_<%=i%>_1.style.display	= 'none';
					tr_acct3_<%=i%>_2.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= 'none';
					tr_acct3_<%=i%>_98.style.display	= 'none';				
				}
			<%}%>				
		
		}else{
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
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';		
			tr_acct_plus.style.display	= 'none';
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';	
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}
	}

	//�����Ļ��� ���� ���ý�
	function cng_input2(val)
	{
		var fm = document.form1;
		if(val == '1'){ //�Ĵ�
			fm.acct_code_g2[1].checked 	= true;
			tr_acct1_1.style.display	= '';
			tr_acct1_2.style.display	= 'none';
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';
			tr_acct101.style.display 	= '';
			
		}
		if(val == '2'){ //ȸ�ĺ�
			fm.acct_code_g2[3].checked 	= true;
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= '';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
		
		}
		if(val == '15'){ //������
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
		if(val == '3'){ //��Ÿ
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
		if(val == '30'){ //�����ް�
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
	}	

	//�����Ļ��� ȸ�ĺ� ���� ���ý�	
	function cng_input22(val)
	{
		var fm = document.form1;
				
		tr_acct98.style.display 	= '';
		tr_acct99.style.display 	= '';					
		tr_acct101.style.display 	= '';	
	}
	
	//��ź� ���� ���ý�	
	function cng_input7(val)
	{
		
		var fm = document.form1;		
		if(val == '16'){			//����			
			tr_acct99.style.display 	= '';					
			tr_acct101.style.display 	= '';			
		}
		if(val == '17'){			//����
			tr_acct99.style.display 	= 'none';					
			tr_acct101.style.display 	= 'none';	
		
		}
		
	}
	
		//����� ���� ���ý�
	function cng_input4()
	{
		var fm = document.form1;
	   	fm.car_su.value='1';		
		cng_input_carsu(fm.car_su.value);
		
		if(fm.acct_code_g[9].checked == true){ //�Ϲ�����
	
			tr_acct_plus.style.display	= '';
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= '';					
		}

		if(fm.acct_code_g[10].checked == true || fm.acct_code_g[12].checked == true ){ //�ڵ����˻� , �縮�� 
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';			
		}
		
		
		if(fm.acct_code_g[11].checked == true || fm.acct_code_g[13].checked == true ){ //��ȣ��, ��Ÿ 
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';			
		}

		if(fm.acct_code_g[5].checked == true  || fm.acct_code_g[6].checked == true || fm.acct_code_g[7].checked == true   )    { //���ָ�, ���� , ������
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= '';
			tr_acct3_3.style.display	= 'none';			
		}
					
		if(fm.acct_code_g[8].checked == true){ //���������� 
			tr_acct_plus.style.display	= '';
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= '';
			tr_acct3_3.style.display	= 'none';			
		}

		
	}		
	
	//���δ� ���� �ݾ�(1/n:0, �ݾ������Է�:1)
	function cng_input1(val)
	{
		var fm 		= document.form1;
		var inCnt	= toInt(fm.user_su.value);
		var inTot	= toInt(parseDigit(fm.buy_amt.value));
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;
		
//		if(inCnt > 100){	alert('1/n �Է��� �ִ�100 �α��� �Դϴ�.'); return;}
		if(inCnt > acar_cnt){	alert('1/n �Է��� �ִ�'+acar_cnt+' �α��� �Դϴ�.'); return;}
		
		if(val == '0' && inCnt > 0 && toInt(parseDigit(fm.buy_amt.value)) > 0)
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
		
		if(val == '1')
		{
	//		for(i=0; i<100 ; i++){
			for(i=0; i<acar_cnt ; i++){
				fm.money[i].value = '0';
			}
			fm.txtTot.value = '0';
		}
	}
	
		
	function cng_input_vat()
	{
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
	function Keyvalue()
	{
		var fm 		= document.form1;
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;
		
//		for(i=0; i<100 ; i++){
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
	
	
	//ī����ǥ ī�庯��
	function doc_card_change(){
		var fm = document.form1;
		window.open("about:blank",'CardChange','scrollbars=yes,status=no,resizable=yes,width=600,height=200,left=250,top=250');		
		fm.action = "card_change.jsp";
		fm.target = "CardChange";
		fm.submit();		
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
		fm.action = '/fms2/consignment_new/cons_oil_doc_u.jsp';		
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
	
	
	//�˾������� ����
	function MM_openBrWindow(theURL,file_path,features) { //v2.0
		//	theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL;
			//alert(theURL);
			window.open(theURL,'popwin_in1',features);
	}	

	//��ĵ����
	function scan_del(){

			var fm = document.form1;
			
			if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
			document.domain = "amazoncar.co.kr";
			fm.action = "https://fms3.amazoncar.co.kr/card/doc_mng/card_del_scan_a.jsp";
			fm.target = "i_no";
			fm.submit();		

	}

	//��ĵ���
	function scan_reg2(){
			window.open("https://fms3.amazoncar.co.kr/card/doc_mng/card_reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&cardno=<%=cardno%>&buy_id=<%=buy_id%>&buy_dt=<%=buy_dt%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}

	
	//����: ��ĵ ����
	function view_map(scan){
		var map_path = scan;
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		

		//��ĵ���
function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&cardno=<%=cardno%>&buy_id=<%=buy_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}
		
		//�̽��ΰ� ���� - �������� (ī�� �߸� �Է�???)
function Del_app(){
	var fm = document.form1;
	if(confirm('�����Ͻðڽ��ϱ�?')){					
	if(confirm('��¥�� �����Ͻðڽ��ϱ�?')){					
	if(confirm('���� �����Ͻðڽ��ϱ�?')){									
		fm.action='/card/doc_app/doc_app_case_del.jsp';		
		fm.target='i_no';
//		fm.target='CardDocView';			
		fm.submit();
	}}}
}
		
-->
</script>

</head>
<body onload="javascript:document.form1.buy_dt.focus();">
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
  <input type="hidden" name="acar_cnt" value="<%=vt_acar_size%>">

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>��ǥ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr><tr><td class=h></td></tr>
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
      <td colspan="2" class="line">
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>�ſ�ī���ȣ</td>
          <td width="87%">&nbsp;
              <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" readonly>
              &nbsp;<a href="javascript:doc_card_change();" ><img src=/acar/images/center/button_in_modify_card.gif border=0 align=absmiddle></a>&nbsp;
          </td>
        </tr>
      </table></td>
    </tr>	
    <tr><td class=h>&nbsp;&nbsp;&nbsp;
     <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getReg_id(), "USER")%>  
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getReg_dt())%>
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getApp_id(), "USER")%>
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getApp_dt())%> 
     <%if(!cd_bean.getR_buy_dt().equals("")){%>
     &nbsp;&nbsp; ������������ : <input name="r_buy_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(cd_bean.getR_buy_dt())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'>
     <%}%>
    </td></tr>
    
    <tr><td class=h></td></tr><tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td colspan="2" class='title'>�ŷ�����</td>
          	<td width="87%">&nbsp;
		  	  <input name="buy_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(cd_bean.getBuy_dt())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>
               
          <tr>
          	<td width="3%" rowspan="3" class='title'>��<br>
            ��<br>
            ��<br>
			��</td>
          	<td class='title'>���ް�</td>
          	<td>&nbsp;
              <input type="text" name="buy_s_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_s_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();'>
              ��</td>
          </tr>		  
          <tr>
          	<td class='title'>�ΰ���</td>
          	<td>&nbsp;
              <input type="text" name="buy_v_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_v_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();'>
              ��
			  &nbsp;&nbsp;<font color="red">�� ī����ǥ�� ��� �ΰ��� ȯ�޴���Դϴ�.(����� ����)</font></td>
          </tr>
           <tr>
            <td class='title'>�հ�</td>
          	<td>&nbsp;
              <input type="text" name="buy_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); tot_buy_amt();'>
              ��
               &nbsp;&nbsp;<font color="blue">�� �ΰ��� �������� <input type="radio" name="vat_Rdio" value="0" onClick="javascript:cng_input_vat()" > ����
			      		<input type="radio" name="vat_Rdio" value="1" onClick="javascript:cng_input_vat()">���� &nbsp;</font>
              </td>
          </tr>
                    
          <tr>
          	<td colspan="2" class='title'>�ŷ�ó</td>
          	<td>&nbsp;
              <input name="ven_name" type="text" class="text" value="<%=cd_bean.getVen_name()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
			  <input type="hidden" name="ven_code" value="<%=cd_bean.getVen_code()%>">			  
			  <a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			  &nbsp;<a href="javascript:CardDocHistory('<%=cd_bean.getVen_code()%>','<%=cd_bean.getCardno()%>','<%=cd_bean.getBuy_id()%>');" ><img src=/acar/images/center/button_in_uselist.gif border=0 align=absmiddle></a>
			  &nbsp;<a href="javascript:VendorHistory('<%=cd_bean.getVen_code()%>');" ><img src=/acar/images/center/button_in_bgir.gif border=0 align=absmiddle></a>
			  &nbsp;&nbsp;&nbsp;&nbsp;
			  (����ڹ�ȣ:<input type="text" class="whitetext" size="12" name="ven_nm_cd"  value="<%=AddUtil.ChangeEnt_no(String.valueOf(vendor.get("S_IDNO")))%>">)
			</td>
       	  </tr>
		  
		  <!-- ���ݿ����� ī����ǥ �Է½� ����� ���ι�ȣ ���̱�-->
		  <%if(cardno.equals("0000-0000-0000-0000")){%>
		  <tr>
          	<td colspan="2" class='title'>���ݿ��������ι�ȣ</td>
          	<td>&nbsp;&nbsp;<input name="siokno" type="text" class="text" value="<%=cd_bean.getSiokno()%>" size="25" style='IME-MODE: active'></td>
			</tr>
		<%}%>	
   		  <tr>
          	<td colspan="2" class='title'>��������</td>
          	<td >&nbsp;<input type="radio" name="ven_st" value="1" <%if(cd_bean.getVen_st().equals("1"))%>checked<%%>  onClick="javascript:cng_vs_input()">�Ϲݰ���
			     &nbsp;<input type="radio" name="ven_st" value="2" <%if(cd_bean.getVen_st().equals("2"))%>checked<%%>  onClick="javascript:cng_vs_input()">���̰���
			     &nbsp;<input type="radio" name="ven_st" value="3" <%if(cd_bean.getVen_st().equals("3"))%>checked<%%>  onClick="javascript:cng_vs_input()">�鼼
			     &nbsp;<input type="radio" name="ven_st" value="4" <%if(cd_bean.getVen_st().equals("4"))%>checked<%%>  onClick="javascript:cng_vs_input()">�񿵸�����(�������/��ü)
					<!--&nbsp;&nbsp;<a href="http://www.nts.go.kr/cal/cal_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif border=0 align=absmiddle></a>-->
					<!--&nbsp;&nbsp;<a href="http://www.nts.go.kr/cal/cal_check_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>-->
					<a href="javascript:search_nts();"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
					&nbsp;<input type="text" class="whitetext"   name="nts_search_nm"  value="">
					<%if(!String.valueOf(ven_reg.get("F_REG_ID")).equals("") && !String.valueOf(ven_reg.get("F_REG_ID")).equals("null")){%>
					<br>
					&nbsp;[�ŷ�ó] 
					&nbsp;<img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(String.valueOf(ven_reg.get("F_REG_ID")), "USER")%>  
     					&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(String.valueOf(ven_reg.get("F_REG_DT")))%>
     					<%	if(!String.valueOf(ven_reg.get("F_REG_ID")).equals(String.valueOf(ven_reg.get("L_REG_ID")))){%>
     					&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(String.valueOf(ven_reg.get("L_REG_ID")), "USER")%>
     					&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(String.valueOf(ven_reg.get("L_REG_DT")))%>      						
     					<%	}%>
     					<%}%>
				 </td>
       	  </tr>		            		  
          <tr>
          	<td colspan="2" class='title'>���ݰ�꼭</td>
          	<td>&nbsp;
			  <input type="checkbox" name="tax_yn" value="Y" <%if(cd_bean.getTax_yn().equals("Y"))%>checked<%%>> (��������)
              </td>
       	  </tr>		  		  		  
          <tr>
            <td colspan="2" class='title'>�����</td>
          	<td width="87%">&nbsp;
		  	  <input name="user_nm" id="user_nm" type="text" class="text" value="<%=c_db.getNameById(cd_bean.getBuy_user_id(), "USER")%>" size="15" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id', '0')">
			  <input type="hidden" name="buy_user_id" value="<%=cd_bean.getBuy_user_id()%>">
			  <a href="javascript:User_search('buy_user_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			  </td>
          </tr>
		  
          <tr>
          	<td colspan="2" class='title'>��������</td>
          	<td>
			  <table width="100%" border="0">
			    <tr>
			    	<td>&nbsp;
	  					<select name="acct_code" onchange="javascript:cng_input(this.options[this.selectedIndex].value)">
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
        </table>
	  </td>
    </tr>
    <tr><td class=h></td></tr><tr><td class=h></td></tr>
    <tr>
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��볻��</span></td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr id=tr_acct1 style='display:<%if(cd_bean.getAcct_code().equals("00001")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" rowspan="2" class='title'>����</td>
          <td width="87%">&nbsp;
		      <input type="radio" name="acct_code_g" value="1" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("1"))%>checked<%%>>�Ĵ�
              <input type="radio" name="acct_code_g" value="2" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("2"))%>checked<%%>>ȸ�ĺ�
			  <input type="radio" name="acct_code_g" value="15" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("15"))%>checked<%%>>������	
			  <input type="radio" name="acct_code_g" value="3" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("3"))%>checked<%%>>��Ÿ	
			  <input type="radio" name="acct_code_g" value="30" disabled  onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("30"))%>checked<%%>>�����ް�				
		  </td>
        </tr>
        <tr>
          <td><table width="90%"  border="0" cellpadding="0" cellspacing="0">
              <tr id=tr_acct1_1 style='display:<%if(cd_bean.getAcct_code_g().equals("1")){%>""<%}else{%>none<%}%>'>
                <td>&nbsp;
                  <input type="radio" name="acct_code_g2" value="1" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("1"))%>checked<%%>>����
				  <input type="radio" name="acct_code_g2" value="2" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("2"))%>checked<%%>>�߽�
				  <input type="radio" name="acct_code_g2" value="3" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("3"))%>checked<%%>>Ư�ٽ�</td>
              </tr>
              <tr id=tr_acct1_2 style='display:<%if(cd_bean.getAcct_code_g().equals("2")){%>""<%}else{%>none<%}%>'>
                <td>&nbsp;
				  <input type="radio" name="acct_code_g2" value="15" <%if(cd_bean.getAcct_code_g2().equals("15"))%>checked<%%>>
				  �系��ȣȸ
                  <input type="radio" name="acct_code_g2" value="4" <%if(cd_bean.getAcct_code_g2().equals("4"))%>checked<%%>>
				  ȸ����ü����
				  <input type="radio" name="acct_code_g2" value="5" <%if(cd_bean.getAcct_code_g2().equals("5"))%>checked<%%>>
				  �μ��� �������
				  <input type="radio" name="acct_code_g2" value="6" <%if(cd_bean.getAcct_code_g2().equals("6"))%>checked<%%>>
				  �μ��� ������ȸ��
				   <input type="radio" name="acct_code_g2" value="31" <%if(cd_bean.getAcct_code_g2().equals("31"))%>checked<%%>>
				  �繫�������ġ��
				    <input type="radio" name="acct_code_g2" value="33" <%if(cd_bean.getAcct_code_g2().equals("33"))%>checked<%%>>
				 �ڷγ��濪��
				  </td>
              </tr>
           
           </table></td>
        </tr>
      </table></td>
    </tr>
    <tr id=tr_acct2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="13" onClick="javascript:cng_input4()"  <%if(cd_bean.getAcct_code_g().equals("13"))%>checked<%%>>���ָ�
			<input type="radio" name="acct_code_g" value="4" onClick="javascript:cng_input4()"  <%if(cd_bean.getAcct_code_g().equals("4"))%>checked<%%>>����
			<input type="radio" name="acct_code_g" value="5" onClick="javascript:cng_input4()"  <%if(cd_bean.getAcct_code_g().equals("5"))%>checked<%%>>LPG
			<input type="radio" name="acct_code_g" value="27" onClick="javascript:cng_input4()"  <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>����/����	<!-- ���������� -->			
		  </td>
        </tr>
		<tr>
			<td width="13%" class='title'>�뵵</td>
			<td width="87%">&nbsp;
				<input type="radio" name="acct_code_g2" value="11" <%if(cd_bean.getAcct_code_g2().equals("11"))%>checked<%%>>����
				<input type="radio" name="acct_code_g2" value="12" <%if(cd_bean.getAcct_code_g2().equals("12"))%>checked<%%>>������ ����
				<input type="radio" name="acct_code_g2" value="13" <%if(cd_bean.getAcct_code_g2().equals("13"))%>checked<%%>>������
			</td>
		</tr>	
		
      </table></td>
    </tr>
    <tr id=tr_acct3 style='display:<%if(cd_bean.getAcct_code().equals("00005")){%>''<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
       <tr>
          <td width="13%" class='title'>����</td>
           <td>&nbsp;
            <input type="radio" name="acct_code_g" value="6"  onClick="javascript:cng_input4()" <%if(cd_bean.getAcct_code_g().equals("6"))%>checked<%%>>
			�Ϲ�����
			<input type="radio" name="acct_code_g" value="7"  onClick="javascript:cng_input4()" <%if(cd_bean.getAcct_code_g().equals("7"))%>checked<%%>>
			�ڵ����˻�
			<!--
			<input type="radio" name="acct_code_g" value="8"  onClick="javascript:cng_input4()" <%if(cd_bean.getAcct_code_g().equals("8"))%>checked<%%>>
			���˱�Ϻ�
		   -->	
			<input type="radio" name="acct_code_g" value="18" onClick="javascript:cng_input4()" <%if(cd_bean.getAcct_code_g().equals("18"))%>checked<%%>>
			��ȣ�Ǵ��
			<input type="radio" name="acct_code_g" value="21" onClick="javascript:cng_input4()" <%if(cd_bean.getAcct_code_g().equals("21"))%>checked<%%>>
			�縮������
			<input type="radio" name="acct_code_g" value="22" onClick="javascript:cng_input4()" <%if(cd_bean.getAcct_code_g().equals("22"))%>checked<%%>>
			��Ÿ
		  </td>
        </tr>
		<tr>
			<td width="13%" class='title'>�뵵</td>
			<td width="87%">&nbsp;
				<input type="radio" name="acct_code_g2" value="21" <%if(cd_bean.getAcct_code_g2().equals("21"))%>checked<%%>>����
				<input type="radio" name="acct_code_g2" value="22" <%if(cd_bean.getAcct_code_g2().equals("22"))%>checked<%%>>������ ����
				<input type="radio" name="acct_code_g2" value="23" <%if(cd_bean.getAcct_code_g2().equals("23"))%>checked<%%>>������
			</td>
		</tr>		
       
      </table></td>
    </tr>
    <tr id=tr_acct4 style='display:<%if(cd_bean.getAcct_code().equals("00003")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="9"  <%if(cd_bean.getAcct_code_g().equals("9"))%>checked<%%>>
			�����
			<input type="radio" name="acct_code_g" value="10" <%if(cd_bean.getAcct_code_g().equals("10"))%>checked<%%>>
			��Ÿ�����
			<input type="radio" name="acct_code_g" value="20" <%if(cd_bean.getAcct_code_g().equals("20"))%>checked<%%>>
			�����н�
			<input type="radio" name="acct_code_g" value="32" <%if(cd_bean.getAcct_code_g().equals("32"))%>checked<%%>>
			��������			
		  <%if( ( nm_db.getWorkAuthUser("������",user_id)||user_id.equals(cd_bean.getReg_id())||user_id.equals(cd_bean.getBuy_user_id()) )  && cd_bean.getBuy_amt()>0  && cd_bean.getAcct_code().equals("00003") && cd_bean.getM_doc_code().equals("")){%>
        		    <font color=red>[���氨��û����</font><a href="javascript:M_doc_action('card', '', '<%=cd_bean.getCardno()%>', '<%=cd_bean.getBuy_id()%>', '<%=cd_bean.getBuy_user_id()%>', '1', '');" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='���氨��û���� ����ϱ�'><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a><font color=red>]</font>
        <%}%>  
			</td>			
	    </tr>
      </table></td>
    </tr>
    <tr id=tr_acct6 style='display:<%if(cd_bean.getAcct_code().equals("00002")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="11" <%if(cd_bean.getAcct_code_g().equals("11"))%>checked<%%>>
			�Ĵ�
			<input type="radio" name="acct_code_g" value="12" <%if(cd_bean.getAcct_code_g().equals("12"))%>checked<%%>>
			������
			<input type="radio" name="acct_code_g" value="14" <%if(cd_bean.getAcct_code_g().equals("14"))%>checked<%%>>
			��Ÿ
			</td>
        </tr>
      </table></td>
    </tr>
    <tr id=tr_acct7 style='display:<%if(cd_bean.getAcct_code().equals("00009")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="16" onClick="javascript:cng_input7(this.value)" <%if(cd_bean.getAcct_code_g().equals("16"))%>checked<%%>>����
			<input type="radio" name="acct_code_g" value="17" onClick="javascript:cng_input7(this.value)" <%if(cd_bean.getAcct_code_g().equals("17"))%>checked<%%>>����</td>
        </tr>
      </table></td>
    </tr>
    
    <tr id=tr_acct8 style='display:<%if(cd_bean.getAcct_code().equals("00016")||cd_bean.getAcct_code().equals("00017")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>����</td>
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="19" <%if(cd_bean.getAcct_code_g().equals("19"))%>checked<%%>> 
			������ϼ�
			<input type="radio" name="acct_code_g" value="23" <%if(cd_bean.getAcct_code_g().equals("23"))%>checked<%%>> 
			������漼
			<input type="radio" name="acct_code_g" value="24" <%if(cd_bean.getAcct_code_g().equals("24"))%>checked<%%>> 
			�����ڵ�����
			<input type="radio" name="acct_code_g" value="25" <%if(cd_bean.getAcct_code_g().equals("25"))%>checked<%%>> 
			����ȯ�氳���δ��
			<input type="radio" name="acct_code_g" value="26" <%if(cd_bean.getAcct_code_g().equals("26"))%>checked<%%>> 
			���������Һ�			
		  </td>
        </tr>
      </table></td>
    </tr>
		
	<tr id=tr_acct_plus style='display:<%if( ( cd_bean.getAcct_code().equals("00005") && cd_bean.getAcct_code_g().equals("6")) ||   cd_bean.getAcct_code().equals("00006") ||   cd_bean.getAcct_code().equals("00019")  ){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" ></td>
          			<td align=right>&nbsp;�Է� ��� : <input type="text" name="car_su" value="<%=car_su%>" size="2" class="text" onBlur='javscript:cng_input_carsu(this.value);'>&nbsp;&nbsp;&nbsp;��
          			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>* �Է� ����� 20����� �����մϴ�.</font></td> 
        		</tr>
      		</table>
      	</td>
    </tr>								
  
    <tr id=tr_acct3_1 style='display:<%if(cd_bean.getAcct_code().equals("00004") || cd_bean.getAcct_code().equals("00006") || cd_bean.getAcct_code().equals("00018") || cd_bean.getAcct_code().equals("00019")|| ( cd_bean.getAcct_code().equals("00005") && (!cd_bean.getAcct_code_g().equals("18") && !cd_bean.getAcct_code_g().equals("22") ) )  ){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td width="87%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=cd_bean.getItem_name()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')">
			<input type="hidden" name="rent_l_cd" value="<%=cd_bean.getRent_l_cd()%>">
			<input type="hidden" name="serv_id" value="<%=cd_bean.getServ_id()%>">
			<input type="hidden" name="item_code" value="<%=cd_bean.getItem_code()%>">
			<input type="hidden" name="last_dist" value="">
			<input type="hidden" name="last_serv_dt" value="">
			<input type="hidden" name="tot_dist" value="">
			<input type="hidden" name="oil_litter" value="">
		   <a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			&nbsp;(������ȣ/��ȣ�� �˻�)</td>       
      </table></td>
    </tr>
    
    <tr id=tr_acct3_2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>        
        	<tr>
					<td width="13%" class='title'>����</td>
					<td width="33%">&nbsp;
						<select name="o_cau" >
							<option value="">--����--</option>
						<%for(int i = 0 ; i < c_size ; i++){
								CodeBean code = codes[i];	%>
							<option value='<%=code.getNm_cd()%>' <%if(cd_bean.getO_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
						<%}%>
						</select>
						<br>&nbsp;*�������� ��� ���þ��ص� ��.
					<%if(!from_page.equals("/fms2/consignment/cons_oil_doc_frame.jsp") && (nm_db.getWorkAuthUser("������",user_id)||user_id.equals(reg_user_id)||user_id.equals(cd_bean.getBuy_user_id())) && cd_bean.getBuy_amt()>0 && cd_bean.getAcct_code_g2().equals("12") && cd_bean.getAcct_code().equals("00004") && cd_bean.getM_doc_code().equals("")){%>
						<br>&nbsp;&nbsp;<font color=red>[������氨��û����</font><a href="javascript:M_doc_action('card', '', '<%=cd_bean.getCardno()%>', '<%=cd_bean.getBuy_id()%>', '<%=cd_bean.getBuy_user_id()%>', '1', '');" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='������氨��û���� ����ϱ�'><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a><font color=red>]</font>
					<%}%>
					<td width="8%" class='title'>������</td>
					<td width="*">&nbsp;
						<input type='text' size='7' class='num'  value="<%=cd_bean.getOil_liter()%>" name='oil_liter' >L<br>
						&nbsp;*�������� ��� �ʼ�<br>&nbsp;&nbsp;(�Ҽ������ڸ����� �Է°���)		
					</td>
					<td width="8%" class='title'>����Ÿ�</td>
					<td width="12%">&nbsp;
						<input type='text' size='7' class='num'  name='tot_dist' value='<%=cd_bean.getTot_dist()%>' >km		
					</td>
				</tr>					
       </table></td>
    </tr>
        
    <tr id=tr_acct3_3 style='display:<%if( ( cd_bean.getAcct_code().equals("00005") &&  cd_bean.getAcct_code_g().equals("6") ) ||   cd_bean.getAcct_code().equals("00006") ){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="13%" class='title'>�����̿���</td>
		          <td width="27%">&nbsp;
		       		   <input type='text' size='30' class='text' name='call_t_nm' value="<%=cd_bean.getCall_t_nm()%>" >		                
		          </td>
		         <td width="13%" class='title'>����ó</td>
		         <td width="47%">&nbsp;
		         	<input type='text' size='30' class='text'  name='call_t_tel' value="<%=cd_bean.getCall_t_tel()%>" >	
		          </td>
		        </tr>
    
      		</table>
      	</td>
    </tr>      
        
    <tr id=tr_acct98 style="display:''">
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td width="87%">&nbsp;
		    <textarea name="acct_cont" cols="90" rows="2" class="text"><%=cd_bean.getAcct_cont()%></textarea>
			(�ѱ�40���̳�)
		
            </td>
            
        </tr>
      </table></td>
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
        }
        
  	%>
     <tr id='tr_acct3_<%=j%>_1'  style='display:<%if( j < vt_i_size1 ){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td width="87%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=ht_item_name%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('<%=j%>')">
				<input type="hidden" name="rent_l_cd" value="<%=ht_rent_l_cd%>">
				<input type="hidden" name="serv_id" value="<%=ht_serv_id%>">
				<input type="hidden" name="item_code" value="<%=ht_item_code%>">
				<input type="hidden" name="firm_nm" value="">
				<input type="hidden" name="stot_amt" value="">
            <a href="javascript:Rent_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(������ȣ/��ȣ�� �˻�)</td>
        </tr>
     		
      </table></td>
    </tr>     
    
      	<tr id=tr_acct3_<%=j%>_2 style='display:<%if( j < vt_i_size1  &&  cd_bean.getAcct_code().equals("00004")   ){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="13%" class='title'>����</td>
					<td width="33%">&nbsp;
						<select name="o_cau" >
							<option value="">--����--</option>
						<%for(int i = 0 ; i < c_size ; i++){
								CodeBean code = codes[i];	%>
							<option value='<%=code.getNm_cd()%>' <%if(ht_o_cau.equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
						<%}%>
						</select>
						<br>&nbsp;*�������� ��� ���þ��ص� ��.
					
					<td width="8%" class='title'>������</td>
					<td width="*">&nbsp;
						<input type='text' size='7' class='num'  value="<%=ht_oil_liter%>" name='oil_liter' >L<br>
						&nbsp;*�������� ��� �ʼ�<br>&nbsp;&nbsp;(�Ҽ������ڸ����� �Է°���)		
					</td>
					<td width="8%" class='title'>����Ÿ�</td>
					<td width="12%">&nbsp;
						<input type='text' size='7' class='num'  name='tot_dist' value='<%=ht_tot_dist%>' >km		
					</td>
				</tr>	
			</table>
		</td>
	</tr>
    
     <tr id=tr_acct3_<%=j%>_3 style='display:<%if( j < vt_i_size1 &&  ( ( cd_bean.getAcct_code().equals("00005") &&  cd_bean.getAcct_code_g().equals("6") ) ||   cd_bean.getAcct_code().equals("00006") )  ){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="13%" class='title'>�����̿���</td>
		          <td width="27%">&nbsp;
		       		   <input type='text' size='30' class='text'  name='call_t_nm'  value="<%=ht_call_t_nm%>">	                
		          </td>
		         <td width="13%" class='title'>����ó</td>
		         <td width="47%">&nbsp;
		         	<input type='text' size='30' class='text'  name='call_t_tel'  value="<%=ht_call_t_tel%>">
		          </td>
		        </tr>		           
    
      		</table>
      	</td>
    </tr>      
   
    <tr id=tr_acct3_<%=j%>_98 style='display:<%if( j < vt_i_size1 ){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="13%" class='title'>����</td>
			          			<td width="87%">&nbsp;
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
	 <tr id=tr_acct100 style="display:''">
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="13%" class='title'>÷������</td>
          			<td width="87%">&nbsp; 
						<%if(!file_name1.equals("")){%>
						<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
							<a href="javascript:openPop('<%=file_type1%>','<%=seq1%>');" title='����' ><%=file_name1%></a>
						<%}else{%>
							<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
						<%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						<%}else{%>
							<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
						<%}%>

				&nbsp;&nbsp;&nbsp;&nbsp;		
		<%if(cd_bean.getAcct_code().equals("00005") ||   cd_bean.getAcct_code().equals("00006") ) { %>			
			        <%if(vt_i_size1 > 0){
					for(int i = 0 ; i < vt_i_size1 ; i++){
							Hashtable ht_i = (Hashtable)vt_item.elementAt(i);
				  
				                            if (!ht_i.get("SCAN_FILE").equals("")){%>							
			        <a href="javascript:view_map('<%=ht_i.get("SCAN_FILE")%>');" title="�������� ���÷��� Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>			
            		               <%                }
            		                   }
            		          } %>
            	<% } %> 		 
            		</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>

    <tr id=tr_acct99 style='display:<%if(cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>���д�</td>
          <td width="87%">&nbsp;
            <input name="user_su" type="text" class="text" value="<%=cd_bean.getUser_su()%>" size="2">
			��
            <input name="user_cont" type="text" class="text" value="<%=cd_bean.getUser_cont()%>" size="93"></td>
        </tr>
        <tr>
          <td width="13%" class='title'>����ݾ�</td>
          <td width="87%">&nbsp;
            <input type="radio" name="user_Rdio" value="0" onClick="javascript:cng_input1(this.value)"> 1/n
			      		<input type="radio" name="user_Rdio" value="1" onClick="javascript:cng_input1(this.value)">�ݾ� �����Է� &nbsp;
			      		<input type="hidden"  name="buy_a_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'></td>
        </tr>		
      </table></td>
    </tr>
    <tr><td class=h></td></tr><tr><td class=h></td></tr>
    <tr>
    	<td>
    		<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�μ�/����/�ݾ� �Է�</span>
    	</td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
  	<tr>
		<td colspan=2 id=tr_acct101 style='display:<%if(cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003")){%>""<%}else{%>none<%}%>'>
			<table border="0" width=100% cellspacing="0" cellpadding="0">
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
							
						<%	for(int j = 0 ; j < vt_size1 ; j+=2){
							
								Hashtable ht = (Hashtable)vts1.elementAt(j);
								Hashtable ht2 = new Hashtable();
								if(j+1 < vt_size1){
										ht2 = (Hashtable)vts1.elementAt(j+1);
										
								}%>								
								
                        	<tr>
	                         	<td align="center"><%=j+1%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+1%>);">>	
          								<option value=''>��ü</option>
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
									<input name="user_nm" type="text" readonly class="text" value='<%=ht.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=Util.parseDecimal(String.valueOf(ht.get("DOC_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
					           	<td align="center"><%=j+2%></td>
					            <%if(j+1 < vt_size1){%>
								<td align="center">
								   		<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>��ü</option>
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
									<input name="user_nm" type="text" readonly class="text" value='<%=ht2.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=Util.parseDecimal(String.valueOf(ht2.get("DOC_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								<% } else  { %>	
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>��ü</option>
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
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								
								<% }  %>	
								</td>
							</tr>								
							<%}%>		
						<!-- �߰� -->						
						<%	if 	(chk.equals("1"))  {
									 vt_size1 = vt_size1 + 1;
							}	
					//		for( int j = vt_size1 ; j < 100 ; j+=2){
							for( int j = vt_size1 ; j < vt_acar_size; j+=2){
								
						%>
                        	<tr>
	                         	<td align="center"><%=j+1%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+1%>);">>	
          								<option value=''>��ü</option>
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
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
						
	                         	<td align="center"><%=j+2%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>��ü</option>
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
   
    <tr>
      <td>&nbsp;</td>
      <td align="right">
        <%if(!from_page.equals("/fms2/consignment/cons_oil_doc_frame.jsp")){%>
	  <%if(cd_bean.getChief_id().equals("") && !chief_id.equals("") && (user_id.equals(chief_id)||nm_db.getWorkAuthUser("������",user_id))){%>	  
<!--	  <a href="javascript:Save_chief();"><img src=/acar/images/center/button_bsj.gif border=0 align=absmiddle></a>&nbsp;  -->
	  <%}%>
	  
	  <%if(cd_bean.getApp_dt().equals("")){%>
	  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id) || cd_bean.getBuy_user_id().equals(user_id)){%>
  		<a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
	  <%	}%>	
	    <%	if(nm_db.getWorkAuthUser("������",user_id) )  {%> 
	 	 <a href="javascript:Del_app();" ><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>&nbsp;
	    <%	}%>	
	  <%}%>
	  
	  <%if(!cd_bean.getApp_dt().equals("")){%>
	  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id) || cd_bean.getApp_id().equals(user_id)){%>
  		<a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
	  <%	}%>	  
	  <%}%>

	  <%	if(auth_rw.equals("6") && !cd_bean.getApp_dt().equals("")){%>
 		<a href="javascript:Cancel();"><img src=/acar/images/center/button_cancel.gif border=0 align=absmiddle></a>&nbsp;
	  <%	}%>
        <%}%>  		
	  <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
    
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
