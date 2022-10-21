<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	// �߰�2006.09.20 �μ��� ��ȸ
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	
	//ī������
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	//����� ����Ʈ ��ȸ
	Hashtable l_cont = CardDb.getLRent(cd_bean.getRent_l_cd());
	
	String buy_user_id 		= cd_bean.getBuy_user_id();
	dept_id 				= c_db.getUserDept(buy_user_id);
	String brch_id 			= c_db.getUserBrch(buy_user_id);
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
	
 	//�Ƹ���ī ������ �ο��� ���ϱ�(20191007)
 	Vector vt_acar = CardDb.getUserSearchList("", "", "AA", "Y");
 	int vt_acar_size = vt_acar.size() + 20;		//	���� 20��
 	if(vt_acar_size%2==1){	vt_acar_size +=	1;		 }	//	Ȧ���̸� ¦���� �ǰ� +1
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

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
	
		//��������� ���� ���÷���
	function cng_input_carsu(car_su){
		var fm = document.form1;		
		
		var car_su = toInt(car_su) ;
				
		if(car_su >20){
			alert('�Է°����� �ִ�Ǽ��� 20�� �Դϴ�.');
			return;
		}
				
		<%for(int i=1;i < 19 ;i++){%>
			if(car_su > <%=i%>){
				tr_acct3_<%=i%>_1.style.display	= '';
				tr_acct3_<%=i%>_3.style.display	= '';
				tr_acct3_<%=i%>_98.style.display	= '';
				
			}else{
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display	= 'none';
			
			}
		<%}%>			
			
	}		

	
	//����
	function Save(){
		var fm = document.form1;
		if(fm.cardno.value == '')	{	alert('ī���ȣ�� �Է��Ͻʽÿ�.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_amt.value == '0'){	alert('���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('�ŷ�ó�� �Է��Ͻʽÿ�.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('�ŷ�ó�� ��ȸ�Ͻʽÿ�?'); return; }
		if(fm.user_nm.value == '' || fm.buy_user_id.value == ''){	alert('����ڸ� �˻��Ͻʽÿ�.'); return; }	
		
		if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false  && fm.ven_st[2].checked == false  && fm.ven_st[3].checked == false)
			{ alert('���������� �����Ͻʽÿ�.'); return;}
		
		if(fm.ven_st[0].checked == true && fm.buy_v_amt.value == '0'){	alert('�Ϲݰ������Դϴ�. �ΰ����� Ȯ�����ּ���.'); return; }	
		
	
		//�����Ļ���
		if(fm.acct_code[0].checked == true 
			&& fm.acct_code_g[0].checked == false  && fm.acct_code_g[1].checked == false  && fm.acct_code_g[2].checked == false && fm.acct_code_g[3].checked == false
			&& fm.acct_code_g2[0].checked == false && fm.acct_code_g2[1].checked == false && fm.acct_code_g2[2].checked == false 
			&& fm.acct_code_g2[3].checked == false && fm.acct_code_g2[4].checked == false && fm.acct_code_g2[5].checked == false && fm.acct_code_g2[6].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//�����		
		if(fm.acct_code[1].checked == true 
			//&& fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false)
			&& fm.acct_code_g[16].checked == false && fm.acct_code_g[17].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//�������
		if(fm.acct_code[2].checked == true 
			//&& fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false && fm.acct_code_g[14].checked == false)
			&& fm.acct_code_g[13].checked == false && fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//����������
		if(fm.acct_code[3].checked == true 
			//&& fm.acct_code_g[4].checked == false  && fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false
			&& fm.acct_code_g[4].checked == false  && fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false && fm.acct_code_g[7].checked == false
			&& fm.acct_code_g2[7].checked == false && fm.acct_code_g2[8].checked == false && fm.acct_code_g2[9].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}		
		
	//	if (fm.acct_code[3].checked == true ) {
	//		if ( fm.acct_code_g2[8].checked == true || fm.acct_code_g2[9].checked == true) {
	//			if ( fm.o_cau.value == '') { alert('������ �����Ͻʽÿ�.'); return;}
	//		}
	//	}	
			
		//���������
		if(fm.acct_code[4].checked == true 
			//&& fm.acct_code_g[7].checked == false && fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false)
			&& fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//��������&�繫��ǰ��&�Ҹ�ǰ��&��ź�&�����μ��&���޼�����&��ǰ&���ޱ�
		if((fm.acct_code[5].checked == true || fm.acct_code[6].checked == true || fm.acct_code[7].checked == true || fm.acct_code[8].checked == true
				|| fm.acct_code[9].checked == true || fm.acct_code[10].checked == true || fm.acct_code[11].checked == true || fm.acct_code[12].checked == true || fm.acct_code[13].checked == true)
			&& fm.acct_cont[0].value == '')
			{ alert('���並 �Է��Ͻʽÿ�.'); return;}
		
			
		//����, ����, ���, ��ݺ�� �ݵ�� ���� ��ȸ�Ͽ� car_mng_id ���Ѵ�.
		if (fm.acct_code[3].checked == true || fm.acct_code[4].checked == true || fm.acct_code[5].checked == true || fm.acct_code[17].checked == true ) {
		   //if (fm.acct_code_g[9].checked == true  || fm.acct_code_g[11].checked == true ) {
		   if (fm.acct_code_g[10].checked == true  || fm.acct_code_g[12].checked == true ) { 	   
		   } else {
		   	if ( fm.item_code[0].value == '') { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
		   }	
		}		
		
			//��ź�
		if(fm.acct_code[7].checked == true 
			//&& fm.acct_code_g[17].checked == false && fm.acct_code_g[18].checked == false)
			&& fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false)
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
        if(fm.acct_code[0].checked == true   ){ 	   
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
				
					
		//���κ� ����ݾ� �հ� ����
		if(fm.txtTot.value != '' && fm.txtTot.value != '0' && fm.txtTot.value != fm.buy_amt.value){ alert("�հ�� ���谡 ���� �ʽ��ϴ�. �ٽ� Ȯ�� ���ּ���"); return; }
			
						
		if(confirm('�����Ͻðڽ��ϱ�?')){					
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
		
		if(fm.ven_st[0].checked == true )
		{		
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
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
		fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
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
		window.open("../doc_reg/vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=700, height=400, scrollbars=yes");		
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
		if(fm.acct_code[4].checked == true){ 	//���������
			//if(fm.acct_code_g[7].checked == false && fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false )
			if(fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )	
			{	alert('������ �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		}
					
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('��ȸ�� ������ȣ/��ȣ�� �Է��Ͻʽÿ�.'); 	fm.item_name.focus(); 	return;}
		
		
		if ( fm.acct_code[4].checked == true ) {
			//if (fm.acct_code_g[7].checked 	== true  || fm.acct_code_g[10].checked 	== true ) { //�Ϲ������, �縮�� �����
			if (fm.acct_code_g[8].checked 	== true  || fm.acct_code_g[11].checked 	== true ) { //�Ϲ������, �縮�� �����	
				window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
		    } else {
		    	window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
		    }
		} else if ( fm.acct_code[5].checked == true ) {
			window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
	    } else {		
			window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
		}
			
	}
	
	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
		
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm.value;
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
	
	//�������� ���ý�
	function cng_input(){
		var fm = document.form1;
		if(fm.acct_code[0].checked == true){ 		//�����Ļ���
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
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[1].checked == true){ 	//�����
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
			//fm.acct_code_g[15].checked 	= true;  //�Ĵ�
			fm.acct_code_g[16].checked 	= true;  //�Ĵ�
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[2].checked == true){ 	//�������
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
			//fm.acct_code_g[12].checked 	= true;    //�����
			fm.acct_code_g[13].checked 	= true;    //�����
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[3].checked == true){ 	//����������
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
			fm.acct_code_g[4].checked 	= true;  //���ָ�
			fm.acct_code_g2[7].checked 	= true;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[4].checked == true){ 	//���������
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
		
			//fm.acct_code_g[7].checked 	= true;
			fm.acct_code_g[8].checked 	= true;
				//if(fm.acct_code_g[7].checked == true){
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
					tr_acct3_<%=i%>_3.style.display	= '';
					tr_acct3_<%=i%>_98.style.display	= '';
					
				}else{
					tr_acct3_<%=i%>_1.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= 'none';
					tr_acct3_<%=i%>_98.style.display	= 'none';
				
				}
			<%}%>	
			
		}else if(fm.acct_code[5].checked == true){ 	//��������
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
			tr_acct3_3.style.display	= ''; 
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		
		}else if(fm.acct_code[7].checked == true){ 	//��ź�
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
			//fm.acct_code_g[17].checked 	= true;	 //����
			fm.acct_code_g[18].checked 	= true;	 //����
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}else if(fm.acct_code[15].checked == true || fm.acct_code[16].checked == true){ 	//�뿩/�����������
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
			//fm.acct_code_g[19].checked 	= true;  //������ϼ�
			fm.acct_code_g[20].checked 	= true;  //������ϼ�
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}else if(fm.acct_code[17].checked == true){ 	//��ݺ�
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
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
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
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}
	}

	//�����Ļ��� ���� ���ý�
	function cng_input2()
	{
		var fm = document.form1;
		if(fm.acct_code_g[0].checked == true){ //�Ĵ�
			fm.acct_code_g2[1].checked 	= true;
			tr_acct1_1.style.display	= '';
			tr_acct1_2.style.display	= 'none';
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';
			tr_acct101.style.display 	= '';
			
		}
		if(fm.acct_code_g[1].checked == true){ //ȸ�ĺ�
			fm.acct_code_g2[3].checked 	= true;
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= '';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
		
		}
		if(fm.acct_code_g[2].checked == true){ //��Ÿ
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
		if(fm.acct_code_g[3].checked == true){ //������
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
	}	

	//�����Ļ��� ȸ�ĺ� ���� ���ý�	
	function cng_input22()
	{
		var fm = document.form1;
				
		tr_acct98.style.display 	= '';
		tr_acct99.style.display 	= '';					
		tr_acct101.style.display 	= '';	
	}
	
	//��ź� ���� ���ý�	
	function cng_input7()
	{
		
		var fm = document.form1;		
		//if(fm.acct_code_g[17].checked == true){			//����			
		if(fm.acct_code_g[18].checked == true){			//����	
			tr_acct99.style.display 	= '';					
			tr_acct101.style.display 	= '';			
		}
		//if(fm.acct_code_g[18].checked == true){			//����
		if(fm.acct_code_g[19].checked == true){			//����
			tr_acct99.style.display 	= 'none';					
			tr_acct101.style.display 	= 'none';	
		
		}
		
	}
	
		//����� ���� ���ý�
	function cng_input4()
	{
		var fm = document.form1;
		//if(fm.acct_code_g[7].checked == true){ //�Ϲ�����
	 	if(fm.acct_code_g[8].checked == true){ //�Ϲ�����
			tr_acct_plus.style.display	= '';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= '';	
				
		}
		//if(fm.acct_code_g[8].checked == true){ //�ڵ����˻�
		if(fm.acct_code_g[9].checked == true){ //�ڵ����˻�
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
	
		//if(fm.acct_code_g[9].checked == true){ //��ȣ��
		if(fm.acct_code_g[10].checked == true){ //��ȣ��
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			
		}
		//if(fm.acct_code_g[10].checked == true){ //�縮������
		if(fm.acct_code_g[11].checked == true){ //�縮������
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
		//if(fm.acct_code_g[11].checked == true){ //��Ÿ
		if(fm.acct_code_g[12].checked == true){ //��Ÿ
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			
		}
	}		
	
	//���δ� ���� �ݾ�(1/n:0, �ݾ������Է�:1)
	function cng_input1()
	{
		var fm 		= document.form1;
		var inCnt	= toInt(fm.user_su.value);
		var inTot	= toInt(parseDigit(fm.buy_amt.value));
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;
		
//		if(inCnt > 60){	alert('1/n �Է��� �ִ� 60�α��� �Դϴ�.'); return;}
		if(inCnt > acar_cnt){	alert('1/n �Է��� �ִ� '+acar_cnt+'�α��� �Դϴ�.'); return;}
		
		if(fm.user_Rdio[0].checked == true && inCnt > 0 && toInt(parseDigit(fm.buy_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_amt.value)) / inCnt);			

			for(i=0; i<inCnt ; i++){
				fm.money[i].value = parseDecimal(inAmt);
				innTot += inAmt;
			}
	//		for(i=inCnt; i<60 ; i++){
			for(i=inCnt; i<acar_cnt ; i++){
				fm.money[i].value = '0';
			}
			
			if(inTot > innTot) 	fm.money[0].value 		= parseDecimal(toInt(parseDigit(fm.money[0].value)) 	  + (inTot-innTot));
			if(inTot < innTot) 	fm.money[inCnt-1].value = parseDecimal(toInt(parseDigit(fm.money[inCnt-1].value)) + (inTot-innTot));
			
			fm.txtTot.value = fm.buy_amt.value;
		}
		
		if(fm.user_Rdio[1].checked == true)
		{
	//		for(i=0; i<60 ; i++){
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
		
//		for(i=0; i<60 ; i++){
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
	
//-->
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
			  &nbsp;&nbsp;<font color="red">�� ī����ǥ�� ��� �ΰ��� ȯ�޴���Դϴ�.</font></td>
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
			  <input type="hidden" name="ven_nm_cd" value="">
			  <a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			  &nbsp;<a href="javascript:CardDocHistory('<%=cd_bean.getVen_code()%>','<%=cd_bean.getCardno()%>','<%=cd_bean.getBuy_id()%>');" ><img src=/acar/images/center/button_in_uselist.gif border=0 align=absmiddle></a>
			  &nbsp;<a href="javascript:VendorHistory('<%=cd_bean.getVen_code()%>');" ><img src=/acar/images/center/button_in_bgir.gif border=0 align=absmiddle></a>
			</td>
					
			  		
       	  </tr>
   		  <tr>
          	<td colspan="2" class='title'>��������</td>
          	<td >&nbsp;<input type="radio" name="ven_st" value="1" <%if(cd_bean.getVen_st().equals("1"))%>checked<%%>>�Ϲݰ���
			     &nbsp;<input type="radio" name="ven_st" value="2" <%if(cd_bean.getVen_st().equals("2"))%>checked<%%>>���̰���
			     &nbsp;<input type="radio" name="ven_st" value="3" <%if(cd_bean.getVen_st().equals("3"))%>checked<%%>>�鼼
			     &nbsp;<input type="radio" name="ven_st" value="4" <%if(cd_bean.getVen_st().equals("4"))%>checked<%%>>�񿵸�����(�������/��ü)
					<!--&nbsp;&nbsp;<a href="http://www.nts.go.kr/cal/cal_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif border=0 align=absmiddle></a>-->
					&nbsp;&nbsp;<a href="http://www.nts.go.kr/cal/cal_check_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>					
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
		  	  <input name="user_nm" type="text" class="text" value="<%=c_db.getNameById(cd_bean.getBuy_user_id(), "USER")%>" size="12" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id', '0')">
			  <input type="hidden" name="buy_user_id" value="<%=cd_bean.getBuy_user_id()%>">
			  <a href="javascript:User_search('buy_user_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			  </td>
          </tr>
		  
          <tr>
          	<td colspan="2" class='title'>��������</td>
          	<td>
			  <table width="100%" border="0">
			    <tr>
				  <td width="40" align="center"><font color="#CCCCCC">[����]</font></td>
			      <td width="90"><input type="radio" name="acct_code" value="00001" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00001"))%>checked<%%>>
				  �����Ļ���</td>
			      <td width="90"><input type="radio" name="acct_code" value="00002" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00002"))%>checked<%%>>
				  �����</td>
			      <td width="90"><input type="radio" name="acct_code" value="00003" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00003"))%>checked<%%>>
				  �������</td>
			      <td width="90"><input type="radio" name="acct_code" value="00004" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00004"))%>checked<%%>>
				  ����������</td>
			      <td width="90"><input type="radio" name="acct_code" value="00005" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00005"))%>checked<%%>>
				  ���������</td>
			      <td width="90"><input type="radio" name="acct_code" value="00006" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00006"))%>checked<%%>>
				  ��������</td>
			      <td width="90"><input type="radio" name="acct_code" value="00007" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00007"))%>checked<%%>>
				  �繫��ǰ�� </td>
				  <td width="90"><input type="radio" name="acct_code" value="00009" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00009"))%>checked<%%>>
					��ź�</td>
				
			    </tr>
			    <tr>
				  <td align="center"><font color="#CCCCCC">[����]</font></td>
			      <td><input type="radio" name="acct_code" value="00008" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00008"))%>checked<%%>>
						�Ҹ�ǰ��</td>
			      <td><input type="radio" name="acct_code" value="00010" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00010"))%>checked<%%>>
						�����μ��</td>
			      <td><input type="radio" name="acct_code" value="00011" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00011"))%>checked<%%>>
						���޼�����</td>
			      <td><input type="radio" name="acct_code" value="00012" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00012"))%>checked<%%>>
						��ǰ</td>
			      <td><input type="radio" name="acct_code" value="00013" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00013"))%>checked<%%>>
						���ޱ�</td>
				  <td><input type="radio" name="acct_code" value="00014" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00014"))%>checked<%%>>
						�����Ʒú�</td>		
				  <td><input type="radio" name="acct_code" value="00015" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00015"))%>checked<%%>>
						���ݰ�����</td>		
				  <td>&nbsp;</td>			
			    </tr>
			    <tr>
				  <td align="center">&nbsp;</td>
			      <td><input type="radio" name="acct_code" value="00016" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00016"))%>checked<%%>>
						�뿩�������</td>
			      <td><input type="radio" name="acct_code" value="00017" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00017"))%>checked<%%>>
						�����������</td>
			      <td><input type="radio" name="acct_code" value="00018" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00018"))%>checked<%%>>
						��ݺ�</td>
			      <td>&nbsp;</td>
			      <td>&nbsp;</td>
				  <td>&nbsp;</td>		
				  <td>&nbsp;</td>		
				  <td>&nbsp;</td>	
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
		      <input type="radio" name="acct_code_g" value="1" onClick="javascript:cng_input2()" <%if(cd_bean.getAcct_code_g().equals("1"))%>checked<%%>>
            	�Ĵ�
              <input type="radio" name="acct_code_g" value="2" onClick="javascript:cng_input2()" <%if(cd_bean.getAcct_code_g().equals("2"))%>checked<%%>>
				������
			  <input type="radio" name="acct_code_g" value="15" onClick="javascript:cng_input2()" <%if(cd_bean.getAcct_code_g().equals("15"))%>checked<%%>> 
				������	
			  <input type="radio" name="acct_code_g" value="3" onClick="javascript:cng_input2()" <%if(cd_bean.getAcct_code_g().equals("3"))%>checked<%%>> 
				��Ÿ			
		  </td>
        </tr>
        <tr>
          <td><table width="90%"  border="0" cellpadding="0" cellspacing="0">
              <tr id=tr_acct1_1 style='display:<%if(cd_bean.getAcct_code_g().equals("1")){%>""<%}else{%>none<%}%>'>
                <td>&nbsp;
                  <input type="radio" name="acct_code_g2" value="1" onClick="javascript:cng_input3()" <%if(cd_bean.getAcct_code_g2().equals("1"))%>checked<%%>>
				  ����
				  <input type="radio" name="acct_code_g2" value="2" onClick="javascript:cng_input3()" <%if(cd_bean.getAcct_code_g2().equals("2"))%>checked<%%>>
				  �߽�
				  <input type="radio" name="acct_code_g2" value="3" onClick="javascript:cng_input3()" <%if(cd_bean.getAcct_code_g2().equals("3"))%>checked<%%>>
				  Ư�ٽ�</td>
              </tr>
              <tr id=tr_acct1_2 style='display:<%if(cd_bean.getAcct_code_g().equals("2")){%>""<%}else{%>none<%}%>'>
                <td>&nbsp;
                  <input type="radio" name="acct_code_g2" value="4" <%if(cd_bean.getAcct_code_g2().equals("4"))%>checked<%%>>
				  ȸ����ü����
				  <input type="radio" name="acct_code_g2" value="5" <%if(cd_bean.getAcct_code_g2().equals("5"))%>checked<%%>>
				  �μ��� �������
				  <input type="radio" name="acct_code_g2" value="6" <%if(cd_bean.getAcct_code_g2().equals("6"))%>checked<%%>>
				  �μ��� ������ȸ��
				  <input type="radio" name="acct_code_g2" value="15" <%if(cd_bean.getAcct_code_g2().equals("15"))%>checked<%%>>
				  ��ȣȸ</td>
              </tr>
           
           </table></td>
        </tr>
      </table></td>
    </tr>
    <tr id=tr_acct2 style="display:<%if(cd_bean.getAcct_code().equals("00004")){%>''<%}else{%>none<%}%>">
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="13" <%if(cd_bean.getAcct_code_g().equals("13"))%>checked<%%>>���ָ�
			<input type="radio" name="acct_code_g" value="4"<%if(cd_bean.getAcct_code_g().equals("4"))%>checked<%%>>����
			<input type="radio" name="acct_code_g" value="5" <%if(cd_bean.getAcct_code_g().equals("5"))%>checked<%%>>LPG
			<input type="radio" name="acct_code_g" value="27" <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>����/����	<!-- ���������� �߰� -->				
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
    <tr id=tr_acct3 style='display:<%if(cd_bean.getAcct_code().equals("00005")){%>""<%}else{%>none<%}%>'>
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
			
		 <%if( ( user_id.equals(cd_bean.getReg_id())||user_id.equals(cd_bean.getBuy_user_id()) )  && cd_bean.getBuy_amt()>0  && cd_bean.getAcct_code().equals("00003") && cd_bean.getM_doc_code().equals("")){%>
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
			������</td>
        </tr>
      </table></td>
    </tr>
    <tr id=tr_acct7 style='display:<%if(cd_bean.getAcct_code().equals("00009")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="16" onClick="javascript:cng_input7()" <%if(cd_bean.getAcct_code_g().equals("16"))%>checked<%%>> 
			����
			<input type="radio" name="acct_code_g" value="17" onClick="javascript:cng_input7()" <%if(cd_bean.getAcct_code_g().equals("17"))%>checked<%%>> 
			����</td>
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
		  </td>
        </tr>
      </table></td>
    </tr>
		
	<tr id=tr_acct_plus style='display:<%if( cd_bean.getAcct_code().equals("00005") && cd_bean.getAcct_code_g().equals("6")   ){%>""<%}else{%>none<%}%>'>
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
  
    <tr id=tr_acct3_1 style='display:<%if(cd_bean.getAcct_code().equals("00004") || cd_bean.getAcct_code().equals("00006") || ( cd_bean.getAcct_code().equals("00005") && !cd_bean.getAcct_code_g().equals("18") )  ){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td width="87%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=cd_bean.getItem_name()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')">
			<input type="hidden" name="rent_l_cd" value="<%=cd_bean.getRent_l_cd()%>">
			<input type="hidden" name="serv_id" value="<%=cd_bean.getServ_id()%>">
			<input type="hidden" name="item_code" value="<%=cd_bean.getItem_code()%>">
		   <a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			&nbsp;(������ȣ/��ȣ�� �˻�)</td>       
      </table></td>
    </tr>
    
    <tr id=tr_acct3_2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td width="87%">&nbsp;
          			  <select name="o_cau" >
        			    <option value="">--����--</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cd_bean.getO_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
        				<%}%>
          			  </select>
            &nbsp;*�������� ��� ���þ��ص� ��.
          </td>
        </tr>	
       </table></td>
    </tr>
        
    <tr id=tr_acct3_3 style='display:<%if( cd_bean.getAcct_code().equals("00005") &&  cd_bean.getAcct_code_g().equals("6")  ){%>""<%}else{%>none<%}%>'>
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
        
    <tr id=tr_acct98 style='display:""'>
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
 	
 	 String ht_acct_cont = ""; 	 
 	 
      for(int j=1; j< 19; j++){
      
        if ( j < vt_i_size1 ) {
        	Hashtable ht_item = (Hashtable)vt_item.elementAt(j);
        	ht_item_name = String.valueOf(ht_item.get("ITEM_NAME"));
        	ht_rent_l_cd = String.valueOf(ht_item.get("RENT_L_CD"));
        	ht_item_code = String.valueOf(ht_item.get("ITEM_CODE"));
        	ht_serv_id = String.valueOf(ht_item.get("SERV_ID"));
        	ht_call_t_nm = String.valueOf(ht_item.get("CALL_T_NM"));
        	ht_call_t_tel = String.valueOf(ht_item.get("CALL_T_TEL"));
           	ht_acct_cont = String.valueOf(ht_item.get("ACCT_CONT"));
        	        			        					
        } else {	
        	ht_item_name = "";
        	ht_rent_l_cd = "";
        	ht_item_code = "";
        	ht_serv_id = "";
        	ht_call_t_nm = "";
     		ht_call_t_tel = "";
     		ht_acct_cont = ""; 	  		
        }
        
  	%>
     <tr id=tr_acct3_<%=j%>_1  style='display:<%if( j < vt_i_size1 ){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>����</td>
          <td width="87%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=ht_item_name%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('<%=j%>')">
				<input type="hidden" name="rent_l_cd" value="<%=ht_rent_l_cd%>">
				<input type="hidden" name="serv_id" value="<%=ht_serv_id%>">
				<input type="hidden" name="item_code" value="<%=ht_item_code%>">
            <a href="javascript:Rent_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(������ȣ/��ȣ�� �˻�)</td>
        </tr>
     		
      </table></td>
    </tr>     
    
     <tr id=tr_acct3_<%=j%>_3 style='display:<%if( j < vt_i_size1 ){%>""<%}else{%>none<%}%>'>
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


    <tr id=tr_acct99 style='display:<%if(cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="13%" class='title'>�����ο�</td>
          <td width="87%">&nbsp;
            <input name="user_su" type="text" class="text" value="<%=cd_bean.getUser_su()%>" size="2">
			��
            <input name="user_cont" type="text" class="text" value="<%=cd_bean.getUser_cont()%>" size="93"></td>
        </tr>
        <tr>
          <td width="13%" class='title'>����ݾ�</td>
          <td width="87%">&nbsp;
            <input type="radio" name="user_Rdio" value="0" onClick="javascript:cng_input1()"> 1/n
			      		<input type="radio" name="user_Rdio" value="1" onClick="javascript:cng_input1()">�ݾ� �����Է� &nbsp;
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
					//		for( int j = vt_size1 ; j < 60 ; j+=2){
							for( int j = vt_size1 ; j < vt_acar_size ; j+=2){
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
