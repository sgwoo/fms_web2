<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	//��ǥ����
	CardDocBean cd_bean = CardDb.getCardDocCons(car_no, cons_no, seq);
	
	cardno = cd_bean.getCardno();
	buy_id = cd_bean.getBuy_id();
	//�ŷ�ó����
	Hashtable vendor = new Hashtable();
	if(!cd_bean.getVen_code().equals("")){
		vendor = neoe_db.getVendorCase(cd_bean.getVen_code());
	}
	
	//�ŷ�ó�����ڵ�
	Hashtable ven_reg = neoe_db.getTradeHisRegIds(cd_bean.getVen_code(), cd_bean.getReg_dt());//-> neoe_db ��ȯ
	
	//����� ����Ʈ ��ȸ
	Hashtable l_cont = CardDb.getLRent(cd_bean.getRent_l_cd());
		
	String acct_code 	= cd_bean.getAcct_code();
	String acct_code_g 	= cd_bean.getAcct_code_g();
	String acct_code_g2 = cd_bean.getAcct_code_g2();
	String acct_cont 	= cd_bean.getAcct_cont()==null?"":cd_bean.getAcct_cont();
	String firm_nm 		= String.valueOf(l_cont.get("FIRM_NM"))==null?"":String.valueOf(l_cont.get("FIRM_NM"));
	String item_name	= cd_bean.getItem_name();
	String doc_acct_cont = "";
	
	String chk="0";
	
	if(!item_name.equals("") && cd_bean.getItem_name().indexOf("(")!=-1){
		item_name 	= cd_bean.getItem_name().substring(0, cd_bean.getItem_name().indexOf("("));
	}
	
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	String user_su 		= cd_bean.getUser_su();
	String user_cont	= cd_bean.getUser_cont();
	String buy_user_nm 	= c_db.getNameById(cd_bean.getBuy_user_id(), "USER");
	
		//�����Ļ���
		if(acct_code.equals("00001")){
			if(acct_code_g.equals("1")      && acct_code_g2.equals("1"))	doc_acct_cont = "���Ĵ�:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("2"))	doc_acct_cont = "�߽Ĵ�:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("3"))	doc_acct_cont = "���Ĵ�:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("4"))	doc_acct_cont = "ȸ����ü����:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("5"))	doc_acct_cont = "�μ����������:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("6"))	doc_acct_cont = "�μ���������ȸ��:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("15"))	doc_acct_cont = "��ȣȸ:"+acct_cont;
			else if(acct_code_g.equals("15") )								doc_acct_cont = "������:"+acct_cont;
			else if(acct_code_g.equals("30") )								doc_acct_cont = "�����ް�:"+acct_cont;
			else 							 								doc_acct_cont = acct_cont;

/*			
			else if(acct_code_g.equals("3") && acct_code_g2.equals("7"))	doc_acct_cont = "Ŀ��:"+acct_cont;
			else if(acct_code_g.equals("3") && acct_code_g2.equals("8"))	doc_acct_cont = "����:"+acct_cont;
			else if(acct_code_g.equals("3") && acct_code_g2.equals("9"))	doc_acct_cont = "��ǰ:"+acct_cont;
			else if(acct_code_g.equals("3") && acct_code_g2.equals("10"))	doc_acct_cont = acct_cont;
*/		
		//����������
		}else if(acct_code.equals("00004")){
			if(acct_code_g.equals("13"))			doc_acct_cont = "���ָ�";
			else if(acct_code_g.equals("4"))		doc_acct_cont = "����";
			else if(acct_code_g.equals("5"))		doc_acct_cont = "LPG";
			else if(acct_code_g.equals("27"))		doc_acct_cont = "����������";	//���������� �߰�
			
			if(acct_code_g2.equals("11"))			doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("12"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("13"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			
		//	if(!cd_bean.getRent_l_cd().equals("")) 	doc_acct_cont = doc_acct_cont+"-"+firm_nm;
		//	else									doc_acct_cont = doc_acct_cont+"("+buy_user_nm+")";
			
		//���������
		}else if(acct_code.equals("00005")){
			
			if(acct_code_g.equals("6"))				doc_acct_cont = "�Ϲ�����:"+acct_cont;
			else if(acct_code_g.equals("7"))		doc_acct_cont = "�ڵ����˻�:"+acct_cont;
	//		else if(acct_code_g.equals("8"))		doc_acct_cont = "���˱�Ϻ�:"+acct_cont;
			else if(acct_code_g.equals("18"))		doc_acct_cont = "��ȣ�Ǵ��:"+acct_cont;		
			else if(acct_code_g.equals("21"))		doc_acct_cont = "�縮������:"+acct_cont;	
			else if(acct_code_g.equals("22"))		doc_acct_cont = acct_cont;	
					
		
		//	if(!buy_user_nm.equals("")) 			doc_acct_cont = doc_acct_cont+"("+buy_user_nm+")";
		
		//��������
		}else if(acct_code.equals("00006")){
		
			doc_acct_cont = acct_cont;
		
		//	if(!buy_user_nm.equals("")) 			doc_acct_cont = doc_acct_cont+"("+buy_user_nm+")";
		
		//�������
		}else if(acct_code.equals("00003")){
		
			//�����
			if(acct_code_g.equals("9"))				doc_acct_cont = "�����:"+acct_cont;
			//�����
			else if(acct_code_g.equals("12"))		doc_acct_cont = "��Ÿ�����:"+acct_cont;
			//�����н�
			else if(acct_code_g.equals("20"))		doc_acct_cont = "�����н�:"+acct_cont;
				//�����н�
			else if(acct_code_g.equals("32"))		doc_acct_cont = "��������:"+acct_cont;
		
		//�����
		}else if(acct_code.equals("00002")){
		
			//�Ĵ�
			if(acct_code_g.equals("11"))			doc_acct_cont = "�Ĵ�:"+acct_cont;
			//������
			else if(acct_code_g.equals("12"))		doc_acct_cont = "������:"+acct_cont;
			//��Ÿ
			else if(acct_code_g.equals("14"))		doc_acct_cont = acct_cont;
		
		//��ź�
		}else if(acct_code.equals("00009")){
													doc_acct_cont = "��ź�:"+acct_cont;
		
		//�뿩�������
		}else if(acct_code.equals("00016")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "������ϼ�:"+acct_cont;
		
		//�����������
		}else if(acct_code.equals("00017")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "������ϼ�:"+acct_cont;
		
		}else{
		
			doc_acct_cont = acct_cont;
		
		}

		if(!user_cont.equals("")) 		doc_acct_cont = doc_acct_cont+" "+user_cont;
		if(!user_su.equals("")) 		doc_acct_cont = doc_acct_cont+"("+user_su+"��)";
		
		
	String car_su = "1";
		
	Vector vt_item = CardDb.getCardDocItemList(cardno, buy_id); 
 	int vt_i_size1 = vt_item.size();
 	
 	if ( vt_i_size1 > 0) {
 	    car_su = Integer.toString(vt_i_size1);
 	} 	

	String file_path = cd_bean.getFile_path();
//	file_path = file_path.substring(0,4);

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
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//����
	function Save_app(){
		var fm = document.form1;
		if(fm.cardno.value == '')	{	alert('ī���ȣ�� �Է��Ͻʽÿ�.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_amt.value == '0'){	alert('���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('�ŷ�ó�� �Է��Ͻʽÿ�.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('�ŷ�ó�� ��ȸ�Ͻʽÿ�?'); return; }
		if(fm.user_nm.value == '' || fm.buy_user_id.value == ''){	alert('����ڸ� �˻��Ͻʽÿ�.'); return; }	
		
		//����� ������
		if(fm.acct_code[1].checked == false ){
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
		if(fm.acct_code[0].checked == true 
			&& fm.acct_code_g[0].checked == false  && fm.acct_code_g[1].checked == false  && fm.acct_code_g[2].checked == false && fm.acct_code_g[3].checked == false && fm.acct_code_g[4].checked == false
			&& fm.acct_code_g2[0].checked == false && fm.acct_code_g2[1].checked == false && fm.acct_code_g2[2].checked == false 
			&& fm.acct_code_g2[3].checked == false && fm.acct_code_g2[4].checked == false && fm.acct_code_g2[5].checked == false && fm.acct_code_g2[6].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//�����		
		if(fm.acct_code[1].checked == true 
			&& fm.acct_code_g[17].checked == false && fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//�������
		if(fm.acct_code[2].checked == true 
			&& fm.acct_code_g[13].checked == false && fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//����������
		if(fm.acct_code[3].checked == true 
			&& fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false
			&& fm.acct_code_g2[7].checked == false && fm.acct_code_g2[8].checked == false && fm.acct_code_g2[9].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//���������
		if(fm.acct_code[4].checked == true 
			&& fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			{ alert('������ �����Ͻʽÿ�.'); return;}
			
		//��������&�繫��ǰ��&�Ҹ�ǰ��&��ź�&�����μ��&���޼�����&��ǰ&���ޱ�
		if((fm.acct_code[5].checked == true || fm.acct_code[6].checked == true || fm.acct_code[7].checked == true || fm.acct_code[8].checked == true
				|| fm.acct_code[9].checked == true || fm.acct_code[10].checked == true || fm.acct_code[11].checked == true || fm.acct_code[12].checked == true || fm.acct_code[13].checked == true)
			&& fm.acct_cont[0].value == '')
			{ alert('���並 �Է��Ͻʽÿ�.'); return;}
		
		//����, ����, ���� �ݵ�� ���� ��ȸ�Ͽ� car_mng_id ���Ѵ�.
		if (fm.acct_code[3].checked == true || fm.acct_code[4].checked == true || fm.acct_code[5].checked == true || fm.acct_code[17].checked == true || fm.acct_code[18].checked == true) {
		   if (fm.acct_code_g[10].checked == true || fm.acct_code_g[12].checked == true ) {
		   } else {
		   	if ( fm.item_code[0].value == '') { alert('������ �˻��Ͽ� �����Ͻʽÿ�.'); return;}
		   }	
		}		
			//��ź�
		if(fm.acct_code[7].checked == true 
			&& fm.acct_code_g[20].checked == false && fm.acct_code_g[21].checked == false)
			{ alert('������ �����Ͻʽÿ�.'); return;}
				
				
		//���� ���ڼ� üũ
	//	if(fm.doc_acct_cont.value != '' && !max_length(fm.doc_acct_cont.value,80)){	
		if(fm.doc_acct_cont.value == ''){	
		//	alert('���� ���� ���̴� '+get_length(fm.doc_acct_cont.value)+'��(��������) �Դϴ�.\n\n����� �ѱ�40��/����80�ڱ��� �Է��� �����մϴ�.'); return; } 
			alert('��ǥ���並 �Է��ϼ���..'); return; 
		} 						

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
      		//  if(fm.acct_code[0].checked == true && fm.acct_code_g[0].checked == true && fm.acct_code_g2[1].checked == true  ){
     		//   if(fm.acct_code[0].checked == true && fm.acct_code_g[0].checked == true   ){
       		if(fm.acct_code[0].checked == true   ){ 	   
        	  	if(fm.user_su.value == ''){ alert("�ο����� ����ϼž� �մϴ�. �ٽ� Ȯ�� ���ּ���"); return; }
        	   
        	  	if ( toInt(fm.user_su.value) == false ) { alert("�ο����� ���ڿ��� �մϴ�. �ٽ� Ȯ�� ���ּ���"); return; }
        	    
        	  	if(fm.txtTot.value == '' || fm.txtTot.value == '0' ){ alert("�ݾ��� ����ϼž� �մϴ�. �ٽ� Ȯ�� ���ּ���"); return; }		
        	  	  
           	  	if(inCnt>0){
					for(i=0; i<inCnt ; i++){
					   strDept_id =  fm.dept_id[i].value;
					   strMoney =  fm.money[i].value;
					   
					   totMoney += toInt(parseDigit(fm.money[i].value));
					   						   
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
		
							
			fm.action='doc_app_case_step.jsp';		
			
			fm.target='i_no';
//			fm.target='CardDocView';						
			fm.submit();
		}
	}

	//����
	function Del_app(){
		var fm = document.form1;
		if(confirm('�����Ͻðڽ��ϱ�?')){					
		if(confirm('��¥�� �����Ͻðڽ��ϱ�?')){					
		if(confirm('���� �����Ͻðڽ��ϱ�?')){									
			fm.action='doc_app_case_del.jsp';		
			fm.target='i_no';
//			fm.target='CardDocView';			
			fm.submit();
		}}}
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
		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
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
		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
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
		if(fm.acct_code[4].checked == true){ 	//���������
			if(fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			{	alert('������ �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		}
					
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('��ȸ�� ������ȣ/��ȣ�� �Է��Ͻʽÿ�.'); 	fm.item_name.focus(); 	return;}
				
		if ( fm.acct_code[4].checked == true ) {
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
		var t_wd = fm.user_nm[0].value;
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
		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}					
	}	
	
		//�������� ���ý�
	function cng_input(){
		var fm = document.form1;
		
		tot_buy_amt();
		
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
			fm.acct_code_g[13].checked 	= true; //�����
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
			fm.acct_code_g[5].checked 	= true;
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
			
	//		fm.acct_code_g[7].checked 	= true;
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
		//	tr_acct102.style.display 	= 'none';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[20].checked 	= true;  //����	
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
		//	tr_acct102.style.display 	= 'none';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[22].checked 	= true;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}else if(fm.acct_code[17].checked == true || fm.acct_code[18].checked == true){ 	//��ݺ�
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
		if(fm.acct_code_g[1].checked == true){ //������
			fm.acct_code_g2[3].checked 	= true;
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= '';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= 'none';			
			tr_acct101.style.display 	= '';
	
		}
		if(fm.acct_code_g[2].checked == true){ //������
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
		if(fm.acct_code_g[3].checked == true){ //��Ÿ
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
		if(fm.acct_code_g[4].checked == true){ //�����ް�
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
		if(fm.acct_code_g[20].checked == true){			//����			
			tr_acct99.style.display 	= '';					
			tr_acct101.style.display 	= '';			
		}
		if(fm.acct_code_g[21].checked == true){			//����
			tr_acct99.style.display 	= 'none';					
			tr_acct101.style.display 	= 'none';	
		
		}
		
	}
	
	//����� ���� ���ý�
	function cng_input4()
	{
		var fm = document.form1;
		if(fm.acct_code_g[8].checked == true){ //�Ϲ�����
			tr_acct_plus.style.display	= '';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= '';	
				
		}
		if(fm.acct_code_g[9].checked == true){ //����˻�
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
	
		if(fm.acct_code_g[10].checked == true){ //��ȣ��
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			
		}
		if(fm.acct_code_g[11].checked == true){ //�縮������
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
		
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
		
		if(inCnt > 80){	alert('1/n �Է��� �ִ� 80�α��� �Դϴ�.'); return;}
		
		if(fm.user_Rdio[0].checked == true && inCnt > 0 && toInt(parseDigit(fm.buy_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_amt.value)) / inCnt);			

			for(i=0; i<inCnt ; i++){
				fm.money[i].value = parseDecimal(inAmt);
				innTot += inAmt;
			}
			for(i=inCnt; i<80 ; i++){
				fm.money[i].value = '0';
			}
			
			if(inTot > innTot) 	fm.money[0].value 		= parseDecimal(toInt(parseDigit(fm.money[0].value)) 	  + (inTot-innTot));
			if(inTot < innTot) 	fm.money[inCnt-1].value = parseDecimal(toInt(parseDigit(fm.money[inCnt-1].value)) + (inTot-innTot));
			
			fm.txtTot.value = fm.buy_amt.value;
		}
		
		if(fm.user_Rdio[1].checked == true)
		{
			for(i=0; i<80 ; i++){
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
		
		for(i=0; i<80 ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		
		<%if(cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003")){%>
		fm.txtTot.value = parseDecimal(innTot);
		<%}%>
	}
	
	//ī����ǥ ī�庯��
	function doc_card_change(){
		var fm = document.form1;
		window.open("about:blank",'CardChange','scrollbars=yes,status=no,resizable=yes,width=600,height=200,left=250,top=250');		
		fm.action = "card_change.jsp";
		fm.target = "CardChange";
		fm.submit();		
	}
	
	function CardDocHistory(ven_code, cardno, buy_id){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code+"&cardno="+cardno+"&buy_id="+buy_id, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
	
	function VendorHistory(ven_code){
		var fm = document.form1;
		window.open("../doc_reg/vendor_history.jsp?ven_code="+ven_code, "VENDOR_H_LIST", "left=10, top=10, width=1050, height=600, scrollbars=yes");				
	}
	
	//����û����������ȸ
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}	


//�˾������� ����
	function MM_openBrWindow(theURL,file_path,features) { //v2.0
			theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL;
		//	alert(theURL);
			window.open(theURL,'popwin_in1',features);
	}	
	
	
	function set_oil_price(){
		var fm = document.form1;		
		
			fm.oil_price.value 		= Math.round(toInt(parseDigit(fm.buy_amt.value)) / parseDigit(fm.oil_liter.value));		
		alert(fm.oilprice.value);
	}

	
			//��ĵ���
function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&cardno=<%=cardno%>&buy_id=<%=buy_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

//-->
</script>

</head>
<body onload="javascript:document.form1.buy_dt.focus();set_oil_price();">
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="car_no" value="<%=car_no%>">
  <input type='hidden' name='cons_no' value='<%=cons_no%>'>
  <input type='hidden' name='nts_yn' value=''> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
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
              <td width="15%" class='title'>�ſ�ī���ȣ</td>
              <td width="85%">&nbsp;
                  <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" readonly> 
                  (<%=buy_id%>)
              </td>
            </tr>
          </table>
      </td>
    </tr>	
    <tr>
	  <td class=h></td>
    <tr>
	  <td>&nbsp;&nbsp;&nbsp;
     <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getReg_id(), "USER")%>  
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getReg_dt())%>
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getApp_id(), "USER")%>
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getApp_dt())%> 
    </td></tr>       
    <tr>
	  <td class=h></td>
    <tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td colspan="2" class='title'>�ŷ�����</td>
          	<td width="85%">&nbsp;
		  	  <input name="buy_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cd_bean.getBuy_dt())%>" size="12" onBlur='javascript:this.value=ChangeDate2(this.value)' readonly></td>
          </tr>
       
          <tr>
          <td width="3%" rowspan="3" class='title'>��<br>
            ��<br>
            ��<br>
			��</td>
          	<td class='title'>���ް�</td>
          	<td>&nbsp;
              <input type="text" name="buy_s_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_s_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();' readonly>
              ��
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			
			</td>
          </tr>		  
          <tr>
          	<td class='title'>�ΰ���</td>
          	<td>&nbsp;
              <input type="text" name="buy_v_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_v_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();' readonly>
              ��
			  </td>
          </tr>
          <tr>
           	<td class='title'>�հ�</td>
          	<td>&nbsp;
              <input type="text" name="buy_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value);  tot_buy_amt();' readonly>
              ��
              
            </td>
          </tr>
          
          <tr>
          	<td colspan="2" class='title'>�ŷ�ó</td>
          	<td>&nbsp;
              <input name="ven_name" type="text" class="whitetext" value="<%=cd_bean.getVen_name()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)" readonly>
			  <input type="hidden" name="ven_code" value="<%=cd_bean.getVen_code()%>">
			  &nbsp;&nbsp;&nbsp;&nbsp;
			  (����ڹ�ȣ:<input type="text" class="whitetext" size="12" name="ven_nm_cd"  value="<%=AddUtil.ChangeEnt_no(String.valueOf(vendor.get("S_IDNO")))%>">)
			</td>
       	  </tr>
   		  <tr>
          	<td colspan="2" class='title'>��������</td>
          	<td >&nbsp;<input type="radio" name="ven_st" value="1" <%if(cd_bean.getVen_st().equals("1"))%>checked<%%>  onClick="javascript:cng_vs_input()">�Ϲݰ���
			     &nbsp;<input type="radio" name="ven_st" value="2" <%if(cd_bean.getVen_st().equals("2"))%>checked<%%>  onClick="javascript:cng_vs_input()">���̰���
			     &nbsp;<input type="radio" name="ven_st" value="3" <%if(cd_bean.getVen_st().equals("3"))%>checked<%%>  onClick="javascript:cng_vs_input()">�鼼
			     &nbsp;<input type="radio" name="ven_st" value="4" <%if(cd_bean.getVen_st().equals("4"))%>checked<%%>  onClick="javascript:cng_vs_input()">�񿵸�����(�������/��ü)
				 </td>
       	  </tr>		            		  
          <tr>
            <td colspan="2" class='title'>�����</td>
          	<td width="85%">&nbsp;
		  	  <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(cd_bean.getBuy_user_id(), "USER")%>" size="30" style='IME-MODE: active' >
			  <input type="hidden" name="buy_user_id" value="<%=cd_bean.getBuy_user_id()%>">
			  </td>
          </tr>
		  <%if(!cd_bean.getSiokno().equals("")){%>
		  <tr>
            <td colspan="2" class='title'>���ݿ����� ���ι�ȣ</td>
          	<td width="85%">&nbsp;
		  	  <input name="user_nm" type="text" class="text" value="<%=cd_bean.getSiokno()%>" size="30" style='IME-MODE: active'>
			  </td>
          </tr>
		  <%}%>
          <tr>
          	<td colspan="2" class='title'>��������</td>
          	<td>
			  <table width="100%" border="0">
			    <tr>
			      <td width="90"><input type="radio" name="acct_code" value="00004" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00004"))%>checked<%%>>
				  ����������</td>
			    </tr>
			    
			  </table>
		    </td>
          </tr>
        </table>
	  </td>
    </tr>
    <tR>
        <td class=h></td>
    </tr>
    <tR>
        <td class=h></td>
    </tr>
    
    <tr id=tr_acct2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line">
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>����</td>          
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="13" <%if(cd_bean.getAcct_code_g().equals("13"))%>checked<%%>>���ָ�
			<input type="radio" name="acct_code_g" value="4"<%if(cd_bean.getAcct_code_g().equals("4"))%>checked<%%>>����
			<input type="radio" name="acct_code_g" value="5" <%if(cd_bean.getAcct_code_g().equals("5"))%>checked<%%>>LPG
			<%-- <input type="radio" name="acct_code_g" value="27" <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>���������� --%>	<!-- ���������� �߰� -->			
			<input type="radio" name="acct_code_g" value="27" <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>����/����	<!-- ����/���� �߰� 2021.01.28. -->			
		 </td>
        </tr>
		<tr>
					<td width="15%" class='title'>�뵵</td>
					<td width="85%">&nbsp;
						<input type="radio" name="acct_code_g2" value="12" <%if(cd_bean.getAcct_code_g2().equals("12"))%>checked<%%>>Ź��
					</td>
				</tr>
      </table></td>
    </tr>

    <tr id=tr_acct3_1 style='display:<%if(cd_bean.getAcct_code().equals("00004") || cd_bean.getAcct_code().equals("00006") || cd_bean.getAcct_code().equals("00018") || cd_bean.getAcct_code().equals("00019") || ( cd_bean.getAcct_code().equals("00005") && (!cd_bean.getAcct_code_g().equals("18") && !cd_bean.getAcct_code_g().equals("22") ) )  ){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>����</td>
          <td width="85%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=cd_bean.getItem_name()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')" readonly>
			<input type="hidden" name="rent_l_cd" value="<%=cd_bean.getRent_l_cd()%>">
			<input type="hidden" name="serv_id" value="<%=cd_bean.getServ_id()%>">
			<input type="hidden" name="item_code" value="<%=cd_bean.getItem_code()%>">
		   <!--<a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			&nbsp;(������ȣ/��ȣ�� �˻�)
			--></td>       
      </table></td>
    </tr>
    
    <tr id=tr_acct3_2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
            <td width="15%" class='title'>������</td>
		    <td width="25%">&nbsp;
		          	<input type='text' size='7' class='num'  value="<%=cd_bean.getOil_liter()%>" name='oil_liter' onBlur='javascript:set_oil_price();'>&nbsp;L	
            &nbsp;* �ʼ�
			</td>
			<td width="15%" class='title'>�����ܰ�</td>
			<td width="15%">&nbsp;<input type='text' size='7' class='num'  value="<%%>" name='oil_price' >&nbsp;��
			<td width="15%" class='title'>����Ÿ�</td>
		    <td width="15%">&nbsp;
		    	<input type='text' size='7' class='num'  value="<%=cd_bean.getTot_dist()%>" name='tot_dist' >&nbsp;km
		    </td>
			
		  
          </td>
        </tr>	
       </table></td>
    </tr>
    
        
    <tr id=tr_acct98 style='display:""'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>����</td>
          <td width="85%">&nbsp;
		    <textarea name="acct_cont" cols="90" rows="2" class="text"><%=cd_bean.getAcct_cont()%></textarea>
            </td>
        </tr>
      </table></td>
    </tr>
    
    <tr>
    	<td class=h></td>
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
          <td width="15%" class='title'>����</td>
          <td width="85%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=ht_item_name%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('<%=j%>')">
				<input type="hidden" name="rent_l_cd" value="<%=ht_rent_l_cd%>">
				<input type="hidden" name="serv_id" value="<%=ht_serv_id%>">
				<input type="hidden" name="item_code" value="<%=ht_item_code%>">
            <a href="javascript:Rent_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(������ȣ/��ȣ�� �˻�)</td>
        </tr>
     		
      </table></td>
    </tr>     
   
    <tr id=tr_acct3_<%=j%>_98 style='display:<%if( j < vt_i_size1 ){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="15%" class='title'>����</td>
			          			<td width="85%">&nbsp;
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
      <td colspan="2" class=h></td>
    </tr>	
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class="line">
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>��ǥ����</td>
          <td width="85%">&nbsp;
		    <textarea name="doc_acct_cont" cols="100" rows="2" class="text"><%=doc_acct_cont%></textarea>
            </td>
        </tr>
      </table></td>
    </tr>	
    <tR>
        <td class=h></td>
    </tr><tR>
        <td class=h></td>
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
