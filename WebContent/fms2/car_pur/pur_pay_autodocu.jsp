<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = d_db.getCarPurPayDocAutoDocuList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();			
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
	
	
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
	
	//�׿��� �ڵ� ���
	function update_vendor(st, nm){
		window.open("/acar/car_office/car_office_i.jsp?auth_rw=6&user_id=<%=user_id%>&br_id=<%=br_id%>&st="+st+"&car_off_id="+nm, "CAR_F_AMT", "left=10, top=10, width=920, height=350, scrollbars=yes, status=yes, resizable=yes");		
	}
	//�ڵ�������� 
	function update_car_f_amt(rent_mng_id, rent_l_cd){
		window.open("/acar/car_register/register_pur_id.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd, "CAR_F_AMT", "left=10, top=10, width=820, height=1000, scrollbars=yes, status=yes, resizable=yes");
	}
	
		
	//����ϱ�
	function save(){
		fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					var idx = parseInt(idnum.substr(21),10);
					<%if(vt_size == 1){%>
					if(fm.dlv_dt.value == '')				{ alert('��� ������ڰ� �����ϴ�.'); 					return; }
					if(fm.car_amt_dt.value == '')				{ alert('��� �������ڰ� �����ϴ�.'); 					return; }
					if(fm.car_tax_dt.value == '')				{ alert('��� �������Լ��ݰ�꼭 �ۼ����ڰ� �����ϴ�.');		return; }
					if(fm.pur_pay_dt.value == '')				{ alert('��� �������ڰ� �����ϴ�.'); 					return; }
					if(fm.dlv_ext_ven_code.value == '')			{ alert('��� ���ݰ�꼭 �ŷ�ó�ڵ尡 �����ϴ�.'); 			return; }
					if(fm.car_off_ven_code.value == '')			{ alert('��� ����ó(������) �ŷ�ó�ڵ尡 �����ϴ�.'); 			return; }
					if(fm.init_reg_dt.value == '')				{ alert('�ڵ�����ϵ��� �ʾҽ��ϴ�.'); 					return; }
					<%}else{%>					
					if(fm.dlv_dt[idx].value == '')				{ alert((idx+1)+'�� ��� ������ڰ� �����ϴ�.'); 			return; }
					if(fm.car_amt_dt[idx].value == '')			{ alert((idx+1)+'�� ��� �������ڰ� �����ϴ�.'); 			return; }
					if(fm.car_tax_dt[idx].value == '')			{ alert((idx+1)+'�� ��� �������Լ��ݰ�꼭 �ۼ����ڰ� �����ϴ�.');	return; }
					if(fm.pur_pay_dt[idx].value == '')			{ alert((idx+1)+'�� ��� �������ڰ� �����ϴ�.'); 			return; }
					if(fm.dlv_ext_ven_code[idx].value == '')		{ alert((idx+1)+'�� ��� ���ݰ�꼭 �ŷ�ó�ڵ尡 �����ϴ�.'); 		return; }
					if(fm.car_off_ven_code[idx].value == '')		{ alert((idx+1)+'�� ��� ����ó(������) �ŷ�ó�ڵ尡 �����ϴ�.'); 	return; }
					if(fm.init_reg_dt[idx].value == '')			{ alert((idx+1)+'�� �ڵ�����ϵ��� �ʾҽ��ϴ�.'); 			return; }
					<%}%>
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("�ϰ� ó���� ���� �����ϼ���.");
			return;
		}	
				
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
		fm.action = 'pur_pay_autodocu_a.jsp';
		fm.submit();
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/common.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body">
<form name='form1' method='post' action='pur_pay_sc_in.jsp'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_pay_frame.jsp'>
  <input type='hidden' name='doc_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='2620'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='30' rowspan='2' class='title'>����</td>
				  <td width='30' rowspan='2' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				  					
		          <td width='100' rowspan='2' class='title'>����ȣ</td>
		          <td width='100' rowspan='2' class='title'>������ȣ</td>
		          <td width='100' rowspan='2' class='title'>�����ȣ</td>				  
		          <td width="200" rowspan='2' class='title'>��</td>
       		      <td width='100' rowspan='2' class='title'>����<br>(���ʵ����)</td>		
       		      <td width='80' rowspan='2' class='title'>�������</td>
       		      <td width='80' rowspan='2' class='title'>��������</td>				  
       		      <td colspan="3" class='title'>���ݰ�꼭</td>				  				  
       		      <td width='80' rowspan='2' class='title'>���ʵ����</td>
       		      <td colspan="2" class='title'>����ó</td>
       		      <td width='80' rowspan='2' class='title'>��������</td>
       		      <td width='100' rowspan='2' class='title'>�հ�</td>					
       		      <td width='80' rowspan='2' class='title'>����</td>									  
				  <td colspan="3" class='title'>����ó����������1</td>				  
				  <td colspan="3" class='title'>����ó����������2</td>
				  <td colspan="3" class='title'>����ó����������3</td>
				  <td colspan="3" class='title'>����ó����������4</td>
			    </tr>
				<tr>
				  <td width='40' class='title'>��ĵ</td>				  
				  <td width='80' class='title'>�ۼ�����</td>				  
				  <td width='160' class='title'>�ŷ�ó�ڵ�</td>
				  <td width='100' class='title'>�̸�</td>
				  <td width='80' class='title'>�ŷ�ó�ڵ�</td>
				  <td width='90' class='title'>����</td>				  
				  <td width='80' class='title'>�ŷ�ó�ڵ�</td>
				  <td width='80' class='title'>�ݾ�</td>
				  <td width='90' class='title'>����</td>				  
				  <td width='80' class='title'>�ŷ�ó�ڵ�</td>
				  <td width='80' class='title'>�ݾ�</td>
				  <td width='90' class='title'>����</td>				  
				  <td width='80' class='title'>�ŷ�ó�ڵ�</td>
				  <td width='80' class='title'>�ݾ�</td>
				  <td width='90' class='title'>����</td>				  
				  <td width='80' class='title'>�ŷ�ó�ڵ�</td>
				  <td width='80' class='title'>�ݾ�</td>
			  </tr>
<%	if(vt_size > 0)	{%>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			
			
		int size = 0;

		String content_code = "LC_SCAN";
		String content_seq  = (String)ht.get("RENT_MNG_ID")+(String)ht.get("RENT_L_CD")+"1";

		Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
		int attach_vt_size = attach_vt.size();

		String file_type1 = "";
		String seq1 = "";
		String file_name1 = "";
		
	
		for(int j=0; j< attach_vt.size(); j++){
			Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
			
			if((content_seq+"10").equals(aht.get("CONTENT_SEQ"))){
				file_name1 = String.valueOf(aht.get("FILE_NAME"));
				file_type1 = String.valueOf(aht.get("FILE_TYPE"));
				seq1 = String.valueOf(aht.get("SEQ"));
			}
		}
			
			
			%>			
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_MNG_ID")%>/<%=ht.get("RENT_L_CD")%>/<%=i%>"></td>
					<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>					
					<td  width='100' align='center'><%=ht.get("CAR_NO")%></td>					
					<td  width='100' align='center'>[<%=ht.get("CAR_COMP_ID")%>] <%=ht.get("RPT_NO")%></td>
					<td  width='200'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 20)%></span></td>
					<td  width='100' align='center'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span>
					  <br><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>
					  <input type='hidden' name='init_reg_dt' value='<%=ht.get("INIT_REG_DT")%>'>
					</td>
					<td  width='80' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_car_f_amt('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%><%if(String.valueOf(ht.get("DLV_DT")).equals("")){%>�̵��<%}%></a><%}%><input type='hidden' name="dlv_dt" value="<%=ht.get("DLV_DT")%>"></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_AMT_DT")))%><input type='hidden' name="car_amt_dt" value="<%=ht.get("CAR_AMT_DT")%>"></td>					
					<td  width='40' align='center'>
	
						<%if(!seq1.equals("")){%>
						<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='����' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0>
						<%}else{%>
						-
						<%}%>							
					</td>	
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_TAX_DT")))%><input type='hidden' name="car_tax_dt" value="<%=ht.get("CAR_TAX_DT")%>"></td>									
					<td  width='160' align='center'>
					
					  <%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0018");
      						int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==����==</option>

                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%>)</option>        						
        				<%	}%>	

			          </select>
			                 
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0002")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0019");
    						int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==����==</option>
                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%><%//= code.getNm()%><%//=code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT")))%>)</option>        						
        				<%	}%>	
			          </select>
				          						
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0003")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0021");
  							int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==����==</option>
                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%><%//= code.getNm()%><%//=code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT")))%>)</option>        						
        				<%	}%>
			          </select>
			                 
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0004")||String.valueOf(ht.get("CAR_COMP_ID")).equals("0005")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0020");
							int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==����==</option>
                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%><%//= code.getNm()%><%//=code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT")))%>)</option>        						
        				<%	}%>
						<option value="608949" >���Ѹ��ͽ�(�λ�)(608949)</option>
						<option value="006005" >���ָ��ͽ�(006005)</option>
						<option value="112700" >GM����(112700)</option>
						<option value="006132" >������������(006132)</option>
						<option value="006052" >��ȭ���ͽ�(006052)</option>						
			          </select>
			          
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0006")){%>
					  [����]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>				        
				        <option value="">==����==</option>
				        <!-- <option value="995591" >���� (��)õ���ڵ���(995591)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0011")){%>
					  [�����ٰ�]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="006282" >�����ٰ� ���̽��͸��ͽ�(006282)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0012")){%>
					  [ũ���̽���]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="000911" >ũ���̽���(000911)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0018")){%>
					  [�ƿ��]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="006306" >�ƿ�� �д�(006306)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0025")){%>
					  [ȥ��]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="104115" >ȥ��(104115)</option>
				        <option value="006385" >ȥ�� ��ȣ���ͽ� ����(006385)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0014")){%>
					  [ĳ����/���]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="104119" >ĳ����/���(104119)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0007")){%>
					  [����Ÿ]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="005970" >���Ƽ����Ÿ(005970)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0013")){%>
					  [BMW]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="006281" >BMW �ڿ��հ���(006281)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0021") || String.valueOf(ht.get("CAR_COMP_ID")).equals("0051")){%>
					  [����]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="006386" >���� �����̾���ͽ�(006386)</option>
				        <option value="028602" >���� �����ڵ���(��)(028602)</option>
				        <option value="995726" >���� �����ڵ���(��)(995726)</option>
				        <option value="996228" >(��)����ũ���ͽ�(996228)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0027")){%>
					  [����]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="006326" >���� ��Ŭ�������(006326)</option>
				        <option value="996235" >���� �Ѽ��ڵ���(996235)</option>		 -->		        
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0033")){%>
					  [�ֻ�]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="006359" >�ֻ� �����̾������(��)(006359)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0034")){%>
					  [Ǫ��]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="995512" >Ǫ�� �Ｑ�۷ι����ͽ�(995512)</option>
				        <option value="996117" >Ǫ�� (��)�ѺҸ��ͽ�(996117)</option>			 -->	         
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0044")){%>
					  [������]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="995514" >������ ����Ƽ������(��)(995514)</option>
				        <option value="108684" >������ ��Ʈ�����ͽ�(108684)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0047")){%>
					  [����]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="995523" >(��)�������ͽ�(995523)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0048")){%>
					  [���Ǵ�Ƽ]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="995566" >���Ǵ�Ƽ �����̾����(��)(995566)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0049")){%>
					  [����ι�]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="996007" >���̾���������(��)(996007)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0050")){%>
					  [�̴�]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==����==</option>
				        <!-- <option value="995501" >�ڿ��ձ۷ι�(��)����MINI����(995501)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="996433" >�׽����ڸ���(996433)</option>
			          </select>			          
					  <%}else{%>
					  <select name="dlv_ext_cd">
				        <option value="" >����</option>
			          </select>
					  <%}%>	


					  <br><input type='text' name='dlv_ext_ven_code' value='<%=ht.get("DLV_EXT_VEN_CODE")%>' class='default' size='10'>			  
					</td>										
					<td  width='80' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("INIT_REG_DT")))%></td>					
				    <td>&nbsp;<%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('car_off', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 6)%></span></a><%}%></td>	
					<td align='center'>
					  <input type='text' name='car_off_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%><input type='hidden' name="pur_pay_dt" value="<%=ht.get("PUR_PAY_DT")%>"></td>					
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>					
					<!--�����-->
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%></td>
					<!--����1-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST1")%>', '<%=ht.get("CARD_KIND1")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND1")%></a><%}%></td>
					<td  width='80' align='center'><input type='hidden' name="card_com_ven_code" value="<%=ht.get("COM_CODE")%>">
					  <%if(String.valueOf(ht.get("TRF_ST1")).equals("����ī��")||String.valueOf(ht.get("TRF_ST1")).equals("�ĺ�ī��")||String.valueOf(ht.get("TRF_ST1")).equals("ī���Һ�")){%>
					  <input type='text' name='trf1_ven_code' value='<%=ht.get("COM_CODE1")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����")){%>
					  <input type='text' name='trf1_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����") && String.valueOf(ht.get("CARD_KIND1")).equals("�����ٰ����̳���")){//�ƿ�������ٰ����̳���%>
					  <input type='text' name='trf1_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����") && String.valueOf(ht.get("CARD_KIND1")).equals("���Ÿ���̳���")){//���Ÿ���̳���%>
					  <input type='text' name='trf1_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����") && String.valueOf(ht.get("CARD_KIND1")).equals("�������̳���")){//�������̳���%>
					  <input type='text' name='trf1_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����") && String.valueOf(ht.get("CARD_KIND1")).equals("������ĳ��Ż�ڸ���")){//������ĳ��Ż�ڸ���%>
					  <input type='text' name='trf1_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����") && String.valueOf(ht.get("CARD_KIND1")).equals("����ĳ��Ż")){//����ĳ��Ż%>
					  <input type='text' name='trf1_ven_code' value='006244' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����Ʈ") && !String.valueOf(ht.get("COM_CODE1")).equals("")){%>
					  <input type='text' name='trf1_ven_code' value='<%=ht.get("COM_CODE1")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE1")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){//�׽���%>
					  <input type='text' name='trf1_ven_code' value='' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE1")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf1_ven_code' value='995581' class='default' size='10'>
					  <%}else{%>
					  <input type='text' name='trf1_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT1")))%></td>
					<!--����2-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST2")%>', '<%=ht.get("CARD_KIND2")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND2")%></a><%}%></td>
					<td  width='80' align='center'>
					  <%if(String.valueOf(ht.get("TRF_ST2")).equals("����ī��")||String.valueOf(ht.get("TRF_ST2")).equals("�ĺ�ī��")||String.valueOf(ht.get("TRF_ST2")).equals("ī���Һ�")){%>
					  <input type='text' name='trf2_ven_code' value='<%=ht.get("COM_CODE2")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����")){%>
					  <input type='text' name='trf2_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����") && String.valueOf(ht.get("CARD_KIND2")).equals("�����ٰ����̳���")){//�ƿ�������ٰ����̳���%>
					  <input type='text' name='trf2_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����") && String.valueOf(ht.get("CARD_KIND2")).equals("���Ÿ���̳���")){//���Ÿ���̳���%>
					  <input type='text' name='trf2_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����") && String.valueOf(ht.get("CARD_KIND2")).equals("�������̳���")){//�������̳���%>
					  <input type='text' name='trf2_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����") && String.valueOf(ht.get("CARD_KIND2")).equals("������ĳ��Ż�ڸ���")){//������ĳ��Ż�ڸ���%>
					  <input type='text' name='trf2_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����") && String.valueOf(ht.get("CARD_KIND2")).equals("����ĳ��Ż")){//����ĳ��Ż%>
					  <input type='text' name='trf2_ven_code' value='006244' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����Ʈ") && !String.valueOf(ht.get("COM_CODE2")).equals("")){%>
					  <input type='text' name='trf2_ven_code' value='<%=ht.get("COM_CODE2")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE2")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf2_ven_code' value='' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE2")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf2_ven_code' value='995581' class='default' size='10'>
					  <%}else{%>
					  <input type='text' name='trf2_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT2")))%></td>
					<!--����3-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST3")%>', '<%=ht.get("CARD_KIND3")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND3")%></a><%}%></td>
					<td  width='80' align='center'>
					  <%if(String.valueOf(ht.get("TRF_ST3")).equals("����ī��")||String.valueOf(ht.get("TRF_ST3")).equals("�ĺ�ī��")||String.valueOf(ht.get("TRF_ST3")).equals("ī���Һ�")){%>
					  <input type='text' name='trf3_ven_code' value='<%=ht.get("COM_CODE3")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����")){%>
					  <input type='text' name='trf3_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����") && String.valueOf(ht.get("CARD_KIND3")).equals("�����ٰ����̳���")){//�ƿ�������ٰ����̳���%>
					  <input type='text' name='trf3_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����") && String.valueOf(ht.get("CARD_KIND3")).equals("���Ÿ���̳���")){//���Ÿ���̳���%>
					  <input type='text' name='trf3_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����") && String.valueOf(ht.get("CARD_KIND3")).equals("�������̳���")){//�������̳���%>
					  <input type='text' name='trf3_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����") && String.valueOf(ht.get("CARD_KIND3")).equals("������ĳ��Ż�ڸ���")){//������ĳ��Ż�ڸ���%>
					  <input type='text' name='trf3_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����") && String.valueOf(ht.get("CARD_KIND3")).equals("����ĳ��Ż")){//����ĳ��Ż%>
					  <input type='text' name='trf3_ven_code' value='006244' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����Ʈ") && !String.valueOf(ht.get("COM_CODE3")).equals("")){%>
					  <input type='text' name='trf3_ven_code' value='<%=ht.get("COM_CODE3")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE3")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf3_ven_code' value='' class='default' size='10'>					  
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE3")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf3_ven_code' value='995581' class='default' size='10'>					  
					  <%}else{%>
					  <input type='text' name='trf3_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT3")))%></td>
					<!--����4-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST4")%>', '<%=ht.get("CARD_KIND4")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND4")%></a><%}%></td>
				    <td  width='80' align='center'>
					  <%if(String.valueOf(ht.get("TRF_ST4")).equals("����ī��")||String.valueOf(ht.get("TRF_ST4")).equals("�ĺ�ī��")||String.valueOf(ht.get("TRF_ST4")).equals("ī���Һ�")){%>
					  <input type='text' name='trf4_ven_code' value='<%=ht.get("COM_CODE4")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����")){%>
					  <input type='text' name='trf4_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����") && String.valueOf(ht.get("CARD_KIND4")).equals("�����ٰ����̳���")){//�ƿ�������ٰ����̳���%>
					  <input type='text' name='trf4_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����") && String.valueOf(ht.get("CARD_KIND4")).equals("���Ÿ���̳���")){//���Ÿ���̳���%>
					  <input type='text' name='trf4_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����") && String.valueOf(ht.get("CARD_KIND4")).equals("�������̳���")){//�������̳���%>
					  <input type='text' name='trf4_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����") && String.valueOf(ht.get("CARD_KIND4")).equals("������ĳ��Ż�ڸ���")){//������ĳ��Ż�ڸ���%>
					  <input type='text' name='trf4_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����Ʈ") && !String.valueOf(ht.get("COM_CODE4")).equals("")){%>
					  <input type='text' name='trf4_ven_code' value='<%=ht.get("COM_CODE4")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE4")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf4_ven_code' value='' class='default' size='10'>					  
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("����Ʈ") && String.valueOf(ht.get("COM_CODE4")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf4_ven_code' value='995581' class='default' size='10'>					  
					  <%}else{%>
					  <input type='text' name='trf4_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT4")))%></td>
				</tr>
<%		}%>
<%	}%>	
			</table>
		</td>
  	</tr>
	<tr>
		<td align='center'>&nbsp;</td>	
	</tr>	
	<tr>
		<td>
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
		  <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		  <%}%>
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>	
	<tr>
		<td align='center'><hr></td>	
	</tr>		
</table>
[����] �����纰 ������� �׿��� �ŷ�ó�ڵ�
<table border="1" cellspacing="3" cellpadding="1" width='100%'>
  <tr>
    <td class="title" width='160'>�����ڵ���</td>
	<td class="title" width='160'>����ڵ���</td>
	<td class="title" width='160'>�Ｚ�ڵ���</td>
	<td class="title" width='160'>�ѱ�GM/�ֿ��ڵ���</td>
	<td class="title">�����ڵ���</td>
  </tr>
  <tr>
    <td align='center'>���(000048)<br>
		�ƻ�(000055)<br>
		����(000136)<br>
		����(006249)<br>
    </td>
	<td align='center'>ȭ��(000052)<br>
		����(000516)<br>
		����(000470)<br>
    </td>
	<td align='center'>�λ�(000053)<br>
		���(003070)<br>
		ȭ��(001660)<br>
    </td>
	<td align='center'>����(000047)<br>
		����(028732)<br>
		����(000135)<br>
		���Ѹ��ͽ�(�λ�)(608949)<br>
		���ָ��ͽ�(006005)<br>
		GM����(112700)<br>
		������������(006132)<br>
		��ȭ���ͽ�(006052)
		
    </td>
	<td align='center'>
	<!-- 
	        ���� (��)õ���ڵ���(995591)<br>
		�����ٰ� ���̽��͸��ͽ�(006282)<br>
		ũ���̽���(000911)<br>
		ȥ��(104115)<br>
		ĳ����/���(104119)<br>
		���Ƽ����Ÿ(005970)<br>
		���ؾ����ͽ�(006031)<br>
		�ڿ��հ���(006281)<br>
		���� ��Ŭ�������(006326)<br>		
		���� �Ѽ��ڵ���(996235)<br>		
		�ֻ� �����̾������(��)(006359)<br>
		�ƿ�� �д�(006306)<br>
		ȥ�� ��ȣ���ͽ� ����(006385)<br>
		������ ����Ƽ������(��)(995514)<br>
		������ ��Ʈ�����ͽ�(108684)<br>		
		���� �����̾���ͽ�(006386)<br>
		���� �����ڵ���(��)(028602)<br>
		���� �����ڵ���(��)(995726)<br>
		Ǫ�� �Ｑ�۷ι����ͽ�(995512)<br>
		Ǫ�� (��)�ѺҸ��ͽ�(996117)<br>
		���Ǵ�Ƽ �����̾����(��)(995566)<br>
		���� (��)�������ͽ�(995523)<br>
		����ι� ���̾���������(��)(996007)<br>
		�ڿ��ձ۷ι�(��)����MINI����(995501)<br>
		(��)����ũ���ͽ�(996228)<br>
		 -->
		�׽����ڸ���(996433)<br>
	</td>
  </tr>
</table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	
<%	if(vt_size > 1){
		for(int i = 0 ; i < vt_size ; i++){%>
		
		if(fm.dlv_ext_ven_code[<%=i%>].value == '' && fm.dlv_ext_cd[<%=i%>].options[fm.dlv_ext_cd[<%=i%>].selectedIndex].value != '') fm.dlv_ext_ven_code[<%=i%>].value = fm.dlv_ext_cd[<%=i%>].options[fm.dlv_ext_cd[<%=i%>].selectedIndex].value;
		
<%		}
	}else if(vt_size == 1){%>
	
		if(fm.dlv_ext_ven_code.value == '' && fm.dlv_ext_cd.options[fm.dlv_ext_cd.selectedIndex].value != '') fm.dlv_ext_ven_code.value = fm.dlv_ext_cd.options[fm.dlv_ext_cd.selectedIndex].value;	

<%	}%>	
//-->
</script>
</body>
</html>
