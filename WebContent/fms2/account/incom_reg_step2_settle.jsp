<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, acar.incom.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
		
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	int incom_cnt  =  0;
	int  trus_cnt = 0;
		
	String i_firm_nm 	= "^^^^";
	String i_client_nm 	= "";
	String i_sta 		= "";
	String i_item 		= "";
	String ven_code		= "";
	
	//�ŷ�ó����
	if (!client_id.equals("999999")) {
		ClientBean client = al_db.getClient(client_id);
	
		i_firm_nm 	= client.getFirm_nm();
		i_client_nm 	= client.getClient_nm();
		i_sta 		= client.getBus_cdt();
		i_item 		= client.getBus_itm();
		ven_code 		= client.getVen_code();
	
	}
	String ip_dt = "";
											
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
   //�Աݰŷ����� ����
	IncomBean base = a_db.getIncomBase(incom_dt, incom_seq);
	int ip_amt = base.getIncom_amt();
			
	String value[] = new String[2];
	StringTokenizer st = new StringTokenizer(base.getBank_nm(),":");
	int s=0; 
	while(st.hasMoreTokens()){
		value[s] = st.nextToken();
		s++;
	}
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "GEN_EMP");
	int user_size = users.size();
	
	
	//�ŷ�ó��
	String firm_nm="";
	firm_nm=c_db.getNameById(client_id, "CLIENT"); 
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	int settle_size = 0;
	long tot_est_amt = 0;
	Vector vt = new Vector();
	
	if(!client_id.equals("")){
		   		
		vt = a_db.getFeeList("", "", client_id, "client", "", "");
		settle_size = vt.size();
		
	}
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
			
	//�� ��ȸ
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}	
		window.open("/fms2/client/client_c.jsp?incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		if(fm.site_id.value == "")	{ alert("����/������ ���� �����Ͻʽÿ�."); return;}		
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//�뿩�ὺ���� ��ȸ
	function search_fee(client_id)
	{
		var fm = document.form1;
		
	//	window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=900,height=600,left=10,top=10');		
	//	fm.action = "/fms2/account/fee_list_in.jsp?client_id="+client_id;
	//	fm.target = "User_search";
	//	fm.submit();
		
	//	window.open("/fms2/account/fee_list_in.jsp?incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&client_id=<%=client_id%>&from_page=/fms2/account/incom_reg_step2.jsp", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
		//��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx=&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') ven_search('');
	}

	//��ü���� (�Աݾ� �ѵ����� �ش�Ǵ� �κ� ó��)
	function AllSelect(idx){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
	
		var ipAmt	=  toInt(parseDigit(fm.in_amt.value));
				
		var accAmt	= 0;
		var totAmt  = 0;
						
		//�ʱ�ȭ	
		for(var j=0; j < idx ; j++){
			fm.ip_amt[j].value ='0';
			fm.jan_amt[j].value = fm.exp_amt[j].value;
			
		}
		
		//����	
		for(var k=0; k < idx ; k++){
			totAmt +=  toInt(parseDigit(fm.exp_amt[k].value));
				  		
			if (fm.pay_chk[k].value == "Y" ) {	  		
				if(ipAmt > totAmt) 	{
						fm.ip_amt[k].value = parseDecimal(toInt(parseDigit(fm.exp_amt[k].value)));
						set_jan_amt(k); 
				} else {
					    fm.ip_amt[k].value = parseDecimal(ipAmt - accAmt);
					    set_jan_amt(k); 
				
				}
			}	
			accAmt	+=  toInt(parseDigit(fm.ip_amt[k].value)); //����
							
		}
		
		set_tot_amt(<%=settle_size%>);
		
		//���ݱݾ��� �ִ� �͸� ǥ��?
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
		
			if(ck.name == "pay_chk"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();					
				}
			}
		}
	}	
	
		//���÷���
	function cng_input(){
		var fm = document.form1;
		if(fm.not_yet.checked == true){ 		//��Ȯ���Ա�
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct5.style.display		= 'none';
		
		} else {
			tr_acct1.style.display		= '';
			tr_acct2.style.display		= '';
			tr_acct3.style.display		= '';
			tr_acct4.style.display		= '';
			tr_acct5.style.display		= '';
		
		}	
	}
	
	//���÷��� (�������� ����)
	function cng_input1(){
		var fm = document.form1;
		var len=fm.elements.length;
		
		var idx = <%=settle_size%>;
		
		if(fm.except_st1.checked ==true){ 	
			for(var k=0; k < idx ; k++){
				if (fm.gubun2[k].value == "���·�" ) {
					fm.pay_chk[k].value = 'N';
					fm.pay_chk[k].disabled = true;	  		
					fm.ip_amt[k].value = '0';
					fm.jan_amt[k].value = parseDecimal(toInt(parseDigit(fm.exp_amt[k].value)));
				}					
			}
					
		} else {
		   for(var j=0; j < idx ; j++){
				if (fm.gubun2[j].value == "���·�" ) {
					fm.pay_chk[j].value = 'Y';
					fm.pay_chk[j].disabled = false;	  		
					fm.ip_amt[j].value = '0';
					fm.jan_amt[j].value = parseDecimal(toInt(parseDigit(fm.exp_amt[j].value)));
				}					
			}
				
		}
	}
	
		//���÷��� (�������� ����) - ��å��
	function cng_input3(){
		var fm = document.form1;
		var len=fm.elements.length;
		
		var idx = <%=settle_size%>;
		
		if(fm.except_st2.checked ==true){ 	
			for(var k=0; k < idx ; k++){
				if (fm.gubun2[k].value == "��å��" ) {
					fm.pay_chk[k].value = 'N';
					fm.pay_chk[k].disabled = true;	  		
					fm.ip_amt[k].value = '0';
					fm.jan_amt[k].value = parseDecimal(toInt(parseDigit(fm.exp_amt[k].value)));
				}					
			}
					
		} else {
		   for(var j=0; j < idx ; j++){
				if (fm.gubun2[j].value == "��å��" ) {
					fm.pay_chk[j].value = 'Y';
					fm.pay_chk[j].disabled = false;	  		
					fm.ip_amt[j].value = '0';
					fm.jan_amt[j].value = parseDecimal(toInt(parseDigit(fm.exp_amt[j].value)));
				}					
			}
				
		}
	}
	
		//���÷��� (�������� ����) - ��ü����
	function cng_input4(){
		var fm = document.form1;
		var len=fm.elements.length;
		
		var idx = <%=settle_size%>;
		
		if(fm.except_st3.checked ==true){ 	
			for(var k=0; k < idx ; k++){
				if (fm.gubun2[k].value == "��ü����" ) {
					fm.pay_chk[k].value = 'N';
					fm.pay_chk[k].disabled = true;	  		
					fm.ip_amt[k].value = '0';
					fm.jan_amt[k].value = parseDecimal(toInt(parseDigit(fm.exp_amt[k].value)));
				}					
			}
					
		} else {
		   for(var j=0; j < idx ; j++){
				if (fm.gubun2[j].value == "��ü����" ) {
					fm.pay_chk[j].value = 'Y';
					fm.pay_chk[j].disabled = false;	  		
					fm.ip_amt[j].value = '0';
					fm.jan_amt[j].value = parseDecimal(toInt(parseDigit(fm.exp_amt[j].value)));
				}					
			}
				
		}
	}
	
	
	//���÷��� (���õȰ�� �Աݾ� ����)
	function cng_input2(){
	
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
	
		var ipAmt	=  toInt(parseDigit(fm.in_amt.value));
				
		var accAmt	= 0;
		var totAmt  = 0;
						
		var idx = <%=settle_size%>;
			
		if ( idx == 1 ) {
			if ( toInt(parseDigit(fm.exp_amt.value)) >= ipAmt ) {  
					fm.ip_amt.value    = parseDecimal(ipAmt);
			} else {					
					fm.ip_amt.value    = parseDecimal(toInt(parseDigit(fm.exp_amt.value)));	
			}		
			fm.jan_amt.value   = parseDecimal(toInt(parseDigit(fm.exp_amt.value)) - toInt(parseDigit(fm.ip_amt.value)));
			
		   	fm.t_ip_amt.value  = parseDecimal(toInt(parseDigit(fm.ip_amt.value)));
			fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.exp_amt.value)) - toInt(parseDigit(fm.ip_amt.value)));
		} else {	
						
			//����	
			for(var k=0; k < idx ; k++){
			
				if (fm.pay_chk[k].value == "Y" ) {	 
					totAmt +=  toInt(parseDigit(fm.exp_amt[k].value));
				}	
				  		
				if (fm.pay_chk[k].value == "Y" ) {	  		
					if(ipAmt > totAmt) 	{
				
							fm.ip_amt[k].value = parseDecimal(toInt(parseDigit(fm.exp_amt[k].value)));
							set_jan_amt(k); 
					} else {
						    fm.ip_amt[k].value = parseDecimal(ipAmt - accAmt);
						    set_jan_amt(k); 
					
					}
				}	
				accAmt	+=  toInt(parseDigit(fm.ip_amt[k].value)); //����
								
			}
						
			//����	
			for(var kk=0; kk < idx ; kk++){
				if ( toInt(parseDigit(fm.ip_amt[kk].value)) > 0 ) {	
			   		fm.pay_chk[kk].checked = true;
				}
			}
			
			set_tot_amt(<%=settle_size%>);
		}	
			
	}
			
	//����ϱ�
	function save(){
		var fm = document.form1;
		
		if(fm.not_yet.checked == false){ 		
			var len=fm.elements.length;
			var cnt=0;
			var idnum="";
			for(var i=0 ; i<len ; i++){
				var ck=fm.elements[i];		
				if(ck.name == "pay_chk"){		
					if(ck.checked == true){
						cnt++;
						idnum=ck.value;
					}
				}
			}	
			if(cnt == 0){
			 	alert("ó���� ���� �����ϼ���.");
				return;
			}	
		}
			
			//��������ó���� ������ üũ �� ó��
		if(fm.pay_gur[0].checked == false){
			if(fm.pay_gur_nm.value == '')	{ alert('��ȣ/������ �Է��Ͻʽÿ�.'); 	return;}
			if(fm.pay_gur_rel.value == '')	{ alert('����/������ �Է��Ͻʽÿ�.'); 	return;}
														
		}	
		
		if (fm.except_st1.checked == true  ) {
		    if(fm.pay_reason.value == '')		{ alert('������ Ȯ���Ͻʽÿ�.'); 	return;}
		    if(fm.pay_sac_id.value == '')		{ alert('�����ڸ� Ȯ���Ͻʽÿ�.'); 	return;}
		}
		
      	if(fm.not_yet.checked == false){ 	
			
        	//�Աݾװ� ����ó������ Ȯ��
       		var in_amt	=  toInt(parseDigit(fm.in_amt.value));
       		var ip_amt	=  toInt(parseDigit(fm.t_ip_amt.value));
      
        	if (in_amt != ip_amt ) {
           		alert('�Աݾװ� ����ó������ Ʋ���ϴ�.!!!.'); 	
        	}          
       	}	
       		
		if(confirm('2�ܰ踦 ����Ͻðڽ��ϱ�?')){	
			fm.action='incom_reg_step2_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	//�ݾ׼���
	function set_jan_amt(idx){
	
		var fm = document.form1;	
		var r_idx = <%=settle_size%>;
			
		if ( r_idx == 1 ) {
			fm.jan_amt.value   = parseDecimal(toInt(parseDigit(fm.exp_amt.value)) - toInt(parseDigit(fm.ip_amt.value)));
		   	fm.t_ip_amt.value  = parseDecimal(toInt(parseDigit(fm.ip_amt.value)));
			fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.exp_amt.value)) - toInt(parseDigit(fm.ip_amt.value)));
		} else {
	        fm.jan_amt[idx].value	 = parseDecimal(toInt(parseDigit(fm.exp_amt[idx].value)) - toInt(parseDigit(fm.ip_amt[idx].value)));
		}	
	}
	
	function set_tot_amt(idx){	
		var fm = document.form1;	
		
		var iTot	= 0;
		var jTot	= 0;
		
		var r_idx = <%=settle_size%>;
			
		if (r_idx > 1) {	
			//����	
			for(var k=0; k < idx ; k++){
				iTot +=  toInt(parseDigit(fm.ip_amt[k].value));
				jTot +=  toInt(parseDigit(fm.jan_amt[k].value));	  		
			}
			fm.t_ip_amt.value = parseDecimal(iTot);	
			fm.t_jan_amt.value = parseDecimal(jTot);		
	    }
	}		

//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name="from_page" 	value="/fms2/account/incom_reg_step1.jsp">
  <input type='hidden' name='bank_code2' 	value='<%=value[0]%>'>
  <input type='hidden' name='deposit_no2' 	value='<%=base.getBank_no()%>'>
  <input type='hidden' name='bank_name' 	value='<%=value[1]%>'>  
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_t_cnt" 		value="<%=settle_size%>">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						�Ա�ó������� [2�ܰ�]</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
    <tr>
        <td class=line2></tD>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr> 
                <td class=title width=13%>ó������</td>
                <td width=37%>&nbsp;
                  <select name="jung_type" disabled>
                    <option value='0' <%if(base.getJung_type().equals("0")) out.println("selected");%>>���</option>
    		       	<option value='1' <%if(base.getJung_type().equals("1")) out.println("selected");%>>����ó��</option>
    		        <option value='2' <%if(base.getJung_type().equals("2")) out.println("selected");%>>������ó��</option>
    		        <option value='3' <%if(base.getJung_type().equals("3")) out.println("selected");%>>����������</option>
    		        <option value='4' <%if(base.getJung_type().equals("4")) out.println("selected");%>>ī��ó��</option>
    		        <option value='5' <%if(base.getJung_type().equals("4")) out.println("selected");%>>ī������</option>
                  </select>
    			</td>	
                <td class=title width=10%>�Աݱ���</td>
                <td width=40%>&nbsp;
    			   <select name="ip_method" disabled>
    		       	<option value='1' <%if(base.getIp_method().equals("1")) out.println("selected");%>>����</option>
    		        <option value='2' <%if(base.getIp_method().equals("2")) out.println("selected");%>>CMS</option>
    		        <option value='3' <%if(base.getIp_method().equals("3")) out.println("selected");%>>ī��</option>
    		        <option value='4' <%if(base.getIp_method().equals("4")) out.println("selected");%>>����</option>
    		        <option value='5' <%if(base.getIp_method().equals("5")) out.println("selected");%>>������</option>
                  </select>
                </td>  							  
              </tr>		  
              <tr> 
                <td class=title width=13%>�Ա�����</td>
                <td width=37%>&nbsp;<%=base.getIncom_dt()%>
                </td>
                <td class=title width=10%>�Ա��Ѿ�</td>
                <td width=40%>&nbsp;
                	<input type='text' name="in_amt" value='<%=AddUtil.parseDecimal(base.getIncom_amt())%>' size="10" class='whitenum' >��
                </td>
              </tr>		
              <tr> 
                <td class=title width=13%>�Ա�����</td>
    <% if ( base.getIp_method().equals("1")) { %>                 
                <td width=37%>&nbsp;<%=value[1]%></td>		
    <% } else if ( base.getIp_method().equals("2")) { %>                 
                <td width=37%>&nbsp;<%=base.getCard_nm()%></td>	            
    <% } else  { %>                 
                <td width=37%>&nbsp;</td>	    
    <% } %>                    			  
                <td class=title width=13%>���¹�ȣ</td>
    <% if ( base.getIp_method().equals("1")) { %>            
         	    <td width=40%>&nbsp;<%=base.getBank_no()%></td>        
    <% } else if ( base.getIp_method().equals("2")) { %>            
         	    <td width=40%>&nbsp;<%=base.getCard_no()%></td>                
    <% } else  { %>            
         	    <td width=40%>&nbsp;</td>             
    <% } %>			
              </tr>		    
              <tr> 
                <td class=title width=13%>����</td>
                <td width=37%>&nbsp;<%=base.getRemark()%></td>
                <td class=title width=10%>�ŷ���</td>
                <td width=40%>&nbsp;<%=base.getBank_office()%></td>
              </tr>		  
    		  
            </table>
	    </td>
    </tr>


	<tr>
	    <td>&nbsp;</td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
             <tr> 
                <td class=title width=13%>��ȣ/����</td>
                <td>&nbsp;
    			  <input type='text' name='firm_nm' size='40' class='text' value="<%=firm_nm%>" readonly >
    			  <input type='hidden' name='client_id' value='<%=client_id%>'>
    			  <input type='hidden' name='client_nm' value=''>
    					
    			  <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align=absmiddle border="0"></a></span>
    			  <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif" align=absmiddle border="0"></a></span>
    			</td>					  
             </tr>	 
             <tr>  
                <td class=title width=13%>��Ȯ���Ա�</td>
                <td>&nbsp;
    			   <input type="checkbox" name="not_yet" value="1" onClick="javascript:cng_input()">��Ȯ���Ա�
    			</td>
    		  </tr>			  
            </table>
	    </td>
    </tr>
  	<tr id=tr_acct1 style="display:''">
        <td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	 	
    			<tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    			</tr>
    			<tr>
            	    <td class=line2></td>
            	</tr>	
    		    <tr>
    		        <td class=line> 
        		        <table border="0" cellspacing="1" cellpadding='0' width=100%>
        		          <tr> 
        		            <td class=title width=13%>��������</td>
        		            <td colspan="3">&nbsp;
        					  <input type="radio" name="pay_gur" value="1" checked>����
        					  <input type="radio" name="pay_gur" value="2">���뺸����
        					  <input type="radio" name="pay_gur" value="3">��������
        					  <input type="radio" name="pay_gur" value="4">ä���߽�
        					  <input type="radio" name="pay_gur" value="5">��Ÿ
        					</td>					  
        		          </tr>		  
        		          <tr> 
        		            <td class=title width=13%>��ȣ/����</td>
        		            <td width=37%>&nbsp;
        					  <input type='text' name='pay_gur_nm' size='40' class='text' value="">
        					</td>					  
        		            <td class=title width=13%>����/����</td>
        		            <td width=40%>&nbsp;
        					  <input type='text' name='pay_gur_rel' size='40' class='text' value="">
        					</td>
        		          </tr>		  
        		        </table>
    			    </td>
    		    </tr>
    		</table>
	   </td>  	
    </tr>	  	    
	
	<tr id=tr_acct2 style="display:''">
       <td>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%> 	 	    
    		    <tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ó��</span></td>
    			</tr>
    			<tr>
            	    <td class=line2></td>
            	</tr>
    			<tr>
    		        <td class=line> 
        		        <table border="0" cellspacing="1" cellpadding='0' width=100%>
        		       
        		            <tr> 
            		            <td class=title width=13%>������������</td>
            		            <td colspan="3">&nbsp;
            					
            					  <input type="checkbox" name="except_st1" value="1" onClick="javascript:cng_input1()">���·�
            					  <input type="checkbox" name="except_st2" value="1" onClick="javascript:cng_input3()">��å��
            					  <input type="checkbox" name="except_st3" value="1" onClick="javascript:cng_input4()">��ü����
            					<!--    <input type="checkbox" name="except_st2" value="1">��ü�� -->
            					</td>					  
        		            </tr>		  
        		
        			        <tr>
        				        <td class=title width=13%>����</td>
        				        <td width=37%>&nbsp;
        				     	<input type="text" name="pay_reason" size=50  class='text' >
        				        </td>
        				        <td class=title width=13%>������</td>
        				        <td width=40%>&nbsp;
        				     	<select name="pay_sac_id">
        						    <option value="">����</option>
        			                <%if(user_size > 0){
        								for(int i = 0 ; i < user_size ; i++){
        									Hashtable user = (Hashtable)users.elementAt(i); %>
        			                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
        			                <%	}
        							}		%>
        			              </select>
        				        </td>
        			        </tr>	  
		                </table>
			        </td>
		        </tr>
    	    </table>
	   </td>  	
    </tr>	 
    <tr>
        <td></td>
    </tr>	    
	<tr>
        <td style='height:1; background-color=dddddd;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>
				
	<tr id=tr_acct3 style="display:''">
       <td>
	        <table border="0" cellspacing="0" cellpadding="0" width=100%> 	
    	    	<tr>
    			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̵���ä�Ǹ���Ʈ</span></td>
    			</tr>
    			<tr>
            	    <td class=line2></td>
            	</tr>	
    			<tr>
    			  <td class=line>
    		        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
    		          <tr>
    		            <td width="6%" class=title>����</td>
    		            <td width="8%" class=title>����
    		            <input type="checkbox" name="ch_all" value="Y" onClick="javascript:cng_input2()">
    		            <!--<input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect('<%=settle_size%>');" <% if (settle_size < 2 ) {%> disabled <%}%> >--></td>	
    		            <td width="8%" class=title>����</td>
    		            <td width="14%" class=title>������ȣ/<br>����ȣ</td>
    		            <td width="24%" class=title>����</td>
    		            <td width="7%" class=title>û���ݾ�</td>
    		            <td width="7%" class=title>�Աݿ�����</td>
    		            <td width="7%" class=title>����ó��<br>�ݾ�</td>
    		            <td width="7%" class=title>����ó��<br>�ܾ�</td>
    		            <td width="11%" class=title>�ŷ�ó</td>
    		            <td width="8%" class=title>��������</td>
    		          </tr>
      
    <%
    		if(!client_id.equals("")){
    								
    			if(settle_size > 0){
    				for (int i = 0 ; i < settle_size ; i++){
    					Hashtable s_list = (Hashtable)vt.elementAt(i);
    					
    					tot_est_amt += AddUtil.parseLong(String.valueOf(s_list.get("EST_AMT")));
    					if (s_list.get("GUBUN2").equals("������")  ) {
    						trus_cnt +=1;
    				    }				
    %>				
    			  	<tr>
    				        <td align="center"><%=i+1%></td>
    			            <td align="center"><input type="checkbox" name="pay_chk" value="Y" ><input type="hidden" name="pay_value" value="<%=s_list.get("GUBUN2")%>^<%=s_list.get("RENT_MNG_ID")%>^<%=s_list.get("RENT_L_CD")%>^<%=s_list.get("RENT_S_CD")%>^<%=s_list.get("EST_DT")%>^<%=s_list.get("EST_AMT")%>^<%=s_list.get("EVAL")%>^<%=s_list.get("CAR_NO")%>^<%=s_list.get("VEN_CODE")%>^<%=s_list.get("VEN_NM")%>^<%=s_list.get("CLIENT_ID")%>^<%=s_list.get("R_SITE")%>^<%=s_list.get("ITEM_ID")%>^"></td>
    			            <td align="center"><input type='text' name='gubun2' value='<%=s_list.get("GUBUN2")%>' size='10' class='whitetext' readonly  ></td>
    			            <td align="center"><%=s_list.get("CAR_NO")%><br><%=s_list.get("RENT_L_CD")%></td>
    			            <td>&nbsp;<%=s_list.get("REMARK")%></td>
    			            <td align="right"><input type='text' name='exp_amt' value='<%=Util.parseDecimal(String.valueOf(s_list.get("EST_AMT")))%>' size='13' class='whitenum' readonly ></td> 
    			            <td align="center"><input type='text' name='exp_dt' value='<%=AddUtil.ChangeDate2(String.valueOf(s_list.get("EST_DT")))%>' size='11' class='whitenum' readonly ></td>
    			            <td align="right">&nbsp;<input type='text' name='ip_amt' value='' size='13' class='num' onBlur="javascript:this.value=parseDecimal(this.value);  set_jan_amt('<%=i%>'); set_tot_amt('<%=settle_size%>');">&nbsp;</td> 
    			            <td align="right"><input type='text' name='jan_amt' value='' size='13' class='whitenum' readonly ></td> 
    			            <td align="center"><input type='text' name='ven_code' value='<%=s_list.get("VEN_CODE")%>' size=7 class='whitetext' readonly  ><br><input type='text' name='ven_nm' value='<%=s_list.get("VEN_NM")%>' size='20' class='whitetext' readonly  ></td>
    			            <td align="center"><select name='eval_gr'>
    		                  <option value="">����</option>
    		                  <option value='10800' <%if(s_list.get("EVAL").equals("10800")){%> selected <%}%>>�ܻ�����</option>
                    		  <option value='25700' <%if(s_list.get("EVAL").equals("25700")){%> selected <%}%>>������</option>
                    		  <option value='31100' <%if(s_list.get("EVAL").equals("31100")){%> selected <%}%>>���뿩������</option>
                    		  <option value='93000' <%if(s_list.get("EVAL").equals("93000")){%> selected <%}%>>������</option>
    						  </select>
    						
    						</td>
    				    </tr>
    				
    		                                 
    <%		} %>
    		           <tr>
    				        <td align="center" colspan=5>�̵���ä���հ�</td>
    			            <td align="right"><%=Util.parseDecimal(tot_est_amt)%></td> 
    			            <td align="right"></td> 
    			            <td align="right"><input type='text' name='t_ip_amt' value='' size='15' class='whitenum' readonly  ></td> 
    			            <td align="right"><input type='text' name='t_jan_amt' value='' size='15' class='whitenum' readonly  ></td> 
    			            <td align="right"></td> 
    			            <td align="right"></td> 
    				    </tr>
    		
    		<%	}else{%>		  
    		           <tr> 
    		                <td align="center" colspan="11">�ڷᰡ �����ϴ�.</td>
    		           </tr>
    		<%	} 	
    		  } %>		 
    		         </table>
    		        </td>
    		    </tr>
    		   	<tr>
    	  			<td align="right"><span class="b"><a href="javascript:search_fee('<%=client_id%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">�̵���ä�Ǹ���Ʈ</a></span></td>
    			</tr>
		        <tr>
                    <td class=h></td>
                </tr>	    
            	<tr>
                    <td style='height:1; background-color=dddddd;'></td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
    	  	</table>
	   </td>  	
    </tr>	  
    

	<tr id=tr_acct4 style="display:''">
       <td>
	        <table border="0" cellspacing="0" cellpadding="0" width=100%> 	
    			<tr>
    			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���ǥ</span></td>
    			</tr>	
    			<tr>
            	    <td class=line2></td>
            	</tr>
    		    <tr>
    		      <td class=line> 
    		        <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		          <tr> 
    			            <td class=title width=13%>���࿩��</td>
    			            <td>&nbsp;
    						  <input type="checkbox" name="neom_yn" value="1">����
    						</td>					  
    		          </tr>	
    		   <!--       	  
    		      	  <tr> 
    			          <td width=13% class='title'>�ŷ�ó</td>
    			          <td>&nbsp; <%	Hashtable ven = neoe_db.getVendorCase(ven_code);%>
    					    <input type='text' name='ven_code' size='5' value='<%=ven_code%>' class='whitetext'>
    						<input type='text' name='ven_name' size='30' value='<%=ven.get("VEN_NAME")==null?"":ven.get("VEN_NAME")%>' class='text' onKeyDown='javascript:enter()' style='IME-MODE: active'>
    				        &nbsp;&nbsp;<a href="javascript:ven_search('')" onMouseOver="window.status=''; return true">�˻�</a> 
    				      
    			          </td>
    		          </tr>
    		          <tr> 
    			            <td class=title width=13%>ǥ������</td>
    			            <td>&nbsp;
    						  <input type='text' name='cont' size='100' class='text' value="">
    						</td>					  
    		          </tr>	
    		          -->	  
    		        </table>
    			  </td>
    		    </tr>	
    	    </table>
	    </td>  	
    </tr>	  
    
<!-- �������ΰ�츸 ǥ�� -->
   	<tr id=tr_acct5 style="display:<%if(trus_cnt < 1 ){%>none<%}else{%>''<%}%>">    
 
       <td>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%> 
    			<tr>
    			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ</span></td>
    			</tr>	
    			<tr>
            	    <td class=line2></td>
            	</tr>
    		    <tr>
    		      <td class=line> 
    		        <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		          <tr> 
    		            <td class=title width=13%>�����Ա�ǥ</td>
    		            <td>&nbsp;
    					  <input type="checkbox" name="trusbill_yn" value="1">����
    					</td>					  
    		          </tr>	
    	<!--	          	  
    		          <tr> 
    		            <td class=title width=13%>�ȳ�����</td>
    		            <td>&nbsp;
    					  <input type="checkbox" name="mail_yn" value="1">�߼�
    					</td>					  
    		          </tr>
    	-->	          		  
    		        </table>
    			  </td>
    		    </tr>	
		    </table>
	   </td>  	
    </tr>	       
		    
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if( user_id.equals("000063")){%>
    <tr>
		<td align="right">		
		  <a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>	
		</td>
	</tr>	
	<%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
