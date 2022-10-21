<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.cont.*,  acar.settle_acc.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");

	//�ŷ�ó
	ClientBean client = al_db.getClient(client_id);	
	
	//Cont List
	Vector vt = s_db.getContList2(client_id);
	
	int vt_size = vt.size();
	
	
	String p_zip = "";
	String p_addr = "";
	
	if(vt_size > 0) {
		for(int i = 0 ; i < vt_size ; i++) {
			Hashtable ht = (Hashtable)vt.elementAt(i);
			if(!String.valueOf(ht.get("P_ZIP")).equals("")){
				p_zip = String.valueOf(ht.get("P_ZIP"));
			}
			if(!String.valueOf(ht.get("P_ADDR")).equals("")){
				p_addr = String.valueOf(ht.get("P_ADDR"));
			}
			
		}
	}
	
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//�˾������� ����
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.gov_nm.value == '') { alert('���ű���� Ȯ���Ͻʽÿ�.'); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "../pop_search/s_client.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd="+fm.gov_nm.value;
		fm.target = "search_open";
		fm.submit();		
	}
	
	//�ߵ���������  ����
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}	
	
	
	function cng_input(val){
	
		var fm = document.form1;
	
				
		if(val == '�����'){ 		//����� �ּ�
			fm.gov_zip.value= "<%=client.getO_zip()%>";
			fm.gov_addr.value= "<%=client.getO_addr()%>";
		}else if(val == '����'){ 	//����	
			fm.gov_zip.value= "<%=client.getRepre_zip()%>";
			fm.gov_addr.value= "<%=client.getRepre_addr()%>";		
		}else if(val == '����'){ 	//
			
			fm.gov_zip.value = "<%=p_zip%>";
			fm.gov_addr.value = "<%=p_addr%>";
		}else if(val == '��Ÿ'){ 	//
			fm.gov_zip.value = "";
			fm.gov_addr.value = "";
		}
	}
		
	
	//���
	function doc_reg(){
		var fm = document.form1;		
		   
		if(fm.doc_id.value == '')		{ alert('������ȣ�� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.doc_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); 	return; }		
		if(fm.gov_id.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); 	return; }		
		if(fm.gov_nm.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); 	return; }
		if(fm.title.value == '')		{ alert('������ �����Ͻʽÿ�.'); 		return; }
		if(fm.gov_addr.value == '')		{ alert('�ּҸ� �Է��Ͻʽÿ�.'); 		return; }
		if(fm.end_dt.value == '')		{ alert('�����Ⱓ�� �Է��Ͻʽÿ�.'); 		return; }
		
		<%if(!client_id.equals("")){%>	
				
		if(fm.tax_yn.checked == true && (fm.stop_s_dt.value == '' || fm.stop_e_dt.value == '' || fm.stop_cau.value == '')){ alert('�����Ⱓ, ������ �Է��Ͻʽÿ�.'); return; }
		
		if(!list_confirm()){				return;	}
		
		if(fm.title.value == '������� �� �����ݳ� �뺸'){ 
			chk_confirm();
		}
		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}		
		fm.action = "settle_doc_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
		<%}%>
	}
	
	//�̼�ä�� ����
	function list_confirm(){
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name.indexOf("ch_l_cd") != -1){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("�̼�ä���� �����ϼ���.");
			return false;
		}else{
			return true;	
		}				
		
	}			
	
	//������� �� �����ݳ� �뺸�ΰ�� �뿩�� �ݾ� Ȯ�� !!!
	function chk_confirm(){
			
			var listLen = $('.checkbox-area').length;	      	
	    	var amt2 ="";	 
	    	var lamt2 ="";	  
	    	var result="";
	    		   	    
	    	for(var i=0; i< listLen; i++){
	    	    
		        if($("#ch_l_cd_"+i).is(":checked")){
		       		amt2 = $("#amt2_"+i).val();		
		        	lamt2 = $("#lamt2_"+i).val();			        	
		        //     alert(amt2);
		        //     alert(lamt2);
		        	if(amt2 != lamt2){
		        		result =  (i+1) + "��° ���꼭���� �̳��뿩��� ���̰� �߻��Ǿ����ϴ�. Ȯ�� �� �����ϼ���!!"		      
		           	}		        	
		        
		        }
	    	}
    	    	
	    	if(result){
	    		alert(result);	    
	    	}
					
	}			
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

		$(document).ready(function(){
				
	    $("input[type='checkbox']").change(function(){
	    	var listLen = $('.checkbox-area').length;
	    	var checkUse ="";	    	
	    	var use_yn ="";	    	
	    	var result="";
	    	
	    	var id = $(this).attr('id');
	    
	    	for(var i=0; i< listLen; i++){
	    	    
		        if($("#ch_l_cd_"+i).is(":checked")){
		        	use_yn = $("#use_yn_"+i).val();		
		        		        	
		        	if(!checkUse){
		        		checkUse = use_yn;
		        		
		        	}else{
		        		if(checkUse != use_yn){
		        			result = "���� ���¿� �������¸� ���ÿ� ��� �� �� �����ϴ�."
			        		   
		        		}
		        	}		        	
		        
		        }
	    	}
	    	
	    	if(checkUse == "����"){	    	    
	    	 	$('#title option:last').attr('disabled','disabled').hide();
	    	 	$('#title option:nth-child(2)').removeAttr('disabled').show();
	    	 	$('#title option:nth-child(3)').removeAttr('disabled').show();
	    		  
	    	}else{

	    		$('#title option:nth-child(2)').attr('disabled','disabled').hide();
	    		$('#title option:nth-child(3)').attr('disabled','disabled').hide();
	    		$('#title option:last').removeAttr('disabled').show();
	    		
	    	}
	    	
	    	if(result){
	    		alert(result);
	    		$('#'+id).attr("checked",false);
	    	}
	    	
	    });
	});
		
		
	function print_view(rent_mng_id, rent_l_cd )
	{
		var fm = document.form1;
		var m_id = rent_mng_id;
		var l_cd = rent_l_cd;
		var b_dt=  fm.doc_dt.value;
		var cls_chk;
	    var mode;
	    fm.scd_fee_cnt.value = '1';
	   	
	    
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=700, height=640, scrollbars=yes");
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='settle_doc_reg_sc_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='size' value=''>


  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="12%">������ȣ</td>
            <td>&nbsp; 
              <input type="text" name="doc_id" size="20" class="text" value="<%=FineDocDb.getSettleDocIdNext("ä���߽�")%>">
            </td>
          </tr>
          <tr> 
            <td class='title'>��������</td>
            <td>&nbsp; 
              <input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
            <td rowspan="2" class='title'>����</td>
            <td>&nbsp;
             <input type="text" name="gov_nm" value="<%=client.getFirm_nm()%>" size="50" class="text" style='IME-MODE: active'>
			  <input type='hidden' name="gov_id" value="<%=client_id%>">			 
			</td>
          </tr>
            <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('gov_zip').value = data.zonecode;
								document.getElementById('gov_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
				
          <tr>
            <td>&nbsp;
            	<select name="post_st" onchange="javascript:cng_input(this.options[this.selectedIndex].value);">                				
								<option value="�����" selected>�����</option>		
								<option value="����">����</option>								
								<option value="����">����</option>								
								<option value="��Ÿ">��Ÿ</option>		
				  </select>				
				<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>				
				&nbsp;<input type="text" name="gov_zip" id="gov_zip"  size="10" class="text" value="<%=client.getO_zip()%>">
            <input type="text" name="gov_addr"   id="gov_addr"  size="100" class="text" value="<%=client.getO_addr()%>">
              (�ּ�) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <a href="javascript:MM_openBrWindow('settle_doc_f_result.jsp?client_id=<%=client_id%>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=700,height=300,top=400,left=240')"><img src="/images/esti_detail.gif"  width="15" height="15" align="absmiddle" border="0" alt="�ݼ��ּҸ���Ʈ����"></a>
              
              
              �ݼ��ּ�</td>
          </tr>    
          <tr> 
            <td class='title'>����</td>
            <td>&nbsp;
              <input type="text" name="mng_dept" size="50" class="text" value="��ǥ�̻� <%=client.getClient_nm()%>"> 
              </td>
          </tr>
          <tr> 
            <td class='title'>����</td>
            <td>&nbsp;&nbsp;<select name='title' id="title">
								<option value=''>����</option>								
								<option value="������� �� �����ְ�">������� �� �����ְ�</option>		
						    	<option value="������� �� �����ݳ� �뺸">������� �� �����ݳ� �뺸</option>
								<option value="�����뺸 �� ��������� ���԰���">�����뺸 �� ��������� ���԰���</option>
               </select>
			   <input type="text" name="title_sub" size="40" class="text" value="">&nbsp;<font color='#CCCCCC'>(��Ÿ�϶�)</font>
			   </td>
          </tr>
          <tr> 
            <td class='title'>�����Ⱓ</td>
            <td>&nbsp;&nbsp;<input type="text" name="end_dt" size="11" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
  
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tR>
	
	<%if(!client_id.equals("")){%>
    <tr>
      <td>
      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <font color="red"><b>�̼�ä��</b></font>  
      </td>
    </tr>	
	<%	Vector settles = s_db.getSettleList3_fine("", "", "", "", "", "", "1", client.getFirm_nm());
		int settle_size = settles.size();
		int base1_amt = 0;
	%>
	<script language='javascript'>
	<!--	
		document.form1.size.value = <%=settle_size%>;
	//-->
	</script>
	<tr>
        <td class=line2></td>
    </tR>
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="4%" >����</td>
            <td class='title' width="4%">����</td>
            <td class='title' width="12%">����ȣ</td>
            <td class='title' width="8%">������ȣ</td>
            <td class='title' width="8%">������</td>
            <td class='title' width="8%">������</td>
            <td class='title' width="8%">�뿩��</td>			
            <td class='title' width="8%">���·�</td>						
            <td class='title' width="8%">��å��</td>									
            <td class='title' width="8%">�ߵ����������</td>												
            <td class='title' width="12%">�հ�</td>
          </tr>
		  <%	for (int i = 0 ; i < settle_size ; i++){
					Hashtable settle = (Hashtable)settles.elementAt(i);
																						
					//���⺻����
				    ContBaseBean base = a_db.getCont( String.valueOf(settle.get("RENT_MNG_ID")), String.valueOf(settle.get("RENT_L_CD")) );
				
					int ifee_mon = 0;
					int ifee_day = 0;
					
					int r_mon = 0;
					int r_day = 0;
									
					int s_mon = 0;
					int s_day = 0;
								
					int nfee_mon = 0;
					int nfee_day = 0;
					float nfee_amt = 0;
					int n_nfee_amt = 0;
				
					int	 nfee_s_amt = 0;
					int fee_s_amt   = 0;
					int ifee_s_amt   = 0;
					
					float ifee_tm = 0;
					int i_ifee_tm = 0;
					
					int pay_tm = 0;
					float ifee_ex_amt = 0;
					int	rifee_s_amt = 0;
					int	nfee_ex_amt = 0;
					
					float f_amt2	 = 0;
					int	  lamt_2	 = 0; 
										
					if(!base.getUse_yn().equals("N")){            
					 //�����ݳ��뺸�� ���Ǵ� �̳��뿩�� 				
					//�⺻����  - ��������� ���� �۾�
						Hashtable base1 = as_db.getSettleBase(String.valueOf(settle.get("RENT_MNG_ID")), String.valueOf(settle.get("RENT_L_CD")), "", "");
																	
						fee_s_amt = AddUtil.parseInt((String)base1.get("FEE_S_AMT")); //���뿩��
						
						r_mon = AddUtil.parseInt((String)base1.get("R_MON")); //����
						r_day = AddUtil.parseInt((String)base1.get("R_DAY")); //�����
										
						nfee_mon = AddUtil.parseInt((String)base1.get("S_MON")); //�̳���
						nfee_day = AddUtil.parseInt((String)base1.get("S_DAY")); //�̳���
						
						if ( ifee_s_amt > 0 ) { //���ô뿩��
							ifee_tm =  ifee_s_amt / fee_s_amt; //  ������ / ���뿩��
							i_ifee_tm = (int) ifee_tm; 
							pay_tm =  AddUtil.parseInt((String)base1.get("CON_MON"))- i_ifee_tm;
							
							if ( r_mon > pay_tm || (r_mon == pay_tm && r_day > 0) ){
								ifee_mon 	= r_mon - pay_tm;
								ifee_day 	= r_day ;
							}		
							//				(���뿩�� * ���� ������ ) + (���뿩�� / 30 * �Ϻ� ������)
							ifee_ex_amt	= (fee_s_amt*ifee_mon) + ( fee_s_amt/30 *ifee_day );
							nfee_ex_amt = (int)  ifee_ex_amt;
							rifee_s_amt	=  ifee_s_amt - nfee_ex_amt;						
						}
						
						//�������� �ִٴ� ���� 
						if(ifee_s_amt == 0 ) {
							  if  (  AddUtil.parseInt((String)base1.get("DI_AMT")) > 0  ) {	
										 if ( AddUtil.parseInt((String)base1.get("S_MON"))  - 1  >= 0 ) {
											 nfee_mon 	= 	AddUtil.parseInt((String)base1.get("S_MON")) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����      
										 } 		
						   	    	 	
										 if ( AddUtil.parseInt((String)base1.get("S_DAY")) > 1 &&  AddUtil.parseInt((String)base1.get("S_MON"))  < 1 ) {
									   		  	if ( AddUtil.parseInt((String)base1.get("HS_MON")) < 1  &&  AddUtil.parseInt((String)base1.get("HS_DAY")) > 1 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
									   		  		nfee_day  = AddUtil.parseInt((String)base1.get("HS_DAY")); 
												 }
									   	 }
										 
						   	    	      //������ �ִٸ� 
						   	    	     /* 
						   	    	     if (  AddUtil.parseInt((String)base.get("EX_S_AMT")) > 0 ){
						   	    	     	nfee_day = 0;
						   	    	     } else {	
						   	    	     	 if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt(cls_dt) ) { //��������	  	    	      
							   	    	  	
							   	    	  		 if  ( AddUtil.parseInt((String)base.get("NFEE_S_AMT"))  == 0 ) {
							   	    	  	 		nfee_day 	= 	r_day;
							   	    	  	 	 }	
							   	    	  	 }  	
							   	    	 }  */
						  	  }  
						
						}   					
					
						//�̳��뿩��												 
					    nfee_amt =  fee_s_amt * ( nfee_mon + (AddUtil.parseFloat(Integer.toString(nfee_day))/30) );
								
						// ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )
					  	if ( ifee_s_amt > 0 ) { //���ô뿩��
					 	   				
					   		if ( rifee_s_amt < 0) {  //���ô뿩�Ḧ �� ������ ���
					   	   								
						   	    if ( AddUtil.parseInt((String)base1.get("RENT_END_DT")) <   AddUtil.parseInt((String)base1.get("USE_S_DT")) ) { //�������� �뿩�� �������� ������ ��� 
						   	       if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���  
						   	      //     alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
						   	       	   nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		
						   	        }else {
						   	      //     alert(" ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
						   	       	  nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 		
						   	       }
						   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
						   	       if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���
						   	     //  alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
						   	           nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
						   	      }else {
						   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
						   	       	   nfee_amt	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - rifee_s_amt ; 
						   	      	
						   	       }
						   	   }
						    } else {  //���ô뿩�ᰡ �����ִ� ���
						         if ( AddUtil.parseInt((String)base1.get("RENT_END_DT")) <   AddUtil.parseInt((String)base1.get("USE_S_DT")) ) { //�������� �뿩�� �������� ������ ��� 
						   	        if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���  
						   	       	//   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
						   	       	   nfee_amt			= fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// �ѹ̳��ῡ�� - ���ô뿩�� ����
						   	       }else {
						   	        //   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
						   	       	    nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 	
						   	       }
						   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
						   	       if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���
						   	       //    alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
						   	           nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
						   	      }else {
						   	        //   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����̾��� ���");
						   	       	   nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) ;
						   	
						   	       }
						   	   }
						    } 
						      
					   	} 
					   	 	
						f_amt2	=	AddUtil.parseInt((String)base1.get("DI_AMT"))  + nfee_amt;  //�뿩��		    	
			   		//	f_amt2	=	AddUtil.parseInt((String)base.get("DI_AMT")) - AddUtil.parseInt((String)base.get("EX_S_AMT")) + nfee_amt;  //�뿩��
			   		//	f_amt2	=	FineDocListBn.getAmt2();  //�뿩��
			   				   			
				 		lamt_2 = ( int ) f_amt2; 		
					
					}	
			%>
			
			<input type='hidden' name='scd_fee_cnt'  value='' >

          <tr class="checkbox-area"> 
		    <input type='hidden' name='c_id_<%=i%>' value='<%=settle.get("CAR_MNG_ID")%>'>
		    <input type='hidden' name='m_id_<%=i%>' value='<%=settle.get("RENT_MNG_ID")%>'>		
		    <input type='hidden' id="lamt2_<%=i%>" name='lamt2_<%=i%>' value='<%=lamt_2%>'>			   
            <td align='center' width="4%" ><input type="checkbox" name="ch_l_cd_<%=i%>"  id="ch_l_cd_<%=i%>" value="Y" ></td>
            <td align='center' width="4%" ><input type="text" name="use_yn_<%=i%>"  size="2" id="use_yn_<%=i%>" class="whitetext" value="<%if(settle.get("USE_YN").equals("Y")){%>����<%}else{%>����<%}%>" ></td>
            <td align='center' width="14%"><input type="text" name="l_cd_<%=i%>" size="15" class="whitetext" value="<%=settle.get("RENT_L_CD")%>">&nbsp;&nbsp;
           <%	if(!base.getUse_yn().equals("N")){%>            
             <a href="javascript:view_settle('<%=String.valueOf(settle.get("RENT_MNG_ID"))%>','<%=String.valueOf(settle.get("RENT_L_CD"))%>');"  title='�����ϱ�'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>
            <% } %>            
            </td>
            <td align='center' width="8%"><input type="text" name="car_no_<%=i%>" size="11" class="whitetext" value="<%=settle.get("CAR_NO")%>"></td>	    
            <td align='center' width="8%"><input type="text" name="end_dt_<%=i%>" size="12"  id="end_dt_<%=i%>" class="whitetext" value="<%=base.getRent_end_dt()%>"></td>
            <td align='center' width="8%"><input type="text" name="amt1_<%=i%>" size="10" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT1")))%>"></td>
            <td align='center' width="8%"><input type="text" id="amt2_<%=i%>" name="amt2_<%=i%>" size="10" class="num" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT2")))%>">
            	<br><a href="javascript:print_view('<%=String.valueOf(settle.get("RENT_MNG_ID"))%>','<%=String.valueOf(settle.get("RENT_L_CD"))%>');" title='�⺻' onMouseOver="window.status=''; return true">[������]</a>
            </td>			
            <td align='center' width="8%"><input type="text" name="amt3_<%=i%>" size="8" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT3")))%>"></td>						
            <td align='center' width="8%"><input type="text" name="amt4_<%=i%>" size="8" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT4")))%>"></td>									
            <td align='center' width="8%"><input type="text" name="amt5_<%=i%>" size="10" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT6")))%>"></td>												
            <td align='center' width="12%"><input type="text" name="amt6_<%=i%>" size="11" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT0")))%>"></td>
          </tr>
         
          
		  <%	}%>
        </table>
	  </td>
    </tr>	
    <tr>
        <td></td>
    </tR>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭 ���� �Ͻ����� ���</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tR>
    <tr>
	    <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width="12%" class='title'>��꼭����</td>
            <td>&nbsp;
              <input type="checkbox" name="tax_yn" value="Y" >
              ����
            </td>
          </tr>
          <tr>
            <td class='title'>����</td>
            <td>&nbsp;
              <input type="radio" name="stop_st" value="1" checked>
              ��ü
            </td>
          </tr>
          <tr>
            <td class='title'>�����Ⱓ</td>
            <td><table width="300"  border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="135">&nbsp;
				<input type='text' name='stop_s_dt' value='' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  ����</td>
                <td width="115"><input type='text' name='stop_e_dt' value='' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  ����</td>
                <td></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td class='title'>����</td>
            <td>&nbsp;
              <textarea name="stop_cau" cols="75" rows="3" class="text"></textarea>
            </td>
          </tr>
        </table>
      </td>
    </tr>	
    <tr>
        <td></td>
    </tR>
  
    <tr>    
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ȳ����� <input type="hidden" name="mail_yn" value="Y" ></span></td>
	<tr>
		
	<tr>
        <td class=line2></td>
    </tR>
    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td width="12%" class=title>�����ּ�</td>
            <td>&nbsp;
			  <input type='text' name='email' size='40' value='<%=client.getCon_agnt_email()%>' class='text' style='IME-MODE: inactive'>
			</td>
          </tr>		  	  		  
       	  	  		  
        </table>
      </td>
    </tr>
    
     <tr>
        <td></td>
    </tR>
    <tr>
	  <td align='left'>&nbsp;<font color="#FF0000">***</font> �ȳ������� �����Ͻ� �ڵ� �߼۵˴ϴ�. </td>
	</tr>	
  
<%}%>	

    <tr>
      <td align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	  <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	  <%}%>
	  </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
